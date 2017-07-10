//
//  FoldersViewController.m
//  Reuters
//
//  Created by Priya Talreja on 06/02/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import "FoldersViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PhotoCollectionViewController.h"
#import "VideosViewController.h"
#import "MoviePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PushNotificationViewController.h"
#import "WebsiteViewController.h"
@interface FoldersViewController ()
{
    NSMutableArray *folders;
    NSMutableArray *videoFolders;
}
@end

@implementation FoldersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    networkAC = [NetworkAccessor shareNetworkAccessor];
    dataAC = [DataAccessor shareDataAccessor];
    HUD = [[MBProgressHUD alloc] init];
     HUD.mode = MBProgressHUDModeIndeterminate;
  //  HUD.color = [UIColor clearColor];
    [self getData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getData
{
    NSFileManager *fileManage =[NSFileManager defaultManager];
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    
    [self.view addSubview:HUD];
    HUD.delegate = self;
       [HUD show:YES];
    
    if([networkAC internetConnectivity])
    {
        
        [networkAC getFolders:^(NSInteger status, NSDictionary *results) {
            if(status)
            {
                [HUD removeFromSuperview];
                NSString *fileName = @"folders";
                NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
                [results writeToFile:filePath atomically:YES];
                [self parseData:results];
                
            }
        }];
    }else
    {
        NSString *dataPath = [documentDirectory stringByAppendingPathComponent:@"folders"];
        
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
-(void)parseData:(NSDictionary *)data
{
    folders = [[NSMutableArray alloc]init];
    videoFolders = [[NSMutableArray alloc]init];
    NSArray *results = [data objectForKey:@"result"];
    if (results.count > 0) {
        for (int i=0; i < results.count; i++) {
            NSDictionary *currFolder = [results objectAtIndex:i];
            if ([[currFolder objectForKey:@"isImage"]boolValue]) {
                [folders addObject:currFolder];
            }
            else
            {
                [videoFolders addObject:currFolder];
            }
        }
        [folders addObjectsFromArray:videoFolders];
        [self setFoldersUI];
    }
    
    
    
}

-(void)setFoldersUI
{
    
    
    float buttonWidth;
    float imageWidth;
    float buttonHeight;
    float startY;
    float startYImg;
    buttonWidth=[UIScreen mainScreen].bounds.size.width/2;
    imageWidth = ([UIScreen mainScreen].bounds.size.width - 30)/2;
    buttonHeight=buttonWidth;
    startY = 0;
    startYImg = 0.0 + 10;
    for(int i=0;i<folders.count;i++)
    {
        float xPos = 0.0;
        float xPosImg = 0.0 + 10;
        float yPos = startY;
        float yPosImg = startYImg;
        switch (i%2) {
                
            case 0:
            {
                xPos = 0.0;
                
                
            }
                break;
            case 1:
            {
                xPos = 0 + buttonWidth;
                xPosImg = 0 + imageWidth + 20;
                startYImg = imageWidth + startYImg + 43 + 10;
                startY = startY + buttonHeight + 43;
            }
                
                break;
                
            default:
                break;
        }
        
        
        NSDictionary *currFolder = [folders objectAtIndex:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        // [button setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        button.frame=CGRectMake(xPos,yPos,buttonWidth, buttonHeight);
        button.tag = i;
        
        
        CGPoint imageCenter = CGPointMake(CGRectGetMidX(button.frame), CGRectGetMidY(button.frame));
        
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(xPosImg,yPosImg, imageWidth, imageWidth)];
        imgView.layer.borderWidth = 1.0f;
        imgView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        imgView.layer.cornerRadius = 10;
        imgView.layer.masksToBounds = true;
        
        
        
        
        if ([[currFolder objectForKey:@"isImage"]boolValue])
        {
            if ([[currFolder objectForKey:@"imageFile"]objectForKey:@"url"]) {
                [imgView sd_setImageWithURL:[NSURL URLWithString:[[currFolder objectForKey:@"imageFile"]objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
            }
        }
        else
        {
            NSString *mainUrl=@"http://img.youtube.com/vi/";
            if ([currFolder objectForKey:@"youtubeId"]) {
                NSString *youtubeId = [currFolder objectForKey:@"youtubeId"];
                NSString *thumbNail = [youtubeId stringByAppendingString:@"/0.jpg"];
                NSString *thumbNailUrl = [mainUrl stringByAppendingString:thumbNail];
                [imgView sd_setImageWithURL:[NSURL URLWithString:thumbNailUrl] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
            }
            else
            {
                [imgView setImage:[UIImage imageNamed:@"video_default"]];
            }
            //  youtubeId
            
            
            
        }
        imgView.tag = i;
        
        
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(xPosImg,yPosImg + imageWidth +3, imageWidth, 40)];
        
        label.textAlignment=NSTextAlignmentLeft;
        [label setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        if ([[currFolder objectForKey:@"photoFolderId"]objectForKey:@"name"])
        {
            if ([currFolder objectForKey:@"folderCount"]) {
                NSString *name=[[[currFolder objectForKey:@"photoFolderId"]objectForKey:@"name"]stringByAppendingString:@" ("];
                NSString *count = [[currFolder objectForKey:@"folderCount"]stringValue];
                NSString *roundBracket = [count stringByAppendingString:@")"];
                label.text = [name stringByAppendingString:roundBracket];
            }
            else
            {
                label.text = [[currFolder objectForKey:@"photoFolderId"]objectForKey:@"name"];
            }
            
            
        }
        
        
        label.numberOfLines=2;
        label.tag=i;
        
        
        
        [self.scrollView addSubview:imgView];
        [self.scrollView addSubview:label];
        [self.scrollView addSubview:button];
    }
    int count = 0;
    if((folders.count) % 2 == 0)
    {
        count = (int)folders.count/2;
    }
    else
    {
        int ct = (int)folders.count + 1;
        count = ct/2;
    }
    [self.scrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width,(buttonWidth+46) * count)];
}
-(void)buttonClicked:(UIButton*)sender
{
    NSDictionary *currFolder = [folders objectAtIndex:sender.tag];
   
        PhotoCollectionViewController *pcVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoCollectionViewController"];
        pcVC.photoObjectId = [[currFolder objectForKey:@"photoFolderId"]objectForKey:@"objectId"];
        pcVC.isVideo = [[currFolder objectForKey:@"isImage"]boolValue];
        [self.navigationController pushViewController:pcVC animated:true];
   
    
}
- (IBAction)openLeft:(id)sender {
     [self.sidePanelController showLeftPanelAnimated:YES];
}
-(UIImage *)loadThumbNail:(NSURL *)urlVideo
{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:urlVideo options:nil];
    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generate.appliesPreferredTrackTransform=TRUE;
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 60);
    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
    NSLog(@"err==%@, imageRef==%@", err, imgRef);
    return [[UIImage alloc] initWithCGImage:imgRef];
}

- (IBAction)openTwitter:(id)sender {
    WebsiteViewController *vv =[self.storyboard instantiateViewControllerWithIdentifier:@"WebsiteViewController"];
    [self.navigationController pushViewController:vv animated:true];

    
   
}

- (IBAction)openNotifciations:(id)sender {
    
    PushNotificationViewController *vv =[self.storyboard instantiateViewControllerWithIdentifier:@"PushNotificationViewController"];
    [self.navigationController pushViewController:vv animated:true];
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
