//
//  SignUpVC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 02/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "SignUpVC.h"
#import "AFNetworking.h"

@interface SignUpVC ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SignUpVC

- (IBAction)gotoSignInAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signUpAction:(UIButton *)sender {
    [self signUpWithEmail:self.emailTextField.text
              phoneNumber:self.phoneNumberTextField.text
                firstName:self.firstNameTextField.text
              andPassword:self.passwordTextField.text];
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

-(void)signUpWithEmail:(NSString*)email phoneNumber:(NSString*)phoneNumber firstName:(NSString*)firstName andPassword:(NSString*)password{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [JSONResponseSerializerWithData serializer];
    NSDictionary *parameters = @{@"email": email,
                                 @"phoneNumber": phoneNumber,
                                 @"firstName": firstName,
                                 @"password": password};
    [manager POST:@"http://ec2-54-93-48-106.eu-central-1.compute.amazonaws.com:9000/account/signUp" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
//        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        //TODO Present error message
        
//        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
//        NSLog(@"Error: %@", serializedData);
    }];
    
}

@end
