//
//  WidgetHelper.m
//  NowPlayingClasses
//
//  Created by Jack Willis on 23/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WidgetHelper.h"

static WidgetHelper *sharedWidgetHelper;
static NSDictionary *preferences;

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{    
    NSString *path = @"/var/mobile/Library/Preferences/com.jw97.NowPlaying.plist";
    
    [preferences release];
    preferences = [[NSDictionary alloc] initWithContentsOfFile:path];
}

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
    if (!preferences)
    {        
        NSString *path = @"/var/mobile/Library/Preferences/com.jw97.NowPlaying.plist";
        
        preferences = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    
    id obj = [preferences objectForKey:key];
    NSLog(@"%@", obj);
    
    return obj;
}

- (id)init
{
    if ((self = [super init]))
    {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PreferencesChangedCallback, CFSTR("com.jw97.NowPlaying.settingsChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    }
    return self;
}

- (void) dealloc
{    
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, CFSTR("com.jw97.NowPlaying.settingsChanged"), NULL);
    
    [_stretchableBgImg release];
    _stretchableBgImg = nil;
    
    [springBoard release];
    springBoard = nil;
    
    [preferences release];
    preferences = nil;
    
    [super dealloc];
}

@end
