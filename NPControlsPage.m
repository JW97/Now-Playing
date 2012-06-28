//
//  NPControlsPage.m
//  NowPlayingClasses
//
//  Created by Jack Willis on 23/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NPControlsPage.h"

@implementation NPControlsPage

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        mediaController = [objc_getClass("SBMediaController") sharedInstance];
        widgetHelper = [WidgetHelper sharedHelper];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingInfoChanged) name:@"SBMediaNowPlayingChangedNotification" object:mediaController];
                
        bgView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, frame.size.width - 4, frame.size.height)];
        bgView.image = [widgetHelper stretchableImage];
        [self addSubview:bgView];
        
        [bgView setUserInteractionEnabled:YES];
        
        faderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        faderView.userInteractionEnabled = YES;
        
        //Buttons
        prevBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];            
        
        prevBtn.frame = CGRectMake(floorf(self.frame.size.width / 2.0f - 22.5f - (self.frame.size.width / 320.0f * 20.0f) - 45.0f), floorf(self.frame.size.height / 2.0f - 21.5f), 45.0f, 45.0f);
        [prevBtn setImage:[widgetHelper springBoardImageNamed:@"MCPrev.png"] forState:UIControlStateNormal];
        [prevBtn setImage:[widgetHelper springBoardImageNamed:@"MCPrev_p.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
        UITapGestureRecognizer *prevTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(prevPressed)];
        [prevBtn addGestureRecognizer:prevTap];
        [prevTap release];
        
        playBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];            
        
        playBtn.frame = CGRectMake(floorf(self.frame.size.width / 2.0f - 22.5f), floorf(self.frame.size.height / 2.0f - 21.5f), 45.0f, 45.0f);
        [self updatePlayImage];
        UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playPressed)];
        [playBtn addGestureRecognizer:playTap];
        [playTap release];
        
        nextBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];            
        
        nextBtn.frame = CGRectMake(floorf(self.frame.size.width / 2.0f + 22.5f + (self.frame.size.width / 320.0f * 20.0f)), floorf(self.frame.size.height / 2.0f - 21.5f), 45.0f, 45.0f);
        [nextBtn setImage:[widgetHelper springBoardImageNamed:@"MCNext.png"] forState:UIControlStateNormal];
        [nextBtn setImage:[widgetHelper springBoardImageNamed:@"MCNext_p.png"] forState:UIControlStateSelected | UIControlStateHighlighted];    
        UITapGestureRecognizer *nextTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextPressed)];
        [nextBtn addGestureRecognizer:nextTap];
        [nextTap release];
        
        if (self.frame.size.width == 320)
        {
            prevBtn.frame = CGRectMake(floorf(self.frame.size.width / 2.0f - 23.0f - 12.0f - 45.0f), floorf(self.frame.size.height / 2.0f - 21.5f), 45.0f, 45.0f);
            playBtn.frame = CGRectMake(floorf(self.frame.size.width / 2.0f - 22.5f), floorf(self.frame.size.height / 2.0f - 21.5f), 45.0f, 45.0f);
            nextBtn.frame = CGRectMake(floorf(self.frame.size.width / 2.0f + 23.0f + 12.0f), floorf(self.frame.size.height / 2.0f - 21.5f), 45.0f, 45.0f);
        }
        
        [faderView addSubview:prevBtn];
        [faderView addSubview:playBtn];
        [faderView addSubview:nextBtn];
        
        //Artwork        
        artwork = [[UIImageView alloc] initWithFrame:CGRectMake(6.0f + 2.0f, 6.0f, 59.0f, 59.0f)];
        artwork.contentMode = UIViewContentModeScaleAspectFit;
        
        NSData *imageData = [[mediaController _nowPlayingInfo] objectForKey:@"artworkData"];
        if (imageData)
        {
            UIImage *art = [[UIImage alloc] initWithData:imageData];
            artwork.image = art;
            [art release];
            
            [faderView addSubview:artwork];
        }
        
        //Social buttons
        ALApplicationList *list = [ALApplicationList sharedApplicationList];
        
        fbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [fbBtn setBackgroundImage:[list iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:@"com.facebook.Facebook"] forState:UIControlStateNormal];
        fbBtn.frame = CGRectMake(self.frame.size.width - 2.0f - 5.0f - 30.0f, 5.0f, 30.0f, 30.0f);
        UITapGestureRecognizer *fbTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fbBtnPressed)];
        [fbBtn addGestureRecognizer:fbTap];
        [fbTap release];
        
        twBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [twBtn setBackgroundImage:[list iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:@"com.atebits.Tweetie2"] forState:UIControlStateNormal];
        twBtn.frame = CGRectMake(self.frame.size.width - 2.0f - 6.0f - 60.0f, 6.0f + 30.0f, 30.0f, 30.0f);
        UITapGestureRecognizer *twTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twBtnPressed)];
        [twBtn addGestureRecognizer:twTap];
        [twTap release];
        
        [faderView addSubview:fbBtn];
        [faderView addSubview:twBtn];
        
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
    //Background view    
    [bgView setFrame:CGRectMake(2, 0, self.frame.size.width - 4, self.frame.size.height)];
    
    [faderView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    //Control buttons
    prevBtn.frame = CGRectMake(floorf(self.frame.size.width / 2.0f - 22.5f - (self.frame.size.width / 320.0f * 20.0f) - 45.0f), floorf(self.frame.size.height / 2.0f - 21.5f), 45.0f, 45.0f);
    playBtn.frame = CGRectMake(floorf(self.frame.size.width / 2.0f - 22.5f), floorf(self.frame.size.height / 2.0f - 21.5f), 45.0f, 45.0f);
    nextBtn.frame = CGRectMake(floorf(self.frame.size.width / 2.0f + 22.5f + (self.frame.size.width / 320.0f * 20.0f)), floorf(self.frame.size.height / 2.0f - 21.5f), 45.0f, 45.0f);
    
    if (self.frame.size.width == 320)
    {
        prevBtn.frame = CGRectMake(floorf(self.frame.size.width / 2.0f - 23.0f - 12.0f - 45.0f), floorf(self.frame.size.height / 2.0f - 21.5f), 45.0f, 45.0f);
        playBtn.frame = CGRectMake(floorf(self.frame.size.width / 2.0f - 22.5f), floorf(self.frame.size.height / 2.0f - 21.5f), 45.0f, 45.0f);
        nextBtn.frame = CGRectMake(floorf(self.frame.size.width / 2.0f + 23.0f + 12.0f), floorf(self.frame.size.height / 2.0f - 21.5f), 45.0f, 45.0f);
    }
    
    fbBtn.frame = CGRectMake(self.frame.size.width - 2.0f - 5.0f - 30.0f, 5.0f, 30.0f, 30.0f);
    twBtn.frame = CGRectMake(self.frame.size.width - 2.0f - 6.0f - 60.0f, 6.0f + 30.0f, 30.0f, 30.0f);
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
    [self updatePlayImage];
    
    [artwork removeFromSuperview];
    NSData *imageData = [[mediaController _nowPlayingInfo] objectForKey:@"artworkData"];
    if (imageData)
    {
        UIImage *art = [[UIImage alloc] initWithData:imageData];
        artwork.image = art;
        [art release];
        
        [self addSubview:artwork];
    }
}

