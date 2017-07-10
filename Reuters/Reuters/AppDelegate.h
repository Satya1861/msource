//
//  AppDelegate.h
//  Reuters
//
//  Created by Priya on 30/01/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JASidePanels/JASidePanelController.h>
#import "DataAccessor.h"
#import "AppUser.h"
#import "NetworkAccessor.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>
{
    NetworkAccessor *networkAC;
    DataAccessor *dataAC;
    AppUser *appUser;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JASidePanelController *viewController;

@property (nonatomic) int selIndex;
@property (assign, nonatomic) BOOL shouldRotate;
@end

