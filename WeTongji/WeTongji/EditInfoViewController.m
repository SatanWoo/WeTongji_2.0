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
#import "EditInfoHeaderView.h"

@interface EditInfoViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    BOOL _isEditEnable;
    BOOL _isKeyBoardAppear;
}
@property (weak, nonatomic) IBOutlet EditInfoHeaderView *headerView;
@property (nonatomic,strong) User * user;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelEditButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ConfirmEditBarButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSArray * editableList;
@property (nonatomic,strong) NSArray * staticList;
@property (nonatomic,strong) NSArray * infoList;
- (void)configureTableView;
@end

@implementation EditInfoViewController
@synthesize infoTableView;
@synthesize user = _user;

#pragma mark - Setter & Getter
-(User *) user
{
    if ( !_user )
    {
        _user = [User userinManagedObjectContext:self.managedObjectContext];
    }
    return _user;
}

-(NSArray *) staticList
{
    if ( !_staticList )
    {
        _staticList = [NSArray arrayWithObjects:[NSNumber numberWithInteger:EditInfoCellTypeStudentNumber],[NSNumber numberWithInteger:EditInfoCellTypeDepartment],[NSNumber numberWithInteger:EditInfoCellTypeMajor],[NSNumber numberWithInteger:EditInfoCellTypeYear], nil];
    }
    return _staticList;
}

-(NSArray *) editableList
{
    if ( !_editableList )
    {
        _editableList = [NSArray arrayWithObjects:[NSNumber numberWithInteger:EditInfoCellTypePhone],[NSNumber numberWithInteger:EditInfoCellTypeQQ],[NSNumber numberWithInteger:EditInfoCellTypeEmail],[NSNumber numberWithInteger:EditInfoCellTypeWeibo], nil];
    }
    return _editableList;
}

-(NSArray *) infoList
{
    if ( !_infoList )
    {
        _infoList = [NSArray arrayWithObjects:self.staticList,self.editableList, nil];
    }
    return _infoList;
}


#pragma mark - Private
- (void)configureTableView
{
    [self.infoTableView registerNib:[UINib nibWithNibName:@"EditInfoCell" bundle:nil] forCellReuseIdentifier:kEditInfoCell];
    [self.infoTableView setBackgroundView:nil];
    [self.infoTableView setBackgroundColor:self.headerView.backgroundColor];
    self.infoTableView.tableHeaderView = self.headerView;
}

#pragma mark - Life Cyclc
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    if ( self.user )
    {
        [self.headerView.avatar setImageWithURL:[NSURL URLWithString: self.user.avatarLink]];
        self.headerView.nameLabel.text = self.user.displayname;
        if ( [self.user.gender isEqualToString:@"男"] )
        {
            [self.headerView.sex setImage:[UIImage imageNamed:@"male.png"]];
        }
        else
            [self.headerView.sex setImage:[UIImage imageNamed:@"female.png"]];
        self.headerView.ageLabel.text = [self.user.age stringValue];
    }
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidUnload
{
    [self setInfoTableView:nil];
    [self setConfirmEditBarButton:nil];
    [self setEditButton:nil];
    [self setScrollView:nil];
    [self setHeaderView:nil];
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
    NSLog(@"%d",[self.infoList count]);
    return [self.infoList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",[[self.infoList objectAtIndex:section] count]);
    return [[self.infoList objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kEditInfoCell];
    if (cell == nil)
    {
        cell = [[EditInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEditInfoCell];
    }
    EditInfoCellType type=[[[self.infoList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] intValue];
    switch (type)
    {
        case EditInfoCellTypeStudentNumber:
            [cell setType:EditInfoCellTypeStudentNumber];
            cell.field.text = self.user.studentNumber;
            break;
        case EditInfoCellTypeDepartment:
            [cell setType:EditInfoCellTypeDepartment];
            cell.field.text = self.user.department;
            break;
        case EditInfoCellTypeMajor:
            [cell setType:EditInfoCellTypeMajor];
            cell.field.text = self.user.major;
            break;
        case EditInfoCellTypeYear:
            [cell setType:EditInfoCellTypeYear];
            cell.field.text = self.user.year;
            break;
        case EditInfoCellTypePhone:
            [cell setType:EditInfoCellTypePhone];
            cell.field.text = self.user.phone;
            break;
        case EditInfoCellTypeQQ:
            [cell setType:EditInfoCellTypeQQ];
            cell.field.text = self.user.qq;
            break;
        case EditInfoCellTypeEmail:
            [cell setType:EditInfoCellTypeEmail];
            cell.field.text = self.user.email;
            break;
        case EditInfoCellTypeWeibo:
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
    self.scrollView.contentInset = UIEdgeInsetsMake(-self.infoTableView.tableHeaderView.frame.size.height, 0, 200, 0);
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
    self.infoList = [NSArray arrayWithObjects:self.editableList, nil];
    [self.infoTableView reloadData];
}

- (IBAction)confirmEditClicked:(id)sender
{
    self.navigationItem.leftBarButtonItem = tempLeftBarItem;
    self.navigationItem.rightBarButtonItem = nil;
    [self.editButton setHidden:NO];
    _isEditEnable = NO;
    self.infoList = nil;
    _isKeyBoardAppear = NO;
    [UIView animateWithDuration:.3 animations:^{self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);} completion:^(BOOL isFinished)
     {
         if (isFinished) _isKeyBoardAppear = NO;
     }];
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
    self.infoList = nil;
    _isKeyBoardAppear = NO;
    [UIView animateWithDuration:.3 animations:^{self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);} completion:^(BOOL isFinished)
     {
         if (isFinished) _isKeyBoardAppear = NO;
     }];
    [self.infoTableView reloadData];
}


@end
