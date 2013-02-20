//
//  WUPageControlViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-11.
//
//

#import "WUPageControlViewController.h"
#import "ZoomScrollView.h"

@interface WUPageControlViewController () <UIScrollViewDelegate>
- (void)configureScrollView;
- (void)loadVisiblePages;
@property (nonatomic ,assign) int pictureNumber;
@property (nonatomic ,strong) NSMutableArray * imageList;
@property (weak, nonatomic) IBOutlet UITextView *imageDescription;
@property (strong, nonatomic) NSMutableArray * descriptionList;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation WUPageControlViewController
@synthesize pagedScrollView;
@synthesize pageControl;

-(void) autolayout
{
    CGRect frame = self.view.frame;
    frame.size.height = [[UIScreen mainScreen] bounds].size.height;
    [self.view setFrame:frame];
    frame = self.pagedScrollView.frame;
    frame.size.height = [[UIScreen mainScreen] bounds].size.height;
    [self.pagedScrollView setFrame:frame];
    frame = self.textView.frame;
    frame.size.height = 40;
    frame.origin.y = self.view.frame.size.height - 40;
    [self.textView setFrame:frame];
    frame = self.pageControl.frame;
    frame.origin.y = self.view.frame.size.height - 80;
    [self.pageControl setFrame:frame];
}

-(void) setPictureNumber:(int)pictureNumber
{
    _pictureNumber = pictureNumber;
    if ( _pictureNumber > 1)
    {
        [self.pageControl setHidden:NO];
    }
    else
    {
        [self.pageControl setHidden:YES];
    }
}

-(NSMutableArray *) imageList
{
    if ( !_imageList )
    {
        _imageList = [[NSMutableArray alloc] init];
    }
    return _imageList;
}

-(NSMutableArray *) descriptionList
{
    if ( !_descriptionList )
    {
        _descriptionList = [[NSMutableArray alloc] init];
    }
    return _descriptionList;
}

#pragma mark - Public
- (void)addPicture:(UIImageView *)image withDescription:(id)desc
{
    CGRect frame = self.view.bounds;
    frame.origin.x = 0;
    frame.origin.y = 0.0f;
    image.frame = frame;
    frame.origin.x = frame.size.width * self.pictureNumber;
    ZoomScrollView * scrollView = [[ZoomScrollView alloc] initWithFrame:frame withImage:image];
    [self.pagedScrollView addSubview:scrollView];
    self.pictureNumber ++;
    self.pageControl.numberOfPages = self.pictureNumber;
    [self.descriptionList addObject:[desc copy]];
    [self.imageList addObject:scrollView];
    if ( [self.descriptionList count] == 1 )
    {
        [self.imageDescription setHidden: ([desc isKindOfClass:[NSNull class]] ? YES : NO)];
        self.imageDescription.text = [NSString stringWithFormat:@"%@",desc];
    }
    [self configureScrollView];
}

- (void)clearPictureAndDescription
{
    NSArray * views = [self.pagedScrollView subviews];
    for ( UIView * view in views )
        [view removeFromSuperview];
    self.pictureNumber = 0 ;
    self.imageList = nil;
    self.descriptionList = nil;
    [self configureScrollView];
    self.pageControl.numberOfPages = self.pictureNumber;
}

#pragma mark - Private Method
- (void)configureScrollView
{
    self.pagedScrollView.delegate = self;
    
    CGSize pagesScrollViewSize = self.pagedScrollView.frame.size;
    self.pagedScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageControl.numberOfPages , pagesScrollViewSize.height);
}

- (void)loadVisiblePages {
    CGFloat pageWidth = self.pagedScrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.pagedScrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    self.pageControl.currentPage = page;
    id desc = self.descriptionList[page];
    self.imageDescription.text = [NSString stringWithFormat:@"%@",desc];
    [self.imageDescription setHidden: ([desc isKindOfClass:[NSNull class]] ? YES : NO)];
}

#pragma mark - Life Cycle

- (void)disableSwipe
{
    UISwipeGestureRecognizer *rightGesturer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:nil];
    rightGesturer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightGesturer];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self configureScrollView];
    [self disableSwipe];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 0;
    [self setWantsFullScreenLayout:YES];
    [self autolayout];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%f",self.view.frame.size.height);
}

- (void)viewDidUnload
{
    [self setPagedScrollView:nil];
    [self setPageControl:nil];
    [self setImageDescription:nil];
    [self setTextView:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages which are now on screen
    [self loadVisiblePages];
}

@end
