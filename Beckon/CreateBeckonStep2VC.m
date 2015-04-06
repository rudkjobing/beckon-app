//
//  CreateBeckonStep2VC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "CreateBeckonStep2VC.h"
#import "CreateBeckonSwipeVC.h"
#import "FriendCell.h"
#import "AFNetworking.h"

@interface CreateBeckonStep2VC ()

@property (strong, nonatomic) UIBarButtonItem *previousButton;
@property (strong, nonatomic) UIBarButtonItem *nextButton;
@property (strong, nonatomic) CreateBeckonSwipeVC *swipeVC;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSArray *friends;
@property (strong, nonatomic) NSArray *friendsFiltered;
@property (strong, nonatomic) NSString *currentFilter;
@property (strong, nonatomic) NSMutableArray *beckonMembers;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UITextField *filter;

@end

@implementation CreateBeckonStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    self.swipeVC = (CreateBeckonSwipeVC*)self.parentViewController.parentViewController;
    self.beckonMembers = [NSMutableArray new];
    [self.swipeVC.beckon setObject:self.beckonMembers forKey:@"members"];
    
    self.navigationItem.title = @"Participants(1)";
    
    self.previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self  action:@selector(previous)];
    self.previousButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.previousButton;
    
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.nextButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
    [self getFriendships];
}

- (void) previous{
    [self.swipeVC swipeToPrevious:self.parentViewController sender:self];
}

- (void) next{
    [self.swipeVC swipeToNext:self.parentViewController sender:self];
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
    cell.phoneNumber.text = [user objectForKey:@"phoneNumber"];
    cell.nickname.text = [friend objectForKey:@"nickname"];
    if([self.beckonMembers containsObject:friend]){
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    else{
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *friend = [self.friendsFiltered objectAtIndex:indexPath.row];
    if([self.beckonMembers containsObject:friend]){
        [self.beckonMembers removeObject:friend];
    }
    else{
        [self.beckonMembers addObject:friend];
    }
    self.navigationItem.title = [[@"Participants(" stringByAppendingString:[NSString stringWithFormat:@"%lu", self.beckonMembers.count + 1]] stringByAppendingString:@")"];
    [self.table reloadData];
}

-(void)getFriendships{
    /*Accept friend request*/
    [self.spinner startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"id": [NSNumber numberWithLong:0L], @"status": @"ACCEPTED"};
    [manager GET:@"http://192.168.1.84:9000/friendships" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
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

@end
