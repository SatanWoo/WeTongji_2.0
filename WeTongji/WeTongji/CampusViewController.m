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
#import "SchoolNewsCell.h"
#import "GroupInfoCell.h"
#import "Information+Addition.h"
#import "Star+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "PullRefreshManagement.h"
#import "SchoolNewsViewController.h"

#define kWidth self.scrollView.frame.size.width
#define kHeight self.scrollView.frame.size.height
#define kContentOffSet 41

typedef enum {
    School = 0,
    Group,
    Action,
    Recommend
} State;

@interface CampusViewController () <UITableViewDataSource, UITableViewDelegate,PullRefreshManagementDelegate>
@property (nonatomic, strong) UIView *schoolInfoView;
@property (nonatomic, strong) UIView *groupInfoView;
@property (nonatomic, strong) UIView *actionView;
@property (nonatomic, strong) UIView *recommendView;

@property (nonatomic, strong) UITableView *schoolInfoTableView;
@property (nonatomic, strong) UITableView *groupOInfoTableView;
@property (nonatomic, strong) UITableView *recommendTableView;
@property (nonatomic, strong) UITableView *actionTableView;
@property (nonatomic, strong) PullRefreshManagement * schoolRefreshManagement;
@property (nonatomic, strong) PullRefreshManagement * groupRefreshManagement;
@property (nonatomic, strong) PullRefreshManagement * recommendRefreshManagement;
@property (nonatomic, strong) PullRefreshManagement * actionRefreshManagement;
@property (nonatomic, weak) PullRefreshManagement * currentRefreshManagememt;
@property (nonatomic) NSInteger schoolNextPage;
@property (nonatomic) NSInteger groupNextPage;
@property (nonatomic) NSInteger recommendlNextPage;
@property (nonatomic) NSInteger actionNextPage;
@property (nonatomic) NSInteger currentNextPage;
@property (nonatomic, strong) NSArray * schoolList;
@property (nonatomic, strong) NSArray * groupList;
@property (nonatomic, strong) NSArray * recommendlList;
@property (nonatomic, strong) NSArray * actionList;
@property (nonatomic, weak) NSArray * currentList;
@property (nonatomic, strong) NSString * currentInformationType;
@property (nonatomic) State state;

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

@synthesize schoolInfoTableView = _schoolInfoTableView;
@synthesize groupOInfoTableView = _groupOInfoTableView;
@synthesize recommendTableView = _recommendTableView;
@synthesize actionTableView = _actionTableView;

#pragma mark - Setter and Getter

- (void)renderShadow:(UIView *)view
{
    if (view) {
        view.layer.shadowOpacity = 0.8f;
        view.layer.cornerRadius = 0.1f;
        view.layer.shadowRadius = 0.4f;
    }
}

- (UITableView *)schoolInfoTableView
{
    if (_schoolInfoTableView == nil) {
        _schoolInfoTableView = [[UITableView alloc] initWithFrame:self.schoolInfoView.bounds style:UITableViewStylePlain];
        [_schoolInfoTableView registerNib:[UINib nibWithNibName:@"SchoolNewsCell" bundle:nil] forCellReuseIdentifier:kSchoolInfoCell];
        _schoolInfoTableView.contentInset = UIEdgeInsetsMake(kContentOffSet, 0.0f, 0.0f, 0.0f);
        _schoolInfoTableView.delegate = self;
        _schoolInfoTableView.dataSource = self;
    }
    return _schoolInfoTableView;
}

- (UITableView *)groupOInfoTableView
{
    if (_groupOInfoTableView == nil) {
        _groupOInfoTableView = [[UITableView alloc] initWithFrame:self.groupInfoView.bounds style:UITableViewStylePlain];
        [_groupOInfoTableView registerNib:[UINib nibWithNibName:@"GroupInfoCell" bundle:nil] forCellReuseIdentifier:kGroupInfoCell];
        _groupOInfoTableView.contentInset = UIEdgeInsetsMake(kContentOffSet, 0.0f, 0.0f, 0.0f);
        _groupOInfoTableView.delegate = self;
        _groupOInfoTableView.dataSource = self;
    }
    return _groupOInfoTableView;
}

