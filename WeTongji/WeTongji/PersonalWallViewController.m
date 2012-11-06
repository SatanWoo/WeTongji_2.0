//
//  PersonalWallViewController.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-19.
//
//

#import "PersonalWallViewController.h"
#import "Macro.h"
#import "ReminderCell.h"
#import "PersonalInfoCell.h"
#import "ScheduleCell.h"
#import "FavoriteCell.h"
#import "WUTapImageView.h"
#import "WUScrollBackgroundView.h"

#define kContentOffSet 168
#define kRowHeight 44
#define kStateY -150

@interface PersonalWallViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) WUTapImageView *wuTapView;
@property (nonatomic, assign) BOOL isAnimationFinished;
- (void)configureTableView;
- (void)didTap:(UITapGestureRecognizer *)recognizer;
@end

@implementation PersonalWallViewController
@synthesize wuTapView = _wuTapView;
@synthesize isAnimationFinished = _isAnimationFinished;

#pragma mark - Private Method
- (void)configureTableView
{
    [self.scheduleTableView registerNib:[UINib nibWithNibName:@"ReminderCell" bundle:nil] forCellReuseIdentifier:kReminderCell];
    [self.scheduleTableView registerNib:[UINib nibWithNibName:@"FavoriteCell" bundle:nil] forCellReuseIdentifier:kFavoriteCell];
    [self.scheduleTableView registerNib:[UINib nibWithNibName:@"PersonalInfoCell" bundle:nil] forCellReuseIdentifier:kPersonalInfoCell];
    [self.scheduleTableView registerNib:[UINib nibWithNibName:@"ScheduleCell" bundle:nil] forCellReuseIdentifier:kScheduleCell];
    
    self.scheduleTableView.contentInset = UIEdgeInsetsMake(kContentOffSet, 0.0f, 0.0f, 0.0f);
    self.scheduleTableView.backgroundColor =[UIColor clearColor];
    
    [self.view insertSubview:self.wuTapView belowSubview:self.scheduleTableView];
}

#pragma mark - Tap
- (void)didTap:(UITapGestureRecognizer *)recognizer
{
    self.isAnimationFinished = false;
    [UIView animateWithDuration:0.55f animations:^{
        self.scheduleTableView.frame = self.view.frame;
    } completion:^(BOOL finished) {
        self.scheduleTableView.userInteractionEnabled = YES;
    }];
    
    [UIView animateWithDuration:0.8f animations:^{
        self.wuTapView.frame = CGRectMake(0, kStateY, self.wuTapView.frame.size.width, self.wuTapView.frame.size.height);
    } completion:^(BOOL finished) {
        self.wuTapView.userInteractionEnabled = NO;
    }];
}

#pragma mark - Setter & Getter
- (WUTapImageView *)wuTapView
{
    if (_wuTapView == nil) {
        _wuTapView = [[WUTapImageView alloc] initWithImage:[UIImage imageNamed:@"scaleview.png"]];
        [_wuTapView setFrame:CGRectMake(0, kStateY, 320 ,480)];
        [_wuTapView setGestureSelector:@selector(didTap:) target:self];
        _wuTapView.userInteractionEnabled = NO;
    }
    return _wuTapView;
}

#pragma mark - Pangesture

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
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

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 86;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:kReminderCell];
        if (cell == nil) {
            cell = [[ReminderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReminderCell];
        }
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else if (indexPath.section == 1) {
        FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:kFavoriteCell];
        if (cell == nil) {
            cell = [[FavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFavoriteCell];
        }
        return cell;
    } else if (indexPath.section == 2){
        PersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kPersonalInfoCell];
        if (cell == nil) {
            cell = [[PersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPersonalInfoCell];
        }
        return cell;
    } else {
        ScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:kScheduleCell];
        if (cell == nil) {
            cell = [[ScheduleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kScheduleCell];
        }
        return cell;
    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:kArrangementViewControllerSegue sender:self];
    } else if (indexPath.section == 1) {
        [self performSegueWithIdentifier:kMyFavortieViewControllerSegue sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    static int velocity = 15;
    
    float rate = (scrollView.contentOffset.y + kContentOffSet) / -kRowHeight;
    
    if (rate > 2) {
        self.isAnimationFinished = true;
        [UIView animateWithDuration:0.25f animations:^{
            self.scheduleTableView.frame = CGRectMake(0, self.view.frame.size.height, self.scheduleTableView.frame.size.width, self.scheduleTableView.frame.size.height);
            self.wuTapView.frame = CGRectMake(0,0, self.wuTapView.frame.size.width, self.wuTapView.frame.size.height);
        } completion:^(BOOL finished) {
            self.wuTapView.userInteractionEnabled = YES;
            self.scheduleTableView.userInteractionEnabled = NO;
        }];
    } else if (self.isAnimationFinished == false) {
        [UIView animateWithDuration:0.05f animations:^{
            self.wuTapView.frame = CGRectMake(0, kStateY + velocity * rate, self.wuTapView.frame.size.width, self.wuTapView.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end
