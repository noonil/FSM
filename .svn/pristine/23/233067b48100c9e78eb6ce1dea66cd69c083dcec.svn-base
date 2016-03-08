//
//  HistroyChartViewController.m
//  Ericsson
//
//  Created by admin on 15/12/1.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "HistroyChartViewController.h"
#import "PNBarChart.h"
#import "historyListModel.h"

#define mmLabelHeight 30
#define mmLabelFont 20.f

@interface HistroyChartViewController ()
{
    NSMutableArray *dataArray;
}

@property (nonatomic) PNBarChart * barChart;

@property (nonatomic,strong) NSMutableArray * deptNameArr;
@property (nonatomic,strong) NSMutableArray * alarmCountArr;
@end

@implementation HistroyChartViewController
#pragma mark - Lazy
- (NSMutableArray*)deptNameArr
{
    if (!_deptNameArr) {
        _deptNameArr = [NSMutableArray array];
    }
    return _deptNameArr;
}
- (NSMutableArray *)alarmCountArr
{
    if (!_alarmCountArr) {
        _alarmCountArr = [NSMutableArray array];
    }
    return _alarmCountArr;
}


#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.、
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"历史活动告警数量统计图";
    
    [self setOthers];
    
    [self loadData];
    
}
- (void)loadData{
    //准备请求参数
    NSString *modelName=@"FSMInformation";
    NSString *methodName=@"FSMGetHistoryAlarmList";
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    //requestData是一个字典类型的参数  把参数与值一一对应存入数组中
    NSMutableDictionary *parmeters = [NSMutableDictionary dictionary];
    //参数准备好了，就固定定要下面这个方法，把参数传进去就行了
    NSString *sopeStr= [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:parmeters];
    
    NSLog(@"sopeStr:%@",sopeStr);
    
    //最后，异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        
        if ([dic[@"retCode"] isEqual:@0]) {//返回正确
            NSLog(@"%@",dic);
            //将请求到的数据加入数组中
            NSMutableArray * historyList = [historyListModel objectArrayWithKeyValuesArray:dic[@"alarmList"]];
            //            [self.alarmListArray addObjectsFromArray:alarmListArr];
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            
            if (historyList.count > 0) {
                for (historyListModel * model in historyList) {
                    [self.deptNameArr addObject:model.alarmDate];
                    NSNumber * num = [f numberFromString:model.alarmCount];
                    [self.alarmCountArr addObject:num];
                }
            }
            [self addChart];
        }
    } falure:^(NSError *response) {
        NSLog(@"活动警告查询错误：%@",response);
    }];
}


-(void)setOthers{
    self.edgesForExtendedLayout=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel *topLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KIphoneWidth, mmLabelHeight)];
    topLabel.font                      = [UIFont boldSystemFontOfSize:mmLabelFont];
    topLabel.backgroundColor           = [UIColor clearColor];
    topLabel.textAlignment             = NSTextAlignmentCenter;
    topLabel.userInteractionEnabled    = YES;
    topLabel.adjustsFontSizeToFitWidth = YES;
    topLabel.numberOfLines             = 0;
    topLabel.text=@"近10天历史告警数量统计图";
    [self.view addSubview:topLabel];
    
    
    UILabel *bottomLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, KIphoneHeight-mmLabelHeight-64, KIphoneWidth, mmLabelHeight)];
    bottomLabel.font                      = [UIFont boldSystemFontOfSize:mmLabelFont];
    bottomLabel.backgroundColor           = [UIColor clearColor];
    bottomLabel.textAlignment             = NSTextAlignmentCenter;
    bottomLabel.userInteractionEnabled    = YES;
    bottomLabel.adjustsFontSizeToFitWidth = YES;
    bottomLabel.numberOfLines             = 0;
    bottomLabel.text=@"告警数量";
    [self.view addSubview:bottomLabel];
    
    
    
    
}

-(void)addChart{
    
    //    self.titleLabel.text = @"Bar Chart";
    
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, mmLabelHeight, KIphoneWidth, KIphoneHeight-2*mmLabelHeight-64)];
    NSLog(@"barchart=%@",NSStringFromCGRect(_barChart.frame));
    
    self.barChart.backgroundColor = [UIColor whiteColor];
    
    self.barChart.xLabelFormatter = ^(CGFloat xValue){
        CGFloat xValueParsed = xValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",xValueParsed];
        return labelText;
    };
    self.barChart.labelMarginTop = 5.0;
    
    // 纵向的数据
    //    [self.barChart setYValues:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6"]];
    [self.barChart setYValues:self.deptNameArr];
    self.barChart.rotateForXAxisText = false ;
    // 横向的数据
    [self.barChart setBarLongArray:self.alarmCountArr];
    
    
    //  [self.barChart setStrokeColors:@[PNGreen,PNGreen,PNRed,PNGreen,PNGreen,PNYellow,PNGreen]];
    // Adding gradient
    self.barChart.barColorGradientStart = [UIColor blueColor];
    self.barChart.showChartBorder=YES;
    
    [self.barChart strokeChart];
    
    //   self.barChart.delegate = self;
    
    [self.view addSubview:self.barChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
