//
//  SearchingAnnViewController.m
//  Ericsson
//
//  Created by Min on 15/12/23.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "SearchingAnnViewController.h"
#import "AnnounceSearchContentViewController.h"
#import "AnnounceContentModel.h"
#import "RMDateSelectionViewController.h"

@interface SearchingAnnViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextField *startTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTF;


/** 弹出警示框 */
@property (nonatomic,strong) UILabel * alertLabel;

/** 覆盖view*/
@property (nonatomic,strong) UIView * coverView;

/** 判断的点击的是否是 startTime*/
@property (nonatomic,assign,getter=isStartTime) BOOL startTime;

/**
 *  开始时间
 *  结束时间
 */
@property (strong ,nonatomic) NSString * startTimeStr;
@property (strong ,nonatomic) NSString * endTimeStr;
@end

@implementation SearchingAnnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查找公告";
#warning 此处的时间选择器 需要封装
}

#pragma mark - 按钮事件
// 点击查询按钮
- (IBAction)searchingBtnClicked:(id)sender {

    // 有开始时间，却没用结束时间
    if ([self.startTimeTF.text isEqualToString:@""] && ![self.endTimeTF.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入结束时间"];
        return;
    }else if (![self.startTimeTF.text isEqualToString:@""] && [self.endTimeTF.text isEqualToString:@""]){
        [self.view makeToast:@"请输入开始时间"];
        return;
    }else if (![self judegTime:self.startTimeTF.text and:self.endTimeTF.text]){
        [self.view makeToast:@""];
    }
    
    
    
    // 有结束时间，却没有开始时间
    // 判断时间，开始时间 大于 结束时间
    
    
    
    AnnounceSearchContentViewController * vc = [[AnnounceSearchContentViewController alloc]init];
    vc.isSearchAnn  = YES;
    vc.navTitle     = self.navTitle;
    vc.requestType  = self.requestType;
    vc.theTitle        = self.titleTF.text;
    vc.startTime    = self.startTimeTF.text;
    vc.endTime      = self.endTimeTF.text;
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    array.array = self.navigationController.viewControllers;
    [array removeObjectAtIndex:3];
    [array addObject:vc];
    
    [self.navigationController setViewControllers:array];
    
}
// 判断时间
- (BOOL)judegTime:(NSString*)startDate and:(NSString*)endDate{
    BOOL isTure;
    
    NSDate * date1 = [self dateFromString:startDate]; // 开始时间
    NSDate * date2 = [self dateFromString:endDate]; // 结束时间
    
    if ([date1 compare:date2] == NSOrderedAscending) { // 开始时间小于结束时间  =====>正确
        isTure = YES;
    }else{
        isTure = NO;
    }
    return isTure;
}
// 点击开始时间textField响应
- (IBAction)startTimeBtnClicked:(id)sender {
    //Create select action
    [self setupTime:self.startTimeTF isStartDate:YES]; // 设置开始时间
}
- (IBAction)endTImeBtnClicked:(id)sender {
    [self setupTime:self.endTimeTF isStartDate:NO];
}
- (void)setupTime:(UITextField*)textField isStartDate:(BOOL)flag
{
    RMAction *selectAction = [RMAction actionWithTitle:@"确认" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        
//        NSLog(@"Successfully selected date: %@", ((UIDatePicker *)controller.contentView).date);
        textField.text = [self stringFromDate:((UIDatePicker *)controller.contentView).date];
        if (flag) { // 设置的是开始时间
            
            self.startTimeStr = textField.text;
        }else{
            self.endTimeStr = textField.text;
        }
    }];
    
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Date selection was canceled");
    }];
    
    //Create date selection view controller
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleDefault selectAction:selectAction andCancelAction:cancelAction];
    
    if (flag) { // YES:设置开始时间，判断有没有结束时间
        if (self.endTimeStr) {
            NSDate * date = [self dateFromString:self.endTimeStr];
            NSDate * maxDate = [NSDate dateWithTimeInterval:(8*60*60) sinceDate:date];
            dateSelectionController.maxDate = maxDate;
        }
    }else{ // 设置结束时间,判断有没有开始时间
        if (self.startTimeStr) {
            dateSelectionController.minDate = [self dateFromString:self.startTimeStr];
        }
    }
   
    
    dateSelectionController.title = @"日期选择";
    //        dateSelectionController.message = @"This is a test message.\nPlease choose a date and press 'Select' or 'Cancel'.";
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}
#pragma mark - others
// datePicker上的时间 转换成  NSString格式
- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * str = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    return str;
}

// 把NSString 转换成 NSDate
- (NSDate *)dateFromString:(NSString*)dateString
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [formatter dateFromString:dateString];
    return date;
}
#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
