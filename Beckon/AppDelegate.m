//
//  AppDelegate.m
//  BroShout
//
//  Created by Steffen Rudkjøbing on 02/01/15.
//  Copyright (c) 2015 Steffen Harbom Rudkjøbing. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"


@import AudioToolbox;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{
                                 @"uuid": token,
                                 @"type": @"APPLE"
                                 };
    [manager POST:@"http://api.broshout.net:9000/account/device/register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {

     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PleaseUpdate" object:self];
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:@"http://api.broshout.net:9000/badge" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *response = responseObject;
         NSInteger badge = [[response objectForKey:@"badge"] intValue];
         [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
