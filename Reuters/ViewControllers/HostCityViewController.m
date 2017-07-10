//
//  HostCityViewController.m
//  Reuters
//
//  Created by Priya Talreja on 17/08/16.
//  Copyright © 2016 Scriptlanes. All rights reserved.
//

#import "HostCityViewController.h"
#import "PushNotificationViewController.h"
#import "WebsiteViewController.h"
@interface HostCityViewController ()
{
    NSMutableArray *imagePaths;
    NSString *objectId;
    
}
@end

@implementation HostCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imagePaths=[[NSMutableArray alloc]init];
    [imagePaths addObject:@"11"];
 
    
    dataArr=[[NSMutableArray alloc]init];
    hostCityDesc=[[NSMutableDictionary alloc]init];
    networkAC=[NetworkAccessor shareNetworkAccessor];
    dataAC=[DataAccessor shareDataAccessor];
        // KASlideshow
    _imageAutomaticSlide.datasource = self;
    _imageAutomaticSlide.delegate = self;
    [_imageAutomaticSlide setDelay:5]; // Delay between transitions
    [_imageAutomaticSlide setTransitionDuration:.5]; // Transition duration
    [_imageAutomaticSlide setTransitionType:KASlideShowTransitionSlideHorizontal]; // Choose a transition type (fade or slide)
    [_imageAutomaticSlide setImagesContentMode:UIViewContentModeScaleToFill]; // Choose a content mode for images to display
    [_imageAutomaticSlide addGesture:KASlideShowGestureAll]; // Gesture to go previous/next directly on the image
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:YES forKey:@"start"];

    [_imageAutomaticSlide stop];
}
-(void)startSlideShow
{
    [_imageAutomaticSlide start];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:YES forKey:@"start"];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
    [_imageAutomaticSlide stop];
    [self getData];
}
-(void)getData
{
    HUD = [[MBProgressHUD alloc] init];
     HUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:HUD];
    HUD.delegate = self;
    
    [HUD show:YES];
    
    NSFileManager *fileManage =[NSFileManager defaultManager];
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    if([networkAC internetConnectivity])
    {
        [networkAC getHostCity:^(NSInteger status, NSDictionary *results) {
            if(status)
            {
                 [HUD removeFromSuperview];
                NSString *fileName = @"HostCity";
                NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
                [results writeToFile:filePath atomically:YES];
                [self parseData:results];
                
            }
        }];
    }else
    {
        NSString *dataPath = [documentDirectory stringByAppendingPathComponent:@"HostCity"];
       
        if ([fileManage fileExistsAtPath:dataPath])
        {
            [HUD removeFromSuperview];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:dataPath];
            [self parseData:dict];
        }else
        {
            [HUD removeFromSuperview];
            
            UIAlertView * alertView1 = [[UIAlertView alloc]initWithTitle:@"JPL Pune 2017" message:@"Seems you are not connected to internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alertView1 show];
            
        }
    }


}

-(void)parseData : (NSDictionary *)result
{
    
    NSArray *results = [result objectForKey:@"results"];
    
        for(NSDictionary *dict in results)
            {
                HostCity *speaker = [dataAC getHostCity:dict];
                [dataArr addObject:speaker];
            }
            
    
    if (dataArr.count > 0) {
        for (HostCity *sp in dataArr)
        {
            if (sp.isActive) {
                objectId=sp.objectId;
                
                [self getHostCityImages];
                self.hostCity.text = [sp.name uppercaseString];
                self.desc.text = sp.description;
                
                NSMutableString *html = [NSMutableString stringWithString: @"<html>"];
                
                //continue building the string
                [html appendString:sp.description];
                [html appendString:@"</html>"];
                [_webView setBackgroundColor:[UIColor clearColor]];
                
                
                [_webView loadHTMLString:html baseURL:nil];
                
                CGRect labelValue=[self.desc.text boundingRectWithSize:CGSizeMake(self.desc.frame.size.width-2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.1]} context:nil];
                self.labelHeight.constant=labelValue.size.height;
                [self.view updateConstraintsIfNeeded];
                
            }
            
            
        }

    }
}


-(void)getHostCityImages
{
    NSFileManager *fileManage =[NSFileManager defaultManager];
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    if([networkAC internetConnectivity])
    {
        [networkAC getHostCityImages:objectId :^(NSInteger status, NSArray *results) {
            if(status)
            {
                 [HUD removeFromSuperview];
                NSString *fileName = [NSString stringWithFormat:@"HostCityImage_%@",objectId];
                NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
                [results writeToFile:filePath atomically:YES];
                [self parseHostCityImages:results];
            }
        }];
    }else
    {
        NSString *dataPath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"HostCityImage_%@",objectId]];
       
        if ([fileManage fileExistsAtPath:dataPath])
        {
            NSArray *dict = [[NSArray alloc] initWithContentsOfFile:dataPath];
            [self parseHostCityImages:dict];
        }else
        {
            [HUD removeFromSuperview];
            UIAlertView * alertView1 = [[UIAlertView alloc]initWithTitle:@"JPL Pune 2017" message:@"Seems you are not connected to internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alertView1 show];
        }
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}
-(BOOL)shouldAutorotate
{
    return NO;
}
-(void)parseHostCityImages : (NSArray *)results
{
    photosArr=[[NSMutableArray alloc]init];
    [imagePaths removeAllObjects];
    for(PFObject *dict in results)
    {
        HostCityImage *ph = [dataAC getHostCityPhoto:dict];
        
        [imagePaths addObject:[NSURL URLWithString:ph.image]];
        
        //[photosArr addObject:ph];
    }
   
    [_imageAutomaticSlide reloadData];
    [self performSelector:@selector(startSlideShow) withObject:NULL afterDelay:1.0];
    
    
    if([photosArr count] == 0)
    {
    }
    else
    {
        
    }
    
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSObject *)slideShow:(KASlideShow *)slideShow objectAtIndex:(NSUInteger)index
{
    return imagePaths[index];
}

- (NSUInteger)slideShowImagesNumber:(KASlideShow *)slideShow
{
    return imagePaths.count;
}

#pragma mark - KASlideShow delegate

- (void) slideShowWillShowNext:(KASlideShow *)slideShow
{
   
    
}

- (void) slideShowWillShowPrevious:(KASlideShow *)slideShow
{
    
    
}

- (void) slideShowDidShowNext:(KASlideShow *)slideShow
{
    
    
}

-(void) slideShowDidShowPrevious:(KASlideShow *)slideShow
{
    
    
}


- (IBAction)openLeft:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:NO forKey:@"start"];
    [_imageAutomaticSlide stop];
    [self.sidePanelController showLeftPanelAnimated:YES];
}

- (IBAction)openSide:(id)sender {
    [_imageAutomaticSlide stop];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:NO forKey:@"start"];

    [self.sidePanelController showLeftPanelAnimated:YES];
}

- (IBAction)openTwitter:(id)sender {
    WebsiteViewController *vv =[self.storyboard instantiateViewControllerWithIdentifier:@"WebsiteViewController"];
    [self.navigationController pushViewController:vv animated:true];
    
    
    
}

- (IBAction)openNotifciations:(id)sender {
    
    PushNotificationViewController *vv =[self.storyboard instantiateViewControllerWithIdentifier:@"PushNotificationViewController"];
    [self.navigationController pushViewController:vv animated:true];
}

@end
