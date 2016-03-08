//
//  WithWorkResultViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/9.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "WithWorkResultViewController.h"
#import "OrderResultItem.h"
#import "UIView+Extension.h"
#import "WorkOrder.h"
#import "WorkOrderStep.h"
#import "KeyMap.h"
#import "ToolBar.h"
#import "PhaseFeedBackDescInputViewController.h"
#include "FDAlertView.h"
#include "AlertInputView.h"

#define DescriptionFont 15


@interface WithWorkResultViewController ()<OrderResultItemDelegate,UITableViewDataSource,UITableViewDelegate,PhaseFeedBackDescInputDelegate,AlertInputViewDelegate>

//完成类型
@property (nonatomic,strong)OrderResultItem *finishTypeItem;
@property (nonatomic,strong)UITableView *finishTypeTableView;
@property (nonatomic,strong)KeyMap *selectedType;

//处理总结
@property (nonatomic,strong)OrderResultItem *handleSummaryItem;
@property (nonatomic,strong)UILabel *handleSummaryLabel;
//有无遗留问题
@property (nonatomic,strong)OrderResultItem *leftProblemItem;
@property (nonatomic,strong)UILabel *leftProblemDescLabel;
//备注
@property (nonatomic,strong)OrderResultItem *remarkItem;
@property (nonatomic,strong)UILabel *remarkDescLabel;

////附件上传工具栏
//@property (nonatomic,strong)OrderResultItem *toolBarItem;
//@property (nonatomic,strong)ToolBar *toolBar;


@property (nonatomic,strong)NSArray *finishTypes;
@property (nonatomic,strong)UIScrollView *contentScrollView;

@property (nonatomic,strong)UIButton *commitBtn;

//超时工单超时原因填写
@property (nonatomic,strong)FDAlertView *alert;
@end

@implementation WithWorkResultViewController

-(NSArray *)finishTypes{
    if (!_finishTypes) {
        _finishTypes = [[NSArray alloc] init];
    }
    return _finishTypes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self queryHandleType];
    
    //添加界面元素
    //完成类型
    self.finishTypeItem = [[[NSBundle mainBundle] loadNibNamed:@"OrderResultItem" owner:nil options:nil] lastObject];
    self.finishTypeItem.handleType.text = @"完成类型";
    
    self.finishTypeItem.handleBtn.selected = YES;
    [self.finishTypeItem.handleBtn setImage:[UIImage imageNamed:@"downpoint"] forState:UIControlStateNormal];
    [self.finishTypeItem.handleBtn setImage:[UIImage imageNamed:@"uppoint"] forState:UIControlStateSelected];
    self.finishTypeItem.delegate = self;
    
    
    //完成类型选择列表
    self.finishTypeTableView = [[UITableView alloc] init];
    self.finishTypeTableView.dataSource = self;
    self.finishTypeTableView.delegate = self;
    self.finishTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.finishTypeTableView.scrollEnabled = NO;
    
    //处理总结
    self.handleSummaryItem = [[[NSBundle mainBundle] loadNibNamed:@"OrderResultItem" owner:nil options:nil] lastObject];
    self.handleSummaryItem.delegate = self;
    self.handleSummaryItem.handleType.text = @"处理总结";
    [self.handleSummaryItem.handleBtn setImage:[UIImage imageNamed:@"edit_bg"] forState:UIControlStateNormal];
    
    self.handleSummaryLabel = [[UILabel alloc] init];
    self.handleSummaryLabel.numberOfLines = 0;
    self.handleSummaryLabel.font = [UIFont systemFontOfSize:DescriptionFont];
    self.handleSummaryLabel.text = @"";
    
    //有无遗留问题
    self.leftProblemItem = [[[NSBundle mainBundle] loadNibNamed:@"OrderResultItem" owner:nil options:nil] lastObject];
    self.leftProblemItem.delegate = self;
    self.leftProblemItem.handleType.text = @"有无遗留问题";
    self.leftProblemItem.handleBtn.selected = NO;
    [self.leftProblemItem.handleBtn setImage:[UIImage imageNamed:@"nonelegacy.png"] forState:UIControlStateNormal];
    [self.leftProblemItem.handleBtn setImage:[UIImage imageNamed:@"legacy.png"] forState:UIControlStateSelected];

    self.leftProblemDescLabel = [[UILabel alloc] init];
    self.leftProblemDescLabel.numberOfLines = 0;
    self.leftProblemDescLabel.font = [UIFont systemFontOfSize:DescriptionFont];
    self.leftProblemDescLabel.text = @"";
    
    //备注
    self.remarkItem = [[[NSBundle mainBundle] loadNibNamed:@"OrderResultItem" owner:nil options:nil] lastObject];
    self.remarkItem.delegate = self;
    self.remarkItem.handleType.text = @"备注";
    [self.remarkItem.handleBtn setImage:[UIImage imageNamed:@"edit_bg"] forState:UIControlStateNormal];
    
    self.remarkDescLabel = [[UILabel alloc] init];
    self.remarkDescLabel.numberOfLines = 0;
    self.remarkDescLabel.font = [UIFont systemFontOfSize:DescriptionFont];
    self.remarkDescLabel.text = @"";
    
