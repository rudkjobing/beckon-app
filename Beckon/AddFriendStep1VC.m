//
//  AddFriendStep1VC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "AddFriendStep1VC.h"
#import "AFNetworking.h"
#import "AddFriendCell.h"

@interface AddFriendStep1VC ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSString *searchedText;
@property (nonatomic, assign) BOOL isSearching;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSArray *searchResults;

@end

@implementation AddFriendStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.isSearching = NO;
    
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.cancelButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.nextButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
    self.navigationItem.title = @"Search";
    [self.table registerClass:[AddFriendCell class] forCellReuseIdentifier:@"AddFriendCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AddFriendCell";
    [tableView registerNib:[UINib nibWithNibName:@"AddFriendCell" bundle: nil] forCellReuseIdentifier:@"AddFriendCell"];
    AddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[AddFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *user = [self.searchResults objectAtIndex:indexPath.row];
    cell.email.text = [user objectForKey:@"email"];
    cell.user = user;
    cell.delegate = self;
    return cell;
}

- (void) cancel{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)searchTextChanged:(id)sender {
    if(!self.isSearching && self.searchTextField.text.length > 4){
        [self searchForFriends];
    }
}

- (void) searchFinished: (NSArray*) searchResult{
    self.searchResults = searchResult;
    [self.table reloadData];
    if(!self.isSearching && self.searchTextField.text.length > 4 && ![self.searchTextField.text isEqualToString:self.searchedText]){
        [self searchForFriends];
    }
}

-(void)searchForFriends{
    [self.spinner startAnimating];
    self.isSearching = YES;
    self.searchedText = self.searchTextField.text;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"queryString": self.searchedText};
    [manager POST:@"http://api.broshout.net:9000/friend/search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self.spinner stopAnimating];
         self.isSearching = NO;
         [self searchFinished:responseObject];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.spinner stopAnimating];
         self.isSearching = NO;
         NSInteger statusCode = operation.response.statusCode;
         if(statusCode == 401) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UserUnautherized" object:self];
         }
     }];
    
}

-(void)inviteFriend: (id) sender{
    AddFriendCell *cell = (AddFriendCell*)sender;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"userId": [cell.user objectForKey:@"id"]};
    [manager PUT:@"http://api.broshout.net:9000/friend" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [sender friendAdded];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [sender friendNotAdded];
         NSInteger statusCode = operation.response.statusCode;
         if(statusCode == 401) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UserUnautherized" object:self];
         }
     }];
    
}

@end