- (void)updatePlayImage
{
    if ([mediaController isPlaying])
    {
        [playBtn setImage:[widgetHelper springBoardImageNamed:@"MCPause.png"] forState:UIControlStateNormal];
        [playBtn setImage:[widgetHelper springBoardImageNamed:@"MCPause_p.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    }
    else
    {
        [playBtn setImage:[widgetHelper springBoardImageNamed:@"MCPlay.png"] forState:UIControlStateNormal];
        [playBtn setImage:[widgetHelper springBoardImageNamed:@"MCPlay_p.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    }
}

- (void)prevPressed
{
    [mediaController changeTrack:-1];
}

- (void)playPressed
{
    [mediaController togglePlayPause];
    [self updatePlayImage];
}

- (void)nextPressed
{
    [mediaController changeTrack:1];
}

- (void)fbBtnPressed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook coming soon" message:@"When an iOS 6 Jailbreak is released, Facebook integration will be added." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)twBtnPressed
{
    [self sendTweetWithArt:YES];
}

- (void)sendTweetWithArt:(BOOL)sendArt
{
    if ([mediaController nowPlayingTitle])
    {
        int remainingCharacters = 140;
        
        if (sendArt == YES)
        {
            remainingCharacters = remainingCharacters - 20;
        }
        
        NSString *start;
        
        if ([mediaController isMovie])
        {
            start = @"#NowWatching ";
        }
        else
        {
            start = @"#NowPlaying ";
        }
        
        NSString *end = @". Sent from Now Playing by @J_W97. ";
        float endLength = [end length];
        
        NSString *message;
        
        message = [NSString stringWithFormat:@"%@", start];
        
        if ([[mediaController nowPlayingTitle] length] <= remainingCharacters)
        {
            message = [NSString stringWithFormat:@"%@%@", message, [mediaController nowPlayingTitle]];
            remainingCharacters = remainingCharacters - [[mediaController nowPlayingTitle] length];
        }
        
        if ([mediaController nowPlayingArtist] && [[mediaController nowPlayingArtist] length] + endLength <= remainingCharacters)
        {
            message = [NSString stringWithFormat:@"%@ by %@", message, [mediaController nowPlayingArtist]];
            remainingCharacters = remainingCharacters - [[mediaController nowPlayingArtist] length];
        }
        
        message = [NSString stringWithFormat:@"%@%@", message, end];
        
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        
        [tweetSheet setInitialText:message];
        
        if (sendArt == YES)
        {
            NSData *imageData = [[mediaController _nowPlayingInfo] objectForKey:@"artworkData"];
            
            if (imageData)
            {
                [tweetSheet addImage:[UIImage imageWithData:imageData]];
            }
        }
        
        viewController = [[UIViewController alloc] init];
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {            
            window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [window setAutorotates:YES];
        }
        else
        {
            window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        }
        
        window.rootViewController = viewController;  
        window.windowLevel = UIWindowLevelAlert;
        
        [window makeKeyAndVisible];
        
        [viewController presentModalViewController:tweetSheet animated:YES];
        
        tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result)
        {
            [viewController dismissModalViewControllerAnimated:YES];
            [tweetSheet release];
            
            [window release];
            [viewController release];
        };        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to send Tweet" message:@"As nothing is playing, you can't send a tweet." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SBMediaNowPlayingChangedNotification" object:mediaController];
    
    [bgView release];
    bgView = nil;
    
    [faderView release];
    faderView = nil;
    
    [prevBtn release];
    prevBtn = nil;
    [playBtn release];
    playBtn = nil;
    [nextBtn release];
    nextBtn = nil;
    
    [artwork release];
    artwork = nil;
    
    //[window release];
    //window = nil;
    //[viewController release];
    //viewController = nil;
    
    [super dealloc];
}

@end
