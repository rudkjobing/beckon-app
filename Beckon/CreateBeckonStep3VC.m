//
//  CreateBeckonStep3VC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "CreateBeckonStep3VC.h"
#import "CreateBeckonSwipeVC.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface CreateBeckonStep3VC ()

@property (strong, nonatomic) UIBarButtonItem *previousButton;
@property (strong, nonatomic) UIBarButtonItem *nextButton;
@property (strong, nonatomic) CreateBeckonSwipeVC *swipeVC;
@property (assign, nonatomic) BOOL isSearching;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTextFieldConstraint;

@end

@implementation CreateBeckonStep3VC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.swipeVC = (CreateBeckonSwipeVC*)self.parentViewController.parentViewController;
    self.isSearching = NO;
    self.navigationItem.title = @"Location";
    
    self.previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self  action:@selector(previous)];
    self.previousButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.previousButton;
    
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.nextButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
}

- (void) previous{
    [self.swipeVC swipeToPrevious:self.parentViewController sender:self];
}

- (void) next{
    [self.swipeVC swipeToNext:self.parentViewController sender:self];
}

- (IBAction)searchInitAction:(id)sender {
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.rightTextFieldConstraint.constant += 60.0f;
                         self.table.layer.hidden = NO;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         self.cancelButton.hidden = NO;
                     }];
}

- (IBAction)SearchCanceledAction:(id)sender {
    [self.searchTextField endEditing:YES];
    [self resignFirstResponder];
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.cancelButton.hidden = YES;
                         self.rightTextFieldConstraint.constant -= 60.0f;
                         self.table.layer.hidden = YES;
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

- (IBAction)searchAction:(id)sender {
    
    
    
}

@end
