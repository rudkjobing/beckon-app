//
//  BeckonsVC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 03/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "BeckonsVC.h"

@interface BeckonsVC ()

@property (strong, nonatomic) UIBarButtonItem *addButton;

@end

@implementation BeckonsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBeckon)];
    self.addButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.addButton;
    self.navigationItem.title = @"Beckons";
}

- (void)addBeckon{
    NSLog(@"Adding beckon");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
