//
//  FilterViewController.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-11.
//
//

#import "FilterViewController.h"
#import "FilterTableViewCell.h"
#import "Macro.h"

@interface FilterViewController ()<UITableViewDelegate>

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
    CGAffineTransform at =CGAffineTransformMakeRotation(-M_PI/2);
    [self.filterTableView setTransform:at];
    [self.filterTableView setCenter:self.view.center];
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
    cell.contentView.transform = CGAffineTransformMakeRotation(+M_PI/2);
    cell.descriptionLabel.text = [self.filterList objectAtIndex:indexPath.row];
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate filterViewSelectedRow:indexPath.row];
}

-(void)selectRow:(NSInteger) row
{
    [self.filterTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.delegate filterViewSelectedRow:row];
}


@end
