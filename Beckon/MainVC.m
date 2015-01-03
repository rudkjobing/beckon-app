//
//  MainVC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 02/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "MainVC.h"
#import "AFNetworking.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToSignIn:)
     name:@"AccessRefused"
     object:nil];
 
    UIViewController *vc1 = [UIViewController new];
    UINavigationController *navCon1 =
    [[UINavigationController alloc]initWithRootViewController:vc1];
    
    UIViewController *vc2 = [UIViewController new];
    [vc2.view setBackgroundColor:[UIColor redColor]];
//    UINavigationController *navCon2 =
//    [[UINavigationController alloc] initWithRootViewController:vc2];
    
    UIViewController *vc3 = [UIViewController new];
//    UINavigationController *navCon3 =
//    [[UINavigationController alloc] initWithRootViewController:vc3];
    
    self.viewControllers = @[navCon1, vc2, vc3];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    
    [self getBeckons];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)goToSignIn:(NSNotification*) notification{
    [self performSegueWithIdentifier:@"goto_login" sender:self];
}

-(void)getBeckons{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:@"http://localhost:9000/beckons" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
                 NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                 NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
                 NSLog(@"Error: %@", serializedData);
         NSInteger statusCode = operation.response.statusCode;
         if(statusCode == 403) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"AccessRefused" object:self];
         }
     }];
    
}

@end
