//
//  SignInVC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 02/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
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
    [manager POST:@"http://192.168.1.91:9000/account/signIn" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              self.message.text = @"";
              [self.message setTextColor:[UIColor blackColor]];
              [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedIn" object:self];
              [self dismissViewControllerAnimated:YES completion:nil];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSInteger statusCode = operation.response.statusCode;
              if(statusCode == 400) {
                  self.message.text = @"Hmm, wrong email or password :(";
                  [self.message setTextColor:[UIColor redColor]];
              }
          }];
    
}

@end
