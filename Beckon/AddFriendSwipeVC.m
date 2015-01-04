//
//  AddFriendSwipeVC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "AddFriendSwipeVC.h"
#import "AddFriendStep1VC.h"
#import "AddFriendStep2VC.h"

@interface AddFriendSwipeVC ()

@end

@implementation AddFriendSwipeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friend = [NSDictionary new];
    //Create the Step 1 controller
    AddFriendStep1VC *step1 = [AddFriendStep1VC new];
    UINavigationController *navCon1 = [[UINavigationController alloc]initWithRootViewController:step1];
    
    //Create the Step 2 controller
    AddFriendStep2VC *step2 = [AddFriendStep2VC new];
    UINavigationController *navCon2 = [[UINavigationController alloc] initWithRootViewController:step2];
    
    self.viewControllers = @[navCon1, navCon2];
}

@end
