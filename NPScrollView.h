//
//  NPScrollView.h
//  NowPlayingClasses
//
//  Created by Jack Willis on 23/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPControlsPage.h"
#import "NPInfoPage.h"
#import "WidgetHelper.h"

@interface NPScrollView : UIScrollView
{   
    NPControlsPage *controlsPage;
    NPInfoPage *infoPage;
    
    int defaultPageInt;
    
    BOOL hasBeenTouched;
}

@end
