//
//  AddFriendCell.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 03/05/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "AddFriendCell.h"

@implementation AddFriendCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
}

- (IBAction)inviteFriendAction:(id)sender {
    [self.activityIndicator startAnimating];
    [self.inviteButton setHidden: YES];
    [self.delegate inviteFriend:self];
}

- (void) friendAdded{
    [self.activityIndicator stopAnimating];
    [self.invitationSentLabel setHidden: NO];
    
}

- (void) friendNotAdded{
    [self.activityIndicator stopAnimating];
    self.invitationSentLabel.text = @"Error";
    [self.invitationSentLabel setHidden: NO];
}

@end
