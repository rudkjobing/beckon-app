//
//  MainVC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 02/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "MainSwipeVC.h"
#import "AFNetworking.h"
#import "ShoutsVC.h"
#import "FriendsVC.h"
#import "SettingsVC.h"

@interface MainSwipeVC ()
@property (nonatomic, assign)BOOL userLoggedIn;
@end

@implementation MainSwipeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToSignIn:)
     name:@"UserUnautherized"
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(userLoggedInEvent:)
     name:@"UserLoggedIn"
     object:nil];
 
    //Create the Beckons controller
    ShoutsVC *beckons = [ShoutsVC new];
    UINavigationController *scene1 = [[UINavigationController alloc]initWithRootViewController:beckons];
    
    //Create the Friends controller
    FriendsVC *friends = [FriendsVC new];
    UINavigationController *scene2 = [[UINavigationController alloc] initWithRootViewController:friends];
    
    //Create the Options controller
    SettingsVC *settings = [SettingsVC new];
    UINavigationController *scene4 = [[UINavigationController alloc] initWithRootViewController:settings];
    
    self.viewControllers = @[scene1, scene2];
    
    self.userLoggedIn = YES;
    
}

-(void)goToSignIn:(NSNotification*) notification{
    if(self.userLoggedIn){
        BOOL t = [self presentedViewController] == nil;
        self.userLoggedIn = NO;
        if(t){
            [self performSegueWithIdentifier:@"goto_login" sender:self];
        }
        else{
            [self.presentedViewController dismissViewControllerAnimated:NO completion:^{
                [self performSegueWithIdentifier:@"goto_login" sender:self];
            }];
        }
    }
}

-(void)userLoggedInEvent:(NSNotification*) notification{
    self.userLoggedIn = YES;
    
    //Create the Beckons controller
    ShoutsVC *beckons = [ShoutsVC new];
    UINavigationController *scene1 = [[UINavigationController alloc]initWithRootViewController:beckons];
    
    //Create the Friends controller
    FriendsVC *friends = [FriendsVC new];
    UINavigationController *scene2 = [[UINavigationController alloc] initWithRootViewController:friends];
  
    //Create the Options controller
    SettingsVC *settings = [SettingsVC new];
    UINavigationController *scene4 = [[UINavigationController alloc] initWithRootViewController:settings];
    
    self.viewControllers = @[scene1, scene2];
}

@end