- (UITableView *)recommendTableView
{
    if (_recommendTableView == nil) {
        _recommendTableView = [[UITableView alloc] initWithFrame:self.recommendView.bounds style:UITableViewStylePlain];
        [_recommendTableView registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:nil] forCellReuseIdentifier:KRecommendCell];
        _recommendTableView.contentInset = UIEdgeInsetsMake(kContentOffSet, 0.0f, 0.0f, 0.0f);
        _recommendTableView.delegate = self;
        _recommendTableView.dataSource = self;
    }
    return _recommendTableView;
}

- (UITableView *)actionTableView
{
    if (_actionTableView == nil) {
        _actionTableView = [[UITableView alloc] initWithFrame:self.actionView.bounds style:UITableViewStylePlain];
        [_actionTableView registerNib:[UINib nibWithNibName:@"SchoolNewsCell" bundle:nil] forCellReuseIdentifier:kSchoolInfoCell];
        _actionTableView.contentInset = UIEdgeInsetsMake(kContentOffSet, 0.0f, 0.0f, 0.0f);
        _actionTableView.delegate = self;
        _actionTableView.dataSource = self;
    }
    return _actionTableView;
}

- (PullRefreshManagement *) schoolRefreshManagement
{
    if ( !_schoolRefreshManagement )
    {
        _schoolRefreshManagement = [[PullRefreshManagement alloc] initWithScrollView:self.schoolInfoTableView];
    }
    return _schoolRefreshManagement;
}

- (PullRefreshManagement *) groupRefreshManagement
{
    if ( !_groupRefreshManagement )
    {
        _groupRefreshManagement = [[PullRefreshManagement alloc] initWithScrollView:self.groupOInfoTableView];
    }
    return _groupRefreshManagement;
}

- (PullRefreshManagement *) recommendRefreshManagement
{
    if ( !_recommendRefreshManagement )
    {
        _recommendRefreshManagement = [[PullRefreshManagement alloc] initWithScrollView:self.recommendTableView];
    }
    return _recommendRefreshManagement;
}

- (PullRefreshManagement *) actionRefreshManagement
{
    if ( !_actionRefreshManagement )
    {
        _actionRefreshManagement = [[PullRefreshManagement alloc] initWithScrollView:self.actionTableView];
    }
    return _actionRefreshManagement;
}

-(void) setCurrentRefreshManagememt:(PullRefreshManagement *)currentRefreshManagememt
{
    if ( _currentRefreshManagememt != currentRefreshManagememt )
    {
        WTClient * client = [WTClient sharedClient];
        [client cancelAllHTTPOperationsWithMethod:nil path:nil];
        [currentRefreshManagememt firstTrigger];
    }
    _currentRefreshManagememt = currentRefreshManagememt;
}

-(NSArray *) schoolList
{
    if ( !_schoolList )
    {
        _schoolList = [Information getAllInformationWithCategory:GetInformationTypeForStaff inManagedObjectContext:self.managedObjectContext];
        NSMutableArray * tempList = [[NSMutableArray alloc] init];
        for ( Information * information in _schoolList )
            if ( ![information.hiden boolValue] )
                [tempList addObject:information];
        NSArray *sortedNames = [tempList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            Information *info1 = (Information *)obj1;
            Information *info2 = (Information *)obj2;
            return [info2.createdAt compare: info1.createdAt];
        }];
        _schoolList = [[NSArray alloc] initWithArray: sortedNames];
    }
    return _schoolList;
}

-(NSArray *) groupList
{
    if ( !_groupList )
    {
        _groupList = [Information getAllInformationWithCategory:GetInformationTypeClubNews inManagedObjectContext:self.managedObjectContext];
        NSMutableArray * tempList = [[NSMutableArray alloc] init];
        for ( Information * information in _groupList )
            if ( ![information.hiden boolValue] )
                [tempList addObject:information];
        NSArray *sortedNames = [tempList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            Information *info1 = (Information *)obj1;
            Information *info2 = (Information *)obj2;
            return [info2.createdAt compare: info1.createdAt];
        }];
        _groupList = [[NSArray alloc] initWithArray: sortedNames];
        
    }
    return _groupList;
}

-(NSArray *) recommendlList
{
    if ( !_recommendlList )
    {
        _recommendlList = [Information getAllInformationWithCategory:GetInformationTypeAround inManagedObjectContext:self.managedObjectContext];
        NSMutableArray * tempList = [[NSMutableArray alloc] init];
        for ( Information * information in _recommendlList )
            if ( ![information.hiden boolValue] )
                [tempList addObject:information];
        NSArray *sortedNames = [tempList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            Information *info1 = (Information *)obj1;
            Information *info2 = (Information *)obj2;
            return [info2.createdAt compare: info1.createdAt];
        }];
        _recommendlList = [[NSArray alloc] initWithArray: sortedNames];
    }
    return _recommendlList;
}

