//
//  AddFriendStep2VC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "AddFriendStep2VC.h"

@interface AddFriendStep2VC ()

@property (strong, nonatomic) UIBarButtonItem *previousButton;
@property (strong, nonatomic) UIBarButtonItem *doneButton;

@end

@implementation AddFriendStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Title";
    
    self.previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self  action:@selector(previous)];
    self.previousButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.previousButton;
    
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(done)];
    self.doneButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
}

- (void) previous{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) done{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
