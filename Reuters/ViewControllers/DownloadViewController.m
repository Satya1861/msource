//
//  DownloadViewController.m
//  Reuters
//
//  Created by Sonali on 12/02/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import "DownloadViewController.h"

@interface DownloadViewController ()
{
    BOOL loaded;
}
@end

@implementation DownloadViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _dFile = [[Download alloc] init];
    }
    return self;
}
-(BOOL)shouldAutorotate
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    headerLabel.hidden=YES;
    headerLabel.text = _dFile.name;

    downloadwebView.scalesPageToFit = YES;
    NSURL *urlrequest = [NSURL fileURLWithPath:self.path];
  
    NSData *data =[NSData dataWithContentsOfURL:urlrequest];
    
     NSURLRequest *request = [NSURLRequest requestWithURL:urlrequest cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval: 4.0];
 
    [downloadwebView loadRequest:request];
  //  [downloadwebView loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@""]];
    [self performSelector:@selector(loadWebView:) withObject:request afterDelay:5.0];

}
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:YES];
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.view layoutIfNeeded];
}
-(void)loadWebView:(NSURLRequest *)post
{
    loaded=YES;
    
    
    [downloadwebView reload];
}
-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
