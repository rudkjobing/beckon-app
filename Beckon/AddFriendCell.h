//
//  AddFriendCell.h
//  Beckon
//
//  Created by Steffen Rudkjøbing on 03/05/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddFriendCellDelegate <NSObject>
- (void) inviteFriend: (id) sender;
@end

@interface AddFriendCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *user;
@property (strong, nonatomic) IBOutlet UILabel *email;
@property (strong, nonatomic) IBOutlet UILabel *invitationSentLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) id <AddFriendCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *inviteButton;

- (void) friendAdded;
- (void) friendNotAdded;

@end

