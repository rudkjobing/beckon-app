//
//  SignInVC.h
//  BroShout
//
//  Created by Steffen Rudkjøbing on 02/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *message;

-(void)signInWithEmail:(NSString*)email andPassword:(NSString*)password;

@end
