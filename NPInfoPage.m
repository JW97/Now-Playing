//
//  NPInfoPage.m
//  NowPlayingClasses
//
//  Created by Jack Willis on 23/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NPInfoPage.h"

@implementation NPInfoPage

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        mediaController = [objc_getClass("SBMediaController") sharedInstance];
        widgetHelper = [WidgetHelper sharedHelper];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                           
        bgView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, frame.size.width - 4, frame.size.height)];
        bgView.image = [widgetHelper stretchableImage];
        [self addSubview:bgView];
        
        UITapGestureRecognizer *selfTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wasTapped)];    
        [self addGestureRecognizer:selfTap];
        [selfTap release];
        
        faderView = [[UIView alloc] initWithFrame:CGRectMake(2, 0, bgView.frame.size.width, bgView.frame.size.height)];
        faderView.userInteractionEnabled = YES;
        
        artwork = [[UIImageView alloc] initWithFrame:CGRectMake(6.0f, 6.0f, 59.0f, 59.0f)];
        artwork.contentMode = UIViewContentModeScaleAspectFit;
        
        NSData *imageData = [[mediaController _nowPlayingInfo] objectForKey:@"artworkData"];        
        if (!imageData)
        {    
            trackLabel = [self addLabel:[mediaController nowPlayingTitle] size:CGRectMake(3.0f, 1.0f, bgView.frame.size.width - 6.0f, 20.0f)];
            artistLabel = [self addLabel:[mediaController nowPlayingArtist] size:CGRectMake(3.0f, 25.0f, bgView.frame.size.width - 6.0f, 20.0f)];
            albumLabel = [self addLabel:[mediaController nowPlayingAlbum] size:CGRectMake(3.0f, 49.0f, bgView.frame.size.width - 6.0f, 20.0f)];
        }
        else
        {
            trackLabel = [self addLabel:[mediaController nowPlayingTitle] size:CGRectMake(3.0 + 59.0f + 6.0f, 1.0f, bgView.frame.size.width - (6.0f + 59.0f + 6.0f), 20.0f)];
            artistLabel = [self addLabel:[mediaController nowPlayingArtist] size:CGRectMake(3.0f + 59.0f + 6.0f, 25.0f, bgView.frame.size.width - (6.0f + 59.0f + 6.0f), 20.0f)];
            albumLabel = [self addLabel:[mediaController nowPlayingAlbum] size:CGRectMake(3.0 + 59.0f + 6.0f, 49.0f, bgView.frame.size.width - (6.0f + 59.0f + 6.0f), 20.0f)];
            
            UIImage *art = [[UIImage alloc] initWithData:imageData];
            artwork.image = art;
            
            [art release];
            
            [faderView addSubview:artwork];
        }
        
        notPlayingLabel = [self addLabel:@"Nothing Playing" size:CGRectMake(2.5f, bgView.frame.size.height / 2.0f - 10.0f, bgView.frame.size.width - 5.0f, 20.0f)];
        
        if ([mediaController nowPlayingTitle])
        {        
            [faderView addSubview:trackLabel];
            [faderView addSubview:artistLabel];
            [faderView addSubview:albumLabel];
        }
        else
        {        
            [faderView addSubview:notPlayingLabel];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingInfoChanged) name:@"SBMediaNowPlayingChangedNotification" object:mediaController];
        
        faderView.alpha = 0.0f;
        [self insertSubview:faderView atIndex:1];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        faderView.alpha = 1.0f;
        [UIView commitAnimations];
                           
        [pool drain];
    }
    return self;
}

