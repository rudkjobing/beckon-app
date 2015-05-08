//
//  BroShoutsVC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 03/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "ShoutsVC.h"
#import "AFNetworking.h"
#import "CreateShoutSwipeVC.h"
#import "ShoutCell.h"
#import "MainSwipeVC.h"

@interface ShoutsVC ()

@property (strong, nonatomic) MainSwipeVC *swipeVC;
@property (strong, nonatomic) UIBarButtonItem *addButton;
@property (strong, nonatomic) UIBarButtonItem *gotoFriendsButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSArray *shouts;
@property (weak, nonatomic) IBOutlet UITableView *shoutTable;

@end

@implementation ShoutsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.swipeVC = (MainSwipeVC*)self.parentViewController.parentViewController;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewEnteredForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBeckon)];
    self.addButton.tintColor = [UIColor blackColor];
    
    self.gotoFriendsButton = [[UIBarButtonItem alloc] initWithTitle:@"friends" style:UIBarButtonItemStylePlain target:self action:@selector(gotoFriends)];
    self.gotoFriendsButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = self.gotoFriendsButton;
    self.navigationItem.rightBarButtonItem = self.addButton;
    self.navigationItem.title = @"Shouts";
 
    [self.shoutTable registerClass:[ShoutRequestCell class] forCellReuseIdentifier:@"ShoutRequestCell"];
    [self.shoutTable registerClass:[ShoutCell class] forCellReuseIdentifier:@"ShoutCell"];
    self.shoutTable.dataSource = self;
    self.shoutTable.delegate = self;
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    //Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShouts) name:@"PleaseUpdate" object:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [self getShouts];
}

- (void) viewWillDisappear:(BOOL)animated{
        
}

- (void) gotoFriends{
    [self.swipeVC swipeToIndex:1 sender:self];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *shout = [self.shouts objectAtIndex:indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"MMM d."];
    
    NSDateFormatter *timeOfDayFormatter = [[NSDateFormatter alloc] init];
    [timeOfDayFormatter setDateFormat: @"HH:mm"];
    
    NSDate *begins = [NSDate dateWithTimeIntervalSince1970:[[shout objectForKey:@"begins"] integerValue] / 1000];
    NSString *title = [shout objectForKey:@"title"];
    NSString *location = [[shout objectForKey:@"location"] objectForKey:@"name"];
    NSArray *members = [shout objectForKey:@"memberList"];
    NSString *creator = @"";
    
    
    /* Present the shout cell if this is a shout invitation */
    if([[shout objectForKey:@"status"] isEqualToString:@"INVITED"]){
        static NSString *cellIdentifier = @"ShoutRequestCell";
        [tableView registerNib:[UINib nibWithNibName:@"ShoutRequestCell" bundle: nil] forCellReuseIdentifier:@"ShoutRequestCell"];
        
        ShoutRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ShoutRequestCell"];
        }
        
        for (NSDictionary *member in members) {
            if ([[member objectForKey:@"role"] isEqualToString:@"CREATOR"]) {
                creator = [member objectForKey:@"name"];
                break;
            }
        }
        
        cell.delegate = self;
        cell.shout = shout;
        cell.headline.text = [creator stringByAppendingString:@" has invited you to"];
        cell.title.text = title;
        cell.location.text = location;

        cell.begins.text = [[[formatter stringFromDate:begins] stringByAppendingString: @" @ "] stringByAppendingString:[timeOfDayFormatter stringFromDate:begins]];
        
        return cell;
    }
    /* Or present a normal shout cell */
    else{
        static NSString *cellIdentifier = @"ShoutCell";
        [tableView registerNib:[UINib nibWithNibName:@"ShoutCell" bundle: nil] forCellReuseIdentifier:@"ShoutCell"];
        
        ShoutCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ShoutCell"];
        }
        
        //Color member names according to status and role
        NSMutableAttributedString *names = [[NSMutableAttributedString alloc] initWithString:@""];
        for (NSDictionary *member in members) {
            
            NSMutableAttributedString *name = names.length == 0 ? [[NSMutableAttributedString alloc] initWithString:[member objectForKey:@"name"]] : [[NSMutableAttributedString alloc] initWithString:[@" " stringByAppendingString:[member objectForKey:@"name"]]];
            if ([[member objectForKey:@"role"] isEqualToString:@"CREATOR"]) {
                [name addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, name.length)];
            }
            else if ([[member objectForKey:@"status"] isEqualToString:@"ACCEPTED"]) {
                [name addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, name.length)];
            }
            else if ([[member objectForKey:@"status"] isEqualToString:@"DECLINED"]) {
                [name addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, name.length)];
            }
            else if ([[member objectForKey:@"status"] isEqualToString:@"INVITED"] || [[member objectForKey:@"status"] isEqualToString:@"MAYBE"]) {
                [name addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(0, name.length)];
            }
            [names appendAttributedString:name];
            
        }
        
        cell.title.text = title;
        cell.location.text = location;
        [cell.members setAttributedText: names];
        cell.begins = begins;
        cell.timeOfDay.text = [timeOfDayFormatter stringFromDate:begins];
        cell.date.text = [formatter stringFromDate:begins];
        
        [cell startTimer];
        
        return cell;
    }
    return nil;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shouts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *shout = [self.shouts objectAtIndex:indexPath.row];
    
    if([[shout objectForKey:@"status"] isEqualToString:@"INVITED"]){
        return 156.0;
    }
    
    return 100.0;
}


