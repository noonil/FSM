//
//  GPSUpLoadFrequencySetViewController.m
//  Ericsson
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "GPSUpLoadFrequencySetViewController.h"
#import "HeaderView.h"
#import "ContactOrderViewCell.h"
#import "PopupObjectList.h"
#import "SettingViewController.h"
#import "TimerService.h"


@interface GPSUpLoadFrequencySetViewController ()<PopupObjectListDelegate>

@property (nonatomic,strong)PopupObjectList * pop;
@property (nonatomic,strong)NSArray * objectArr;
@property (nonatomic,strong)NSMutableArray * array;


@end

@implementation GPSUpLoadFrequencySetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GPS上传频率设置";
    [self loadDataFromDB];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    //设置tableView头部视图
    self.headerView.imageView.image = [UIImage imageNamed:@"spare_search"];
    
    //需要根据具体类型改变，暂不处理
    self.headerView.title.text = @"GPS上传频率设置";
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *num=[defaults valueForKey:KGpsFrequency];
    if (num==nil) {
        _frequencytf.text = @"120";

    }
    else{
        _frequencytf.text = [num stringValue];

    }
    _frequencytf.enabled=NO;

}

- (void)loadDataFromDB{
    
    self.objectArr = [NSArray new];
    
    self.objectArr = [NSArray arrayWithObjects:@"30", @"60", @"90", @"120", @"180", @"240", @"300",  nil];
    
    _array = [NSMutableArray new];
    
    for (int i = 0; i < _objectArr.count; i ++) {
        
        [_array addObject:_objectArr[i]];
        
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)chooseFrequency:(id)sender {
    _pop = [[PopupObjectList alloc]initWithData:self.array selectedData:_frequencytf.text fromWhichObject:_frequencytf];
    _pop.delegate = self;
    
    [_pop presentPopupControllerAnimated];

}
- (IBAction)okBtn:(UIButton *)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:_frequencytf.text];
    
    NSUserDefaults * defaults= [NSUserDefaults standardUserDefaults];
    [defaults setValue:myNumber forKey:KGpsFrequency];
    
    [[TimerService shareInstance] fireTimer];
    
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma PopupObjectList - Delegate

- (void)popupObjectListDidSelectRowAtIndexPath:(NSString *)selectedData fromWhichObject:(id)fromWhichObject row:(NSInteger)row{
    
    if (fromWhichObject == _frequencytf) {
        
        _frequencytf.text = self.array[row];
        

        
    }
    
}




@end
