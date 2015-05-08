//
//  FriendsVC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 03/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "FriendsVC.h"
#import "FriendVC.h"
#import "AFNetworking.h"
#import "AddFriendStep1VC.h"
#import "AddFriendNC.h"
#import "FriendCell.h"
#import "MainSwipeVC.h"

@interface FriendsVC ()

@property (strong, nonatomic) MainSwipeVC *swipeVC;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIBarButtonItem *addButton;
@property (strong, nonatomic) UIBarButtonItem *gotoShoutsButton;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSArray *friends;
@property (strong, nonatomic) NSArray *friendsFiltered;
@property (strong, nonatomic) NSString *currentFilter;
@property (weak, nonatomic) IBOutlet UITextField *filter;

@end

@implementation FriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.swipeVC = (MainSwipeVC*)self.parentViewController.parentViewController;
    self.table.dataSource = self;
    self.table.delegate = self;
    
    self.gotoShoutsButton = [[UIBarButtonItem alloc] initWithTitle:@"shouts" style:UIBarButtonItemStylePlain target:self action:@selector(gotoShouts)];
    self.gotoShoutsButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = self.gotoShoutsButton;
    
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    self.addButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.addButton;
    
    self.navigationItem.title = @"Friends";
    [self.table registerClass:[FriendRequestCell class] forCellReuseIdentifier:@"FriendRequestCell"];
    [self.table registerClass:[FriendCell class] forCellReuseIdentifier:@"FriendCell"];
}

- (void) viewDidAppear:(BOOL)animated{
    [self getFriendships];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFriendships) name:@"PleaseUpdate" object:nil];
}

- (void) viewWillDisappear:(BOOL)animated{
  
}

- (void) gotoShouts{
    [self.swipeVC swipeToIndex:0 sender:self];
}

- (IBAction)filterTyped:(id)sender {
    self.currentFilter = [self.filter.text lowercaseString];
    if([self.currentFilter isEqualToString:@""]){
        self.friendsFiltered = [self.friends copy];
    }
    else{
        NSMutableArray *friendsNewFilter = [NSMutableArray new];
        for(NSDictionary *friend in self.friends){
            NSDictionary *user = [friend objectForKey:@"friend"];
            NSString *email = [[user objectForKey:@"email"] lowercaseString];
            NSString *firstName = [[user objectForKey:@"firstName"] lowercaseString];
            NSString *lastName = [[user objectForKey:@"lastName"] lowercaseString];
            if([email hasPrefix:self.currentFilter] || [firstName hasPrefix:self.currentFilter] || [lastName hasPrefix:self.currentFilter]){
                [friendsNewFilter addObject:friend];
            }
        }
        self.friendsFiltered = [friendsNewFilter copy];
    }
    [self.table reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsFiltered.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *friend = [self.friendsFiltered objectAtIndex:indexPath.row];
    /* Present the friendrequest cell if this is a friend request */
    if([[friend objectForKey:@"status"] isEqualToString:@"PENDING"]){
        static NSString *cellIdentifier = @"FriendRequestCell";
        [tableView registerNib:[UINib nibWithNibName:@"FriendRequestCell" bundle: nil] forCellReuseIdentifier:@"FriendRequestCell"];
        FriendRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"FriendRequestCell"];
        }
        cell.delegate = self;
        NSDictionary *user = [friend objectForKey:@"friend"];
        cell.name.text = [[[user objectForKey:@"firstName"] stringByAppendingString:@" "] stringByAppendingString:[user objectForKey:@"lastName"]];
        cell.friend = friend;
        return cell;
    }
    /* Or present a normal friend cell if the friendship is established */
    else{
        static NSString *cellIdentifier = @"FriendCell";
        [tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle: nil] forCellReuseIdentifier:@"FriendCell"];
        FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
        }
        NSDictionary *user = [friend objectForKey:@"friend"];
        if([[friend objectForKey:@"status"] isEqualToString:@"INVITED"]){
            cell.name.text =@"Awaiting approval";
            cell.email.text = [user objectForKey:@"email"] ;
        }
        else{
            cell.name.text = [[[user objectForKey:@"firstName"] stringByAppendingString:@" "] stringByAppendingString:[user objectForKey:@"lastName"]];
            cell.email.text = [user objectForKey:@"email"];
        }
        return cell;

    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)acceptFriendRequestAction:(id)sender{
    /*Accept friend request*/
    FriendRequestCell *s = (FriendRequestCell*) sender;
    NSDictionary *friend = s.friend;
    [self.spinner startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"id": [friend objectForKey:@"id"]};
    [manager POST:@"http://api.broshout.net:9000/friend/accept" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self.spinner stopAnimating];
         [self getFriendships];
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

-(void)declineFriendRequestAction:(id)sender{
    /*Accept friend request*/
    FriendRequestCell *s = (FriendRequestCell*) sender;
    NSDictionary *friend = s.friend;
    [self.spinner startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"id": [friend objectForKey:@"id"]};
    [manager POST:@"http://api.broshout.net:9000/friend/decline" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self.spinner stopAnimating];
         [self getFriendships];
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

- (void)addFriend{
    AddFriendStep1VC *step1 = [AddFriendStep1VC new];
    AddFriendNC *navCon = [[AddFriendNC alloc] initWithRootViewController:step1];
    [self presentViewController:navCon animated:YES completion:nil];
}

-(void)getFriendships{
    /*Accept friend request*/
    [self.spinner startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:@"http://api.broshout.net:9000/friendships" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         
         for(NSDictionary *friend in responseObject){
             if([[friend objectForKey:@"status"] isEqualToString:@"PENDING"]){
                 NSLog(@"Bingo");
             }
         }
         self.friends = responseObject;
         self.friendsFiltered =  [self.friends copy];
         [self.table reloadData];
         

         [self.spinner stopAnimating];
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

@end
