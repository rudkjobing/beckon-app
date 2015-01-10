//
//  BeckonsVC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 03/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "BeckonsVC.h"
#import "AFNetworking.h"
#import "CreateBeckonSwipeVC.h"

@interface BeckonsVC ()

@property (strong, nonatomic) UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation BeckonsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBeckon)];
    self.addButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.addButton;
    self.navigationItem.title = @"Beckons";
}

- (void)addBeckon{
    CreateBeckonSwipeVC *createBeckonModal = [CreateBeckonSwipeVC new];
    [self presentViewController:createBeckonModal animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [self getBeckons];
}

-(void)getBeckons{
    [self.spinner startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:@"http://localhost:9000/beckons" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
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
