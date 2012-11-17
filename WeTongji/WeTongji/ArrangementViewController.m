//
//  ArrangementViewController.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-11-5.
//
//

#import "ArrangementViewController.h"
#import "ArrangementCell.h"
#import "Macro.h"
#import "WUArrangementSectionHeaderView.h"

@interface ArrangementViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *sectionTableView;
- (void)configureTableView;
@end

@implementation ArrangementViewController
@synthesize arrangementTableView;

#pragma mark - Private Method
- (void)configureTableView
{
    [self.arrangementTableView registerNib:[UINib nibWithNibName:@"ArrangementCell" bundle:nil] forCellReuseIdentifier:kArrangementCell];
    self.arrangementTableView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setArrangementTableView:nil];
    [self setSectionTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView == self.sectionTableView ) return 9;
    return 10;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( tableView == self.sectionTableView ) return 80;
    return 0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WUArrangementSectionHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"WUArrangementSectionHeaderView" owner:self options:nil] objectAtIndex:0];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if ( tableView == self.sectionTableView )
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"transparentTableCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"transparentTableCell"];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kArrangementCell];
        if (cell == nil) {
            cell = [[ArrangementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kArrangementCell];
        }
    }
    return cell;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( scrollView == self.arrangementTableView )
    {
        [self.sectionTableView scrollRectToVisible:CGRectMake(self.arrangementTableView.contentOffset.x, self.arrangementTableView.contentOffset.y,self.arrangementTableView.bounds.size.width, self.arrangementTableView.bounds.size.height)  animated:NO];
    }
}

@end
