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

#define kLabelHeight 30

@interface LeftMenuViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) NSArray *identifierArray;

- (void)configureTableView;
@end

@implementation LeftMenuViewController
@synthesize menuTableView = _menuTableView;
@synthesize isLogin = _isLogin;
@synthesize delegate = _delegate;

@synthesize identifierArray = _identifierArray;

#pragma mark - Private Method
- (void)configureTableView
{
    self.menuTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenuBg.png"]];
    [self.menuTableView registerNib:[UINib nibWithNibName:@"LeftMenuCell" bundle:nil] forCellReuseIdentifier:kLeftMenuCell];
    
    //TableViewHeader
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMenuDisplayedWidth, kLabelHeight)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"We";
    label.font = [UIFont boldSystemFontOfSize:20.f];
    label.textAlignment = UITextAlignmentCenter;
    self.menuTableView.contentInset = UIEdgeInsetsMake(label.frame.size.height, 0.0f, 0.0f, 0.0f);
    [self.view addSubview:label];
}

#pragma mark - Getter & Setter
- (NSArray *)identifierArray
{
    if (_identifierArray == nil) {
        _identifierArray = [NSArray arrayWithObjects:kPersonalViewController,kCampusViewController,nil];
    }
    return _identifierArray;
}

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
}

- (void)viewDidUnload
{
    [self setMenuTableView:nil];
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
    if (self.isLogin) {
        return 4;
    } else {
        return 3;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeftMenuCell];
    if (cell == nil) {
        cell = [[LeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLeftMenuCell];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    LeftMenuCell *cell = (LeftMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.title.textColor = [UIColor whiteColor];
//    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:[self.identifierArray objectAtIndex:indexPath.row]];
    [self.delegate changeMiddleContent:controller];
}

@end
