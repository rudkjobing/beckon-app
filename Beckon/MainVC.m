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

-(void)goToSignIn:(NSNotification*) notification{
    [self performSegueWithIdentifier:@"goto_login" sender:self];
}

@end
