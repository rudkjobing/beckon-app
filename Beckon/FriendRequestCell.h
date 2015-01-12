//
//  FriendRequestCell.h
//  Beckon
//
//  Created by Steffen Rudkjøbing on 11/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FriendRequestCellDelegate <NSObject>
- (void) acceptFriendRequestAction: (id) sender;
- (void) declineFriendRequestAction: (id) sender;
@end

@interface FriendRequestCell : UITableViewCell
//{
//    id <FriendRequestCellDelegate> delegate;
//}
@property (nonatomic, assign) id <FriendRequestCellDelegate> delegate;
@property (strong, nonatomic) NSDictionary *friend;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
