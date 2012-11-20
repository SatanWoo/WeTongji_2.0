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
#import "WeeklyPersonCell.h"

@interface MyFavortieViewController () < UITableViewDelegate, UITableViewDataSource>
@end

@implementation MyFavortieViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
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
    [self performSegueWithIdentifier:kMyFavoriteNewsViewControllerSegue sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        EventInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyFavoriteCell];
        if (cell == nil) {
            cell = [[EventInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMyFavoriteCell];
        }
        return cell;
}

@end