//    //附件上传工具栏
//    self.toolBarItem = [[[NSBundle mainBundle] loadNibNamed:@"OrderResultItem" owner:nil options:nil] lastObject];
//    self.toolBarItem.handleType.text = @"上传附件";
//    
//    self.toolBar = [[ToolBar alloc] init];
//    self.toolBar.view.frame = self.toolBar.bounds;
//    //附件列表内容暂不添加（待后续附件上传功能处理好再补）
    
    //提交按钮
    self.commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 114, [UIScreen mainScreen].bounds.size.width, 50)];
    [self.commitBtn setTitle:@"提交m" forState:UIControlStateNormal];
    self.commitBtn.backgroundColor = [UIColor blackColor];
    [self.commitBtn addTarget:self action:@selector(EndOrderCommit) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 50)];
    
    [self.contentScrollView addSubview:self.finishTypeItem];
    [self.contentScrollView addSubview:self.finishTypeTableView];
    [self.contentScrollView addSubview:self.handleSummaryItem];
    [self.contentScrollView addSubview:self.handleSummaryLabel];
    [self.contentScrollView addSubview:self.leftProblemItem];
    [self.contentScrollView addSubview:self.leftProblemDescLabel];
    [self.contentScrollView addSubview:self.remarkItem];
    [self.contentScrollView addSubview:self.remarkDescLabel];
//    [self.contentScrollView addSubview:self.toolBarItem];
//    [self.contentScrollView addSubview:self.toolBar];
    
    [self.view addSubview:self.contentScrollView];
    [self.view addSubview:self.commitBtn];

    //控制alerView视图随键盘显示隐藏而改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGPoint center = self.alert.contentView.center;
    center.y = keyboardRect.origin.y - self.alert.contentView.frame.size.height / 2;
    self.alert.contentView.center = center;
}

