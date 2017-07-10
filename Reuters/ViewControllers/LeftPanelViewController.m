//
//  LeftPanelViewController.m
//  Reuters
//
//  Created by Priya on 30/01/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import "LeftPanelViewController.h"
#import "CenterPanelViewController.h"

@interface LeftPanelViewController ()
{
     BOOL isReg;
    
}
@end

@implementation LeftPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    networkAC = [NetworkAccessor shareNetworkAccessor];
    // Do any additional setup after loading the view.
//    menuArr = [[NSArray alloc] initWithObjects:@"Schedule", @"Speakers", @"Sponsors",@"Photos", @"Survey", @"Quiz", @"Question", @"Downloads", @"My Schedule", nil];
//    
    menuArr = [[NSArray alloc] initWithObjects:@"Home",@"Fixtures",@"Results",@"Standings", @"Teams",@"Sponsors",@"Quiz",@"Gallery",@"Helpdesk",@"About us", nil];
    
    unSelImgs = [[NSArray alloc] initWithObjects:@"home",@"schedule",@"result",@"standing", @"teams", @"spons",@"quiz",@"photos",@"contact", @"abtus", nil];
    
    selImgs = [[NSArray alloc] initWithObjects:@"homeu",@"schedule-sel",@"res-sel", @"stand-sel",@"team-sel", @"spons-sel",@"quiz-sel",@"photos-sel",@"ph-sel",@"abt-sel", nil];
    
    CGFloat width = (0.75) * [UIScreen mainScreen].bounds.size.width;
    self.trailingSpaceImg.constant = width;
    
    NSMutableString *html = [NSMutableString stringWithString: @"<html><body><div>"];
    [html appendString:@"<p style=\"text-align: center;font-family:Helvetica;font-size:80%;width:75%\"><span style=\"color: #000000;\"><span style=\"color: gray;\">App developed by <span style=\"color: #2B2B2C;font-weight:400\">Script </span><span style=\"color: #c9232b;;font-weight:400\">Lanes</span></span></span></p>"];
    // [html appendString:style];
    [html appendString:@"</div></body></html>"];
    [_webView loadHTMLString:html baseURL:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
    _hcVC=[self.storyboard instantiateViewControllerWithIdentifier:@"HostCityViewController"];
    [_hcVC.imageAutomaticSlide stop];
    

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}
-(BOOL)shouldAutorotate
{
    return NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableView Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //sideBarCell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sideBarCell"];
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    
    UIImageView *profileImg = (UIImageView *)[cell viewWithTag:1];

    profileImg.image = [UIImage imageNamed:[unSelImgs objectAtIndex:indexPath.row]];
    
    UILabel *label1 = (UILabel *)[cell viewWithTag:2];

    label1.text = [menuArr objectAtIndex:indexPath.row];
    label1.textColor = [UIColor colorWithRed:41/255.0 green:21/255.0 blue:110/255.0 alpha:1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Add your Colour.
   
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:41/255.0 green:21/255.0 blue:110/255.0 alpha:1];
    
    UIImageView *profileImg = (UIImageView *)[cell viewWithTag:1];
    
    profileImg.image = [UIImage imageNamed:[selImgs objectAtIndex:indexPath.row]];
    
    UILabel *label1 = (UILabel *)[cell viewWithTag:2];
    
    label1.text = [menuArr objectAtIndex:indexPath.row];
    
    label1.textColor = [UIColor whiteColor];
    
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Reset Colour.
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    
    UIImageView *profileImg = (UIImageView *)[cell viewWithTag:1];
    
    profileImg.image = [UIImage imageNamed:[unSelImgs objectAtIndex:indexPath.row]];
    
    UILabel *label1 = (UILabel *)[cell viewWithTag:2];
    
    label1.text = [menuArr objectAtIndex:indexPath.row];
    
    label1.textColor = [UIColor colorWithRed:41/255.0 green:21/255.0 blue:110/255.0 alpha:1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuArr count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:41/255.0 green:21/255.0 blue:110/255.0 alpha:1];
    UIImageView *profileImg = (UIImageView *)[cell viewWithTag:1];
    
    profileImg.image = [UIImage imageNamed:[selImgs objectAtIndex:indexPath.row]];
    
    UILabel *label1 = (UILabel *)[cell viewWithTag:2];
    
    label1.text = [menuArr objectAtIndex:indexPath.row];
    
    label1.textColor = [UIColor whiteColor];
    if(indexPath.row == 5)
    {
        self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoCollectionViewController"];
    
    }
    else if (indexPath.row == 6)
    {
        
        NSUserDefaults *defaults1=[NSUserDefaults standardUserDefaults];
        if ([defaults1 objectForKey:@"isRegistered"]) {
            isReg=[[defaults1 objectForKey:@"isRegistered"]boolValue];
        }
        
        
        if(isReg == NO)
        {
            self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
        }
        else
        {
            self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"QuizViewController"];
        }
        //self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"QuizViewController"];
    }
    else if (indexPath.row == 7)
    {
        self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"FoldersViewController"];
    }
    else if (indexPath.row == 9)
    {
        self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"HostCityViewController"];
    }
    
    else if (indexPath.row == 8)
    {
        self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
    }
    
    else if(indexPath.row == 1 || indexPath.row == 2)
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        if (indexPath.row == 2) {
            
            [defaults setBool:YES forKey:@"isResults"];
        }
        else
        {
             [defaults setBool:NO forKey:@"isResults"];
        }
        
         self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    }
    else if (indexPath.row == 3)
    {
        self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"StandingsViewController"];
    }
    else if (indexPath.row == 0)
    {
        self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingViewController"];
    }

    else
    {
        self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"CenterPanelViewController"];
    }
    
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.selIndex = (int)indexPath.row;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    
    UIImageView *profileImg = (UIImageView *)[cell viewWithTag:1];
    
    profileImg.image = [UIImage imageNamed:[unSelImgs objectAtIndex:indexPath.row]];
    
    UILabel *label1 = (UILabel *)[cell viewWithTag:2];
    
    label1.text = [menuArr objectAtIndex:indexPath.row];
    
    label1.textColor = [UIColor colorWithRed:41/255.0 green:21/255.0 blue:110/255.0 alpha:1];
}

@end
