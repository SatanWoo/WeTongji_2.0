//
//  UIApplication+nj_SmartStatusBar.m
//  WeTongji
//
//  Created by Tang Zhixiong on 12-11-26.
//
//

#import "UIApplication+nj_SmartStatusBar.h"

@implementation UIApplication (nj_SmartStatusBar)

-(void)nj_setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation{
    UIWindow *window = [self.windows objectAtIndex:0];
    UIViewController *rootViewController = window.rootViewController;
    UIView *view = rootViewController.view;
    
    // slight optimization to avoid unnecassary calls.
    BOOL isHiddenNow = self.statusBarHidden;
    if (hidden == isHiddenNow) return;
    
    // Hide/Unhide the status bar
    [self setStatusBarHidden:hidden withAnimation:animation];
    
    // Get statusBar's frame
    CGRect statusBarFrame = self.statusBarFrame;
    // Establish a baseline frame.
    CGRect newViewFrame = window.bounds;
    
    // Check if statusBar's frame is worth dodging.
    if (!CGRectEqualToRect(statusBarFrame, CGRectZero)){
        UIInterfaceOrientation currentOrientation = rootViewController.interfaceOrientation;
        if (UIInterfaceOrientationIsPortrait(currentOrientation)){
            // If portrait we need to shrink height
            newViewFrame.size.height -= statusBarFrame.size.height;
            if (currentOrientation == UIInterfaceOrientationPortrait){
                // If not upside-down move down the origin.
                newViewFrame.origin.y += statusBarFrame.size.height;
            }
        } else { // Is landscape / Slightly trickier.
            // For portrait we shink width (for status bar on side of window)
            newViewFrame.size.width -= statusBarFrame.size.width;
            if (currentOrientation == UIInterfaceOrientationLandscapeLeft){
                // If the status bar is on the left side of the window we move the origin over.
                newViewFrame.origin.x += statusBarFrame.size.width;
            }
        }
    }
    // Animate... Play with duration later...
    [UIView animateWithDuration:0.35 animations:^{
        view.frame = newViewFrame;
    }];
}

@end
