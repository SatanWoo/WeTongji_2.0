#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class KenBurnsView;

#pragma - KenBurnsViewDelegate
@protocol KenBurnsViewDelegate <NSObject>
@optional
- (void)didShowImageAtIndex:(NSUInteger)index;
- (void)didFinishAllAnimations;
@end

@interface KenBurnsView : UIView {
    NSMutableArray *imagesArray;
    float timeTransition;
    BOOL isLoop;
    BOOL isLandscape;
    __weak id <KenBurnsViewDelegate> delegate;
}

@property (nonatomic, assign) float timeTransition;
@property (nonatomic, retain) NSMutableArray *imagesArray;
@property (nonatomic) BOOL isLoop;
@property (nonatomic) BOOL isLandscape;
@property (weak) id<KenBurnsViewDelegate> delegate;

- (void) animateWithImages:(NSArray *)images transitionDuration:(float)time loop:(BOOL)isLoop isLandscape:(BOOL)isLandscape;
- (void) animateWithURLs:(NSArray *)urls transitionDuration:(float)duration loop:(BOOL)shouldLoop isLandscape:(BOOL)inLandscape;

@end


