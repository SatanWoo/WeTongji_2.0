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
{
    BOOL _isEditEnable;
    BOOL _isKeyBoardAppear;
}
@property (nonatomic,strong) User * user;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelEditButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ConfirmEditBarButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
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
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidUnload
{
    [self setProfileAvatar:nil];
    [self setName:nil];
    [self setSex:nil];
    [self setInfoTableView:nil];
    [self setAgeLabel:nil];
    [self setConfirmEditBarButton:nil];
    [self setEditButton:nil];
    [self setScrollView:nil];
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
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kEditInfoCell];
    if (cell == nil)
    {
        cell = [[EditInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEditInfoCell];
    }
    if ( indexPath.section == 0 )
        switch (indexPath.row)
        {
            case 0:
                [cell setType:EditInfoCellTypeStudentNumber];
                cell.field.text = self.user.studentNumber;
                break;
            case 1:
                [cell setType:EditInfoCellTypeDepartment];
                cell.field.text = self.user.department;
                break;
            case 2:
                [cell setType:EditInfoCellTypeMajor];
                cell.field.text = self.user.major;
                break;
            case 3:
                [cell setType:EditInfoCellTypeYear];
                cell.field.text = self.user.year;
                break;
            default:
                break;
        }
    if ( indexPath.section == 1 )
        switch (indexPath.row)
        {
            case 0:
                [cell setType:EditInfoCellTypePhone];
                cell.field.text = self.user.phone;
                break;
            case 1:
                [cell setType:EditInfoCellTypeQQ];
                cell.field.text = self.user.qq;
                break;
            case 2:
                [cell setType:EditInfoCellTypeEmail];
                cell.field.text = self.user.email;
                break;
            case 3:
                [cell setType:EditInfoCellTypeWeibo];
                cell.field.text = self.user.sinaWeibo;
                break;
            default:
                break;
    }
    [cell setIsEditEnable:_isEditEnable];
    [cell.field addTarget:self action:@selector(didEndEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [cell.field addTarget:self action:@selector(didBeginEdit:) forControlEvents:UIControlEventEditingDidBegin];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didBeginEdit:(id)sender
{
    if ( _isKeyBoardAppear ) return;
    _isKeyBoardAppear = YES;
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    self.scrollView.contentInset = UIEdgeInsetsMake(-self.upperView.frame.size.height, 0, 200, 0);
    [UIView commitAnimations];
}

- (void)didEndEdit:(id)sender
{
    [sender resignFirstResponder];
    [UIView animateWithDuration:.3 animations:^{self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);} completion:^(BOOL isFinished)
     {
         if (isFinished) _isKeyBoardAppear = NO;
     }];
}

static id tempLeftBarItem;

- (IBAction)editClcked:(id)sender
{
    _isEditEnable = YES;
    tempLeftBarItem = self.navigationItem.leftBarButtonItem;
    self.navigationItem.leftBarButtonItem = self.cancelEditButton;
    self.navigationItem.rightBarButtonItem = self.ConfirmEditBarButton;
    [self.editButton setHidden:YES];
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    self.infoTableView.contentInset = UIEdgeInsetsMake(self.upperView.frame.size.height-190, 0, 0, 0);
    [UIView commitAnimations];
    [self.infoTableView setScrollEnabled:NO];
    [self.scrollView setScrollEnabled:YES];
    [self.infoTableView reloadData];

}

- (IBAction)confirmEditClicked:(id)sender
{
    self.navigationItem.leftBarButtonItem = tempLeftBarItem;
    self.navigationItem.rightBarButtonItem = nil;
    [self.editButton setHidden:NO];
    _isEditEnable = NO;
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    self.infoTableView.contentInset = UIEdgeInsetsMake(self.upperView.frame.size.height, 0, 0, 0);
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [UIView commitAnimations];
    [self.infoTableView setScrollEnabled:YES];
    [self.scrollView setScrollEnabled:NO];
    _isKeyBoardAppear = NO;
    NSString * email;
    NSString * weiboName;
    NSString * phone;
    NSString * qq;
    EditInfoCell * cell;
    for ( int i = 0 ; i<4 ; i++ )
    {
        cell = ( EditInfoCell *)[self.infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
        [cell setIsEditEnable:NO];
        switch (cell.type)
        {
            case EditInfoCellTypePhone:
                phone = cell.field.text;
                break;
            case EditInfoCellTypeQQ:
                qq = cell.field.text;
                break;
            case EditInfoCellTypeEmail:
                email = cell.field.text;
                break;
            case EditInfoCellTypeWeibo:
                weiboName = cell.field.text;
                break;
            default:
                break;
        }
    }
    WTClient * client = [WTClient getClient];
    [client setCompletionBlock:^(id responseData)
    {
        [User updateUser:[responseData objectForKey:@"User"] inManagedObjectContext:self.managedObjectContext];
        [self.infoTableView reloadData];
        NSLog(@"%@",responseData);
    }];
    [client updateUserDisplayName:nil email:email weiboName:weiboName phoneNum:phone qqAccount:qq];
}

- (IBAction)cancelEditClicked:(id)sender
{
    self.navigationItem.leftBarButtonItem = tempLeftBarItem;
    self.navigationItem.rightBarButtonItem = nil;
    [self.editButton setHidden:NO];
    _isEditEnable = NO;
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    self.infoTableView.contentInset = UIEdgeInsetsMake(self.upperView.frame.size.height, 0, 0, 0);
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [UIView commitAnimations];
    [self.infoTableView setScrollEnabled:YES];
    [self.scrollView setScrollEnabled:NO];
    _isKeyBoardAppear = NO;
    [self.infoTableView reloadData];
}


@end
