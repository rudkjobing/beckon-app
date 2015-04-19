//
//  CreateBeckonSwipeVC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "CreateShoutSwipeVC.h"
#import "CreateShoutStep1VC.h"
#import "CreateShoutStep2VC.h"

@interface CreateShoutSwipeVC ()

@end

@implementation CreateShoutSwipeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.beckon = [NSMutableDictionary new];
    //Create the Step 1 controller
    CreateShoutStep1VC *step1 = [CreateShoutStep1VC new];
    UINavigationController *navCon1 = [[UINavigationController alloc]initWithRootViewController:step1];
    
    //Create the Step 2 controller
    CreateShoutStep2VC *step2 = [CreateShoutStep2VC new];
    UINavigationController *navCon2 = [[UINavigationController alloc] initWithRootViewController:step2];
    
    self.viewControllers = @[navCon1, navCon2];
}

@end
