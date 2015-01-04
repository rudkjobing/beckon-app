//
//  CreateBeckonStep4VC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "CreateBeckonStep4VC.h"
#import "CreateBeckonSwipeVC.h"

@interface CreateBeckonStep4VC ()

@property (strong, nonatomic) UIBarButtonItem *previousButton;
@property (strong, nonatomic) UIBarButtonItem *doneButton;
@property (strong, nonatomic) CreateBeckonSwipeVC *swipeVC;

@end

@implementation CreateBeckonStep4VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.swipeVC = (CreateBeckonSwipeVC*)self.parentViewController.parentViewController;
    
    self.navigationItem.title = @"Time";
    
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
