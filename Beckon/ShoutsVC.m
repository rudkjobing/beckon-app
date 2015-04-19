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

@interface ShoutsVC ()

@property (strong, nonatomic) UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSArray *shouts;
@property (weak, nonatomic) IBOutlet UITableView *shoutTable;

@end

@implementation ShoutsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewEnteredForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBeckon)];
    self.addButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.addButton;
    self.navigationItem.title = @"Shouts";
    [self.shoutTable registerClass:[ShoutRequestCell class] forCellReuseIdentifier:@"ShoutRequestCell"];
    [self.shoutTable registerClass:[ShoutCell class] forCellReuseIdentifier:@"ShoutCell"];
    self.shoutTable.dataSource = self;
    self.shoutTable.delegate = self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *shout = [self.shouts objectAtIndex:indexPath.row];
    /* Present the friendrequest cell if this is a friend request */
    if([[shout objectForKey:@"status"] isEqualToString:@"INVITED"]){
        static NSString *cellIdentifier = @"ShoutRequestCell";
        [tableView registerNib:[UINib nibWithNibName:@"ShoutRequestCell" bundle: nil] forCellReuseIdentifier:@"ShoutRequestCell"];
        ShoutRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ShoutRequestCell"];
        }
        //cell.delegate = self;
        cell.delegate = self;
        cell.shout = shout;
        cell.headline.text = [[shout objectForKey:@"createrName"] stringByAppendingString:@" has invited you to"];
        cell.title.text = [shout objectForKey:@"title"];
        cell.location.text = [[shout objectForKey:@"location"] objectForKey:@"name"];
        
        return cell;
    }
    /* Or present a normal friend cell if the friendship is established */
    else{
        static NSString *cellIdentifier = @"ShoutCell";
        [tableView registerNib:[UINib nibWithNibName:@"ShoutCell" bundle: nil] forCellReuseIdentifier:@"ShoutCell"];
        ShoutCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ShoutCell"];
        }
        
        cell.title.text = [shout objectForKey:@"title"];
        cell.location.text = [[shout objectForKey:@"location"] objectForKey:@"name"];
        cell.members.text = [shout objectForKey:@"acceptedMemberList"];
        
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
        return 177.0;
    }
    
    return 100.0;
}


- (void)addBeckon{
    CreateShoutSwipeVC *createBeckonModal = [CreateShoutSwipeVC new];
    [self presentViewController:createBeckonModal animated:YES completion:nil];
}

- (void)viewEnteredForeground{
    [self getBeckons];
}

- (void)viewDidAppear:(BOOL)animated{
    //Register for notifications
    [self getBeckons];
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

-(void)getBeckons{
    [self.spinner startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:@"http://192.168.1.91:9000/shouts" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
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
    [manager POST:@"http://192.168.1.91:9000/shout/membership/status" parameters:shout success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self.spinner stopAnimating];
         [self getBeckons];
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
