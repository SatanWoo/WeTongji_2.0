//
//  EventInfoViewController.m
//  WeTongji
//
//  Created by Ziqi on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EventInfoViewController.h"
#import "Macro.h"
#import "EventInfoCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WUPopOverView.h"

@interface EventInfoViewController () <UITableViewDataSource, UITableViewDelegate, WUPopOverViewDelegate>
- (void)configureTableView;
@end

@implementation EventInfoViewController
#pragma mark - Private 
- (void)configureTableView
{
    [self.eventTableView registerNib:[UINib nibWithNibName:@"EventInfoCell" bundle:nil] forCellReuseIdentifier:kEventInfoCell];
}

#pragma mark - LifeCycle
@synthesize filterButton;
@synthesize eventTableView;
@synthesize filterView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    self.filterView.layer.opacity = 0;
}

- (void)viewDidUnload
{
    [self setFilterButton:nil];
    [self setEventTableView:nil];
    [self setFilterView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction 
- (IBAction)filterEvent:(UIButton *)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        self.filterView.layer.opacity = 1 - self.filterView.layer.opacity;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kEventInfoCell];
    if (cell == nil) {
        cell = [[EventInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEventInfoCell];
    }
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 122;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - WUPopOverViewDelegate
- (void)selectItemInPopOverViewAtIndex:(UIButton *)index
{
    
}

@end
