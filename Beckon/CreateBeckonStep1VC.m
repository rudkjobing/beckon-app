//
//  CreateBeckonStep1VC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "CreateBeckonStep1VC.h"
#import "CreateBeckonSwipeVC.h"

@interface CreateBeckonStep1VC ()

@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *nextButton;
@property (strong, nonatomic) CreateBeckonSwipeVC *swipeVC;

@end

@implementation CreateBeckonStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.swipeVC = (CreateBeckonSwipeVC*)self.parentViewController.parentViewController;

    self.navigationItem.title = @"Title";
    
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.cancelButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
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
