//
//  MainVC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 02/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "MainVC.h"
#import "AFNetworking.h"
#import "BeckonsVC.h"
#import "FriendsVC.h"
#import "OverviewVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToSignIn:)
     name:@"UserUnautherized"
     object:nil];
 
    //Create the Beckons controller
    BeckonsVC *beckons = [BeckonsVC new];
    UINavigationController *navCon1 = [[UINavigationController alloc]initWithRootViewController:beckons];
    
    //Create the Friends controller
    FriendsVC *friends = [FriendsVC new];
    UINavigationController *navCon2 = [[UINavigationController alloc] initWithRootViewController:friends];
    
    //Create the Overview controller
    OverviewVC *vc3 = [OverviewVC new];

    
    self.viewControllers = @[navCon1, navCon2, vc3];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    
//    [self getBeckons];
    
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
     }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSInteger statusCode = operation.response.statusCode;
         if(statusCode == 401) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UserUnautherized" object:self];
         }
     }];
    
}

@end
