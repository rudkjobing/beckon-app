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
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (assign) BOOL working;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

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
    self.working = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
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
    if(self.working){
        return;
    }
    self.working = YES;
    [self.activityIndicator startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"email": self.emailTextField.text,
                                 @"firstName": self.firstNameTextField.text,
                                 @"lastName": self.lastNameTextField.text};
    [manager POST:@"http://api.broshout.net:9000/account/signUp" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        self.message.text = @"";
        [self.message setTextColor:[UIColor blackColor]];
        [self.feedbackLabel setTextColor:[UIColor blackColor]];
        self.feedbackLabel.text = [responseObject objectForKey:@"message"];
        self.signInVCemailTextField.text = self.emailTextField.text;
        self.working = NO;
        [self.activityIndicator stopAnimating];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        self.working = NO;
        [self.activityIndicator stopAnimating];
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
