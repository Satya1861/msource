//
//  VideosViewController.m
//  Reuters
//
//  Created by Priya Talreja on 06/02/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import "VideosViewController.h"
#import "AppDelegate.h"
@interface VideosViewController ()
{
    BOOL videoLoaded;
    BOOL videoLoaded1;
    
}
@end

@implementation VideosViewController
@synthesize videoId;
- (void)viewDidLoad {
    [super viewDidLoad];
    HUD = [[MBProgressHUD alloc] init];
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    _webView.hidden = true;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doneButtonClick:)
                                                 name:@"UIWindowDidBecomeHiddenNotification"
                                               object:nil];
    
    
    
    NSString *yt = @"<html><body><script src='https://www.youtube.com/iframe_api'></script><button>play fullscreen</button><br><div id='player'></div><script src='https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js></script><script>var player, iframe;var $ = document.querySelector.bind(document);// init playerfunction onYouTubeIframeAPIReady() { player = new YT.Player('player', {   height: '200',   width: '300',   videoId: 'cx0458MJwT0',   events: {     'onReady': onPlayerReady   } });}// when ready, wait for clicksfunction onPlayerReady(event) { var player = event.target; iframe = $('#player'); setupListener(); }function setupListener (){$('button').addEventListener('click', playFullscreen);}function playFullscreen (){ player.playVideo();//won't work on mobile var requestFullScreen = iframe.requestFullScreen || iframe.mozRequestFullScreen || iframe.webkitRequestFullScreen; if (requestFullScreen) {   requestFullScreen.bind(iframe)(); }}</script></body></html>";
    
     [_webView loadHTMLString:yt baseURL:nil];
    
    videoLoaded1 = false;
    videoLoaded = false;

    
}
-(void)viewDidAppear:(BOOL)animated
{
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];

}
-(void)doneButtonClick:(UIButton *)sender
{
    if (videoLoaded) {
        if (videoLoaded1)
        {
             [self.navigationController popViewControllerAnimated:true];
        }
        else
        {
            videoLoaded1 = true;
        }
        
    }
    videoLoaded = true;
}
-(void)viewDidDisappear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] removeObserver:@
      "UIWindowDidBecomeHiddenNotification"];
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
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    
    [self.view addSubview:HUD];
    HUD.delegate = self;
    
    [HUD show:YES];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
   _webView.hidden = false;
    [HUD removeFromSuperview];
}
- (IBAction)backClicked:(id)sender {
     [self.navigationController popViewControllerAnimated:true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
