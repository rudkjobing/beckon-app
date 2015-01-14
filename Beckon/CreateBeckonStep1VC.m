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
@property (weak, nonatomic) IBOutlet UITextField *beckonTitle;
@property (weak, nonatomic) IBOutlet UITextField *beckonDescription;

@end

@implementation CreateBeckonStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.swipeVC = (CreateBeckonSwipeVC*)self.parentViewController.parentViewController;

    [self.swipeVC.beckon setObject:self.beckonTitle.text forKey:@"title"];
    [self.swipeVC.beckon setObject:self.beckonDescription.text forKey:@"description"];
    
    self.navigationItem.title = @"Title";
    
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.cancelButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.nextButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.nextButton;
//    [self.swipeVC.beckon setValue:self.beckonTitle.text forKey:@"title"];
//    [self.swipeVC.beckon setValue:self.beckonDescription.text forKey:@"description"];
}

- (void) cancel{
    [self.swipeVC dismissViewControllerAnimated:YES completion:nil];
}

- (void) next{
    NSLog(@"%@", self.swipeVC.beckon);
    [self.swipeVC swipeToNext:self.parentViewController sender:self];
}

- (IBAction)titleTyped:(id)sender {
    [self.swipeVC.beckon setValue:self.beckonTitle.text forKey:@"title"];
}

- (IBAction)descriptionTyped:(id)sender {
    [self.swipeVC.beckon setValue:self.beckonDescription.text forKey:@"description"];
}

@end
