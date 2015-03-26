//
//  BulletComment.m
//  BulletPlayer
//
//  Created by wenxiaopei on 14-9-7.
//  Copyright (c) 2014年 wenxiaopei. All rights reserved.
//

#import "BulletComment.h"

@implementation BulletComment
/*
 _bulletComment:弹幕文字
 _bulletColor:弹幕字体颜色
 _textFontSize:弹幕字体大小
 _textDispMode:弹幕显示模式，顶部显示:0、中部显示:1、底部显示:2
 _bulletStime:弹幕相对于视频的播放时间
 */
+(BulletComment *)bulletWithComment:(NSString *)_bulletComment withTextColor:(UIColor *)_bulletColor withFontSize:(CGFloat )_textFontSize withDispMode:(NSUInteger )_textDispMode withStime:(NSString *)_bulletStime
{
    return [[self alloc]initWithBulletComment:_bulletComment withTextColor:_bulletColor withFontSize:_textFontSize withDispMode:_textDispMode withStime:_bulletStime];
}

-(id)initWithBulletComment:(NSString *)_bulletComment withTextColor:(UIColor *)_bulletColor withFontSize:(CGFloat )_textFontSize withDispMode:(NSUInteger )_textDispMode withStime:(NSString *)_bulletStime
{
    if (self=[super init])
    {
        _bulletString = [_bulletComment copy];
        _textColor = _bulletColor;
        _fontSize = _textFontSize;
        switch (_textDispMode)
        {
            case 5:
            {
                _dispMode = kBulletTopStaticMode;
                break;
            }
            case 1:
            {
                _dispMode = kBulletMoveMode;
                break;
            }
            case 4:
            {
                _dispMode = kBulletButtomStaticMode;
                break;
            }
            default:
            {
                _dispMode = kBulletMoveMode;
                break;
            }
        }
        _stime = [_bulletStime copy];
        _isDispBorder = NO;
    }
    return self;
}

@end
