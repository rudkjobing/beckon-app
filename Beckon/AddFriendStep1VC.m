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
@property (assign) BOOL *isSearching;

@end

@implementation AddFriendStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSearching = NO;
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.cancelButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.title = @"Search";
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.nextButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
}

- (void) cancel{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) next{
    AddFriendStep2VC *step2 = [AddFriendStep2VC new];
    [self.navigationController pushViewController:step2 animated:YES];
}

- (IBAction)searchTextChanged:(id)sender {
    NSLog(@"asd");
//    if(!self.isSearching && self.searchedText.length > 2){
        [self searchForFriends];
//    }
}

-(void)searchForFriends{
    [self.spinner startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"searchString": self.searchTextField.text};
    [manager POST:@"http://localhost:9000/users/search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
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
