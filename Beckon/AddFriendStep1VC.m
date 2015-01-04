//
//  AddFriendStep1VC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "AddFriendStep1VC.h"
#import "AddFriendSwipeVC.h"

@interface AddFriendStep1VC ()

@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) AddFriendSwipeVC *parent;

@end

@implementation AddFriendStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parent = (AddFriendSwipeVC*)self.parentViewController;
    
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.cancelButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.title = @"Search";
}

- (void) cancel{
    [self.parent dismissViewControllerAnimated:YES completion:nil];
}

@end
