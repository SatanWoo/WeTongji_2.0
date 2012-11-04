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

@interface MyFavortieViewController () <WUPopOverViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic , assign) int currentFilterItem;
- (void)configureTableView;
- (void)refreshTitle:(UIButton *)button;
@end

@implementation MyFavortieViewController
@synthesize contentTableView;
@synthesize filterView;
@synthesize recommendButton;
@synthesize schoolInfoButton;
@synthesize celebrityButton;
@synthesize titleButton;

@synthesize currentFilterItem  = _currentFilterItem;

#pragma mark - Setter & Getter
- (void)setCurrentFilterItem:(int)currentFilterItem
{
    _currentFilterItem = currentFilterItem;
    [self.contentTableView reloadData];
}

#pragma mark - Private Method
- (void)configureTableView
{
    self.filterView.layer.opacity = 0;
    
    [self.contentTableView registerNib:[UINib nibWithNibName:@"EventInfoCell" bundle:nil] forCellReuseIdentifier:kEventInfoCell];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"SchoolNewsCell" bundle:nil] forCellReuseIdentifier:kSchoolInfoCell];
}

- (void)refreshTitle:(UIButton *)button
{
    //self.titleButton.titleLabel.text = button.titleLabel.text;
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
    [self setFilterView:nil];
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

#pragma mark - WUPopOverDelegate
- (void)selectItemInPopOverViewAtIndex:(UIView *)sender
{
    if (sender == self.recommendButton) {
        self.currentFilterItem = eRECOMEND;
    } else if (sender == self.schoolInfoButton) {
        self.currentFilterItem = eSCHOOL;
    } else {
        self.currentFilterItem = eCELEBRITY;
    }
    [self refreshTitle:(UIButton *)sender];
    [self filterItem:sender];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentFilterItem == eSCHOOL) {
        [self performSegueWithIdentifier:kMyFavoriteNewsViewControllerSegue sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentFilterItem == eRECOMEND) {
        return 122;
    } else {
        return 44;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentFilterItem == eRECOMEND) {
        EventInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kEventInfoCell];
        if (cell == nil) {
            cell = [[EventInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEventInfoCell];
        }
        return cell;
    } else if (self.currentFilterItem == eSCHOOL) {
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

#pragma mark - IBAction
- (IBAction)filterItem:(id)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        self.filterView.layer.opacity = 1 - self.filterView.layer.opacity;
    } completion:^(BOOL finished) {
    }];
}
@end
