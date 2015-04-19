//
//  FriendRequestCell.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 11/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "FriendRequestCell.h"

@interface FriendRequestCell ()

@end

@implementation FriendRequestCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)acceptAction:(id)sender {
    if(self.delegate){
        [self.delegate acceptFriendRequestAction:self];
    }
}

- (IBAction)declineAction:(id)sender {
    if(self.delegate){
        [self.delegate declineFriendRequestAction:self];
    }
}

@end
