//
//  AddFriendStep2VC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "AddFriendStep2VC.h"
#import "AFNetworking.h"

@interface AddFriendStep2VC ()

@property (strong, nonatomic) UIBarButtonItem *previousButton;
@property (strong, nonatomic) UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *nickname;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation AddFriendStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Add friend";
    
    self.previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self  action:@selector(previous)];
    self.previousButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.previousButton;
    
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.doneButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    self.nickname.text = [self.user objectForKey:@"firstName"];
    self.name.text = [self.user objectForKey:@"firstName"];
    self.email.text = [self.user objectForKey:@"email"];
    self.phoneNumber.text = [self.user objectForKey:@"phoneNumber"];
    
}

- (void) previous{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) done{
    if([self.nickname.text isEqualToString:@""]){
        self.errorLabel.text = @"Please choose a nickname.";
    }
    else{
        [self addFriend];
    }
}

-(void)addFriend{
    [self.spinner startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"userId": [self.user objectForKey:@"id"],
                                 @"nickname": self.nickname.text};
    [manager PUT:@"http://192.168.1.84:9000/friend" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self.spinner stopAnimating];
         [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
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
