//
//  SwipeVC.h
//  BroShout
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "YZSwipeBetweenViewController.h"

@interface SwipeVC : YZSwipeBetweenViewController

- (void)swipeToIndex: (NSInteger)index sender:(id)sender;
- (void)swipeToNext: (id)controllerToSwipe sender:(id)sender;
- (void)swipeToPrevious: (id)controllerToSwipe sender:(id)sender;

@end