- (void)addBeckon{
    CreateShoutSwipeVC *createBeckonModal = [CreateShoutSwipeVC new];
    [self presentViewController:createBeckonModal animated:YES completion:nil];
}

- (void)viewEnteredForeground{
    [self getShouts];
}

-(void)getShouts{
    [self.spinner startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:@"http://api.broshout.net:9000/shouts" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.shouts = responseObject;
         NSLog(@"JSON: %@", self.shouts);
         [self.shoutTable reloadData];
         [self.spinner stopAnimating];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.spinner stopAnimating];
         NSInteger statusCode = operation.response.statusCode;
         if(statusCode == 401) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UserUnautherized" object:self];
         }
     }];
    
}

-(void)updateShoutMemberShout: (NSDictionary *) shout shoutOriginal: (NSDictionary *) original{
    [self.spinner startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"http://api.broshout.net:9000/shout/membership/status" parameters:shout success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self.spinner stopAnimating];
         [self getShouts];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.spinner stopAnimating];
         NSInteger statusCode = operation.response.statusCode;
         NSLog(@"%ld", (long)statusCode);
         if(statusCode == 401) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UserUnautherized" object:self];
         }
     }];
    
}

-(void)acceptShoutRequestAction:(id)sender{
    ShoutRequestCell *s = (ShoutRequestCell*) sender;
    NSDictionary *update = @{@"memberId": [s.shout objectForKey:@"memberId"], @"shoutId": [s.shout objectForKey:@"id"], @"status": @"ACCEPTED"};
    [self updateShoutMemberShout:update shoutOriginal:s.shout];
}

-(void)maybeShoutRequestAction:(id)sender{
    ShoutRequestCell *s = (ShoutRequestCell*) sender;
    NSDictionary *update = @{@"memberId": [s.shout objectForKey:@"memberId"], @"shoutId": [s.shout objectForKey:@"id"], @"status": @"MAYBE"};
    [self updateShoutMemberShout:update shoutOriginal:s.shout];
}

-(void)declineShoutRequestAction:(id)sender{
    ShoutRequestCell *s = (ShoutRequestCell*) sender;
    NSDictionary *update = @{@"memberId": [s.shout objectForKey:@"memberId"], @"shoutId": [s.shout objectForKey:@"id"], @"status": @"DECLINED"};
    [self updateShoutMemberShout:update shoutOriginal:s.shout];
}

@end
