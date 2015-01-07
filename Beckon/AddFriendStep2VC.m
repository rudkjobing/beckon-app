//
//  AddFriendStep2VC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "AddFriendStep2VC.h"
#import "AddFriendSwipeVC.h"

@interface AddFriendStep2VC ()

@property (strong, nonatomic) UIBarButtonItem *previousButton;
@property (strong, nonatomic) UIBarButtonItem *doneButton;
@property (strong, nonatomic) AddFriendSwipeVC *swipeVC;

@end

@implementation AddFriendStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.swipeVC = (AddFriendSwipeVC*)self.parentViewController.parentViewController;
    
    self.navigationItem.title = @"Title";
    
    self.previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self  action:@selector(previous)];
    self.previousButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.previousButton;
    
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(done)];
    self.doneButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
}

- (void) previous{
    [self.swipeVC swipeToPrevious:self.parentViewController];
}

- (void) done{
    [self.swipeVC dismissViewControllerAnimated:YES completion:nil];
}

@end
