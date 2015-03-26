//
//  BulletLabel.m
//  BulletPlayer
//
//  Created by wenxiaopei on 14-9-7.
//  Copyright (c) 2014年 wenxiaopei. All rights reserved.
//

#import "BulletLabel.h"
#import "BulletComment.h"
//#import "VideoPlayerView.h"

@interface BulletLabel(Private)
-(void)setupView;
-(void)animateCurrentTickerString;
-(void)pauseLayer:(CALayer *)layer;
-(void)resumeLayer:(CALayer *)layer;
@end

@implementation BulletLabel
{
	// The ticker speed
	float _tickerSpeed;
	
	// The current state of the ticker
	BOOL _running;
	
	// The ticker font
	UIFont *_tickerFont;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setupView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	if( (self = [super initWithCoder:aDecoder]) )
    {
		// Initialization code
		[self setupView];
	}
	return self;
}


-(void)setupView {
	// Set background color to white
	[self setBackgroundColor:[UIColor clearColor]];
	// Set a corner radius
    _tickerFont = [UIFont systemFontOfSize:12];
	// Add the label (i'm gonna center it on the view - please feel free to do your own thing)
	[self setNumberOfLines:1];
    self.textColor = _bulletComment.textColor;
    self.durationTime = 6.0f;
}

#pragma mark - Ticker Animation Handling
-(void)startMoveWithCompletion:(void (^)(void))_countBlock
{
	// Set running
	_running = YES;
	// Start the animation
    // Setup some starting and end points
    float endX = - CGRectGetWidth(self.frame)*1.5;
    
	// Calculate a uniform duration for the item
	float duration = (self.frame.origin.x+self.frame.size.width) / _tickerSpeed;
	
	// Create a UIView animation
    [UIView animateWithDuration:_durationTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        // Update end position
        CGRect frame = self.frame;
        frame.origin.x = endX;
        self.frame = frame;
    } completion:^(BOOL finished) {
        //VideoPlayerView *videoPlayerView = (VideoPlayerView *)self.superview.superview;
        //[videoPlayerView.reusedBulletViews addObject:self];
        self.hidden = YES;
        _countBlock();
    }];
}

-(void)startFadeWithCompletion:(void (^)(void))_countBlock
{
    // Set running
	_running = YES;
	
	// Create a UIView animation
    [UIView animateWithDuration:0 delay:_durationTime options:UIViewAnimationOptionCurveEaseOut animations:^{
        // Update end alpha
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        //VideoPlayerView *videoPlayerView = (VideoPlayerView *)self.superview.superview;
        //[videoPlayerView.reusedBulletViews addObject:self];
        _countBlock();
    }];
}

- (void)setBulletComment:(BulletComment *)bulletComment
{
    _bulletComment = bulletComment;
    self.text = _bulletComment.bulletString;
    //self.text = @"暴走漫画测试弹幕";
    int fontSize = 14;
    if (((int)bulletComment.fontSize)<=20)
    {
        fontSize = 14;
    }
    else
    {
        fontSize = 18;
    }
    [self setFont:[UIFont systemFontOfSize:18]];
    [self sizeToFit];
    
    if (bulletComment.isDispBorder)
    {
        //显示边框
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [bulletComment.textColor CGColor];
    }
    else
    {
        //显示边框
        self.layer.borderWidth = 0;
        self.layer.borderColor = [[UIColor clearColor]CGColor];
    }
}

-(void)pause
{
	// Check if running
	if(_running)
    {
		// Pause the layer
		[self pauseLayer:self.layer];
		_running = NO;
	}
}

-(void)resume
{
	// Check not running
	if(!_running)
    {
		// Resume the layer
		[self resumeLayer:self.layer];
		_running = YES;
	}
}

#pragma mark - UIView layer animations utilities
-(void)pauseLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

@end
