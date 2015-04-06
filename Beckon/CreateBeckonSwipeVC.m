//
//  CreateBeckonSwipeVC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "CreateBeckonSwipeVC.h"
#import "CreateBeckonStep1VC.h"
#import "CreateBeckonStep2VC.h"
#import "CreateBeckonStep3VC.h"

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
    
    //Create the Step 3 controller
    CreateBeckonStep3VC *step3 = [CreateBeckonStep3VC new];
    UINavigationController *navCon3 = [[UINavigationController alloc] initWithRootViewController:step3];
        
    self.viewControllers = @[navCon1, navCon2, navCon3];
}

@end
