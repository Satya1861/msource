//
//  Member.h
//  Reuters
//
//  Created by Priya Talreja on 01/02/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *memberName;
@property (nonatomic, strong) NSString *profilePic;
@property (nonatomic, strong) NSDictionary *teamId;

@end
