//
//  CreateBeckonStep1VC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "CreateShoutStep1VC.h"
#import "CreateShoutSwipeVC.h"

@interface CreateShoutStep1VC ()

@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *nextButton;
@property (strong, nonatomic) CreateShoutSwipeVC *swipeVC;
@property (weak, nonatomic) IBOutlet UITextField *beckonTitle;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *where;

@end

@implementation CreateShoutStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.swipeVC = (CreateShoutSwipeVC*)self.parentViewController.parentViewController;

    [self.swipeVC.beckon setObject:self.beckonTitle.text forKey:@"title"];
    [self.swipeVC.beckon setObject:[NSMutableDictionary new] forKey:@"location"];
    [self.swipeVC.beckon setObject:self.datePicker.date.description forKey:@"begins"];
    
    self.navigationItem.title = @"Shout";
    
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.cancelButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.nextButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
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
- (IBAction)whereTyped:(id)sender {
    [[self.swipeVC.beckon objectForKey:@"location"] setValue:self.where.text forKey:@"name"];
}

- (IBAction)dateSelected:(id)sender {
    [self.swipeVC.beckon setValue:self.datePicker.date.description forKey:@"begins"];
}

@end
