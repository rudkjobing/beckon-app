//
//  SignInVC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 02/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//
#import "SignInVC.h"
#import "AFNetworking.h"

@interface SignInVC ()

@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *notAMemberButton;

@end

@implementation SignInVC

- (IBAction)signInAction:(UIButton *)sender {
    //Check inputfields
    
    [self signInWithEmail: self.emailAddressTextField.text andPassword:self.passwordTextField.text];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)signInWithEmail:(NSString*)email andPassword:(NSString*)password{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"email": email,
                                 @"password": password};
    [manager POST:@"http://192.168.1.192:9000/account/signIn" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedIn" object:self];
              [self dismissViewControllerAnimated:YES completion:nil];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
          }];
    
}

@end
