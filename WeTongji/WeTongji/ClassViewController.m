//
//  ClassViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-1-5.
//
//

#import "ClassViewController.h"

@interface ClassViewController ()

@end

@implementation ClassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureScrollView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (void)configureScrollView
{
    CGRect frame = self.scrollView.frame;
    frame.size.height += 10;
    self.scrollView.contentSize = frame.size;
}

@end
