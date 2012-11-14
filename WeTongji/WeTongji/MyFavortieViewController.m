//
//  MyFavortieViewController.m
//  WeTongji
//
//  Created by Ziqi on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyFavortieViewController.h"
#import "Macro.h"
#import "EventInfoCell.h"
#import "SchoolNewsCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WUFolderView.h"

@interface MyFavortieViewController () < UITableViewDelegate, UITableViewDataSource>
- (void)configureTableView;
@property (nonatomic ,assign) int currentSelectSection;
@end

@implementation MyFavortieViewController
@synthesize contentTableView;
@synthesize recommendButton;
@synthesize schoolInfoButton;
@synthesize celebrityButton;
@synthesize titleButton;

@synthesize currentSelectSection = _currentSelectSection;

#pragma mark - Setter & Getter

- (void)setCurrentSelectSection:(int)currentSelectSection
{
    _currentSelectSection = currentSelectSection;
    [self.contentTableView reloadData];
}

#pragma mark - Private Method
- (void)configureTableView
{
    [self.contentTableView registerNib:[UINib nibWithNibName:@"EventInfoCell" bundle:nil] forCellReuseIdentifier:kEventInfoCell];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"SchoolNewsCell" bundle:nil] forCellReuseIdentifier:kSchoolInfoCell];
    self.currentSelectSection = -1;
}

-(void)headerClicked:(id)sender
{
    int sectionIndex = ((UIButton*)sender).tag;
    if (sectionIndex == self.currentSelectSection) {
        self.currentSelectSection = -1;
    } else {
        self.currentSelectSection = sectionIndex;
    }
    [self.contentTableView reloadData];
}

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setContentTableView:nil];
    [self setRecommendButton:nil];
    [self setSchoolInfoButton:nil];
    [self setCelebrityButton:nil];
    [self setTitleButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.currentFilterItem == eSCHOOL) {
//        [self performSegueWithIdentifier:kMyFavoriteNewsViewControllerSegue sender:self];
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.currentSelectSection) {
        if (self.currentSelectSection == eRECOMMEND) {
            return 122;
        }
    } else {
        return 44;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == self.currentSelectSection) {
        return 5;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WUFolderView *abtn = [[[NSBundle mainBundle] loadNibNamed:@"WUFolderView" owner:self options:nil] objectAtIndex:0];
    abtn.tapButton.tag = section;
    abtn.tapButton.titleLabel.text = @"haha";
    [ abtn.tapButton addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
    return abtn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentSelectSection == eRECOMMEND) {
        EventInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kEventInfoCell];
        if (cell == nil) {
            cell = [[EventInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEventInfoCell];
        }
        return cell;
    } else if (self.currentSelectSection == eSCHOOL) {
        SchoolNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kSchoolInfoCell];
        if (cell == nil) {
            cell = [[SchoolNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSchoolInfoCell];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}
#pragma mark - Private 
@end
