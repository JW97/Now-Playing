//
//  NPScrollView.m
//  NowPlayingClasses
//
//  Created by Jack Willis on 23/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NPScrollView.h"

@implementation NPScrollView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {        
        hasBeenTouched = NO;
        
        self.contentSize = CGSizeMake(self.frame.size.width * 2, self.frame.size.height);
        //self.contentOffset = CGPointMake(self.frame.size.width, 0);
        self.userInteractionEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        
        NSNumber *defaultPage = [[WidgetHelper sharedHelper] preferenceObjectForKey:@"defaultPage"];
        defaultPageInt = [defaultPage intValue];
        
        if (defaultPageInt == 0)
        {
            self.contentOffset = CGPointMake(self.frame.size.width, 0);
        }
        else if (defaultPageInt == 1)
        {
            self.contentOffset = CGPointMake(0, 0);
        }
        
        controlsPage = [[NPControlsPage alloc] initWithFrame:self.frame];
        [self addSubview:controlsPage];
        
        infoPage = [[NPInfoPage alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:infoPage];
    }
    return self;
}

- (void)layoutSubviews
{
    controlsPage.frame = self.frame;
    infoPage.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    self.contentSize = CGSizeMake(self.frame.size.width * 2, self.frame.size.height);
    if (hasBeenTouched == NO)
    {
        hasBeenTouched = YES;
        
        if (defaultPageInt == 0)
        {
            self.contentOffset = CGPointMake(self.frame.size.width, 0);
        }
        else if (defaultPageInt == 1)
        {
            self.contentOffset = CGPointMake(0, 0);
        }
    }
}


- (void)dealloc
{
    [controlsPage release];
    controlsPage = nil;
    [infoPage release];
    infoPage = nil;
    
    [super dealloc];
}

@end