-(NSArray *) actionList
{
    if ( !_actionList )
    {
        _actionList = [Information getAllInformationWithCategory:GetInformationTypeSchoolNews inManagedObjectContext:self.managedObjectContext];
        NSMutableArray * tempList = [[NSMutableArray alloc] init];
        for ( Information * information in _actionList )
            if ( ![information.hiden boolValue] )
                [tempList addObject:information];
        NSArray *sortedNames = [tempList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            Information *info1 = (Information *)obj1;
            Information *info2 = (Information *)obj2;
            return [info2.createdAt compare: info1.createdAt];
        }];
        _actionList = [[NSArray alloc] initWithArray: sortedNames];
    }
    return _actionList;
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
    [self.schoolInfoButton setBackgroundImage:[UIImage imageNamed:@"xiaowu_hl.png"] forState:UIControlStateHighlighted];
    [self.schoolInfoButton setBackgroundImage:[UIImage imageNamed:@"xiaowu_sl.png"] forState:UIControlStateSelected];
    [self.schoolInfoButton setSelected:YES];
    
    [self.groupInfoButton setBackgroundImage:[UIImage imageNamed:@"tonggao_hl.png"] forState:UIControlStateHighlighted];
    [self.groupInfoButton setBackgroundImage:[UIImage imageNamed:@"tonggao_sl.png"] forState:UIControlStateSelected];
    
    [self.actionButton setBackgroundImage:[UIImage imageNamed:@"dongtai_hl.png"] forState:UIControlStateHighlighted];
    [self.actionButton setBackgroundImage:[UIImage imageNamed:@"dongtai_sl.png"] forState:UIControlStateSelected];
    
    [self.recommendButton setBackgroundImage:[UIImage imageNamed:@"tuijian_hl.png"] forState:UIControlStateHighlighted];
    [self.recommendButton setBackgroundImage:[UIImage imageNamed:@"tuijian_sl.png"] forState:UIControlStateSelected];
}

- (void)configureTableView
{
    [self.schoolInfoView addSubview:self.schoolInfoTableView];
    [self.groupInfoView addSubview:self.groupOInfoTableView];
    [self.recommendView addSubview:self.recommendTableView];
    [self.actionView addSubview:self.actionTableView];
    self.schoolRefreshManagement.delegate = self;
    self.groupRefreshManagement.delegate = self;
    self.recommendRefreshManagement.delegate = self;
    self.actionRefreshManagement.delegate = self;
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
        } else {
            [btn setSelected:NO];
        }
    }];
    
    switch (index) {
        case 0:
            self.state = School;
            self.currentList = self.schoolList;
            self.currentNextPage = self.schoolNextPage;
            self.currentInformationType = GetInformationTypeForStaff;
            self.currentRefreshManagememt = self.schoolRefreshManagement;
            break;
        case 1:
            self.state = Group;
            self.currentList = self.groupList;
            self.currentNextPage = self.groupNextPage;
            self.currentInformationType = GetInformationTypeClubNews;
            self.currentRefreshManagememt = self.groupRefreshManagement;
            break;
        case 2:
            self.state = Action;
            self.currentList = self.actionList;
            self.currentNextPage = self.actionNextPage;
            self.currentInformationType = GetInformationTypeSchoolNews;
            self.currentRefreshManagememt = self.actionRefreshManagement;
            break;
        case 3:
            self.state = Recommend;
            self.currentList = self.recommendlList;
            self.currentNextPage = self.recommendlNextPage;
            self.currentInformationType = GetInformationTypeAround;
            self.currentRefreshManagememt = self.recommendRefreshManagement;
            break;
        default:
            break;
    }
    
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
    [self pageChange:self.schoolInfoButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.currentRefreshManagememt firstTrigger];
}

