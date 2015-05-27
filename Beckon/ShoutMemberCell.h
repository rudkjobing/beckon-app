//
//  ShoutMemberCell.h
//  BroShout
//
//  Created by Steffen Rudkjøbing on 25/05/15.
//  Copyright (c) 2015 BroShout IVS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoutMemberCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *role;
@property (strong, nonatomic) IBOutlet UIButton *button;

@end
