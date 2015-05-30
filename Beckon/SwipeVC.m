//
//  SwipeVC.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "SwipeVC.h"

@interface SwipeVC ()

@end

@implementation SwipeVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)swipeToPrevious:(id)controllerToSwipe sender:(id)sender {
    NSInteger currentIndex = [self.viewControllers indexOfObject:controllerToSwipe];
    NSInteger newIndex = currentIndex - 1;
    if(currentIndex != 0){
        [[self view] endEditing:YES];
        [self scrollToViewControllerAtIndex:newIndex animated:YES];
    }
}

- (void)swipeToNext:(id)controllerToSwipe sender:(id)sender {
    NSInteger currentIndex = [self.viewControllers indexOfObject:controllerToSwipe];
    NSInteger newIndex = currentIndex + 1;
    if(newIndex <= self.viewControllers.count){
        [[self view] endEditing:YES];
        [self scrollToViewControllerAtIndex:newIndex animated:YES];
    }
}

- (void)swipeToIndex:(NSInteger)index sender:(id)sender{
    [[self view] endEditing:YES];
    [self scrollToViewControllerAtIndex:index animated:YES];
}

@end
