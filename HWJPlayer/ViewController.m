//
//  ViewController.m
//  HWJPlayer
//
//  Created by 侯文静 on 15-3-19.
//  Copyright (c) 2015年 侯文静. All rights reserved.
//

#import "ViewController.h"
#import "CusBulletPlayerView.h"
#import "ASIHTTPRequest.h"
#import "BulletComment.h"
@interface ViewController ()

@end
#define ScreenSize [[UIScreen mainScreen]bounds].size

@implementation ViewController
{
    CusBulletPlayerView * bulletPlayer ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    bulletPlayer = [[CusBulletPlayerView alloc]initWithFrame:CGRectMake(0, 20, ScreenSize.width, ScreenSize.height*0.4)];
    [self.view addSubview:bulletPlayer];
    
    [bulletPlayer playWithMovieUrl:@"http://pl.youku.com/playlist/m3u8?vid=229038321&type=mp4&ts=1427350945&keyframe=0&ep=G02M1ZVJxfdEWBjeEZSzVsWS1tqhVrrrujqLXLc6NTASUxxfVJCftl%2Fuo%2BEoi1DB&sid=5427340747339123eb2e6&token=4001&ctype=20&ev=1&oip=2032758278&uc_param_str=xk"];
    
    // 弹幕
    NSString * danmuStr = @"http://api.baomihua.tv/videos/520724/subtitles.json";
    ASIHTTPRequest * request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:danmuStr]];
    request.delegate = self;
    __weak ASIHTTPRequest * wRequest = request;
    [request setCompletionBlock:^(){
        NSArray * danmuArr = [NSJSONSerialization JSONObjectWithData:wRequest.responseData options:NSJSONReadingMutableLeaves error:nil];
        [bulletPlayer resetBulletPlayerBulletaArrWithArr:danmuArr];
    }];
    [request setFailedBlock:^(){
        NSLog(@"弹幕请求失败");
    }];
    [request startAsynchronous];
    

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
