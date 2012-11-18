//
//  RegisterViewController.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-13.
//
//

#import "RegisterViewController.h"
#import "RegInfomationCell.h"
#import "Macro.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *regTabelVIew;

@end

@implementation RegisterViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.regTabelVIew.contentInset =  UIEdgeInsetsMake(60, 0.0f, 0.0f, 0.0f);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) return 4;
    if ( section == 1 ) return 1;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:kRegInformationCell];
            if (cell == nil)
            {
                cell = [[RegInfomationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRegInformationCell];
                
            }
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:kRegButtonCell];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRegButtonCell];
                
            }
            break;
        default:
            break;
    }

    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setRegTabelVIew:nil];
    [super viewDidUnload];
}
@end
