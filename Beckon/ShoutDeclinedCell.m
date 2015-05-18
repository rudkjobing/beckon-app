//
//  ShoutDeclinedCell.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 16/05/15.
//  Copyright (c) 2015 BroShout IVS. All rights reserved.
//

#import "ShoutDeclinedCell.h"

@implementation ShoutDeclinedCell

- (void)awakeFromNib {
    [self.bgView setAlpha:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
