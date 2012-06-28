//
//  NPControlsPage.h
//  NowPlayingClasses
//
//  Created by Jack Willis on 23/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIWindow2.h>
#import <Twitter/Twitter.h>
#import <SpringBoard/SBMediaController.h>
#import <libapplist/ALApplicationList.h>
#import "WidgetHelper.h"

@interface NPControlsPage : UIView
{
    SBMediaController *mediaController;
    
    UIImageView *bgView;
    WidgetHelper *widgetHelper;
    
    UIView *faderView;
    
    UIImageView *artwork;
    
    UIButton *prevBtn;
    UIButton *playBtn;
    UIButton *nextBtn;
    
    UIButton *twBtn;
    UIButton *fbBtn;
    
    UIViewController *viewController;
    UIWindow *window;
}

- (void)setShowsBackground:(BOOL)should;

- (void)nowPlayingInfoChanged;

- (void)updatePlayImage;

- (void)prevPressed;
- (void)playPressed;
- (void)nextPressed;

- (void)fbBtnPressed;
- (void)twBtnPressed;

- (void)sendTweetWithArt:(BOOL)sendArt;

@end
