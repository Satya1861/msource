//
//  Photos.h
//  Reuters
//
//  Created by Sonali on 16/02/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Photos : NSObject

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageFile;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *youtubeId;
@property(nonatomic)BOOL isImage;
@end
