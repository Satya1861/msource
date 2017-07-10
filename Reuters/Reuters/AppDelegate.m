//
//  AppDelegate.m
//  Reuters
//
//  Created by Priya on 30/01/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import "AppDelegate.h"
#import "SSZipArchive.h"
#import <Parse/Parse.h>
#import "XCDYouTubeKit.h"
#import "XCDYouTubeVideoPlayerViewController.h"
#import <AFNetworking/AFNetworking.h>




@interface AppDelegate ()
{
    NSMutableArray *alerts;
    NSMutableDictionary *alertWithtime;
    BOOL isReg;
}
@end

@implementation AppDelegate
@synthesize shouldRotate;


-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if (self.shouldRotate)
        return UIInterfaceOrientationMaskAllButUpsideDown;
    else
        return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:3.0];
    dataAC = [DataAccessor shareDataAccessor];
    appUser= [dataAC loggedInUser];
    networkAC =[NetworkAccessor shareNetworkAccessor];
    _selIndex=1;
    
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"34kw1RSNbc52ki5ggls8KTrAuXvtzLxSWrj5GxlB";
        
        configuration.localDatastoreEnabled=true;
        configuration.clientKey = @"N2wsmMt5991pylA5dX5VNmo7DquAL9dk61l3muy3";
      configuration.server = @"http://34.209.23.24:1338/parse";
     //   configuration.server =@"http://192.168.0.126:1338/parse";
    }]];
    

    
    
    
    [self mergeCachedImages];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotifications];
      //  [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeSound)];
    }

    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.viewController = [[JASidePanelController alloc] init];
    
    self.viewController.pushesSidePanels = NO;
    
    self.viewController.leftPanel = [storyboard instantiateViewControllerWithIdentifier:@"LeftPanelViewController"];
    self.viewController.centerPanel = [storyboard instantiateViewControllerWithIdentifier:@"LandingViewController"];
    
    UINavigationController *navVC = [storyboard instantiateViewControllerWithIdentifier:@"navigation2"];
    navVC = [navVC initWithRootViewController:self.viewController];
    
    
    NSUserDefaults *defaults1=[NSUserDefaults standardUserDefaults];
    if ([defaults1 objectForKey:@"isRegistered"]) {
        isReg=[[defaults1 objectForKey:@"isRegistered"]boolValue];
    }

    
//    if(isReg == NO)
//    {
//        if ([networkAC internetConnectivity]) {
//            [PFInstallation getCurrentInstallationInBackground];
//            [networkAC checkIfUserExist:@"dsf" :^(NSInteger status, NSArray *reuslt) {
//                if (status) {
//                    if (reuslt.count == 0) {
//                        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"navigation1"];
//                    }
//                    else
//                    {
//                        [dataAC saveUserCredentials:[reuslt objectAtIndex:0]];
//                    }
//                }
//            }];
//        }
//        else
//        {
//            UIAlertView * alertView1 = [[UIAlertView alloc]initWithTitle:@"JPL Pune 2017" message:@"Seems you are not connected to internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//            [alertView1 show];
//        }
//        
//    }else
        self.window.rootViewController = navVC;
    
    return YES;
}

-(void)mergeCachedImages
{
    NSString *sourceBasePath = [[NSBundle mainBundle] pathForResource:@"com.hackemist.SDWebImageCache.default" ofType:@"zip"];
    NSArray *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *destBasePath = [[libraryPath objectAtIndex:0] stringByAppendingPathComponent:@"Caches/com.hackemist.SDWebImageCache.default"];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL isDir;
    BOOL exists = [fileManager fileExistsAtPath:destBasePath isDirectory:&isDir];
    if (!exists)
    {
        destBasePath = [[libraryPath objectAtIndex:0] stringByAppendingPathComponent:@"Caches"];
        [SSZipArchive unzipFileAtPath:sourceBasePath toDestination:destBasePath];
    }
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [PFPush handlePush:userInfo];

    NSString *msg;
    NSLog(@"User info %@",userInfo);
    
    
    
    if ([userInfo count]!= 0)
    {
        msg = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    }
    else
    {
        msg = @"You have received a notification";
    }
    
    if ([userInfo count]!= 0){
        if ([userInfo objectForKey:@"link"]) {
            if ([[userInfo objectForKey:@"link"] isEqualToString:@""] || [[userInfo objectForKey:@"link"] isEqualToString:@" "]) {
                
                
            }
            else
            {
            XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:[userInfo objectForKey:@"link"]];
            // videoPlayerViewController.moviePlayer.backgroundPlaybackEnabled = true;
            
            // videoPlayerViewController.preferredVideoQualiti = self.lowQualitySwitch.on ? @[ @(XCDYouTubeVideoQualitySmall240), @(XCDYouTubeVideoQualityMedium360) ] : nil;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:videoPlayerViewController.moviePlayer];
            
            
            [self.window.rootViewController presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
            }
        }
    }
    

}
- (void) moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:notification.object];
    MPMovieFinishReason finishReason = [notification.userInfo[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    if (finishReason == MPMovieFinishReasonPlaybackError)
    {
        NSString *title = NSLocalizedString(@"Video Playback Error", @"Full screen video error alert - title");
        NSError *error = notification.userInfo[XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey];
        NSString *message = [NSString stringWithFormat:@"%@\n%@ (%@)", error.localizedDescription, error.domain, @(error.code)];
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Full screen video error alert - cancel button");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alertView show];
    }
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    NSString *msg;
    NSLog(@"User info %@",userInfo);
    
    if ( application.applicationState == UIApplicationStateActive )
        NSLog(@"inside");
        else
            NSLog(@"from");

    NSLog(@"This is did recieve");
    if ([userInfo count]!= 0)
    {
        msg = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    }
    else
    {
        msg = @"You have received a notification";
    }
    alertWithtime = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults=([NSUserDefaults standardUserDefaults]);
    [alertWithtime setObject:msg forKey:@"alert"];
    [alertWithtime setObject:[NSDate date] forKey:@"dateOfAlert"];
    [alerts addObject:alertWithtime];
    [defaults setObject:alerts forKey:@"todayAlerts"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    alertView.delegate= self;
    
     [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.viewController.centerPanel = [storyboard instantiateViewControllerWithIdentifier:@"PushNotificationViewController"];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    if (error.code == 3010)
    {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    }
    else
    {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
