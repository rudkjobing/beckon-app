//
//  SwipeVC.h
//  Beckon
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "YZSwipeBetweenViewController.h"

@interface SwipeVC : YZSwipeBetweenViewController

- (void)swipeToIndex: (NSInteger)index;
- (void)swipeToNext: (id)sender;
- (void)swipeToPrevious: (id)sender;

@end
