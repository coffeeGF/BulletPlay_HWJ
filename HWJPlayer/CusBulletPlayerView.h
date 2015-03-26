//
//  CusBulletPlayerView.h
//  HWJPlayer
//
//  Created by 侯文静 on 15-3-19.
//  Copyright (c) 2015年 侯文静. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CusPlayerView.h"
#import "TypeDefine.h"

@interface CusBulletPlayerView : UIView<CusPlayerViewDelegate>


@property (nonatomic,strong)NSString * movieUrl;
@property (nonatomic,strong)NSString * movieDownUrl;
@property (nonatomic,strong)NSString * movieName;


- (void)playWithMovieUrl:(NSString *)movieUrl;

- (float)playerCurrentTime;

- (void)startRunBulletTextWithBullects:(NSMutableArray *)bullectComments startTime:(NSInteger)starTime;

- (void)resetBulletPlayerBulletaArrWithArr:(NSArray *)arr;
@end
