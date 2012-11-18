//
//  ProtocolViewController.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-11-18.
//
//

#import "ProtocolViewController.h"

@interface ProtocolViewController ()
- (void)refreshScrollView;
- (void)loadProtocol;
@end

@implementation ProtocolViewController

- (void)loadProtocol
{
    self.protocolLabel.text = @"1.本应用使用同济大学电子邮件系统进行实名认证。用户须使用自己的@tongji.edu.cn电子邮箱进行WeTongji账号激活操作。尚未注册邮箱的用户须访问mail.tongji.edu.cn先行完成邮箱的注册操作。本应用不对因同济大学电子邮件系统故障造成的影响负责。\n\n2.用户不得冒充他人登录，不得冒用他人的名义发布信息，不得使用本应用侵犯他人的利益、损害他人的名誉。微同济校园信息服务小组有权清除存在上述侵权行为的用户。\n\n3.本应用重视对用户个人隐私的保护。除法律或有法律赋予权限的部门要求或事先得到用户明确授权的情况外，本应用保证不对外公开或向第三方泄漏用户个人隐私信息及用户在使用本应用过程中产生的数据。\n\n4.本应用不保证所提供服务内容的及时性、安全性、准确性，也不对因提供的服务内容的谬误造成的影响负责。\n\n5.微同济校园信息服务小组对本协议的条款具有修改权和变更权，并有义务在协议内容发生变更时向用户提示。如不同意对本协议相关条款的修改，用户有权并应当停止使用本应用。\n\n6.微同济校园信息服务小组对本应用产生的统计信息具有所有权和使用权，并承诺在同济大学学生处的监督管理下通过正确的途径使用这些信息。";
    [self.protocolLabel sizeToFit];
    [self refreshScrollView];
}

- (void)refreshScrollView
{
    self.protocolLabel.frame = CGRectMake(self.protocolLabel.frame.origin.x, 10, self.protocolLabel.frame.size.width, self.protocolLabel.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.protocolLabel.frame.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadProtocol];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setProtocolLabel:nil];
    [super viewDidUnload];
}
@end
