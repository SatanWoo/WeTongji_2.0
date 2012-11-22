//
//  FilterViewController.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-11.
//
//

#import "FilterViewController.h"
#import "FilterTableViewCell.h"
#import "Event+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "Macro.h"

@interface FilterViewController ()<UITableViewDelegate>
{
    NSInteger _selectedIndex;
}

@property (nonatomic,strong) NSArray * filterList;
@property (nonatomic,weak) UIView * contentView;
@property (nonatomic,strong) UIView * shadowView;
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;

@end

@implementation FilterViewController

@synthesize filterList=_filterList;
@synthesize contentView=_contentView;
@synthesize shadowView = _shadowView;
@synthesize delegate=_delegate;

-(id) initWithFilterList:(NSArray *) filterList forContentView:(UIView *)contentView
{
    self = [super initWithNibName:nil bundle:nil];
    if ( self )
    {
        self.filterList=filterList;
        self.contentView=contentView;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(UIView *) shadowView
{
    if ( !_shadowView )
    {
        _shadowView = [[UIView alloc] initWithFrame:[self.contentView bounds]];
        [_shadowView setBackgroundColor:[UIColor blackColor]];
        _shadowView.alpha = 0.0;
        [self.contentView addSubview:_shadowView];
        [self.shadowView setHidden:YES];
        UITapGestureRecognizer * g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowTaped:)];
        [self.shadowView addGestureRecognizer:g];
    }
    return _shadowView;
}

-(void)shadowTaped:(UITapGestureRecognizer *)g
{
    [self hideFilterView];
}

-(void)showFilterView
{
    if ( _isFilterViewAppear ) return;
    [self.view setHidden:NO];
    [self.shadowView setHidden:NO];
    [UIView animateWithDuration:0.3f animations:^{
        UIView * view = self.contentView;
        [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+self.view.bounds.size.height, view.frame.size.width, view.frame.size.height)];
        [self.shadowView setAlpha:0.6];
    } completion:^(BOOL isFinished){
        if (isFinished)
        {
            
        }
    }];
    _isFilterViewAppear=YES;
}
-(void)hideFilterView
{
    if ( !_isFilterViewAppear ) return;
    [UIView animateWithDuration:0.3f animations:^{
        UIView * view = self.contentView;
        [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-self.view.bounds.size.height, view.frame.size.width, view.frame.size.height)];
        [self.shadowView setAlpha:0.0];
    } completion:^(BOOL isFinished){
        if (isFinished)
        {
            [self.view setHidden:YES];
            [self.shadowView setHidden:YES];
        }
    }];
    _isFilterViewAppear=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _selectedIndex = 1;
    CGAffineTransform at =CGAffineTransformMakeRotation(-M_PI/2);
    [self.filterTableView setTransform:at];
    CGPoint center = self.view.center;
    center.y -= 5;
    [self.filterTableView setCenter:center];
    [self.filterTableView registerNib:[UINib nibWithNibName:@"FilterTableViewCell" bundle:nil] forCellReuseIdentifier:kFilterTableViewCell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFilterTableView:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filterList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFilterTableViewCell];
    if (cell == nil)
    {
        cell = [[FilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFilterTableViewCell];
        
    }
    Event * event;
    switch (indexPath.row) {
        case 0:
            event = [Event getNearestEventInManagedObjectContext:self.managedObjectContext];
            NSLog(@"%@",event.beginTime);
            break;
        case 1:
            event = [Event getLatestEventInManagedObjectContext:self.managedObjectContext];
            NSLog(@"%@",event.createAt);
            break;
        case 2:
            event = [Event getHotestEventInManagedObjectContext:self.managedObjectContext];
            NSLog(@"%@",event.title);
            break;
        default:
            break;
    }
    [cell.avatarImage setImageWithURL:[NSURL URLWithString:event.orgranizerAvatarLink] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    cell.contentView.transform = CGAffineTransformMakeRotation(+M_PI/2);
    cell.descriptionLabel.text = [self.filterList objectAtIndex:indexPath.row];
    return cell;
}

-(void) reloadTableView
{
    [self.filterTableView reloadData];
    [self.filterTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
    [self.delegate filterViewSelectedRow:indexPath.row];
}

-(void)selectRow:(NSInteger) row
{
    _selectedIndex = row;
    [self.filterTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.delegate filterViewSelectedRow:row];
}


@end
