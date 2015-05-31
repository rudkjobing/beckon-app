//
//  SettingsVC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "SettingsVC.h"
#import "AFNetworking.h"

@interface SettingsVC ()
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Settings & options";
    self.table.delegate = self;
    self.table.dataSource = self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if(indexPath.row == 0){
        cell.textLabel.text = @"Sign out everywhere";
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        
        [self.spinner startAnimating];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager DELETE:@"http://api.broshout.net:9000/account/sessions" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [self.spinner stopAnimating];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UserUnautherized" object:self];
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self.spinner stopAnimating];
             NSInteger statusCode = operation.response.statusCode;
             if(statusCode == 401) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"UserUnautherized" object:self];
             }
         }];
        
    }
}

@end

