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
    
    [self.view addSubview:self.kenView];
    self.menuTableView.contentInset = UIEdgeInsetsMake(self.kenView.frame.size.height, 0, 0, 0);
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

- (WUKenBurnViewHeader *)kenView
{
    if (_kenView == nil) {
        
        _kenView = [[[NSBundle mainBundle] loadNibNamed:@"WUKenBurnViewHeader" owner:self options:nil] objectAtIndex:0];

        _kenView.kenView.layer.borderWidth = 1;
        _kenView.kenView.layer.borderColor = [UIColor blackColor].CGColor;
        
        NSArray *myImages = [NSArray arrayWithObjects:
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
        
        [_kenView.kenView animateWithImages:myImages
                     transitionDuration:15
                                   loop:YES
                            isLandscape:YES];
    }
    return _kenView;
}

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftMenuCell *cell = (LeftMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES];
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:cell.identifer];
    [self.delegate changeMiddleContent:controller];
}

@end
