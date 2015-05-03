//
//  FriendCell.h
//  BroShout
//
//  Created by Steffen Rudkjøbing on 12/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *email;

@end