- (void)viewDidUnload
{
    self.scrollView = nil;
    
    self.schoolInfoButton = nil;
    self.schoolInfoTableView = nil;
    self.schoolInfoView = nil;
    
    self.groupInfoButton = nil;
    self.groupOInfoTableView = nil;
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

static NSInteger tempRow;

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SchoolNewsViewController * controller = segue.destinationViewController;
    [controller setInformation:self.currentList[tempRow]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tempRow = indexPath.row;
    [self performSegueWithIdentifier:kkSchoolNewsViewControllerSegue sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView == self.schoolInfoTableView ) {
        return [self.schoolList count];
    } else if ( tableView == self.groupOInfoTableView ) {
        return [self.groupList count];
    } else if ( tableView == self.actionTableView ) {
        return [self.actionList count];
    } else if ( tableView == self.recommendTableView ) {
        return [self.recommendlList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.schoolInfoTableView) {
        SchoolNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kSchoolInfoCell];
        if (cell == nil) {
            cell = [[SchoolNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSchoolInfoCell];
        }
        [cell setInformation:self.schoolList[indexPath.row]];
        return cell;
    } else if (tableView == self.groupOInfoTableView) {
        GroupInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kGroupInfoCell];
        if (cell == nil) {
            cell = [[GroupInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGroupInfoCell];
        }
        [cell setInformation:self.groupList[indexPath.row]];
        return cell;
        
    } else if (tableView == self.recommendTableView) {
        RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:KRecommendCell];
        if (cell == nil) {
            cell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KRecommendCell];
        }
        [cell setInformation:self.recommendlList[indexPath.row]];
        return cell;
    } else {
        SchoolNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kSchoolInfoCell];
        if (cell == nil) {
            cell = [[SchoolNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSchoolInfoCell];
        }
        [cell setInformation:self.actionList[indexPath.row]];
        return cell;
    }
}

#pragma -
#pragma - refresh method by tzx

- (void)refresh
{
    self.currentNextPage = 1;
    [self loadMoreData];
}

- (void)clearData
{
    NSArray *informations = [Information getAllInformationWithCategory:self.currentInformationType inManagedObjectContext:self.managedObjectContext];
    for(Information * information in informations)
    {
        information.hiden = [NSNumber numberWithBool:YES];
    }
    
}

- (void)endLoading
{
    if ( self.state == School ) {
        self.schoolList = nil;
        [self.schoolInfoTableView reloadData];
        self.currentList = self.schoolList;
    } else if ( self.state == Group ) {
        self.groupList = nil;
        [self.groupOInfoTableView reloadData];
        self.currentList = self.groupList;
    } else if ( self.state == Action ) {
        self.actionList = nil;
        [self.actionTableView reloadData];
        self.currentList = self.actionList;
    } else if ( self.state == Recommend ) {
        self.recommendlList = nil;
        [self.recommendTableView reloadData];
        self.currentList = self.recommendlList;
    }
}

- (void)loadMoreData
{
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData)
                           {
                               if(self.currentNextPage == 1)
                                   [self clearData];
                               NSString * key;
                               if ( [self.currentInformationType isEqualToString: GetInformationTypeAround] ||
                                   [self.currentInformationType isEqualToString: GetInformationTypeForStaff] )
                                   key = [self.currentInformationType stringByAppendingString:@"s"];
                               else if ( [self.currentInformationType isEqualToString: GetInformationTypeClubNews] ||
                                        [self.currentInformationType isEqualToString: GetInformationTypeSchoolNews])
                                   key = self.currentInformationType;
                               NSArray *array = [responseData objectForKey:key];
                               for(NSDictionary *dict in array)
                               {
                                   Information *information = [Information insertAnInformation:dict inCategory:self.currentInformationType inManagedObjectContext:self.managedObjectContext];
                                   information.hiden = [NSNumber numberWithBool:NO];
                               }
                               self.currentNextPage = [[NSString stringWithFormat:@"%@", [responseData objectForKey:@"NextPager"]] intValue];
                               if (self.currentNextPage == 0) [self.currentRefreshManagememt setNoMoreData:YES];
                               [self.currentRefreshManagememt endLoading];
                           }
                            failureBlock:^(NSError * error)
                            {
                                [self.currentRefreshManagememt endLoading];
                            }];
    [request getAllInformationInType:self.currentInformationType sort:GetActivitySortMethodCreateDesc nextPage:self.currentNextPage];
    [client enqueueRequest:request];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self.currentRefreshManagememt scrollViewDidScroll:scrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerat
{
    [self.currentRefreshManagememt scrollViewDidEndDragging:scrollView willDecelerate:decelerat];
}



@end
