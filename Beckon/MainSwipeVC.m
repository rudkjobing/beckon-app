//
//  MainVC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 02/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "MainSwipeVC.h"
#import "AFNetworking.h"
#import "BeckonsVC.h"
#import "FriendsVC.h"
#import "OverviewVC.h"
#import "SettingsVC.h"

@interface MainSwipeVC ()

@end

@implementation MainSwipeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToSignIn:)
     name:@"UserUnautherized"
     object:nil];
 
    //Create the Beckons controller
    BeckonsVC *beckons = [BeckonsVC new];
    UINavigationController *scene1 = [[UINavigationController alloc]initWithRootViewController:beckons];
    
    //Create the Friends controller
    FriendsVC *friends = [FriendsVC new];
    UINavigationController *scene2 = [[UINavigationController alloc] initWithRootViewController:friends];
    
    //Create the Overview controller
    OverviewVC *scene3 = [OverviewVC new];

    //Create the Options controller
    SettingsVC *settings = [SettingsVC new];
    UINavigationController *scene4 = [[UINavigationController alloc] initWithRootViewController:settings];
    
    self.viewControllers = @[scene1, scene2, scene3, scene4];
    
}

-(void)goToSignIn:(NSNotification*) notification{
    [self performSegueWithIdentifier:@"goto_login" sender:self];
}

@end
