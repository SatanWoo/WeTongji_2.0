//
//  WUTableHeaderView.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-11-4.
//
//

#import "WUTableHeaderView.h"

@interface WUTableHeaderView()
{
    BOOL _isButtonBoardLeft;
}
@property (weak, nonatomic) IBOutlet UIView *buttonBoard;

@end

@implementation WUTableHeaderView
@synthesize upperHiddenView;
@synthesize titleLabel;
@synthesize sourceLabel;
@synthesize seeNumber;
@synthesize releaseTimeLabel;
@synthesize likeNumber;
@synthesize favoriteNumber;
@synthesize likeButton;
@synthesize favoriteButton;
@synthesize moveFavorView;
@synthesize moveLikeView;
@synthesize buttonBoard;

-(void) changeButtonPositionToLeft
{
    if ( _isButtonBoardLeft ) return;
    CGPoint center = [self.buttonBoard center];
    center.x = center.x + 54;
    [self.buttonBoard setCenter:center];
    _isButtonBoardLeft = YES;
}

-(void) resetButtonPosition
{
    if ( !_isButtonBoardLeft ) return;
    CGPoint center = [self.buttonBoard center];
    center.x = center.x - 54;
    [self.buttonBoard setCenter:center];
    _isButtonBoardLeft = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


@end
