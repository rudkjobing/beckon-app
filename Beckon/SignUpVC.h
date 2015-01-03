//
//  SignUpVC.h
//  Beckon
//
//  Created by Steffen Rudkjøbing on 02/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpVC : UIViewController

-(void)signUpWithEmail:(NSString*)email phoneNumber:(NSString*)phoneNumber firstName:(NSString*)firstName andPassword:(NSString*)password;

@end
