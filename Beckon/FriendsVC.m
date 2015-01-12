//
//  FriendsVC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 03/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "FriendsVC.h"
#import "AFNetworking.h"
#import "AddFriendStep1VC.h"
#import "AddFriendNC.h"

@interface FriendsVC ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSArray *friends;

@end

@implementation FriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    self.addButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.addButton;
    self.navigationItem.title = @"Friends";
    [self.table registerClass:[FriendRequestCell class] forCellReuseIdentifier:@"FriendRequestCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friends.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *friend = [self.friends objectAtIndex:indexPath.row];
    if([[friend objectForKey:@"status"] isEqualToString:@"PENDING"]){
        static NSString *cellIdentifier = @"FriendRequestCell";
        [tableView registerNib:[UINib nibWithNibName:@"FriendRequestCell" bundle: nil] forCellReuseIdentifier:@"FriendRequestCell"];
        FriendRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"FriendRequestCell"];
        }
        cell.delegate = self;
        NSDictionary *user = [friend objectForKey:@"friend"];
        cell.name.text = [user objectForKey:@"firstName"];
        cell.friend = friend;
        return cell;
    }
    else{
        static NSString *cellIdentifier = @"FriendCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = [friend objectForKey:@"nickname"];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Goto the selected friend
}

-(void)acceptFriendRequestAction:(id)sender{
    /*Accept friend request*/
    FriendRequestCell *s = (FriendRequestCell*) sender;
    NSDictionary *friend = s.friend;
    [self.spinner startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"id": [friend objectForKey:@"id"]};
    [manager POST:@"http://localhost:9000/friend/accept" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
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
    [manager POST:@"http://localhost:9000/friend/decline" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
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

- (void)viewDidAppear:(BOOL)animated{
    [self getFriendships];
}

-(void)getFriendships{
    /*Accept friend request*/
    [self.spinner startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:@"http://localhost:9000/friendships" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         self.friends = responseObject;
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
