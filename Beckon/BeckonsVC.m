//
//  BroShoutsVC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 03/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "BeckonsVC.h"
#import "AFNetworking.h"
#import "CreateBeckonSwipeVC.h"
#import "BeckonRequestCell.h"

@interface BeckonsVC ()

@property (strong, nonatomic) UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSArray *shouts;
@property (weak, nonatomic) IBOutlet UITableView *shoutTable;

@end

@implementation BeckonsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewEnteredForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBeckon)];
    self.addButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.addButton;
    self.navigationItem.title = @"Beckons";
    [self.shoutTable registerClass:[BeckonRequestCell class] forCellReuseIdentifier:@"BeckonRequestCell"];
    self.shoutTable.dataSource = self;
    self.shoutTable.delegate = self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *shout = [self.shouts objectAtIndex:indexPath.row];
    /* Present the friendrequest cell if this is a friend request */
    if([[shout objectForKey:@"status"] isEqualToString:@"INVITED"]){
        static NSString *cellIdentifier = @"BeckonRequestCell";
        [tableView registerNib:[UINib nibWithNibName:@"BeckonRequestCell" bundle: nil] forCellReuseIdentifier:@"BeckonRequestCell"];
        BeckonRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"BeckonRequestCell"];
        }
        //cell.delegate = self;
        
        cell.headline.text = [[shout objectForKey:@"createrName"] stringByAppendingString:@" has invited you to"];
        cell.title.text = [shout objectForKey:@"title"];
        cell.location.text = [[shout objectForKey:@"location"] objectForKey:@"name"];
        
        return cell;
    }
    /* Or present a normal friend cell if the friendship is established */
    else{
        
    }
    return nil;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shouts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 177.0;
}


- (void)addBeckon{
    CreateBeckonSwipeVC *createBeckonModal = [CreateBeckonSwipeVC new];
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
    [manager GET:@"http://192.168.1.91:9000/beckons" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
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

@end
