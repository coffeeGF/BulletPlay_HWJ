//
//  CusPlayerView.m
//  HWJPlayer
//
//  Created by 侯文静 on 15-3-19.
//  Copyright (c) 2015年 侯文静. All rights reserved.
//

#import "CusPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>

#define MoveLengthW 50
#define MoveLengthH 20


@implementation CusPlayerView
{
    float touchX;
    
    float touchY;
    
    CGFloat  totalMovieDuration;
    
    CGFloat  currentDuration;
    
    BOOL     isPlaying;
}

- (void)playWithMoviewUrl:(NSString *)movieUrl{
    
    NSURL* url = [NSURL URLWithString:movieUrl];
    //资源类
    AVURLAsset* asset = [AVURLAsset assetWithURL:url];
    //准备播放
    [asset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
        //得到状态
        AVKeyValueStatus status = [asset statusOfValueForKey:@"tracks" error:nil];
        //判断状态
        if (status == AVKeyValueStatusLoaded) {
            
            
            
            AVPlayerItem* playerItem = [AVPlayerItem playerItemWithAsset:asset];
            self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
            //关联播放器和屏幕
            [self setPlayer:self.player];
            //设置进度  CMTime 帧数 帧率
            
            __block CusPlayerView * blockCusPlayer = self;
            
            [self.player play];

            if([_delegate respondsToSelector:@selector(cusPlayerStatusLoaded)]){
                
                [_delegate cusPlayerStatusLoaded];

            }
            
            CMTime totalTime = playerItem.duration;
            
            totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
            
            //
            //CMTimeMake(1, 1)
            [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.01, NSEC_PER_SEC) queue:dispatch_get_global_queue(0, 0) usingBlock:^(CMTime time) {
                //每隔1s执行一次
                //刷新进度
                //当前时间
                CMTime currentTime = blockCusPlayer.player.currentItem.currentTime;
                //总时间
                CMTime duration = blockCusPlayer.player.currentItem.duration;
                
                if (CMTimeGetSeconds(duration) > 0.0) {
                    //进度
                    float pro = CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (blockCusPlayer.delegate && [blockCusPlayer.delegate respondsToSelector:@selector(cusPlayerViewPlayEverySecondStatusWithCurrentTime:duration:)]) {
                            [blockCusPlayer.delegate cusPlayerViewPlayEverySecondStatusWithCurrentTime:currentTime duration:duration];
                        }
                        
                        //[blockProSlider setValue:pro animated:YES];
                        
                    });
                }
            }];
        }
    }];

}

- (void) retreat
{
    
    //获取当前时间
    CMTime currentTime = self.player.currentItem.currentTime;
    //转成秒数
    currentDuration = (CGFloat)currentTime.value/currentTime.timescale;
    CGFloat newTime = currentDuration - 30;

    if (newTime <= 0.0)
    {
        if (isPlaying == YES)
        {
            [self cusPlayerPlay];
        }
        return;
    }
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(newTime, 1);
    [self.player seekToTime:dragedCMTime completionHandler:
     ^(BOOL finish)
     {
         [self cusPlayerPlay];
     }];
    isPlaying = YES;
}
- (void) speed
{
    //获取当前时间
    CMTime currentTime = self.player.currentItem.currentTime;
    //转成秒数
    currentDuration = (CGFloat)currentTime.value/currentTime.timescale;
    CGFloat newTime = currentDuration + 30;

    if (newTime >= totalMovieDuration)
    {
        if (isPlaying == YES)
        {
            [self cusPlayerPlay];
        }
        return;
    }
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(newTime, 1);
    [self.player seekToTime:dragedCMTime completionHandler:
     ^(BOOL finish)
     {
         [self cusPlayerPlay];
     }];
    isPlaying = YES;
}


#pragma mark AVPlayerLayer层级基本构造
//重写uiview的layerclass方法,返回可以播放视频的层layer
+ (Class)layerClass{
    
    return [AVPlayerLayer class];
    
}
//重写layer变量的set/get方法
- (AVPlayer *)player{
    
    return [(AVPlayerLayer*)[self layer] player];
    
}

- (void)setPlayer:(AVPlayer *)thePlayer{
    
    return [(AVPlayerLayer *)[self layer] setPlayer:thePlayer];
    
}

//触摸屏幕
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    UITouch * touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    touchX = touchPoint.x;
    
    touchY = touchPoint.y;
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesMoved:touches withEvent:event];
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesEnded:touches withEvent:event];
    
    UITouch * touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    if ((touchPoint.x - touchX) >= 50 && (touchPoint.y - touchY) <= 20 && (touchY - touchPoint.y) >= -20) {
        
        [self speed];

        //快进
        if ([_delegate respondsToSelector:@selector(cusPlayerTouchGoFast)]) {
            
            
            [_delegate cusPlayerTouchGoFast];
            
        }
    }
    
    if ((touchPoint.x - touchX) >= 50 && (touchY - touchPoint.y) <= 50 && (touchY - touchPoint.y) >= -50)
    {
        [self speed];
        //快进
        if ([_delegate respondsToSelector:@selector(cusPlayerTouchGoFast)]){
            
            [_delegate cusPlayerTouchGoFast];
            
        }
    }
    if ((touchX - touchPoint.x) >= 50 && (touchPoint.y - touchY) <= 50 && (touchPoint.y - touchY) >= -50)
    {
        //快退"
        [self retreat];
        
        if ([_delegate respondsToSelector:@selector(cusPlayerTouchGoBack)])
        {
            [_delegate cusPlayerTouchGoBack];
        }
        
    }
    if ((touchX - touchPoint.x) >= 50 && (touchY - touchPoint.y) <= 50 && (touchY - touchPoint.y) >= -50)
    {
        //快退
        [self retreat];
        
        if ([_delegate respondsToSelector:@selector(cusPlayerTouchGoBack)])
        {
            [_delegate cusPlayerTouchGoBack];
        }
        
    }
    if ((touchPoint.y - touchY) >= 50 && (touchPoint.x - touchX) <= 50 && (touchPoint.x - touchX) >= -50)
    {
        //减小音量1/10
        MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
        if ((mpc.volume - 0.1) <= 0)
        {
            mpc.volume = 0;
        }
        else
        {
            mpc.volume = mpc.volume - 0.05;
        }
    }
    if ((touchY - touchPoint.y) >= 50)
    {
        //加大音量
        MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
        if ((mpc.volume + 0.1) >= 1)
        {
            mpc.volume = 1;
        }
        else
        {
            mpc.volume = mpc.volume + 0.05;
        }
        
    }
    
}

- (float)cusPlayerCurrentTime{
    return CMTimeGetSeconds([self.player currentTime]);
}
#pragma mark funcs
- (void)cusPlayerPlay{
    
    [self.player play];
    
}

- (void)cusPlayerPause{

    [self.player pause];
    
}

@end
