//
//  QuizViewController.m
//  Reuters
//
//  Created by Priya Talreja on 02/02/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import "QuizViewController.h"
#import "UIView+Toast.h"
#import "PushNotificationViewController.h"
#import "WebsiteViewController.h"
#import "SponsporLinkViewController.h"
@interface QuizViewController ()
{
    MBProgressHUD *HUD;
    NetworkAccessor *networkAC;
    DataAccessor *dataAC;
    int selectedAns;
}
@end

@implementation QuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HUD = [[MBProgressHUD alloc] init];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.color = [UIColor clearColor];
    networkAC = [NetworkAccessor shareNetworkAccessor];
    dataAC = [DataAccessor shareDataAccessor];
    dataArr = [[NSMutableArray alloc] init];
    self.subLabel.layer.cornerRadius = 10;
    self.subLabel.layer.masksToBounds = true;
    selectedAns = 0;
    self.op1Img.hidden = true;
    self.op2Img.hidden = true;
    self.op3Img.hidden = true;
    self.op4Img.hidden = true;
    self.subLabel.hidden = true;
    
    [self.op1Img setImage:[UIImage imageNamed:@"nsel"]];
    [self.op2Img setImage:[UIImage imageNamed:@"nsel"]];
    [self.op3Img setImage:[UIImage imageNamed:@"nsel"]];
    [self.op4Img setImage:[UIImage imageNamed:@"nsel"]];
   //
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
        
        [networkAC getQuestions:^(NSInteger status, NSDictionary *results) {
            if(status)
            {
                
                 [HUD removeFromSuperview];
                NSString *fileName = @"quiz";
                NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
                [results writeToFile:filePath atomically:YES];
                [self parseData:results];
                
            }
        }];
    }else
    {
        
        
                    [HUD removeFromSuperview];
            
            
            UIAlertView * alertView1 = [[UIAlertView alloc]initWithTitle:@"JPL Pune 2017" message:@"Seems you are not connected to internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alertView1 show];
            
        
        
        
        
        
        
    }

}

-(void)parseData:(NSDictionary *)data
{
    NSArray *result = [data objectForKey:@"result"];
    
    
    if (result.count > 0) {
        NSDictionary *check = [result objectAtIndex:0];
        if ([check objectForKey:@"token"]) {
            if ([[check objectForKey:@"token"] isEqual:@0]) {
                
                self.webView.hidden = YES;
                self.scrollView.hidden =NO;
                
                self.op1Img.hidden = false;
                self.op2Img.hidden = false;
                self.op3Img.hidden = false;
                self.op4Img.hidden = false;
                self.subLabel.hidden = false;
                for(NSDictionary *dict in result)
                {
                    Quiz *quiz = [dataAC getQuiz:dict];
                    [dataArr addObject:quiz];
                }
                if (dataArr.count > 0) {
                    Quiz *que = [dataArr objectAtIndex:0];
                    self.question.text = que.question;
                    self.op1.text = que.option1;
                    self.op2.text = que.option2;
                    self.op3.text = que.option3;
                    self.op4.text = que.option4;
                    
                    CGFloat string1Ht = [self heightForLabel:self.op1.text :self.view.frame.size.width-100 andfont:[UIFont systemFontOfSize:19.0]];
                    self.op1Ht.constant = string1Ht;
                    self.view1Ht.constant = string1Ht + 10;
                    
                    CGFloat string2Ht = [self heightForLabel:self.op2.text :self.view.frame.size.width-100 andfont:[UIFont systemFontOfSize:19.0]];
                    self.op2Ht.constant = string2Ht;
                    self.view2Ht.constant = string2Ht + 10;
                    
                    CGFloat string3Ht = [self heightForLabel:self.op3.text :self.view.frame.size.width-100 andfont:[UIFont systemFontOfSize:19.0]];
                    self.op3Ht.constant = string3Ht;
                    self.view3Ht.constant = string3Ht + 10;
                    
                    CGFloat string4Ht = [self heightForLabel:self.op4.text :self.view.frame.size.width-100 andfont:[UIFont systemFontOfSize:19.0]];
                    self.op4Ht.constant = string4Ht;
                    self.view4Ht.constant = string4Ht + 10;
                    
                    
                    
                }

            }
            else
            {
                self.scrollView.hidden = YES;
                self.webView.hidden = NO;
                
                if ([check objectForKey:@"msg"]) {
                    
                    NSMutableString *html = [NSMutableString stringWithString: @"<html><body><div>"];
                    [html appendString:[check objectForKey:@"msg"]];
                    [html appendString:@"</div></body></html>"];
                    [_webView loadHTMLString:html baseURL:nil];
                    
                }
                
            }
        }
        
        
    }
    
}
- (IBAction)option1Clicked:(id)sender {
     [self.op1Img setImage:[UIImage imageNamed:@"sel"]];
     [self.op2Img setImage:[UIImage imageNamed:@"nsel"]];
     [self.op3Img setImage:[UIImage imageNamed:@"nsel"]];
     [self.op4Img setImage:[UIImage imageNamed:@"nsel"]];
     selectedAns = 1;
    
}
- (IBAction)option2Clicked:(id)sender {
    [self.op1Img setImage:[UIImage imageNamed:@"nsel"]];
    [self.op2Img setImage:[UIImage imageNamed:@"sel"]];
    [self.op3Img setImage:[UIImage imageNamed:@"nsel"]];
    [self.op4Img setImage:[UIImage imageNamed:@"nsel"]];
    selectedAns = 2;

}

