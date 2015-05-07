//
//  FriendVC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 12/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "FriendVC.h"
#import "AFNetworking.h"

@interface FriendVC ()

@property (strong, nonatomic) UIBarButtonItem *previousButton;
@property (strong, nonatomic) UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *nickname;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSDictionary *user;
@property (strong, nonatomic) NSString *initialNickname;

@end

@implementation FriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Edit friend";
    
    self.previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self  action:@selector(previous)];
    self.previousButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.previousButton;
    
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(update)];
    self.doneButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    self.user = [self.friend objectForKey:@"friend"];
    
    self.nickname.text = [self.friend objectForKey:@"nickname"];
    self.name.text = [[[self.user objectForKey:@"firstName"] stringByAppendingString:@" "] stringByAppendingString:[self.user objectForKey:@"lastName"]];
    self.email.text = [self.user objectForKey:@"email"];
    self.phoneNumber.text = [self.user objectForKey:@"phoneNumber"];
    
}

- (void) previous{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) update{
    [self updateFriend];
}

-(void)updateFriend{
    [self.spinner startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"id": [self.friend objectForKey:@"id"],
                                 @"nickname": self.nickname.text};
    [manager POST:@"http://api.broshout.net:9000/friend" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self.spinner stopAnimating];
         [self.navigationController popToRootViewControllerAnimated:YES];
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
