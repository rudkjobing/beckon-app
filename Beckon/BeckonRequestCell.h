//
//  BroShoutRequestCell.h
//  BroShout
//
//  Created by Steffen Rudkjøbing on 15/04/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeckonRequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headline;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *begins;

@end
