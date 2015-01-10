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

@end

@implementation FriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    self.addButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.addButton;
    self.navigationItem.title = @"Friends";
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
    [self.spinner startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:@"http://localhost:9000/friendships" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
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