-(void)keyboardWillHide:(NSNotification *)notification{
    self.alert.contentView.center = CGPointMake(self.alert.center.x, 100);
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat MaxY;
    
    [self.finishTypeItem setFrame:CGRectMake(20, 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
    MaxY = CGRectGetMaxY(self.finishTypeItem.frame);
    
    if (self.finishTypeItem.handleBtn.selected) {
        [self.finishTypeTableView setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, self.finishTypes.count * 40)];
        MaxY = CGRectGetMaxY(self.finishTypeTableView.frame);
    }else{
        [self.finishTypeTableView setFrame:CGRectZero];
    }
    
    [self.handleSummaryItem setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
    MaxY = CGRectGetMaxY(self.handleSummaryItem.frame);
    
    if (self.handleSummaryLabel.text.length > 0) {
        CGSize textSize = [self sizeWithText:self.handleSummaryLabel.text font:[UIFont systemFontOfSize:DescriptionFont] maxW:[UIScreen mainScreen].bounds.size.width - 40];
        
        [self.handleSummaryLabel setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, textSize.height)];
        MaxY = CGRectGetMaxY(self.handleSummaryLabel.frame);
    }else{
        [self.handleSummaryLabel setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 10)];
        MaxY = CGRectGetMaxY(self.handleSummaryLabel.frame);
    }
    
    
    [self.leftProblemItem setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
    MaxY = CGRectGetMaxY(self.leftProblemItem.frame);
    
    if (self.leftProblemItem.handleBtn.selected) {
        CGSize TextSize = [self sizeWithText:self.leftProblemDescLabel.text font:[UIFont systemFontOfSize:DescriptionFont] maxW:[UIScreen mainScreen].bounds.size.width - 40];
        
        [self.leftProblemDescLabel setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, TextSize.height)];
        MaxY = CGRectGetMaxY(self.leftProblemDescLabel.frame);
    }else{
        [self.leftProblemDescLabel setFrame:CGRectZero];
    }
    
    
    [self.remarkItem setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
    MaxY = CGRectGetMaxY(self.remarkItem.frame);
    
    if (self.remarkDescLabel.text.length > 0) {
        CGSize textSize = [self sizeWithText:self.remarkDescLabel.text font:[UIFont systemFontOfSize:DescriptionFont] maxW:[UIScreen mainScreen].bounds.size.width - 40];
        
        [self.remarkDescLabel setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, textSize.height)];
        MaxY = CGRectGetMaxY(self.remarkDescLabel.frame);
    }else{
        [self.remarkDescLabel setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 10)];
        MaxY = CGRectGetMaxY(self.remarkDescLabel.frame);
    }
    
//    [self.toolBarItem setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
//    MaxY = CGRectGetMaxY(self.toolBarItem.frame);
//    
//    [self.toolBar setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
//    MaxY = CGRectGetMaxY(self.toolBar.frame);
    
    self.contentScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, MaxY + 70);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//进行随工类工单处理结束提交
