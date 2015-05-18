//
//  BroShoutRequestCell.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 15/04/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "ShoutRequestCell.h"

@implementation ShoutRequestCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)acceptAction:(UIButton *)sender {
    [sender setEnabled:NO];
    [self.delegate acceptShoutRequestAction:self];
}

- (IBAction)maybeAction:(UIButton *)sender {
    [sender setEnabled:NO];
    [self.delegate maybeShoutRequestAction:self];
}

- (IBAction)declineAction:(UIButton *)sender {
    [sender setEnabled:NO];
    [self.delegate declineShoutRequestAction:self];
}

@end
