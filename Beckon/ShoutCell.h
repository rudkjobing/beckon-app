//
//  BroShoutCell.h
//  BroShout
//
//  Created by Steffen Rudkjøbing on 15/04/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoutCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *members;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *timeLeft;
@property (weak, nonatomic) IBOutlet UILabel *timeOfDay;

@property(strong,nonatomic) NSDate *begins;

- (void) startTimer;

@end