- (void)EndOrderCommit{
    //数据检查
    if (!self.finishTypeItem.handleTypeValue.text.length > 0) {
        [MBProgressHUD showError:@"请选择完成类型"];
        return;
    }
    
    if (!self.handleSummaryLabel.text.length > 0) {
        [MBProgressHUD showError:@"请填写处理总结"];
        return;

    }
    
    //请求数据示例
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:@"username"];
    NSString *sessionId = [defaults objectForKey:@"sessionId"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    //选择人员传入参数为数组，不过目前是单选
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":userId,@"woId":self.workOrder.woId,@"taskName":self.currentStep.taskName,@"taskId":self.currentStep.taskId,@"localTs":currentDateStr,@"finishType":self.selectedType.value,@"handleSummary":self.handleSummaryLabel.text,@"questionDescribe":self.leftProblemDescLabel.text,@"remark":self.remarkDescLabel.text,@"operMBPS":@"处理结束",@"processId":@"0"}];
    

    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMSubmitCompeleteWO";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    
    [MBProgressHUD showMessage:@"正在发送处理结束操作请求"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            if ([dic[@"timeOut"] isEqualToString:@"true"]) {
                //弹出密码格式提醒
                self.alert = [[FDAlertView alloc] init];
                AlertInputView *contentView = [[NSBundle mainBundle] loadNibNamed:@"AlertInputView" owner:nil options:nil].lastObject;
                contentView.frame = CGRectMake(0, 0, 300, 350);
                contentView.delegate = self;
                self.alert.contentView = contentView;
                [self.alert show];
            }else{
//                NSLog(@"处理结束成功");
                [self.navigationController.view makeToast:@"请求成功"];
                [self.navigationController popToViewController:self.rootController animated:YES];
            }
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
    
}

#pragma mark - AlertInputViewDelegate
- (void)AlertViewFinishInput:(NSString *)content
{
    [self.alert hide];
    
    //请求数据示例
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:@"username"];
    NSString *sessionId = [defaults objectForKey:@"sessionId"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    //选择人员传入参数为数组，不过目前是单选
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":userId,@"woId":self.workOrder.woId,@"taskName":self.currentStep.taskName,@"taskId":self.currentStep.taskId,@"localTs":currentDateStr,@"finishType":self.selectedType.value,@"handleSummary":self.handleSummaryLabel.text,@"questionDescribe":self.leftProblemDescLabel.text,@"remark":self.remarkDescLabel.text,@"timeOutReason":content,@"operMBPS":@"处理结束",@"processId":@"0"}];
    

    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMinsertWOTimeout";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在发送处理结束带超时原因请求"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
//            NSLog(@"处理结束成功");
            [self.navigationController popToViewController:self.rootController animated:YES];
            [self.navigationController.view makeToast:@"请求成功"];

        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
    
}

#pragma mark - OrderResultItemDelegate
-(void)OrderResultItemClick:(UIButton *)btn{
    if (btn == self.finishTypeItem.handleBtn) {
        //细节操作实现于此
        
    }else if (btn == self.handleSummaryItem.handleBtn){
        PhaseFeedBackDescInputViewController *summaryInput = [[PhaseFeedBackDescInputViewController alloc] init];
        summaryInput.content = self.handleSummaryLabel.text;
        summaryInput.delegate = self;
        summaryInput.item = self.handleSummaryItem;
        
        [self.navigationController pushViewController:summaryInput animated:YES];
    }else if (btn == self.leftProblemItem.handleBtn){
        if (btn.selected == YES) {
            PhaseFeedBackDescInputViewController *leftProblemInput = [[PhaseFeedBackDescInputViewController alloc] init];
            leftProblemInput.delegate = self;
            leftProblemInput.item = self.leftProblemItem;
            
            [self.navigationController pushViewController:leftProblemInput animated:YES];
        }else{
            self.leftProblemDescLabel.text = @"";
        }
    }else if (btn == self.remarkItem.handleBtn){
        PhaseFeedBackDescInputViewController *remarkInput = [[PhaseFeedBackDescInputViewController alloc] init];
        remarkInput.content = self.remarkDescLabel.text;
        remarkInput.delegate = self;
        remarkInput.item = self.remarkItem;
        
        [self.navigationController pushViewController:remarkInput animated:YES];
    }
    
    [self.view setNeedsLayout];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.finishTypeTableView) {
        return self.finishTypes.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identity"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identity"];
    }
    
    if (tableView == self.finishTypeTableView) {
        KeyMap *type = self.finishTypes[indexPath.row];
        cell.textLabel.text = type.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.finishTypeTableView) {
        KeyMap *type = self.finishTypes[indexPath.row];
        self.selectedType = type;
        self.finishTypeItem.handleTypeValue.text = type.name;
        [self.finishTypeItem handleClick:self.finishTypeItem.handleBtn];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mark - PhaseFeedBackDescInputDelegate
-(void)ContentDidInputWithItem:(OrderResultItem *)item Content:(NSString *)content{
    if (item == self.handleSummaryItem) {
        self.handleSummaryLabel.text = content;
    }else if (item == self.leftProblemItem){
        self.leftProblemDescLabel.text = content;
    }else if (item == self.remarkItem){
        self.remarkDescLabel.text = content;
    }
}

-(void)queryHandleType{
    //请求数据示例
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:@"username"];
    NSString *sessionId = [defaults objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"userId":userId,@"woId":self.workOrder.woId,@"taskName":@"处理结束",@"operMBPS":@"处理结束",@"processId":@"0"};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMGetCompelteTypes";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取完成类型"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            self.finishTypes = [KeyMap objectArrayWithKeyValuesArray:dic[@"types"]];
            
            [self.finishTypeTableView reloadData];
            
            [self.view setNeedsLayout];

        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