- (IBAction)option3Clicked:(id)sender {
    [self.op1Img setImage:[UIImage imageNamed:@"nsel"]];
    [self.op2Img setImage:[UIImage imageNamed:@"nsel"]];
    [self.op3Img setImage:[UIImage imageNamed:@"sel"]];
    [self.op4Img setImage:[UIImage imageNamed:@"nsel"]];
    selectedAns = 3;

}

- (IBAction)option4Clicked:(id)sender {
    [self.op1Img setImage:[UIImage imageNamed:@"nsel"]];
    [self.op2Img setImage:[UIImage imageNamed:@"nsel"]];
    [self.op3Img setImage:[UIImage imageNamed:@"nsel"]];
    [self.op4Img setImage:[UIImage imageNamed:@"sel"]];
    selectedAns = 4;
}

- (IBAction)openTwitter:(id)sender {
    WebsiteViewController *vv =[self.storyboard instantiateViewControllerWithIdentifier:@"WebsiteViewController"];
    [self.navigationController pushViewController:vv animated:true];

}
- (IBAction)openNotification:(id)sender {
    PushNotificationViewController *vv =[self.storyboard instantiateViewControllerWithIdentifier:@"PushNotificationViewController"];
    [self.navigationController pushViewController:vv animated:true];
}
- (IBAction)openMenu:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}
- (IBAction)submitClicked:(id)sender {
    [self submitAnswerCall];
}

-(void)submitAnswerCall
{
    if(selectedAns == 0)
    {
        UIAlertView * alertView1 = [[UIAlertView alloc]initWithTitle:@"JPL Pune 2017" message:@"Please select the option" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alertView1 show];

    }
    else
    {
    [self.view addSubview:HUD];
    HUD.delegate = self;
    
    [HUD show:YES];
    Quiz *que;
    if (dataArr.count > 0) {
        que = [dataArr objectAtIndex:0];
    }
    AppUser *user = [dataAC loggedInUser];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    if (user.objectId) {
       [parameters setObject:user.objectId forKey:@"appUserId"];
        [parameters setObject:[NSNumber numberWithInt:selectedAns] forKey:@"answerByUser"];
        [parameters setObject:que.objectId forKey:@"questionId"];
    }
    
    if([networkAC internetConnectivity])
    {
        
        [networkAC submitAnswer:parameters :^(NSInteger status, NSDictionary *results) {
            if(status)
            {
                
                [HUD removeFromSuperview];
                
                [self parseSubmitData:results];
                
            }
        }];
    }else
    {
            [HUD removeFromSuperview];
            
            
            UIAlertView * alertView1 = [[UIAlertView alloc]initWithTitle:@"JPL Pune 2017" message:@"Seems you are not connected to internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alertView1 show];
            

        
        
    }
    }
}

- (float)heightForLabel:(NSString *)text :(float)labelWidth andfont:(UIFont*)textFont
{
    CGSize constraint = CGSizeMake(labelWidth, 20000.0f);
    
    CGRect textRect = [text boundingRectWithSize:constraint
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:textFont}
                                         context:nil];
    
    CGSize size = textRect.size;
    
    CGFloat height = size.height;
    
    return height;
}
-(void)parseSubmitData:(NSDictionary *)data
{
    NSString *msg = [data objectForKey:@"result"];
    
    self.webView.hidden = NO;
    self.scrollView.hidden = YES;
    if (msg) {
        
        NSMutableString *html = [NSMutableString stringWithString: @"<html><body><div>"];
        [html appendString:msg];
        [html appendString:@"</div></body></html>"];
        [_webView loadHTMLString:html baseURL:nil];
        
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)quizInfo:(id)sender {
    SponsporLinkViewController *sl=[self.storyboard instantiateViewControllerWithIdentifier:@"SponsporLinkViewController"];
    
    sl.isInfo = YES;
    [self.navigationController pushViewController:sl animated:true];
}

@end
