//
//  WidgetHelper.h
//  NowPlayingClasses
//
//  Created by Jack Willis on 23/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage2.h>

@interface WidgetHelper : NSObject
{
    NSBundle *springBoard;
    
    UIImage *_stretchableBgImg;
}
@property (nonatomic, retain) UIImage *stretchableBgImg;

+ (WidgetHelper *)sharedHelper;
- (UIImage *)stretchableImage;
- (UIImage *)springBoardImageNamed:(NSString *)name;
- (id)preferenceObjectForKey:(NSString *)key;

- (id)init;

@end
