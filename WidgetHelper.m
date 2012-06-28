//
//  WidgetHelper.m
//  NowPlayingClasses
//
//  Created by Jack Willis on 23/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WidgetHelper.h"

static WidgetHelper *sharedWidgetHelper;

@implementation WidgetHelper

@synthesize stretchableBgImg = _stretchableBgImg;

+ (WidgetHelper *)sharedHelper
{
    if (!sharedWidgetHelper)
    {
        sharedWidgetHelper = [[WidgetHelper alloc] init];
    }
    
    return sharedWidgetHelper;
}

- (UIImage *)stretchableImage;
{
    if (!_stretchableBgImg)
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        UIImage *bgImg = [UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/NowPlaying.bundle/WeeAppBackground.png"];
        _stretchableBgImg = [[bgImg stretchableImageWithLeftCapWidth:floorf(bgImg.size.width / 2.f) topCapHeight:floorf(bgImg.size.height / 2.f)] retain];
        [pool drain];
    }
    
    return _stretchableBgImg;
}

- (UIImage *)springBoardImageNamed:(NSString *)name
{
    if (!springBoard)
    {
        springBoard = [[NSBundle alloc] initWithPath:@"/System/Library/CoreServices/SpringBoard.app"];
    }
    
    return [UIImage imageNamed:name inBundle:springBoard];
}

- (UIImage *)ownImageNamed:(NSString *)name
{
    if (!ownBundle)
    {
        ownBundle = [[NSBundle alloc] initWithPath:@"/System/Library/WeeAppPlugins/NowPlaying.bundle"];
    }
    
    return [UIImage imageNamed:name inBundle:ownBundle];
}

- (id)preferenceObjectForKey:(NSString *)key
{
    NSString *path = @"/var/mobile/Library/Preferences/com.jw97.NowPlaying.plist";
    
    id obj = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:key];
    
    return obj;
}

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

- (void) dealloc
{
    [_stretchableBgImg release];
    _stretchableBgImg = nil;
    
    [springBoard release];
    springBoard = nil;
    
    [super dealloc];
}

@end
