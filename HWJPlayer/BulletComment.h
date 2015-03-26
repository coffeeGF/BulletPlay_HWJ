//
//  BulletComment.h
//  BulletPlayer
//
//  Created by wenxiaopei on 14-9-7.
//  Copyright (c) 2014年 wenxiaopei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, BulletDispMode)
{
    kBulletTopStaticMode,         //顶部固定显示模式
    kBulletMoveMode,          //滚动显示模式
    kBulletButtomStaticMode,          //底部固定显示模式
};

@interface BulletComment : NSObject
@property (nonatomic, readonly
           ) NSString *bulletString;//弹幕文字
@property (nonatomic, readonly) UIColor *textColor;//弹幕字体颜色
@property (nonatomic, assign) CGFloat fontSize;//弹幕字体大小
@property (nonatomic, assign) BulletDispMode dispMode;//弹幕显示模式，顶部显示、中部显示、底部显示
@property (nonatomic, readonly) NSString *stime;//弹幕相对于视频的播放时间
@property (nonatomic, assign) BOOL isDispBorder;//是否显示边框

/*
 _bulletComment:弹幕文字
 _bulletColor:弹幕字体颜色
 _textFontSize:弹幕字体大小
 _textDispMode:弹幕显示模式，顶部显示:0、中部显示:1、底部显示:2
 _bulletStime:弹幕相对于视频的播放时间
 */
+(BulletComment *)bulletWithComment:(NSString *)_bulletComment withTextColor:(UIColor *)_bulletColor withFontSize:(CGFloat )_textFontSize withDispMode:(NSUInteger )_textDispMode withStime:(NSString *)_bulletStime;

@end
