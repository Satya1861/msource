//
//  WebsiteViewController.m
//  Reuters
//
//  Created by Priya Talreja on 02/09/16.
//  Copyright © 2016 Scriptlanes. All rights reserved.
//

#import "WebsiteViewController.h"

@interface WebsiteViewController ()
{
    MBProgressHUD *HUD;
    NetworkAccessor *networkAC;
    DataAccessor *dataAC;
}
@end

@implementation WebsiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    networkAC = [NetworkAccessor shareNetworkAccessor];
    if (networkAC.internetConnectivity) {
        HUD = [[MBProgressHUD alloc] init];
        HUD.mode = MBProgressHUDModeIndeterminate;
        
        _webView.hidden = true;
        
        [self.view addSubview:HUD];
        HUD.delegate = self;
        
        [HUD show:YES];
        
        NSString *twitterUrl =  @"<!DOCTYPE html><html lang=\"en-US\">  <head> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">             <script>window.twttr = (function(d, s, id) {  var js, fjs = d.getElementsByTagName(s)[0],    t = window.twttr || {};  if (d.getElementById(id)) return t;  js = d.createElement(s);  js.id = id;  js.src = \"https://platform.twitter.com/widgets.js\";  fjs.parentNode.insertBefore(js, fjs);  t._e = [];  t.ready = function(f) {    t._e.push(f);  };  return t;}(document, \"script\", \"twitter-wjs\"));      twttr.widgets.load(  document.getElementById(\"container\"));      </script>                </head>      <body class=\"size-1140\">            <!-- Twitter  -->         <a class=\"twitter-timeline\"  href=\"https://twitter.com/search?q=%23jpl2017pune%20OR%20%23jpl2017%20OR%20%23jitopune%20OR%20%23jplpune2017%20OR%20%40JitoPuneChapter\" data-widget-id=\"832152665878577152\">Tweets about #jpl2017pune OR #jpl2017 OR #jitopune OR #jplpune2017 OR @JitoPuneChapter</a> <script async src=\"//platform.twitter.com/widgets.js\" charset=\"utf-8\"></script> </body></html>";
        [_webView setBackgroundColor:[UIColor clearColor]];
        
        
        [_webView loadHTMLString:twitterUrl baseURL:nil];
    }
    else
    {
        UIAlertView * alertView1 = [[UIAlertView alloc]initWithTitle:@"JPL Pune 2017" message:@"Seems you are not connected to internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alertView1 show];

    }

  

  
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
 
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
     [HUD removeFromSuperview];
    [self performSelector:@selector(unHideWebView) withObject:NULL afterDelay:1.0];
    
}
-(void)unHideWebView
{
    _webView.hidden = false;
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
