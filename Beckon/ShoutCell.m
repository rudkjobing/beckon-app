//
//  BroShoutCell.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 15/04/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "ShoutCell.h"

@implementation ShoutCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) startTimer{
    [self updateLabel];
    NSTimer *timer = [[NSTimer alloc] init];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    
}

- (void) updateLabel{
    if(self.begins){
        NSTimeInterval ti = [self.begins timeIntervalSinceDate:[[NSDate alloc] init]];
        NSString *stringTi = [self stringFromTimeInterval:ti];
        self.timeLeft.text = stringTi;
    }
}


- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval
{
 
    if(interval > 60*60*24){
        [self.bgView setAlpha:0.7];
    }
    
    if(interval > 60*60*24*7){
        [self.bgView setAlpha:0.5];
    }
    
    if(interval > 60*60*24){
        NSInteger ti = (NSInteger)interval;
        NSInteger days = ti/60/60/24;
        if(days == 1){
            return [NSString stringWithFormat:@"%li Day", (long)days];
        }
        return [NSString stringWithFormat:@"%li Days", (long)days];
    }
    else if (interval > 60*60 && interval <= 60*60*24){
        NSInteger ti = (NSInteger)interval;
        NSInteger hours = ti/60/60;
        if(hours == 1){
            return [NSString stringWithFormat:@"%li Hour", (long)hours];
        }
        return [NSString stringWithFormat:@"%li Hours", (long)hours];
    }
    else if (interval <= 60*60 && interval > 0){
        NSInteger ti = (NSInteger)interval;
        NSInteger minutes = ti/60;
        if(minutes == 1){
            return [NSString stringWithFormat:@"%li Minute", (long)minutes];
        }
        return [NSString stringWithFormat:@"%li Minutes", (long)minutes];
    }

    
    return @"NOW";
}
@end
