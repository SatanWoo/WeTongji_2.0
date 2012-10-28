//
//  CampusViewController.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-20.
//
//

#import "CampusViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Macro.h"
#import "RecommendCell.h"

#define kWidth self.scrollView.frame.size.width
#define kHeight self.scrollView.frame.size.height

@interface CampusViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *schoolInfoView;
@property (nonatomic, strong) UIView *groupInfoView;
@property (nonatomic, strong) UIView *actionView;
@property (nonatomic, strong) UIView *recommendView;

@property (nonatomic ,strong) UITableView *recommendTableView;

- (void)configureScrollView;
- (void)pageChange:(UIButton *)clickButton;
- (void)configureTabBar;
- (void)configureTableView;
- (void)renderShadow:(UIView *)view;
@end

@implementation CampusViewController
@synthesize scrollView = _scrollView;
@synthesize indicator = _indicator;
@synthesize schoolInfoButton = _schoolInfoButton;
@synthesize groupInfoButton = _groupInfoButton;
@synthesize actionButton = _actionButton;
@synthesize recommendButton = _recommendButton;

@synthesize schoolInfoView = _schoolInfoView;
@synthesize groupInfoView = _groupInfoView;
@synthesize actionView = _actionView;
@synthesize recommendView = _recommendView;

@synthesize recommendTableView = _recommendTableView;

#pragma mark - Setter and Getter

- (void)renderShadow:(UIView *)view
{
    if (view) {
        view.layer.shadowOpacity = 0.8f;
        view.layer.cornerRadius = 0.1f;
        view.layer.shadowRadius = 0.4f;
        view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    }
}

- (UITableView *)recommendTableView
{
    if (_recommendTableView == nil) {
       _recommendTableView = [[UITableView alloc] initWithFrame:self.recommendView.bounds style:UITableViewStylePlain];
        [_recommendTableView registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:nil] forCellReuseIdentifier:KRecommendCell];
        _recommendTableView.contentInset = UIEdgeInsetsMake(self.recommendButton.frame.size.height, 0.0f, 0.0f, 0.0f);
        _recommendTableView.delegate = self;
        _recommendTableView.dataSource = self;
    }
    return _recommendTableView;
}

#pragma mark - Private Method
- (void)configureScrollView
{
    self.schoolInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.schoolInfoView.backgroundColor = [UIColor redColor];
    
    self.groupInfoView = [[UIView alloc] initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight)];
    self.groupInfoView.backgroundColor = [UIColor blueColor];
    
    self.actionView = [[UIView alloc] initWithFrame:CGRectMake(kWidth * 2,0, kWidth, kHeight)];
    self.actionView.backgroundColor = [UIColor orangeColor];
    
    self.recommendView = [[UIView alloc] initWithFrame:CGRectMake(kWidth * 3,0, kWidth, kHeight)];
    self.recommendView.backgroundColor = [UIColor blackColor];
    
    [self.scrollView setContentSize:CGSizeMake(kWidth * 4, kHeight)];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    
    [self.scrollView addSubview:self.schoolInfoView];
    [self.scrollView addSubview:self.groupInfoView];
    [self.scrollView addSubview:self.actionView];
    [self.scrollView addSubview:self.recommendView];
}

- (void)configureTabBar
{
    [self.schoolInfoButton setBackgroundImage:[UIImage imageNamed:@"block_sl.png"] forState:UIControlStateSelected];
    [self.schoolInfoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.schoolInfoButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [self.schoolInfoButton setSelected:YES];
    
    [self.groupInfoButton setBackgroundImage:[UIImage imageNamed:@"block_sl.png"] forState:UIControlStateSelected];
    [self.groupInfoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.groupInfoButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    [self.actionButton setBackgroundImage:[UIImage imageNamed:@"block_sl.png"] forState:UIControlStateSelected];
    [self.actionButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    [self.recommendButton setBackgroundImage:[UIImage imageNamed:@"block_sl.png"] forState:UIControlStateSelected];
    [self.recommendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.recommendButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    [self renderShadow:self.schoolInfoButton];
    [self renderShadow:self.groupInfoButton];
    [self renderShadow:self.actionButton];
    [self renderShadow:self.recommendButton];
}

- (void)configureTableView
{
      [self.recommendView addSubview:self.recommendTableView];
}

- (void)pageChange:(UIButton *)clickButton
{
    __block int index = 0;
    NSArray *buttonArray = [NSArray arrayWithObjects:self.schoolInfoButton,
                                                     self.groupInfoButton, self.actionButton, self.recommendButton, nil];
    [buttonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = obj;
        if(btn == clickButton) {
            index = idx;
            [btn setSelected:YES];
        }
        else {
            [btn setSelected:NO];
        }
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.scrollView setContentOffset:CGPointMake(index * kWidth, 0)];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Lifecycle;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureScrollView];
    [self configureTabBar];
    [self configureTableView];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    self.scrollView = nil;
    
    self.schoolInfoButton = nil;
    self.schoolInfoView = nil;

    self.groupInfoButton = nil;
    self.groupInfoView = nil;
    
    self.actionButton = nil;
    self.actionView = nil;
    
    self.recommendButton = nil;
    self.recommendView = nil;
    self.recommendTableView = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)buttonPressed:(UIButton *)sender
{
    [self pageChange:sender];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.recommendTableView) {
        return 70;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.recommendTableView) {
        RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:KRecommendCell];
        if (cell == nil) {
            cell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KRecommendCell];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else {
        return nil;
    }
}

@end
