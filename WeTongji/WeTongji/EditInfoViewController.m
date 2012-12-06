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
#import "UIBarButtonItem+CustomButton.h"
#import "EditAvatarViewController.h"
#import "MBProgressHUD.h"

@interface EditInfoViewController ()<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,EditAvatarViewControllerDelegate,MBProgressHUDDelegate>
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
@property (nonatomic,strong) MBProgressHUD * progress;
- (void)configureTableView;
- (void)configureNavBar;
@end

@implementation EditInfoViewController
@synthesize infoTableView;
@synthesize user = _user;

#pragma mark - Setter & Getter

-(MBProgressHUD *) progress
{
    if ( !_progress )
    {
        _progress = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progress];
        _progress.delegate = self;
    }
    return _progress;
}

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

- (void)configureNavBar
{
    //self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:@"edit_btn" selector:@selector(editClcked:) target:self];
}

#pragma mark - Life Cyclc
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    [self configureNavBar];
    if ( self.user )
    {
        [self.headerView.avatar setImageWithURL:[NSURL URLWithString: self.user.avatarLink]];
        self.headerView.nameLabel.text = self.user.displayname;
        if ( [self.user.gender isEqualToString:@"男"] )
        {
            [self.headerView.sex setImage:[UIImage imageNamed:@"male"]];
        }
        else
            [self.headerView.sex setImage:[UIImage imageNamed:@"female"]];
        self.headerView.ageLabel.text = [self.user.age stringValue];
    }
    //self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidUnload
{
    [self setInfoTableView:nil];
    [self setConfirmEditBarButton:nil];
    [self setEditButton:nil];
    [self setScrollView:nil];
    [self setHeaderView:nil];
    [self setAvatar:nil];
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
    self.infoList = [NSArray arrayWithObjects:self.editableList, nil];
    [self.infoTableView reloadData];
}

- (IBAction)confirmEditClicked:(id)sender
{
    self.navigationItem.leftBarButtonItem = tempLeftBarItem;
    self.navigationItem.rightBarButtonItem = nil;
    [self configureNavBar];
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
        cell = ( EditInfoCell *)[self.infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
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
    self.progress.labelText  = @"更新资料中...";
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) 
    {
        [User updateUser:[responseData objectForKey:@"User"] inManagedObjectContext:self.managedObjectContext];
        [self.infoTableView reloadData];
        self.progress.mode = MBProgressHUDModeText;
        self.progress.labelText = @"更新完成";
        [self.progress hide:YES afterDelay:1];
    #ifdef DEBUG
        NSLog(@"%@",responseData);
    #endif
    }
    failureBlock:^(NSError * error)
    {
        self.progress.mode = MBProgressHUDModeText;
        self.progress.labelText = @"更新失败";
        self.progress.square = YES;
        self.progress.detailsLabelText = [[error userInfo] objectForKey:@"errorDesc"];
        [self.progress hide:YES afterDelay:1];
    }];
    [request updateUserDisplayName:nil email:email weiboName:weiboName phoneNum:phone qqAccount:qq];
    [client enqueueRequest:request];
}

- (IBAction)cancelEditClicked:(id)sender
{
    self.navigationItem.leftBarButtonItem = tempLeftBarItem;
    self.navigationItem.rightBarButtonItem = nil;
     [self configureNavBar];
    _isEditEnable = NO;
    self.infoList = nil;
    _isKeyBoardAppear = NO;
    [UIView animateWithDuration:.3 animations:^{self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);} completion:^(BOOL isFinished)
     {
         if (isFinished) _isKeyBoardAppear = NO;
     }];
    [self.infoTableView reloadData];
}

- (IBAction)didClickAvatarButton:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"相册", @"拍照", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 2)
        return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.allowsEditing = NO;
    
    if(buttonIndex == 0) {
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if(buttonIndex == 1) {
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentModalViewController:ipc animated:YES];
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    EditAvatarViewController *vc = [[EditAvatarViewController alloc] initWithImage:image];
    vc.delegate = self;
    [picker pushViewController:vc animated:YES];
}

- (void)editAvatarViewDidCancelEdit
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)editAvatarViewDidFinishEdit:(UIImage *)image
{
    [self.progress show:YES];
    self.progress.mode = MBProgressHUDModeIndeterminate;
    self.progress.labelText = @"更新头像中...";
    self.avatar.image = image;
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData)
                           {
                            #ifdef DEBUG
                               NSLog(@"%@",responseData);
                            #endif
                               [User updateUser:[responseData objectForKey:@"User"] inManagedObjectContext:self.managedObjectContext];
                               [self.infoTableView reloadData];
                               self.progress.mode = MBProgressHUDModeText;
                               self.progress.labelText = @"更新完成";
                               [self.progress hide:YES afterDelay:1];
                           }
                            failureBlock:^(NSError * error)
                            {
                                self.progress.mode = MBProgressHUDModeText;
                                self.progress.labelText = @"更新失败";
                                self.progress.square = YES;
                                self.progress.detailsLabelText = [[error userInfo] objectForKey:@"errorDesc"];
                                [self.progress hide:YES afterDelay:1];
                            }];
    [request updateUserAvatar:image];
    [client enqueueRequest:request];
    [self dismissModalViewControllerAnimated:YES];
}

-(void) hudWasHidden:(MBProgressHUD *)hud
{
    [self.progress removeFromSuperview];
    self.progress =  nil;
}

@end
