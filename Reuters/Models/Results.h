//
//  Results.h
//  Reuters
//
//  Created by Priya Talreja on 03/02/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Results : NSObject
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *matchName;
@property (nonatomic, strong) NSString *stadiumName;
@property (nonatomic, strong) NSArray *team;
@property (nonatomic, strong) NSDate *dateOfMatch;
@property (nonatomic,strong)NSString *fixtureId;
@property (nonatomic)BOOL isReportEntered;
@end
