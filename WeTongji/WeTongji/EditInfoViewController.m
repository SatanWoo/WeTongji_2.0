//
//  EditInfoViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-12.
//
//

#import "EditInfoViewController.h"
#import "Macro.h"
#import "EditInfoCell.h"
#import <QuartzCore/QuartzCore.h>
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "User+Addition.h"

@interface EditInfoViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) User * user;
- (void)configureTableView;
@end

@implementation EditInfoViewController
@synthesize profileAvatar;
@synthesize name;
@synthesize sex;
@synthesize upperView;
@synthesize infoTableView;
@synthesize user = _user;

-(User *) user
{
    if ( !_user )
    {
        _user = [User userinManagedObjectContext:self.managedObjectContext];
    }
    return _user;
}

#pragma mark - Private
- (void)configureTableView
{
    [self.infoTableView registerNib:[UINib nibWithNibName:@"EditInfoCell" bundle:nil] forCellReuseIdentifier:kEditInfoCell];
    self.infoTableView.contentInset = UIEdgeInsetsMake(self.upperView.frame.size.height, 0, 0, 0);
    self.upperView.layer.shadowOpacity = 0.8;
    self.upperView.layer.shadowColor = [UIColor blackColor].CGColor;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    if ( self.user )
    {
        [self.profileAvatar setImageWithURL:[NSURL URLWithString: self.user.avatarLink]];
        self.name.text = self.user.displayname;
        if ( [self.user.gender isEqualToString:@"男"] )
        {
            [self.sex setImage:[UIImage imageNamed:@"male.png"]];
        }
        else
            [self.sex setImage:[UIImage imageNamed:@"female.png"]];
        self.ageLabel.text = [self.user.age stringValue];
    }
}

- (void)viewDidUnload
{
    [self setProfileAvatar:nil];
    [self setName:nil];
    [self setSex:nil];
    [self setUpperView:nil];
    [self setInfoTableView:nil];
    [self setAgeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kEditInfoCell];
    if (cell == nil) {
        cell = [[EditInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEditInfoCell];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
