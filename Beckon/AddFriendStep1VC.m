//
//  AddFriendStep1VC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "AddFriendStep1VC.h"
#import "AddFriendStep2VC.h"
#import "AFNetworking.h"

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
    self.navigationItem.title = @"Search";    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SearchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *user = [self.searchResults objectAtIndex:indexPath.row];
    cell.textLabel.text = [user objectForKey:@"email"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Goto step2 with the selected user
    AddFriendStep2VC *step2 = [AddFriendStep2VC new];
    step2.user = [self.searchResults objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:step2 animated:YES];
}


- (void) cancel{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)searchTextChanged:(id)sender {
    if(!self.isSearching && self.searchTextField.text.length > 2){
        [self searchForFriends];
    }
}

- (void) searchFinished: (NSArray*) searchResult{
    self.searchResults = searchResult;
    [self.table reloadData];
    if(!self.isSearching && self.searchTextField.text.length > 2 && ![self.searchTextField.text isEqualToString:self.searchedText]){
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
    [manager POST:@"http://localhost:9000/users/search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
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

@end
