//
//  ShoutMiscVC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 14/05/15.
//  Copyright (c) 2015 BroShout IVS. All rights reserved.
//

#import "ShoutMiscVC.h"
#import "ShoutSwipeVC.h"
#import "AFNetworking.h"

@interface ShoutMiscVC ()

@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) ShoutSwipeVC *swipeVC;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIButton *accept;
@property (strong, nonatomic) IBOutlet UIButton *maybe;
@property (strong, nonatomic) IBOutlet UIButton *decline;

@end

@implementation ShoutMiscVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.swipeVC = (ShoutSwipeVC *)self.parentViewController.parentViewController;
    self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];;
    self.backButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.backButton;
    if([[self.swipeVC.shout objectForKey:@"status"] isEqualToString:@"ACCEPTED"]){
        [self.accept setEnabled:NO];
        [self.accept setAlpha:0.1];
    }
    else if([[self.swipeVC.shout objectForKey:@"status"] isEqualToString:@"MAYBE"]){
        [self.maybe setEnabled:NO];
        [self.maybe setAlpha:0.1];
    }
    else if([[self.swipeVC.shout objectForKey:@"status"] isEqualToString:@"DECLINED"]){
        [self.decline setEnabled:NO];
        [self.decline setAlpha:0.1];
    }
}

- (void) back{
    [self.swipeVC dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeStatus:(UIButton *)sender {

    NSString *status = @"";
    
    if([sender.titleLabel.text isEqualToString:@"Cool"] ){
        status = @"ACCEPTED";
        [self.accept setEnabled:NO];
        [self.accept setAlpha:0.1];
        [self.maybe setEnabled:YES];
        [self.maybe setAlpha:1.0];
        [self.decline setEnabled:YES];
        [self.decline setAlpha:1.0];
    }
    else if([sender.titleLabel.text isEqualToString:@"Hmm"] ){
        status = @"MAYBE";
        [self.accept setEnabled:YES];
        [self.accept setAlpha:1.0];
        [self.maybe setEnabled:NO];
        [self.maybe setAlpha:0.1];
        [self.decline setEnabled:YES];
        [self.decline setAlpha:1.0];
    }
    else if([sender.titleLabel.text isEqualToString:@"Pass"] ){
        status = @"DECLINED";
        [self.accept setEnabled:YES];
        [self.accept setAlpha:1.0];
        [self.maybe setEnabled:YES];
        [self.maybe setAlpha:1.0];
        [self.decline setEnabled:NO];
        [self.decline setAlpha:0.1];
    }
    
    NSDictionary *update = @{@"memberId": [self.swipeVC.shout objectForKey:@"memberId"], @"shoutId": [self.swipeVC.shout objectForKey:@"id"], @"status": status};
    
    [self.spinner startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"http://api.broshout.net:9000/shout/membership/status" parameters:update success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self.spinner stopAnimating];
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.spinner stopAnimating];
         NSInteger statusCode = operation.response.statusCode;
         NSLog(@"%ld", (long)statusCode);
         if(statusCode == 401) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UserUnautherized" object:self];
         }
     }];
    
}

@end
