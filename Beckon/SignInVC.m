//
//  SignInVC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 02/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//
#import "SignInVC.h"
#import "AFNetworking.h"
#import "SignUpVC.h"

@interface SignInVC ()

@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *notAMemberButton;
@property (assign) BOOL working;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SignInVC

- (IBAction)signInAction:(UIButton *)sender {
    //Check inputfields
    
    [self signInWithEmail: self.emailAddressTextField.text andPassword:self.passwordTextField.text];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.working = NO;
    // Do any additional setup after loading the view.
}

-(void)signInWithEmail:(NSString*)email andPassword:(NSString*)password{
    if(self.working){
        return;
    }
    self.working = YES;
    [self.activityIndicator startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"email": email,
                                 @"password": password};
    [manager POST:@"http://api.broshout.net:9000/account/signIn" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              self.message.text = @"";
              [self.message setTextColor:[UIColor blackColor]];
              [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedIn" object:self];
              self.working = NO;
              [self.activityIndicator stopAnimating];
              [self dismissViewControllerAnimated:YES completion:nil];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              self.working = NO;
              [self.activityIndicator stopAnimating];
              NSInteger statusCode = operation.response.statusCode;
              if(statusCode == 400) {
                  NSDictionary *data = operation.responseObject;
                  self.message.text = [data objectForKey:@"message"];
                  [self.message setTextColor:[UIColor redColor]];
              }
          }];
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (IBAction)forgotPasswordAction:(id)sender {
    [self requestPin:self.emailAddressTextField.text];
}

- (void)requestPin: (NSString*)email{
    if(self.working){
        return;
    }
    self.working = YES;
    [self.activityIndicator startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"email": email};
    [manager POST:@"http://api.broshout.net:9000/account/requestPin" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [self.message setTextColor:[UIColor blackColor]];
              self.message.text = [responseObject objectForKey:@"message"];
              self.working = NO;
              [self.activityIndicator stopAnimating];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              self.working = NO;
              [self.activityIndicator stopAnimating];
              NSInteger statusCode = operation.response.statusCode;
              if(statusCode == 400) {
                  NSDictionary *data = operation.responseObject;
                  self.message.text = [data objectForKey:@"message"];
                  [self.message setTextColor:[UIColor redColor]];
              }
          }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"gotoSignup"])
    {
        // Get reference to the destination view controller
        SignUpVC *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.feedbackLabel = self.message;
        vc.signInVCemailTextField = self.emailAddressTextField;
    }
}

@end
