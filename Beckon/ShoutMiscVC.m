//
//  ShoutMiscVC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 14/05/15.
//  Copyright (c) 2015 BroShout IVS. All rights reserved.
//

#import "ShoutMiscVC.h"
#import "ShoutSwipeVC.h"
#import "AFNetworking.h"
#import "ShoutMemberCell.h"

@interface ShoutMiscVC ()

@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) ShoutSwipeVC *swipeVC;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIButton *accept;
@property (strong, nonatomic) IBOutlet UIButton *maybe;
@property (strong, nonatomic) IBOutlet UIButton *decline;
@property (strong, nonatomic) NSArray *members;
@property (strong, nonatomic) UIBarButtonItem *addButton;

@end

@implementation ShoutMiscVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.swipeVC = (ShoutSwipeVC *)self.parentViewController.parentViewController;
    self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];;
    self.backButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.backButton;
    if([[self.swipeVC.shout objectForKey:@"status"] isEqualToString:@"ACCEPTED"]){
        [self.accept setEnabled:NO];
        [self.accept setAlpha:0.1];
    }
    else if([[self.swipeVC.shout objectForKey:@"status"] isEqualToString:@"MAYBE"]){
        [self.maybe setEnabled:NO];
        [self.maybe setAlpha:0.1];
    }
    else if([[self.swipeVC.shout objectForKey:@"status"] isEqualToString:@"DECLINED"]){
        [self.decline setEnabled:NO];
        [self.decline setAlpha:0.1];
    }
    self.members = [self.swipeVC.shout objectForKey:@"memberList"];
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.table registerClass:[ShoutMemberCell class] forCellReuseIdentifier:@"ShoutMemberCell"];
//    if(![[self.swipeVC.shout objectForKey:@"role"] isEqualToString:@"CREATOR"] || ![[self.swipeVC.shout objectForKey:@"role"] isEqualToString:@"ADMIN"]){
//        self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addShoutMembers)];
//        self.addButton.tintColor = [UIColor blackColor];
//        self.navigationItem.rightBarButtonItem = self.addButton;
//    }
}

-(void) addShoutMembers{
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *member = [self.members objectAtIndex:indexPath.row];;
    static NSString *cellIdentifier = @"ShoutMemberCell";
    [tableView registerNib:[UINib nibWithNibName:@"ShoutMemberCell" bundle: nil] forCellReuseIdentifier:@"ShoutMemberCell"];
    ShoutMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ShoutMemberCell"];
    }
    //TODO remove this when add members is ready
    [cell.button setHidden:YES];
    
    if(![[self.swipeVC.shout objectForKey:@"role"] isEqualToString:@"CREATOR"] || ![[self.swipeVC.shout objectForKey:@"role"] isEqualToString:@"ADMIN"]){
        [cell.button setHidden:YES];
    }
    
    cell.name.text = [member objectForKey:@"firstName"];
    cell.role.text = [[member objectForKey:@"role"] lowercaseString];
    
    /* Present the friendrequest cell if this is a friend request */
    if([[member objectForKey:@"role"] isEqualToString:@"CREATOR"]) {
        [cell.role setTextColor:[UIColor orangeColor]];
        [cell.button setHidden:YES];
    }
    else if([[member objectForKey:@"role"] isEqualToString:@"ADMIN"]) {
        [cell.role setTextColor:[UIColor purpleColor]];
        [cell.button setTitle:@"Demote" forState:UIControlStateNormal];
    }
    else if([[member objectForKey:@"role"] isEqualToString:@"MEMBER"]) {
        [cell.role setTextColor:[UIColor purpleColor]];
        [cell.button setTitle:@"Promote" forState:UIControlStateNormal];
    }
    
    if([[member objectForKey:@"status"] isEqualToString:@"ACCEPTED"]) {
        [cell.name setTextColor:[UIColor greenColor]];
    }
    else if ([[member objectForKey:@"status"] isEqualToString:@"DECLINED"]) {
        [cell.name setTextColor:[UIColor redColor]];
    }
    else if ([[member objectForKey:@"status"] isEqualToString:@"INVITED"] || [[member objectForKey:@"status"] isEqualToString:@"MAYBE"]) {
        [cell.name setTextColor:[UIColor purpleColor]];
    }
    return cell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.members.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (void) back{
    [self.swipeVC dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeStatus:(UIButton *)sender {

    NSString *status = @"";
    
    if([sender.titleLabel.text isEqualToString:@"Cool"] ){
        status = @"ACCEPTED";
        [self.accept setEnabled:NO];
        [self.accept setAlpha:0.1];
        [self.maybe setEnabled:YES];
        [self.maybe setAlpha:1.0];
        [self.decline setEnabled:YES];
        [self.decline setAlpha:1.0];
    }
    else if([sender.titleLabel.text isEqualToString:@"Hmm"] ){
        status = @"MAYBE";
        [self.accept setEnabled:YES];
        [self.accept setAlpha:1.0];
        [self.maybe setEnabled:NO];
        [self.maybe setAlpha:0.1];
        [self.decline setEnabled:YES];
        [self.decline setAlpha:1.0];
    }
    else if([sender.titleLabel.text isEqualToString:@"Pass"] ){
        status = @"DECLINED";
        [self.accept setEnabled:YES];
        [self.accept setAlpha:1.0];
        [self.maybe setEnabled:YES];
        [self.maybe setAlpha:1.0];
        [self.decline setEnabled:NO];
        [self.decline setAlpha:0.1];
    }
    
    NSDictionary *update = @{@"memberId": [self.swipeVC.shout objectForKey:@"memberId"], @"shoutId": [self.swipeVC.shout objectForKey:@"id"], @"status": status};
    
    [self.spinner startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"http://api.broshout.net:9000/shout/membership/status" parameters:update success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self.spinner stopAnimating];
         [self getShout];
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

-(void)getShout{
    [self.spinner startAnimating];
    NSString *currentShoutId = [[self.swipeVC.shout objectForKey:@"id"] stringValue];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:[@"http://api.broshout.net:9000/shout/" stringByAppendingString:currentShoutId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         self.swipeVC.shout = responseObject;
         self.members = [self.swipeVC.shout objectForKey:@"memberList"];
         [self.table reloadData];
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
