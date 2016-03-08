//
//  MOViewController.m
//  Ericsson
//
//  Created by admin on 15/12/2.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "MOViewController.h"

@interface MOViewController ()

@end

@implementation MOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title=@"活动告警数量统计图";
    NSMutableArray *arr=[NSMutableArray arrayWithObjects:@"临高片区",@"万宁片区",@"澄迈片区",@"白沙片区",@"乐乐片区",@"屯昌片区",@"儋州片区",@"昌江片区",@"琼海片区",@"三亚片区",@"文昌片区",@"保亭片区",@"五指山片区",@"陵水片区",@"琼中片区",@"派单中心",@"东方片区",@"定安片区",@"海口片区", nil];
    NSMutableArray *arr1=[NSMutableArray arrayWithObjects:@"0",@"20",@"40",@"60",@"80", nil];
    NSMutableArray *arr2=[NSMutableArray arrayWithObjects:@"13",@"15",@"33",@"0",@"20",@"28",@"70",@"35",@"30",@"80",@"14",@"35",@"7",@"22",@"0",@"0",@"17",@"16",@"0", nil];
    //竖轴
    NSUInteger i = 0;
    for (; i<19; i++) {
        CGFloat height = 18;
        UILabel * label = [[UILabel alloc]init];
        label.text=arr[i];
        label.font=[UIFont systemFontOfSize:12];
        label.textAlignment=NSTextAlignmentCenter;
        if ([UIScreen mainScreen].bounds.size.width>320)
        {
            label.font=[UIFont systemFontOfSize:16];
            height = 24;
        }
        label.frame = CGRectMake(0, 80+i*height, 70, 16);
        [self.view addSubview:label];
        
        
    }
    //x轴，y轴
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    if ([UIScreen mainScreen].bounds.size.width<=320)
    {
        
        UIView *v1 = [[UIView alloc]initWithFrame:CGRectMake(60, 80, 1, 340)];
        [v1 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1]];
        UIView *v2 = [[UIView alloc]initWithFrame:CGRectMake(60, 420, 250,1)];
        [v2 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1]];
        [self.view addSubview:v1];
        [self.view addSubview:v2];
        
    }
    else{
        UIView *v1 = [[UIView alloc]initWithFrame:CGRectMake(70, 60, 1, 460)];
        [v1 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1]];
        UIView *v2 = [[UIView alloc]initWithFrame:CGRectMake(70,520, 270,1)];
        [v2 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1]];
        [self.view addSubview:v1];
        [self.view addSubview:v2];
    }
    //横轴
    for(int i=0;i<5;i++){
        CGFloat width;
        UILabel * label1 = [[UILabel alloc]init];
        label1.text=arr1[i];
        if ([UIScreen mainScreen].bounds.size.width>320)
        {
            label1.font=[UIFont systemFontOfSize:16];
            width = 70;
            label1.frame = CGRectMake(60+i*width,523 , 50, 20);
            [self.view addSubview:label1];
        }
        if ([UIScreen mainScreen].bounds.size.width<=320)
        {
            label1.font=[UIFont systemFontOfSize:12];
            width = 60;
            label1.frame = CGRectMake(60+i*width,415 , 50, 20);
            [self.view addSubview:label1];
        }
        
    }
    //数据柱状图
    for(int i=0;i<arr2.count;i++){
        CGFloat width1;
        CGFloat height1;
        UIView * view = [[UIView alloc]init];
        UILabel * label2 = [[UILabel alloc]init];
        if ([UIScreen mainScreen].bounds.size.width<=320)
        {
            
            height1=18;
            label2.text=arr2[i];
            label2.font=[UIFont systemFontOfSize:12];
            view.frame=CGRectMake(60,80+i*height1 ,3*[[arr2 objectAtIndex:i]floatValue], 16);
            label2.frame=CGRectMake(60+3*[[arr2 objectAtIndex:i]floatValue], 80+i*height1,50 , 16);
            [view setBackgroundColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1]];
            [self.view addSubview:view];
            [self.view addSubview:label2];
        }
        if ([UIScreen mainScreen].bounds.size.width>320)
        {
            
            height1=24;
            label2.text=arr2[i];
            label2.font=[UIFont systemFontOfSize:16];
            view.frame=CGRectMake(70,60+i*height1 ,3.5*[[arr2 objectAtIndex:i]floatValue], 16);
            label2.frame=CGRectMake(70+3.5*[[arr2 objectAtIndex:i]floatValue], 60+i*height1,50 , 16);
            [view setBackgroundColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1]];
            [self.view addSubview:view];
            [self.view addSubview:label2];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
