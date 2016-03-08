//
//  TimerService.m
//  Ericsson
//
//  Created by xuming on 16/2/4.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "TimerService.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

@interface TimerService()<BMKLocationServiceDelegate>
@property(nonatomic,strong)BMKLocationService *locService;
@property(nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong) NSString *lat;
@property (nonatomic,strong) NSString *lon;
@end


@implementation TimerService

+(TimerService *)shareInstance
{
    static TimerService* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        db = [[TimerService alloc]init];
    });
    return db;
}


- (instancetype)init
{
    
    self = [super init]; // call the designated initializer
    if (self) {

        //初始化BMKLocationService
        self.locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        //启动LocationService
        [_locService startUserLocationService];
    }
    return self;
}

-(void)fireTimer{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber * gpsFrequency = [defaults valueForKey:KGpsFrequency];
    
    //如果设置了gps上传频率
    if (gpsFrequency) {
        //清除掉原来的设置
        [self.timer  invalidate];
        
        //设置新的上传频率
        self.timer = [NSTimer scheduledTimerWithTimeInterval:[gpsFrequency intValue] target:self selector:@selector(upLoadLocation) userInfo:nil repeats:YES];
    }
    //如果没有设置gps上传频率，用默认的上传频率
    else{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:[KDefaultGpsFrequency intValue] target:self selector:@selector(upLoadLocation) userInfo:nil repeats:YES];
    }
    
    [self.timer fire];
}

-(void)stopTimer{
    [self.timer  invalidate];


}
#pragma mark -upLoadLocation
-(void)upLoadLocation{
    
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSString * time = [df stringFromDate:currentDate];
    
    
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"userId"];
    NSString * sessonId = [defaulsts objectForKey:@"sessionId"];
    

    
    if (self.lon.length>0 && self.lat.length>0) {
        
        NSDictionary *params = @{ @"userId":userId,
                                  @"time":time,
                                  @"longitude":self.lon==NULL?@"":self.lon,
                                  @"latitude":self.lat==NULL?@"":self.lat,
                                  };
        NSLog(@"采集的经纬度=%@",params);

        
        NSString *sopeStr=
        [[SoapUtility shareInstance] BuildSoapWithModelName:@"locationUpload" methodName:@"uploadUserLocation" sessonId:sessonId requestData:params];
        
        //异步请求
        [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
            NSLog(@"dic=%@",dic);
            
            if ([dic[@"retCode"]  isEqual: @0]) {
                NSLog( @"定时上传经纬度成功");
                
            }
            else if ([dic[@"retCode"]  isEqual: @(-1)]) {
                NSLog( @"定时上传经纬度返回非-1");
                
            }
            else if ([dic[@"retCode"]  isEqual: @(-2)]) {
                NSLog( @"定时上传经纬度返回非-2");
                
            }
            
        } falure:^(NSError *err) {
            NSLog( @"定时上传经纬度falure");
            
        }];
    }
    

    
}


#pragma mark -delegate
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    
    self.lat=[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    self.lon=[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
}
@end
