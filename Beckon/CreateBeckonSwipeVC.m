//
//  CreateBeckonSwipeVC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "CreateBeckonSwipeVC.h"
#import "CreateBeckonStep1VC.h"
#import "CreateBeckonStep2VC.h"

@interface CreateBeckonSwipeVC ()

@end

@implementation CreateBeckonSwipeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.beckon = [NSMutableDictionary new];
    //Create the Step 1 controller
    CreateBeckonStep1VC *step1 = [CreateBeckonStep1VC new];
    UINavigationController *navCon1 = [[UINavigationController alloc]initWithRootViewController:step1];
    
    //Create the Step 2 controller
    CreateBeckonStep2VC *step2 = [CreateBeckonStep2VC new];
    UINavigationController *navCon2 = [[UINavigationController alloc] initWithRootViewController:step2];
    
    self.viewControllers = @[navCon1, navCon2];
}

@end
