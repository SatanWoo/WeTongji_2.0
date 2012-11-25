//
//  LeftMenuViewController.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-19.
//
//

#import "LeftMenuViewController.h"
#import "Macro.h"
#import "LeftMenuCell.h"
#import "PlistReader.h"
#import "LeftMenuCellModel.h"
#import "JBKenBurnsView.h"
#import "WUKenBurnViewHeader.h"
#import "WUSlideViewController.h"
#import "User+Addition.h"

#define kLabelHeight 30

@interface LeftMenuViewController () <UITableViewDataSource,UITableViewDelegate>


@property (nonatomic ,strong) WUKenBurnViewHeader *kenView;
@property (nonatomic ,readonly) BOOL isLogIn;
@property (nonatomic ,strong) UIImageView *topImageView;
@property (nonatomic ,strong) UIImageView *bottomImageView;
@property (nonatomic ,strong) NSArray *imageArray;

- (void)configureBottomBarButton;
- (void)configureTableView;
@end

@implementation LeftMenuViewController
@synthesize menuTableView = _menuTableView;
@synthesize isLogin = _isLogin;
@synthesize delegate = _delegate;
@synthesize settingButton = _settingButton;
@synthesize infoButton = _infoButton;
@synthesize slideViewController = _slideViewController;

@synthesize identifierArray = _identifierArray;
@synthesize kenView = _kenView;
@synthesize topImageView = _topImageView;
@synthesize bottomImageView = _bottomImageView;
@synthesize imageArray = _imageArray;

#pragma mark - IBAction
- (IBAction)triggerInfo:(UIButton *)sender
{
    //[sender setSelected:!sender.selected];
    [self.slideViewController performSegueWithIdentifier:kAboutViewControllerSegue sender:self];
}

- (IBAction)triggerSetting:(UIButton *)sender
{
    [self.slideViewController performSegueWithIdentifier:kSettingViewControllerSegue sender:self];
    //[sender setSelected:!sender.selected];
}

#pragma mark - Private Method
- (void)configureTableView
{
    self.menuTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenuBg.png"]];
    [self.menuTableView registerNib:[UINib nibWithNibName:@"LeftMenuCell" bundle:nil] forCellReuseIdentifier:kLeftMenuCell];
}

- (void)configureBottomBarButton
{
    [self.settingButton setImage:[UIImage imageNamed:@"settings_btn_hl"] forState:UIControlStateHighlighted];
    [self.infoButton setImage:[UIImage imageNamed:@"info_btn_hl.png"] forState:UIControlStateHighlighted];
}

- (void)configureNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:kLogoutNotification object:nil];
}

- (void)logout
{
    self.identifierArray = nil;
    [self.menuTableView reloadData];
    LeftMenuCellModel * model = self.identifierArray[0];
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:model.identifier];
    [self.delegate changeMiddleContent:controller];
    
    LeftMenuCell *cell = (LeftMenuCell *)[self.menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell setSelected:YES];
}

- (void)configureHeader
{
    self.bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,270,120)];
    [self.view addSubview:self.bottomImageView];
    
    self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,270,120)];
    [self.view addSubview:self.topImageView];
    
    self.imageArray = [NSArray arrayWithObjects:
                          [UIImage imageNamed:@"1.png"],
                          [UIImage imageNamed:@"2.png"],
                          [UIImage imageNamed:@"3.png"],
                          [UIImage imageNamed:@"4.png"],
                          [UIImage imageNamed:@"5.png"],
                          [UIImage imageNamed:@"6.png"],
                          [UIImage imageNamed:@"7.png"],
                          [UIImage imageNamed:@"8.png"],
                          [UIImage imageNamed:@"9.png"],
                          [UIImage imageNamed:@"10.png"],
                          [UIImage imageNamed:@"11.png"],
                          [UIImage imageNamed:@"12.png"],
                          [UIImage imageNamed:@"13.png"],
                          nil];
    
    self.topImageView.image = [self.imageArray objectAtIndex:0];
    self.bottomImageView.image = [self.imageArray objectAtIndex:1];

    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(crossfade) userInfo:nil repeats:YES];
        
    self.menuTableView.contentInset = UIEdgeInsetsMake(self.topImageView.frame.size.height, 0, 0, 0);
}

- (void)crossfade {
    static int topIndex = 0;
    static int prevTopIndex = 1;
    static int round = 0;
    if(round % 2 == 0){
        
        [UIView animateWithDuration:3.0f animations:^{
            self.topImageView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                topIndex += 2;
                if (topIndex > [self.imageArray count] - 1) {
                    topIndex = 0;
                }
                self.topImageView.image = [self.imageArray objectAtIndex:topIndex];
                self.bottomImageView.image = [self.imageArray objectAtIndex:prevTopIndex];
                round += 1;
            }
        }];
       
    }else{
        [UIView animateWithDuration:3.0f animations:^{
            self.topImageView.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (finished) {
                prevTopIndex += 2;
                if (prevTopIndex > [self.imageArray count] - 1) {
                    prevTopIndex = 1;
                }
                self.topImageView.image = [self.imageArray objectAtIndex:topIndex];
                self.bottomImageView.image = [self.imageArray objectAtIndex:prevTopIndex];
                
                round -= 1;
            }
        }];
    }
}

#pragma mark - Getter & Setter
- (NSArray *)identifierArray
{
    if (_identifierArray == nil)
    {
        NSMutableArray * tempList = [[NSMutableArray alloc] init];
        _identifierArray = [[[PlistReader alloc] init] getLeftMenuResult];
        if ( !self.isLogIn )
            for ( LeftMenuCellModel * model in _identifierArray )
            {
                if ( !model.needLogin )
                    [tempList addObject:model];
            }
        else
            for ( LeftMenuCellModel * model in _identifierArray )
            {
                if ( model != _identifierArray[0] )
                    [tempList addObject:model];
            }
        _identifierArray = [NSArray arrayWithArray:tempList];
    }
    return _identifierArray;
}

-(BOOL) isLogIn
{
    if ( [User userinManagedObjectContext:self.managedObjectContext] ) return YES;
    else return NO;
}

- (void)setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    [self.menuTableView reloadData];
}

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    [self configureHeader];
    [self configureBottomBarButton];
    [self configureNotification];
}

- (void)viewDidUnload
{
    [self setMenuTableView:nil];
    [self setSettingButton:nil];
    [self setInfoButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.identifierArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeftMenuCell] ;
    if (cell == nil) {
        cell = [[LeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLeftMenuCell];
    }
    
    LeftMenuCellModel *model = (LeftMenuCellModel *)[self.identifierArray objectAtIndex:indexPath.row];
    cell.title.text = model.cellName;
    cell.identifer = model.identifier;
    if ([cell.identifer isEqualToString:kPersonalViewController] && self.isLogIn)
    {
        cell.title.text = [User userinManagedObjectContext:self.managedObjectContext].displayname;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [cell setSelected:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UITableViewCell *cell in [tableView visibleCells]) {
        [cell setSelected:NO];
    }
    
    LeftMenuCell *cell = (LeftMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES];
    
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:cell.identifer];
    [self.delegate changeMiddleContent:controller];
}

@end
