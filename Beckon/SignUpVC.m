//
//  SignUpVC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 02/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "SignUpVC.h"
#import "AFNetworking.h"

@interface SignUpVC ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *message;

@end

@implementation SignUpVC

- (IBAction)gotoSignInAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signUpAction:(UIButton *)sender {
    [self signUpWithEmail];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)signUpWithEmail{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [JSONResponseSerializerWithData serializer];
    NSDictionary *parameters = @{@"email": self.emailTextField.text,
                                 @"phoneNumber": self.phoneNumberTextField.text,
                                 @"firstName": self.firstNameTextField.text,
                                 @"lastName": self.lastNameTextField.text,
                                 @"password": self.passwordTextField.text};
    [manager POST:@"http://192.168.1.91:9000/account/signUp" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        self.message.text = @"";
        [self.message setTextColor:[UIColor blackColor]];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSInteger statusCode = operation.response.statusCode;
        if(statusCode == 400) {
            NSDictionary *data = operation.responseObject;
            NSLog(@"%@", [data objectForKey:@"message"]);
            self.message.text = [data objectForKey:@"message"];
            [self.message setTextColor:[UIColor redColor]];
        }
    }];
    
}

@end
