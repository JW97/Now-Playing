//
//  NPInfoPage.h
//  NowPlayingClasses
//
//  Created by Jack Willis on 23/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIWindow2.h>
#import <SpringBoard/SBMediaController.h>
#import <SpringBoard/SBUIController.h>
#import "WidgetHelper.h"
#import "AutoScrollLabel.h"

@interface NPInfoPage : UIView
{
    SBMediaController *mediaController;
    
    UIImageView *bgView;
    WidgetHelper *widgetHelper;
    
    UIView *faderView;
    
    BOOL updatingLabels;
    
    UIImageView *artwork;
    
    AutoScrollLabel *trackLabel;
    AutoScrollLabel *artistLabel;
    AutoScrollLabel *albumLabel;
    
    AutoScrollLabel *notPlayingLabel;
}

- (void)setShowsBackground:(BOOL)should;

- (void)nowPlayingInfoChanged;
- (void)wasTapped;

- (AutoScrollLabel *)addLabel:(NSString *)text size:(CGRect)labelSize;

@end
