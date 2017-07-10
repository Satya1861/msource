//
//  TeamMembersViewController.m
//  Reuters
//
//  Created by Priya Talreja on 31/01/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import "TeamMembersViewController.h"
#import "TeamTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TeamMembersViewController ()

@end

@implementation TeamMembersViewController
@synthesize teamObj;
- (void)viewDidLoad {
    [super viewDidLoad];
    networkAC = [NetworkAccessor shareNetworkAccessor];
    dataAC = [DataAccessor shareDataAccessor];
    dataArr = [[NSMutableArray alloc] init];
    HUD = [[MBProgressHUD alloc] init];
     HUD.mode = MBProgressHUDModeIndeterminate;
     sections = [[NSMutableDictionary alloc] init];
    
    self.teamLogo.layer.cornerRadius = 10;
    self.teamLogo.layer.masksToBounds = true;
    
    self.logoLeadingSpace.constant = ([UIScreen mainScreen].bounds.size.width/2)-35;
    [self.view updateConstraintsIfNeeded];
    [self getMemberData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(void)getMemberData
{
    [self.view addSubview:HUD];
    HUD.delegate = self;
    
    [HUD show:YES];
    NSFileManager *fileManage =[NSFileManager defaultManager];
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    if([networkAC internetConnectivity])
    {
        [networkAC getMembers:teamObj :^(NSInteger status, NSDictionary *results) {
            if(status)
            {
                NSString *fileName = [NSString stringWithFormat:@"Members%@",teamObj];
                NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
                [results writeToFile:filePath atomically:YES];
                [self parseData:results];
            }
        }];
    }else
    {
        NSString *dataPath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Members%@",teamObj]];
        
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

-(void)parseData : (NSDictionary *)results
{
    NSArray *result = [results objectForKey:@"results"];
    for(NSDictionary *dict in result)
    {
        Member *speaker = [dataAC getMember:dict];
        [dataArr addObject:speaker];
    }
    
    if (dataArr.count > 0) {
        Member *member = [dataArr objectAtIndex:0];
        NSDictionary *curr = member.teamId;
        self.teamName.text = [[curr objectForKey:@"longName"]uppercaseString];
        if([[curr objectForKey:@"teamLogo"]objectForKey:@"url"])
        {
            [self.teamLogo sd_setImageWithURL:[NSURL URLWithString:[[curr objectForKey:@"teamLogo"]objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"default-speaker-image"]];
        }
        
        if([[curr objectForKey:@"sponsorImage"]objectForKey:@"url"])
        {
            [self.sponsporLogo sd_setImageWithURL:[NSURL URLWithString:[[curr objectForKey:@"sponsorImage"]objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"ts_sd"]];
        }
        
    }
    
    for (Member *sp in dataArr)
    {
        NSString *alphabet = [sp.memberName substringToIndex:1];
        
        // If we don't yet have an array to hold the events for this day, create one
        NSMutableArray *memberWithAlphabet = [sections objectForKey:alphabet];
        if (memberWithAlphabet == nil) {
            memberWithAlphabet = [NSMutableArray array];
            // Use the reduced date as dictionary key to later retrieve the event list this day
            [sections setObject:memberWithAlphabet forKey:alphabet];
        }
        
        // Add the event to the list for this day
        [memberWithAlphabet addObject:sp];
    }
    
    // Create a sorted list of days
    NSArray *unsortedDays = [sections allKeys];
    sortedDays = [[NSMutableArray alloc] initWithArray:[unsortedDays sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]] ;
    
    [self.tableView reloadData];
    [HUD removeFromSuperview];
    
    dataArr1 = [dataArr mutableCopy];

    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (sortedDays.count > 0) {
         return [sortedDays count];
    }
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *alphabet = [sortedDays objectAtIndex:section];
    
    return alphabet;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,30)];
    sectionView.tag=section;
    sectionView.backgroundColor=[UIColor colorWithRed:(85/255.0) green:(85/255.0) blue:(85/255.0) alpha:1];
    
    UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 10, 280, 21)];
    viewLabel.backgroundColor=[UIColor colorWithRed:(85/255.0) green:(85/255.0) blue:(85/255.0) alpha:1];
    viewLabel.textColor=[UIColor whiteColor];
    viewLabel.font=[UIFont systemFontOfSize:15];
    
    NSString *alphabet = [sortedDays objectAtIndex:section];
    viewLabel.text=alphabet;
    [sectionView addSubview:viewLabel];
    
    return sectionView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if([sortedDays count] != 0)
    {
        
        NSString *alphabet = [sortedDays objectAtIndex:section];
        NSArray *memberWithAlphabet = [sections objectForKey:alphabet];
        
        return [memberWithAlphabet count];
    }else
        return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //  [tableView setSeparatorInset:UIEdgeInsetsZero];
    // [tableView setSeparatorStyle: UITableViewCellSeparatorStyleSingleLine];
    static NSString *CellIdentifier = @"teamCell";
    TeamTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TeamTableViewCell" owner:self options:nil];
        cell = (TeamTableViewCell *)[nib objectAtIndex:0];
    }
    NSString *alphabet = [sortedDays objectAtIndex:indexPath.section];
    NSArray *speakerWithAlphabet = [sections objectForKey:alphabet];
    Member *sp = [speakerWithAlphabet objectAtIndex:indexPath.row];
    
    
    
    [cell.memberImg sd_setImageWithURL:[NSURL URLWithString:sp.profilePic] placeholderImage:[UIImage imageNamed:@"default-speaker-image"]];
    
    cell.memberName.text = sp.memberName;
    cell.desg.text = sp.role;
    
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
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
