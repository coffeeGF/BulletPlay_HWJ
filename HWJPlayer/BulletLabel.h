//
//  BulletLabel.h
//  BulletPlayer
//
//  Created by wenxiaopei on 14-9-7.
//  Copyright (c) 2014年 wenxiaopei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLabel.h"

@class BulletComment;

//弹幕滚动效果Label
@interface BulletLabel : THLabel

@property(nonatomic) float tickerSpeed;                 //弹幕滚动speed
@property (nonatomic) float durationTime;               //弹幕在屏幕上的持续时间
@property (nonatomic) CGFloat beginAnimateTime;         //起始时间
@property (nonatomic) CGFloat beginPosRight;            //起始右边的位置
@property (nonatomic, weak) BulletComment *bulletComment;   //需要显示的弹幕信息

//弹幕开始滚动
-(void)startMoveWithCompletion:(void (^)(void))_countBlock;
//弹幕开始褪色
-(void)startFadeWithCompletion:(void (^)(void))_countBlock;

/*!
 弹幕暂停滚动
 */
-(void)pause;

/*!
 弹幕重新开始滚动
 */
-(void)resume;



@end
