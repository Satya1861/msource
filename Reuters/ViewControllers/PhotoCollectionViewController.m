//
//  PhotoCollectionViewController.m
//  Reuters
//
//  Created by Sonali on 16/02/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "SponsporLinkViewController.h"
#import "PushNotificationViewController.h"
#import "WebsiteViewController.h"
#import "VideosViewController.h"
#import "XCDYouTubeKit.h"
#import "XCDYouTubeVideoPlayerViewController.h"
#import "AppDelegate.h"
//#import "MPMoviePlayerController+BackgroundPlayback.h"
@interface PhotoCollectionViewController ()
{
    CGFloat photoCellPrevWidth;
    UILabel *link;
    UILabel *name;
    NSInteger previousOffset;
    NSInteger selectedValue;
}
@end

@implementation PhotoCollectionViewController
@synthesize photoObjectId,isVideo;
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        networkAC = [NetworkAccessor shareNetworkAccessor];
        dataAC = [DataAccessor shareDataAccessor];
    }
    return self;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    photosArr = [[NSMutableArray alloc] init];
    dataArr = [[NSMutableArray alloc] init];
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    i=0;
    selectedValue = 0;
    if(app.selIndex  == 5)
    {
        headerLabel.text = @"SPONSORS";
        self.imageBack.image = [UIImage imageNamed:@"menu"];
        [sponsorCollectionView setBackgroundColor:[UIColor whiteColor]];
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        self.isNextView = NO;
        if (!isVideo) {
            headerLabel.text = @"VIDEOS";
        }
        else
        {
            headerLabel.text = @"PHOTOS";
        }
        self.imageBack.image = [UIImage imageNamed:@"back-button-blue"];
    }
    
    
    HUD = [[MBProgressHUD alloc] init];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:HUD];
    HUD.delegate = self;
    
    [HUD show:YES];
    errorView.hidden = YES;
    
    [self getPhotos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    if (app.selIndex == 5) {
        //  [sponsorCollectionView reloadData];
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void)getPhotos
{
    if(app.selIndex  == 5)
    {
        photoCollectionView.hidden = YES;
        sponsorCollectionView.hidden = NO;
        nextBtn.hidden = NO;
        nextImage.hidden = NO;
        NSFileManager *fileManage =[NSFileManager defaultManager];
        NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        if([networkAC internetConnectivity])
        {
            [networkAC getSponsors:^(NSInteger status, NSArray *results) {
                if(status)
                {
                    NSString *fileName = @"Sponsors";
                    NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
                    [results writeToFile:filePath atomically:YES];
                    [self parseSpeakers:results];
                }
            }];
        }else
        {
            NSString *dataPath = [documentDirectory stringByAppendingPathComponent:@"Sponsors"];
            
            if ([fileManage fileExistsAtPath:dataPath])
            {
                [HUD removeFromSuperview];
                NSArray *dict = [[NSArray alloc] initWithContentsOfFile:dataPath];
                [self parseSpeakers:dict];
            }else
            {
                [HUD removeFromSuperview];
                errorView.hidden = NO;
                errImage.image = [UIImage imageNamed:@"no-network"];
                errLabel.text = @"Seems you are not connected to internet";
                UIAlertView * alertView1 = [[UIAlertView alloc]initWithTitle:@"JPL Pune 2017" message:@"Seems you are not connected to internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alertView1 show];
            }
        }
    }else
    {
        photoCollectionView.hidden = NO;
        sponsorCollectionView.hidden = YES;
        nextBtn.hidden = YES;
        nextImage.hidden = YES;
        NSFileManager *fileManage =[NSFileManager defaultManager];
        NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        if([networkAC internetConnectivity])
        {
            [networkAC getPhotos:photoObjectId :^(NSInteger status, NSArray *results) {
                if(status)
                {
                    NSString *fileName = @"Photos";
                    NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
                    [results writeToFile:filePath atomically:YES];
                    [self parseSpeakers:results];
                }
            }];
        }else
        {
            NSString *dataPath = [documentDirectory stringByAppendingPathComponent:@"Photos"];
            
            if ([fileManage fileExistsAtPath:dataPath])
            {
                [HUD removeFromSuperview];
                NSArray *dict = [[NSArray alloc] initWithContentsOfFile:dataPath];
                [self parseSpeakers:dict];
            }else
            {
                [HUD removeFromSuperview];
                errorView.hidden = NO;
                errImage.image = [UIImage imageNamed:@"no-network"];
                errLabel.text = @"Seems you are not connected to internet";
                UIAlertView * alertView1 = [[UIAlertView alloc]initWithTitle:@"JPL Pune 2017" message:@"Seems you are not connected to internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alertView1 show];
            }
        }
    }
}

-(void)parseSpeakers:(NSArray*)results
{
    // NSArray *result = [results objectForKey:@"results"];
    for(PFObject *dict in results)
    {
        Photos *ph = [dataAC getPhoto:dict];
        [photosArr addObject:ph];
    }
    
    
    
    
    if(app.selIndex  == 5)
    {
        
        
        NSMutableArray *workingArray = [photosArr mutableCopy];
        
        
        // Update the collection view's data source property
        dataArr = [NSMutableArray arrayWithArray:workingArray];
        
        [sponsorCollectionView reloadData];
        
    }else
        [photoCollectionView reloadData];
    
    [HUD removeFromSuperview];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    self.isNextView = YES;
}


#pragma mark - UICollectionView

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //collectionCell
    if(app.selIndex  == 5)
    {
        UICollectionViewCell *cell = [sponsorCollectionView dequeueReusableCellWithReuseIdentifier:@"sponsorcell" forIndexPath:indexPath];
        
        Photos *ph = [dataArr objectAtIndex:indexPath.row];
        
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:1];
        imgView.backgroundColor = [UIColor whiteColor];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        
        link = (UILabel *)[cell viewWithTag:3];
        name = (UILabel *)[cell viewWithTag:10];
        name.text=ph.name;
        
        if (ph.url) {
            if ([ph.url isEqualToString:@""]||[ph.url isEqualToString:@" "]) {
                link.text = @" ";
            }
            else
            {
                
                link.text = ph.url;
            }
        }
        
        
        UIButton *linkClick = (UIButton *)[cell viewWithTag:4];
        
        linkClick.tag = indexPath.row;
        [linkClick addTarget:self action:@selector(onClickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
        // [imgView setImage:[PFFile fileWithData:[NSData dataWithContentsOfFile:ph.imageFile]]];
        //[imgView sd_setImageWithURL:[NSURL URLWithString:ph.imageFile]];
        [imgView sd_setImageWithURL:[NSURL URLWithString:ph.imageFile] placeholderImage:[UIImage imageNamed:@"sponsor_def"]];
        
        
        
        return cell;
    }else
    {
        UICollectionViewCell *cell = [photoCollectionView dequeueReusableCellWithReuseIdentifier:@"photocell" forIndexPath:indexPath];
        
        Photos *ph = [photosArr objectAtIndex:indexPath.row];
        
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:1];
        imgView.backgroundColor = [UIColor whiteColor];
        
        if (ph.isImage) {
            [imgView sd_setImageWithURL:[NSURL URLWithString:ph.imageFile] placeholderImage:[UIImage imageNamed:@"ph-sel"]];
        }
        else
        {
            NSString *mainUrl=@"http://img.youtube.com/vi/";
            if (ph.youtubeId) {
                NSString *youtubeId = ph.youtubeId;
                NSString *thumbNail = [youtubeId stringByAppendingString:@"/0.jpg"];
                NSString *thumbNailUrl = [mainUrl stringByAppendingString:thumbNail];
                [imgView sd_setImageWithURL:[NSURL URLWithString:thumbNailUrl] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
            }
            else
            {
                [imgView setImage:[UIImage imageNamed:@"video_default"]];
            }
            
        }
        
        
        return cell;
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if(app.selIndex == 5)
    {
        return [dataArr count];
    }else
    {
        return [photosArr count];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(app.selIndex == 5)
    {
        return CGSizeMake((sponsorCollectionView.bounds.size.width)-5, (sponsorCollectionView.bounds.size.height));
    }else
    {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        
        if (!isVideo) {
            if (width > height) {
                return CGSizeMake((photoCollectionView.bounds.size.height - 16) / 3, (photoCollectionView.bounds.size.height - 16) / 3);
            }
            else
            {
                return CGSizeMake((photoCollectionView.bounds.size.width - 16) / 3, (photoCollectionView.bounds.size.width - 16) / 3);
            }
            
        }
        else{
            return CGSizeMake((photoCollectionView.bounds.size.width - 16) / 3, (photoCollectionView.bounds.size.width - 16) / 3);
        }
        
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(app.selIndex == 5)
    {
        NSLog(@"Clicked");
    }else
    {
        Photos *ph = [photosArr objectAtIndex:indexPath.row];
        if (ph.isImage) {
            // Create browser
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            browser.displayActionButton = YES;
            browser.displayNavArrows = NO;
            browser.displaySelectionButtons = NO;
            browser.alwaysShowControls = NO;
            browser.zoomPhotosToFill = YES;
            
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            browser.wantsFullScreenLayout = YES;
#endif
            browser.enableGrid = NO;
            browser.startOnGrid = NO;
            browser.autoPlayOnAppear = NO;
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate setShouldRotate:YES];
            browser.enableSwipeToDismiss = YES;
            [browser setCurrentPhotoIndex:indexPath.row];
            [self.navigationController pushViewController:browser animated:YES];
        }
        else
        {
            
            XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:ph.youtubeId];
            // videoPlayerViewController.moviePlayer.backgroundPlaybackEnabled = true;
            
            // videoPlayerViewController.preferredVideoQualiti = self.lowQualitySwitch.on ? @[ @(XCDYouTubeVideoQualitySmall240), @(XCDYouTubeVideoQualityMedium360) ] : nil;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:videoPlayerViewController.moviePlayer];
            [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
            //            VideosViewController *vv =[self.storyboard instantiateViewControllerWithIdentifier:@"VideosViewController"];
            //            vv.videoId = ph.youtubeId;
            //            [self.navigationController pushViewController:vv animated:true];
        }
        
        
        
        // Show
        
        
    }
}

#pragma mark - Notifications

- (void) moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:notification.object];
    MPMovieFinishReason finishReason = [notification.userInfo[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    
    if (finishReason == MPMovieFinishReasonPlaybackError)
    {
        NSString *title = NSLocalizedString(@"Video Playback Error", @"Full screen video error alert - title");
        NSError *error = notification.userInfo[XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey];
        NSString *message = [NSString stringWithFormat:@"%@\n%@ (%@)", error.localizedDescription, error.domain, @(error.code)];
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Full screen video error alert - cancel button");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alertView show];
    }
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return photosArr.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    MWPhoto *photo;
    Photos *ph = [photosArr objectAtIndex:index];
    
    if (ph.isImage == false) {
        photo = [MWPhoto videoWithURL:[NSURL URLWithString:@"https://scontent.cdninstagram.com/hphotos-xfa1/t50.2886-16/11336249_1783839318509644_116225363_n.mp4"]];
        photo.isVideo = true;
    }
    else
    {
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:ph.imageFile]];
    }
    photo.caption = ph.name;
    return photo;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < photosArr.count)
    {
        Photos *ph = [photosArr objectAtIndex:index];
        if (ph.isImage == false) {
            MWPhoto *photo;
            photo.isVideo = true;
            return [MWPhoto videoWithURL:[NSURL URLWithString:@"https://scontent.cdninstagram.com/hphotos-xfa1/t50.2886-16/11336249_1783839318509644_116225363_n.mp4"]];
            
        }
        else
        {
            return [MWPhoto photoWithURL:[NSURL URLWithString:ph.imageFile]];
            
        }
    }
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
}

#pragma mark - onClickEvents

- (IBAction)onClickBackBtn:(id)sender
{
    if(app.selIndex  == 5)
    {
        [self.sidePanelController showLeftPanelAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (IBAction)onClickNextBtn:(UIButton *)sender
{
    NSLog(@"LInk text %@",link.text);
    NSLog(@"name text %@",name.text);
    
    Photos *ph = [dataArr objectAtIndex:selectedValue];
    if (ph.url) {
        if ([ph.url isEqualToString:@""]||[ph.url isEqualToString:@" "]) {
            link.text = @" ";
        }
        else
        {
            
            SponsporLinkViewController *sl=[self.storyboard instantiateViewControllerWithIdentifier:@"SponsporLinkViewController"];
            sl.name = ph.name;
            sl.url = ph.url;
            sl.isInfo = NO;
            [self.navigationController pushViewController:sl animated:true];
        }
    }
    
    
}

#pragma mark - scrollView

-(void)scroll
{
    
    if(i<[photosArr count])
    {
        i++;
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
        selectedValue = newIndexPath.row;
        [sponsorCollectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }else
    {
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    previousOffset = scrollView.contentOffset.x;
    scrollView.pagingEnabled = YES;
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if(app.selIndex == 5)
    {
        // Calculate where the collection view should be at the right-hand end item
        //        selectedValue++;
        //        if (selectedValue > dataArr.count-1) {
        //            selectedValue--;
        // }
        float contentOffsetWhenFullyScrolledRight = (sponsorCollectionView.frame.size.width) * ([dataArr count] -1);
        
        
        
        if (scrollView.contentOffset.x == contentOffsetWhenFullyScrolledRight) {
            
            selectedValue = [dataArr count]-1;
            i = 1;
            
            
        } else if (scrollView.contentOffset.x == 0)  {
            
            selectedValue = 0;
            i = 3;
            
        }
        else
        {
            if (previousOffset > scrollView.contentOffset.x) {
                selectedValue --;
                if (selectedValue <= 0) {
                    selectedValue =0;
                }
            }
            else if (previousOffset < scrollView.contentOffset.x)
            {
                selectedValue++;
                if (selectedValue > [dataArr count]-1) {
                    selectedValue = [dataArr count]-1;
                }
            }
        }
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:selectedValue inSection:0];
        [sponsorCollectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];

    }
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
