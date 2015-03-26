//
//  CusPlayerView.h
//  HWJPlayer
//
//  Created by 侯文静 on 15-3-19.
//  Copyright (c) 2015年 侯文静. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol CusPlayerViewDelegate <NSObject>

- (void)cusPlayerTouchGoFast;

- (void)cusPlayerTouchGoBack;


- (void)cusPlayerStatusLoaded;

/**
 *  播放器CMTimeMakeWithSeconds(0.01, NSEC_PER_SEC)0.01秒播放代理
 *
 *  @param _currentTime 当前播放时间
 *  @param duration     视频全部时间
 */
- (void)cusPlayerViewPlayEverySecondStatusWithCurrentTime:(CMTime)_currentTime duration:(CMTime)duration;

@end

@interface CusPlayerView : UIView

@property (nonatomic,strong)AVPlayer * player;

@property (nonatomic,assign)id <CusPlayerViewDelegate> delegate;

- (void)cusPlayerPlay;

- (void)cusPlayerPause;

- (void)playWithMoviewUrl:(NSString *)movieUrl;

- (float)cusPlayerCurrentTime;

@end
