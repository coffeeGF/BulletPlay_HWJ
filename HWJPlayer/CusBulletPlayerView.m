//
//  CusBulletPlayerView.m
//  HWJPlayer
//
//  Created by 侯文静 on 15-3-19.
//  Copyright (c) 2015年 侯文静. All rights reserved.
//

#import "CusBulletPlayerView.h"
#import "BulletComment.h"
#import "BulletLabel.h"

#define bullectViewWidth CGRectGetWidth([self bounds])
#define bullectViewHeight CGRectGetHeight([self bounds])

@implementation CusBulletPlayerView
{
    CusPlayerView * cusPlayerView;
    
    UIView * bulletView;
    
    NSMutableDictionary *_lastBulletTickerViewInfos;            //弹幕的每行的最后一个Bullet的信息
    
    NSMutableSet * reuseBulleLabeltSet;

    int bulletCountOnScreen;
    
    UIView *  upToolControl; //上部工具条
    
    UIButton * bulletBtn;//弹幕开关
    
    BOOL isBulletOpen;
    
    UIView *  downToolControl;
    
    
    NSArray * originalBulletArr;
    
    float _preVideoPlayTime;                        //上次的播放时间点
    NSMutableDictionary *_bulletCommentInfo;            //弹幕信息,以@{时间点:@[弹幕内容]}的形式存在
    NSMutableSet *_playTimes;                           //所有的播放时间点
    BOOL danMuAlready;//弹幕解析完毕准备好
}
- (instancetype)init{
    
    if (self = [super init]) {
    
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _lastBulletTickerViewInfos = [NSMutableDictionary dictionaryWithCapacity:10];
        reuseBulleLabeltSet = [NSMutableSet set];
        _playTimes = [NSMutableSet set];
        _bulletCommentInfo = [NSMutableDictionary dictionary];
        originalBulletArr = [NSArray array];
        [self createUI];
        
    }
    return self;
}
- (void)playWithMovieUrl:(NSString *)movieUrl{
    
    [cusPlayerView playWithMoviewUrl:movieUrl];
    
}


