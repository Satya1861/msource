//
//  HostCity.h
//  Reuters
//
//  Created by Priya Talreja on 18/08/16.
//  Copyright © 2016 Scriptlanes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HostCity : NSObject

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) BOOL isActive;
@end
