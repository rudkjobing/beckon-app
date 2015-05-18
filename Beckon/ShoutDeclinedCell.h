//
//  ShoutDeclinedCell.h
//  BroShout
//
//  Created by Steffen Rudkjøbing on 16/05/15.
//  Copyright (c) 2015 BroShout IVS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShoutDeclinedCellDelegate <NSObject>
- (void) dismissShoutAction: (id) sender;
@end

@interface ShoutDeclinedCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@end