- (void)layoutSubviews
{
    [bgView setFrame:CGRectMake(2, 0, self.frame.size.width - 4, self.frame.size.height)];
    [faderView setFrame:CGRectMake(2, 0, self.frame.size.width - 4, self.frame.size.height)];
    
    [notPlayingLabel removeFromSuperview];
    [trackLabel removeFromSuperview];
    [artistLabel removeFromSuperview];
    [albumLabel removeFromSuperview];
    
    notPlayingLabel = [self addLabel:@"Nothing Playing" size:CGRectMake(2.5f, bgView.frame.size.height / 2.0f - 10.0f, bgView.frame.size.width - 5.0f, 20.0f)];
    
    if ([mediaController nowPlayingTitle])
    {
        NSData *imageData = [[mediaController _nowPlayingInfo] objectForKey:@"artworkData"];    
        if (!imageData)
        {                    
            trackLabel = [self addLabel:[mediaController nowPlayingTitle] size:CGRectMake(3.0f, 1.0f, bgView.frame.size.width - 6.0f, 20.0f)];
            artistLabel = [self addLabel:[mediaController nowPlayingArtist] size:CGRectMake(3.0f, 25.0f, bgView.frame.size.width - 6.0f, 20.0f)];
            albumLabel = [self addLabel:[mediaController nowPlayingAlbum] size:CGRectMake(3.0f, 49.0f, bgView.frame.size.width - 6.0f, 20.0f)];
            
            [faderView addSubview:trackLabel];
            [faderView addSubview:artistLabel];
            [faderView addSubview:albumLabel];
        }
        else
        {                    
            trackLabel = [self addLabel:[mediaController nowPlayingTitle] size:CGRectMake(3.0 + 59.0f + 6.0f, 1.0f, bgView.frame.size.width - (6.0f + 59.0f + 6.0f), 20.0f)];
            artistLabel = [self addLabel:[mediaController nowPlayingArtist] size:CGRectMake(3.0f + 59.0f + 6.0f, 25.0f, bgView.frame.size.width - (6.0f + 59.0f + 6.0f), 20.0f)];
            albumLabel = [self addLabel:[mediaController nowPlayingAlbum] size:CGRectMake(3.0 + 59.0f + 6.0f, 49.0f, bgView.frame.size.width - (6.0f + 59.0f + 6.0f), 20.0f)];
            
            [faderView addSubview:trackLabel];
            [faderView addSubview:artistLabel];
            [faderView addSubview:albumLabel];
            
            //UIImage *art= [[UIImage alloc] initWithData:imageData];
            //artwork.image = art;
            
            //[art release];
            
            //[faderView addSubview:infoPageArtwork];
        }
    }
    else
    {
        [faderView addSubview:notPlayingLabel];
    }   
}

- (void)setShowsBackground:(BOOL)should
{
    if(should == NO)
    {
        [bgView removeFromSuperview];
    }
    else
    {
        [bgView removeFromSuperview];
        [self addSubview:bgView];
    }
}

- (void)nowPlayingInfoChanged
{
    [notPlayingLabel removeFromSuperview];
    
    [artwork removeFromSuperview];
    
    [trackLabel removeFromSuperview];
    [artistLabel removeFromSuperview];
    [albumLabel removeFromSuperview];
    
    if ([mediaController nowPlayingTitle])
    {
        NSData *imageData = [[mediaController _nowPlayingInfo] objectForKey:@"artworkData"];
        
        if (!imageData)
        {                    
            trackLabel = [self addLabel:[mediaController nowPlayingTitle] size:CGRectMake(3.0f, 1.0f, bgView.frame.size.width - 6.0f, 20.0f)];
            artistLabel = [self addLabel:[mediaController nowPlayingArtist] size:CGRectMake(3.0f, 25.0f, bgView.frame.size.width - 6.0f, 20.0f)];
            albumLabel = [self addLabel:[mediaController nowPlayingAlbum] size:CGRectMake(3.0f, 49.0f, bgView.frame.size.width - 6.0f, 20.0f)];
        }
        else
        {                    
            trackLabel = [self addLabel:[mediaController nowPlayingTitle] size:CGRectMake(3.0 + 59.0f + 6.0f, 1.0f, bgView.frame.size.width - (6.0f + 59.0f + 6.0f), 20.0f)];
            artistLabel = [self addLabel:[mediaController nowPlayingArtist] size:CGRectMake(3.0f + 59.0f + 6.0f, 25.0f, bgView.frame.size.width - (6.0f + 59.0f + 6.0f), 20.0f)];
            albumLabel = [self addLabel:[mediaController nowPlayingAlbum] size:CGRectMake(3.0 + 59.0f + 6.0f, 49.0f, bgView.frame.size.width - (6.0f + 59.0f + 6.0f), 20.0f)];
            
            UIImage *art= [[UIImage alloc] initWithData:imageData];
            artwork.image = art;
            
            [art release];
            
            [faderView addSubview:artwork];
        }
        
        [faderView addSubview:trackLabel];
        [faderView addSubview:artistLabel];
        [faderView addSubview:albumLabel];
    }
    else
    {
        [faderView addSubview:notPlayingLabel];
    }
}

- (void)wasTapped
{
    if (![[objc_getClass("SBAwayController") sharedAwayController] isLocked])
    {
        [[objc_getClass("SBUIController") sharedInstance] activateApplicationFromSwitcher:[mediaController nowPlayingApplication]];
    }
}
                           
- (AutoScrollLabel *)addLabel:(NSString *)text size:(CGRect)labelSize
{
    AutoScrollLabel *label = [[AutoScrollLabel alloc] initWithFrame:labelSize];
            
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.scrollEnabled = YES;
            
    [label setText:text];
            
    return label;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SBMediaNowPlayingChangedNotification" object:mediaController];
    
    [bgView release];
    bgView = nil;
    
    [faderView release];
    faderView = nil;
    
    [artwork release];
    artwork = nil;
    
    [trackLabel release];
    trackLabel = nil;
    [artistLabel release];
    artistLabel = nil;
    [albumLabel release];
    albumLabel = nil;
    
    [notPlayingLabel release];
    notPlayingLabel = nil;
    
    [super dealloc];
}

@end
