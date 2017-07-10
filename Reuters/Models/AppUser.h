//
//  AppUser.h
//  DemoSharingApp
//
//  Created by Priya on 27/01/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFObject+NSCoding.h"

@interface AppUser : NSObject

@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) NSString *fullName;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *contactNo;
@property (nonatomic) BOOL isPending;
@property (nonatomic, retain) PFUser *facebookLink;
@end