- (void)createUI{
    
    cusPlayerView                 = [[CusPlayerView alloc] initWithFrame:self.frame];
    cusPlayerView.backgroundColor = [UIColor lightGrayColor];
    cusPlayerView.delegate        = self;
    [self addSubview:cusPlayerView];

    bulletView                    = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    bulletView.backgroundColor    = [UIColor clearColor];
    [self addSubview:bulletView];
    
}
- (void)startRunBulletTextWithBullects:(NSMutableArray *)bullectComments startTime:(NSInteger)starTime{
    
    CGFloat lineHeight      = 21;
    NSInteger numberOflines = bullectViewHeight/lineHeight;
    float durationTime      = 5;
    float borderValue       = 2.0f;
    float alphaValue        = 0.7;
    int countValue          = 80;
    int moveRow             = 0;
    int topBullectRow       = 0;
    int bottomBullectRow    = 0;
    
    //确定弹幕起始行号
    for (int i = 0 ; i < numberOflines; i++) {
        int top = i * lineHeight;
        BulletLabel * lastTickerLabelInLine = _lastBulletTickerViewInfos[@(top)];
        if ((lastTickerLabelInLine == nil) || (starTime - lastTickerLabelInLine.beginAnimateTime > 1)) {
            moveRow = i;
            break;
        }
    }
    for (BulletComment * bulletCommet in bullectComments) {
        BulletLabel * curBullectTicker;
        if ([reuseBulleLabeltSet count] > 0) {
            curBullectTicker = [reuseBulleLabeltSet anyObject];
            [reuseBulleLabeltSet removeObject:curBullectTicker];
            [bulletView bringSubviewToFront:curBullectTicker];
            curBullectTicker.hidden = NO;
        }else{
            curBullectTicker = [[BulletLabel alloc]initWithFrame:CGRectMake(bullectViewWidth, 0, 0, [UIFont systemFontOfSize:bulletCommet.fontSize].lineHeight)];
        }
        
        curBullectTicker.alpha = alphaValue;
        curBullectTicker.textColor = bulletCommet.textColor;
        curBullectTicker.bulletComment = bulletCommet;
        curBullectTicker.beginAnimateTime = starTime;
        curBullectTicker.durationTime = durationTime;
        curBullectTicker.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        curBullectTicker.strokeSize = borderValue;
        
        if (![curBullectTicker isDescendantOfView:bulletView]) {
            [bulletView addSubview:curBullectTicker];
        }
        
        switch (bulletCommet.dispMode) {
            case kBulletTopStaticMode:{
                
                int top = (int)(topBullectRow%(numberOflines/2))*lineHeight;
                CGRect curFrame = curBullectTicker.frame;
                curFrame.origin.y = top;
                curFrame.origin.x = (bullectViewWidth - CGRectGetWidth(curFrame))/2.0;
                curBullectTicker.frame = curFrame;
                curBullectTicker.alpha = alphaValue;
                bulletCountOnScreen += 1;
                [curBullectTicker startFadeWithCompletion:^(){
                    bulletCountOnScreen -= 1;
                }];
                
                topBullectRow += 1;
                if (topBullectRow > numberOflines/2) {
                    topBullectRow = 0;
                }
                break;
            }
            case kBulletButtomStaticMode:
            {
                int top = bullectViewHeight - (int)(bottomBullectRow%(numberOflines/2))*lineHeight;
                CGRect curFrame = curBullectTicker.frame;
                curFrame.origin.y = top - CGRectGetHeight(curFrame);
                curFrame.origin.x = (bullectViewWidth - CGRectGetWidth(curFrame))/2.0;
                curBullectTicker.frame = curFrame;
                
                bulletCountOnScreen += 1;
                [curBullectTicker startFadeWithCompletion:^(){
                    bulletCountOnScreen -= 1;
                }];
                
                bottomBullectRow += 1;
                if (bottomBullectRow > (numberOflines/2)) {
                    bottomBullectRow = 0;
                }
                
                break;
            }
            case kBulletMoveMode:
            default:{
                int top = (int)(moveRow%numberOflines)*lineHeight;
                CGRect curFrame = curBullectTicker.frame;
                curFrame.origin.y  = top;
                curBullectTicker.frame = curFrame;
                
                CGFloat bottomLine = bullectViewHeight;
                if ((curBullectTicker.frame.origin.y + CGRectGetHeight(curBullectTicker.frame) > bottomLine)) {
                    curFrame = curBullectTicker.frame;
                    curFrame.origin.y = bottomLine - lineHeight;
                    curBullectTicker.frame = curFrame;
                }
                CGRect curBulletFrame = curBullectTicker.frame;
                curBulletFrame.origin.x = bullectViewWidth;
                curBullectTicker.frame = curBulletFrame;
                
                curBullectTicker.tickerSpeed = (curBulletFrame.origin.x + CGRectGetWidth(curBulletFrame))/durationTime;
                curBullectTicker.beginPosRight = curBullectTicker.frame.origin.x+CGRectGetWidth(curBullectTicker.frame);

                bulletCountOnScreen += 1;
                [curBullectTicker startMoveWithCompletion:^(){
                    bulletCountOnScreen -= 1;
                }];
                [_lastBulletTickerViewInfos setObject:curBullectTicker forKey:@(top)];
                moveRow += 1;
                break;
            }
        }
    }
    
    
}
- (float)playerCurrentTime{
    return [cusPlayerView cusPlayerCurrentTime];
}
//开始加载显示弹幕
- (void)sendBulletTextWithCurrentTime:(CMTime)_currentTime{

    float time = CMTimeGetSeconds(_currentTime);
    if ((int)(_preVideoPlayTime*100) == -1000 || (int)(_preVideoPlayTime*100) != (int)(time*100))
    {
        NSString *timeString = [NSString stringWithFormat:@"%0.2f",time];
        _preVideoPlayTime = time;
        if ([_playTimes containsObject:timeString])
        {
            [self startRunBulletTextWithBullects:_bulletCommentInfo[timeString] startTime:time];
        }
    }
}
- (void)reModeDanMuArr:(NSArray *)originalArr{
    NSMutableArray *tempBulletsArray = [NSMutableArray arrayWithCapacity:200];
    for (NSDictionary *dict in originalArr)
    {
        NSString *stime = [NSString stringWithFormat:@"%0.2f",[[dict objectForKey:@"stime"] floatValue]];
        NSString *colorValueString = [NSString stringWithFormat:@"%06x",[[dict objectForKey:@"color"] intValue]];
        UIColor *tempColor = [self getColor:colorValueString];
        
        BulletComment *bulletContent = [BulletComment bulletWithComment:[dict objectForKey:@"content"]withTextColor:tempColor withFontSize:[[dict objectForKey:@"font_size"] intValue] withDispMode:[[dict objectForKey:@"mode"] intValue] withStime:stime];
        [tempBulletsArray addObject:bulletContent];
    }
    //按时间排序
    [tempBulletsArray sortUsingComparator:^NSComparisonResult(BulletComment *bullet1, BulletComment *bullet2)
     {
         return [bullet1.stime intValue] > [bullet2.stime intValue];
     }];
    
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    
    for (BulletComment *bullet in tempBulletsArray)
    {
        NSString *time = bullet.stime;
        if (time==nil)
        {
            continue;
        }
        NSMutableArray *array = resultDict[time];
        if (array == nil)
        {
            array = [NSMutableArray array];
            resultDict[time] = array;
        }
        [array addObject:bullet];
    }
    
    _bulletCommentInfo = resultDict;
    
    _playTimes = [[_bulletCommentInfo allKeys] mutableCopy];
    
    danMuAlready = YES;
}

//将6位16进制数字转成UIColor
- (UIColor *)getColor:(NSString*)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    if (red == 0 && green == 0 && blue == 0) {
        red = 255;
        green = 255;
        blue = 255;
    }
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}
- (void)resetBulletPlayerBulletaArrWithArr:(NSArray *)arr{
    originalBulletArr = arr;
    
    [self reModeDanMuArr:originalBulletArr];
}
#pragma mark cusPlayerViewDelegate
- (void)cusPlayerViewPlayEverySecondStatusWithCurrentTime:(CMTime)_currentTime duration:(CMTime)duration{
    if (danMuAlready) {
        [self sendBulletTextWithCurrentTime:_currentTime];
    }
}
- (void)cusPlayerStatusLoaded{
    
    if (isBulletOpen) {
        //播放弹幕
        
    }
}
- (void)cusPlayerTouchGoBack{

}
- (void)cusPlayerTouchGoFast{

}
@end
