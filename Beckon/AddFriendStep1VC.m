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
@property (strong, nonatomic) UIBarButtonItem *nextButton;
@property (strong, nonatomic) AddFriendSwipeVC *swipeVC;

@end

@implementation AddFriendStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.swipeVC = (AddFriendSwipeVC*)self.parentViewController.parentViewController;
    
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.cancelButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.title = @"Search";
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.nextButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
}

- (void) cancel{
    [self.swipeVC dismissViewControllerAnimated:YES completion:nil];
}

- (void) next{
    [self.swipeVC swipeToNext:self.parentViewController];
}

@end
