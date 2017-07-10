//
//  MoviePlayerViewController.m
//  Reuters
//
//  Created by Priya on 12/02/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import "MoviePlayerViewController.h"

@interface MoviePlayerViewController ()

@end

@implementation MoviePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self playMovie];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:YES];
    
}

-(BOOL)shouldAutorotate
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}
- (IBAction)backClicked:(id)sender {
    [_moviePlayer stop];
     [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)playMovie
{
    
    NSURL *docUrl= [NSURL URLWithString:@" https://scontent.cdninstagram.com/hphotos-xfa1/t50.2886-16/11336249_1783839318509644_116225363_n.mp4"];
    if (_moviePlayer != nil)
    {
        _moviePlayer = nil;
        
    }
    
  
    _moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:docUrl];
    _moviePlayer.view.frame = CGRectMake(self.view.frame.origin.x, 65, self.view.frame.size.width, self.view.frame.size.height-65);
    _moviePlayer.scalingMode =  MPMovieScalingModeAspectFill;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doneButtonClick:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.backgroundView.backgroundColor=[UIColor whiteColor];
    _moviePlayer.shouldAutoplay = YES;
    _moviePlayer.repeatMode = NO;
    [_moviePlayer setRepeatMode:MPMovieRepeatModeNone];
    _moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    _moviePlayer.fullscreen = YES;
    [self.view addSubview:_moviePlayer.view];
    
    [_moviePlayer play];
}


- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    [_moviePlayer stop];
    [_moviePlayer.view removeFromSuperview];
    if (_moviePlayer != nil)
    {
        _moviePlayer = nil;
        
    }
    
     [[NSNotificationCenter defaultCenter]removeObserver:self];
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
     [[NSNotificationCenter defaultCenter]removeObserver:self];
    if ([player respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player stop];
        [player setRepeatMode:MPMovieRepeatModeNone];
        [player.view removeFromSuperview];
        if (player != nil) {
            
            player = nil;
        }
        [self.navigationController popViewControllerAnimated:YES];
        //  [self dismissModalViewControllerAnimated:NO];
        
    }
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    UIDeviceOrientation Lorientation = [[UIDevice currentDevice] orientation];
     CGRect screenBounds = [UIScreen mainScreen].bounds ;
    CGFloat width = CGRectGetWidth(screenBounds)  ;
    CGFloat height = CGRectGetHeight(screenBounds) ;
    if (Lorientation == UIDeviceOrientationLandscapeLeft || Lorientation == UIDeviceOrientationLandscapeRight)  {
        screenBounds.size = CGSizeMake(height, width);
        
         [_moviePlayer setFullscreen:YES animated:YES];
        
        
    }
    else
    {
        
    }

}
-(void)viewWillDisappear:(BOOL)animated
{
    
    
}

-(void)doneButtonClick:(NSNotification*)aNotification
{
    [_moviePlayer pause];
    [_moviePlayer stop];
    [_moviePlayer.view removeFromSuperview];
    MPMoviePlayerController *player = [aNotification object];
    player.view.hidden = YES;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerWillExitFullscreenNotification
     object:player];
    
    if (_moviePlayer != nil)
    {
        _moviePlayer = nil;
        
    }
    [player stop];
    if ([player respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player pause];
        [player stop];
        [player setRepeatMode:MPMovieRepeatModeNone];
        [player.view removeFromSuperview];
        
        if (player != nil) {
            player = nil;
        }
    
        [self.navigationController popViewControllerAnimated:YES];
       
    }
}

-(void)viewDidLayoutSubviews
{
    _moviePlayer.view.frame = CGRectMake(self.view.frame.origin.x, 65, self.view.frame.size.width, self.view.frame.size.height-65);
}

@end
