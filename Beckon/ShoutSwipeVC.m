//
//  ShoutSwipeVC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 14/05/15.
//  Copyright (c) 2015 BroShout IVS. All rights reserved.
//

#import "ShoutSwipeVC.h"
#import "ShoutMiscVC.h"

@interface ShoutSwipeVC ()

@end

@implementation ShoutSwipeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //Create the Misc controller
    ShoutMiscVC *misc = [ShoutMiscVC new];
    UINavigationController *navCon1 = [[UINavigationController alloc]initWithRootViewController:misc];
        
    self.viewControllers = @[navCon1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
