//
//  CreateBeckonStep3VC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "CreateBeckonStep3VC.h"
#import "CreateBeckonSwipeVC.h"

@interface CreateBeckonStep3VC ()

@property (strong, nonatomic) UIBarButtonItem *previousButton;
@property (strong, nonatomic) UIBarButtonItem *nextButton;
@property (strong, nonatomic) CreateBeckonSwipeVC *swipeVC;

@end

@implementation CreateBeckonStep3VC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.swipeVC = (CreateBeckonSwipeVC*)self.parentViewController.parentViewController;
    
    self.navigationItem.title = @"Location";
    
    self.previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self  action:@selector(previous)];
    self.previousButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.previousButton;
    
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.nextButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
}

- (void) previous{
    [self.swipeVC swipeToPrevious:self.parentViewController];
}

- (void) next{
    [self.swipeVC swipeToNext:self.parentViewController];
}

@end
