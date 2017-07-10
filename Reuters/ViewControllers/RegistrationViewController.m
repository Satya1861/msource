//
//  RegistrationViewController.m
//  Reuters
//
//  Created by Priya Talreja on 31/01/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import "RegistrationViewController.h"

#import <Parse/Parse.h>

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataAC = [DataAccessor shareDataAccessor];
    networkAC = [NetworkAccessor shareNetworkAccessor];
    [self registerForKeyboardNotifications];
    
    if (networkAC.internetConnectivity) {
        
        HUD = [[MBProgressHUD alloc] init];
        HUD.mode = MBProgressHUDModeIndeterminate;
        
        [self.view addSubview:HUD];
        HUD.delegate = self;
        
        [HUD show:YES];
        
        [networkAC getQuizRules:^(NSInteger status, NSDictionary *results) {
            if(status)
            {
                [HUD removeFromSuperview];
                [self parseData:results];
                
            }
        }];
        
    }
    else
    {
        UIAlertView * alertView1 = [[UIAlertView alloc]initWithTitle:@"JPL Pune 2017" message:@"Seems you are not connected to internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alertView1 show];
    }

    // Do any additional setup after loading the view.
}
-(void)parseData:(NSDictionary *)data
{
    NSArray *results = [data objectForKey:@"results"];
    if (results.count > 1) {
        NSDictionary *result = [results objectAtIndex:1];
        if ([result objectForKey:@"details"]) {
            
            NSString *contactus = [result objectForKey:@"details"];
            NSMutableString *html = [NSMutableString stringWithString: @"<html><body><div>"];
            [html appendString:contactus];
            [html appendString:@"</div></body></html>"];
            [_webView loadHTMLString:html baseURL:nil];
        }
        
    }
    else
    {
        NSMutableString *html = [NSMutableString stringWithString: @"<html><body><div>"];
        [html appendString:@""];
        [html appendString:@"</div></body></html>"];
        [_webView loadHTMLString:html baseURL:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerClicked:(id)sender {
    [self registerCall];
}

-(void)registerCall
{
    HUD = [[MBProgressHUD alloc] init];
     HUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:HUD];
    HUD.delegate = self;
   
    [HUD show:YES];
    if ([self.mobileNumber.text isEqualToString:@""]||[self.mobileNumber.text isEqualToString:@" "]) {
        self.mobileNumber.text = @"";
    }
    
    if(![self validateEmail:_emailId.text]){
        [HUD removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"JPL Pune 2017" message:@"Enter Valid Email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else
    {
        
        if([_fullName.text length] == 0){
            [HUD removeFromSuperview];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"JPL Pune 2017" message:@"Enter Full Name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }else
        {
//            if(![self validatePhone:_mobileNumber.text]){
//                [HUD removeFromSuperview];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"JPL Pune 2017" message:@"Enter correct 10 digit contact number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                [alert show];
//            }else
            {
                
                
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded)
                    {
                        [PFCloud callFunctionInBackground:@"SaveUser" withParameters:@{@"email":_emailId.text,@"password":@"",@"userName":_fullName.text,@"contactNo":_mobileNumber.text,@"isPending":[NSNumber numberWithBool:NO]} block:^(id object, NSError *error) {
                            if(!error)
                            {
                                [dataAC saveUserCredentials:object];
                               
                                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                [defaults setBool:YES forKey:@"isRegistered"];
                                
                                object[@"deviceInfo"] = currentInstallation;
                                [object saveInBackground];
                                
                                AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                del.viewController = [[JASidePanelController alloc] init];
                                
                                del.viewController.pushesSidePanels = NO;
                                
                                del.viewController.leftPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftPanelViewController"];
                                del.viewController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"QuizViewController"];
                                
                                UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"navigation2"];
                                navVC = [navVC initWithRootViewController:del.viewController];
                                
                                del.window.rootViewController = navVC;
                                [HUD removeFromSuperview];
                                
                                
                            }
                            else
                            {
                                [HUD removeFromSuperview];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"JPL Pune 2017" message:@"Email Id already exists, please use another email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                [alert show];
                            }
                        }];
                    }
                }];
            }
        }
    }

}

-(BOOL) validateEmail: (NSString *) email
{
    BOOL isValid;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    isValid = [emailTest evaluateWithObject:email];
    return isValid;
}



-(BOOL)validatePhone:(NSString *)phone
{
    NSString * forNumeric =  @"^(\\+?)(\\d{10})$";
    NSPredicate * phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",forNumeric];
    BOOL isValid = [phoneTest evaluateWithObject:phone];
    return isValid;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardWasShown:)
                                                 name: UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardWillBeHidden:)
                                                 name: UIKeyboardDidHideNotification object:nil];
}
#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.mobileNumber) {
        [self registerCall];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if(textField.tag==3)
    {
        if([self.mobileNumber.text isEqualToString:@""]&&[string isEqualToString:@"0"])
        {
            return NO;
        }
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if ([self isNumeric:string] && [self.mobileNumber.text length]<10) {
            return YES;
        }
        
        else
            return NO;
    }
    return YES;

}

-(BOOL)isNumeric:(NSString*)inputString
{
    NSCharacterSet *cs=[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered;
    filtered = [[inputString componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [inputString isEqualToString:filtered];
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeTextField.frame animated:YES];
        
    }
    
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)openLeft:(id)sender {
     [self.sidePanelController showLeftPanelAnimated:YES];
}

@end
