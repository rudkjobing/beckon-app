//
//  CreateBeckonStep2VC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "CreateShoutStep2VC.h"
#import "CreateShoutSwipeVC.h"
#import "FriendCell.h"
#import "AFNetworking.h"

@interface CreateShoutStep2VC ()

@property (strong, nonatomic) UIBarButtonItem *previousButton;
@property (strong, nonatomic) UIBarButtonItem *nextButton;
@property (strong, nonatomic) CreateShoutSwipeVC *swipeVC;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSArray *friends;
@property (strong, nonatomic) NSArray *friendsFiltered;
@property (strong, nonatomic) NSString *currentFilter;
@property (strong, nonatomic) NSMutableArray *beckonMembers;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UITextField *filter;
@property (assign) BOOL isSaving;

@end

@implementation CreateShoutStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isSaving = NO;
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
    self.swipeVC = (CreateShoutSwipeVC*)self.parentViewController.parentViewController;
    self.beckonMembers = [NSMutableArray new];
    [self.swipeVC.beckon setObject:self.beckonMembers forKey:@"members"];
    
    self.navigationItem.title = @"Friends(0)";
    
    self.previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self  action:@selector(previous)];
    self.previousButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.previousButton;
    
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStylePlain target:self action:@selector(go)];
    self.nextButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
    [self getFriendships];
}

- (void) viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFriendships) name:@"PleaseUpdate" object:nil];
}

- (void) viewWillDisappear:(BOOL)animated{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void) previous{
    [self.swipeVC swipeToPrevious:self.parentViewController sender:self];
}

- (void) go{
    [self createBeckon:self.swipeVC.beckon];
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
            NSString *nickname = [[friend objectForKey:@"nickname"] lowercaseString];
            NSString *email = [[user objectForKey:@"email"] lowercaseString];
            NSString *firstName = [[user objectForKey:@"firstName"] lowercaseString];
            NSString *lastName = [[user objectForKey:@"lastName"] lowercaseString];
            if([email hasPrefix:self.currentFilter] || [nickname hasPrefix:self.currentFilter] || [firstName hasPrefix:self.currentFilter] || [lastName hasPrefix:self.currentFilter]){
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
    static NSString *cellIdentifier = @"FriendCell";
    [tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle: nil] forCellReuseIdentifier:@"FriendCell"];
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    }
    NSDictionary *user = [friend objectForKey:@"friend"];
    cell.name.text = [[[user objectForKey:@"firstName"] stringByAppendingString:@" "] stringByAppendingString:[user objectForKey:@"lastName"]];
    cell.email.text = [user objectForKey:@"email"];
    if([self.beckonMembers containsObject:friend]){
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *friend = [self.friendsFiltered objectAtIndex:indexPath.row];
    FriendCell *cell = (FriendCell *)[tableView cellForRowAtIndexPath:indexPath];
    if([self.beckonMembers containsObject:friend]){
        [self.beckonMembers removeObject:friend];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    else{
        [self.beckonMembers addObject:friend];
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    self.navigationItem.title = [[@"Friends(" stringByAppendingString:[NSString stringWithFormat:@"%ld", (unsigned long)self.beckonMembers.count]] stringByAppendingString:@")"];
    [self.table reloadData];
}

-(void)getFriendships{
    /*Accept friend request*/
    [self.spinner startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"id": [NSNumber numberWithLong:0L], @"status": @"ACCEPTED"};
    [manager GET:@"http://api.broshout.net:9000/friendships" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         self.friends = responseObject;
         self.friendsFiltered = [self.friends copy];
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

-(void)createBeckon:(NSDictionary*)beckonRequest{
    if(self.isSaving){
        return;
    }
    [self.spinner startAnimating];
    self.isSaving = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = beckonRequest;
    [manager POST:@"http://api.broshout.net:9000/shout" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              self.isSaving = NO;
              [self.spinner stopAnimating];
              [self.swipeVC dismissViewControllerAnimated:YES completion:nil];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              self.isSaving = NO;
              [self.spinner stopAnimating];
          }];
    
}

@end
