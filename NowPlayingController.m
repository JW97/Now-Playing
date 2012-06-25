#import "BBWeeAppController-Protocol.h"
#import "WidgetHelper.h"
#import "NPScrollView.h"

static NSBundle *_NowPlayingWeeAppBundle = nil;

@interface NowPlayingController: NSObject <BBWeeAppController> {
    
	UIView *_view;
    
    NPScrollView *scrollView;
    
    UIImageView *_placeHolder;
}
@property (nonatomic, retain) UIView *view;

@end

@implementation NowPlayingController
@synthesize view = _view;

+ (void)initialize
{
	_NowPlayingWeeAppBundle = [[NSBundle bundleForClass:[self class]] retain];
}

- (id)init
{
	if((self = [super init]) != nil)
    {
		
	} return self;
}

- (void)loadFullView
{
    scrollView = [[NPScrollView alloc] initWithFrame:_view.frame];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [_placeHolder removeFromSuperview];
    [_placeHolder release];
    _placeHolder = nil;
    
    [_view addSubview:scrollView];
}

- (void)loadPlaceholderView
{
	_view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, [self viewHeight])];
	_view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _view.userInteractionEnabled = YES;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	_placeHolder = [[UIImageView alloc] initWithImage:[[WidgetHelper sharedHelper] stretchableImage]];
    [pool drain];
	_placeHolder.frame = CGRectMake(2.0f, 0.0f, _view.frame.size.width - 4.0f, _view.frame.size.height);
	_placeHolder.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
	[_view addSubview:_placeHolder];
}

- (void)unloadView
{
    [_view release];
	_view = nil;
    
    [scrollView release];
    scrollView = nil;
    
    [_placeHolder release];
    _placeHolder = nil;
    
	// Destroy any additional subviews you added here. Don't waste memory :(.
}

- (void)dealloc
{    
	[_view release];
    
    [scrollView release];
    
    [_placeHolder release];

	[super dealloc];
}

- (float)viewHeight {
	return 71.f;
}

@end
