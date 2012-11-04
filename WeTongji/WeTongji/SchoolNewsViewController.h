//
//  SchoolNewsViewController.h
//  WeTongji
//
//  Created by Ziqi on 12-10-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolNewsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *upperHiddenView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *seeNumber;
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeNumber;
@property (weak, nonatomic) IBOutlet UILabel *favoriteNumber;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIView *moveFavorView;
@property (weak, nonatomic) IBOutlet UIView *moveLikeView;

- (IBAction)goBack:(id)sender;
@end
