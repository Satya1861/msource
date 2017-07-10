//
//  MoviePlayerViewController.h
//  Reuters
//
//  Created by Sonali on 12/02/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
@interface MoviePlayerViewController : UIViewController
{
    MPMoviePlayerController * _moviePlayer;
    
}
@property (nonatomic , strong)NSString *path;

@end
