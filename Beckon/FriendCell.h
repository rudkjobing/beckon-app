//
//  FriendCell.h
//  Beckon
//
//  Created by Steffen Rudkjøbing on 12/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;

@end
