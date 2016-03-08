//
//  AddingAnnViewController.m
//  Ericsson
//
//  Created by Min on 15/12/23.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "AddingAnnViewController.h"
#import "AddAnnoucneTitleVC.h"
#import "AddAnnounceDepartmentVC.h"
#import "AnnounceContentModel.h"
#import "AllAnnounceViewController.h"
#import "RMDateSelectionViewController.h"
@interface AddingAnnViewController () <addAnnoucneTitleVCDelegate,AddAnnounceDepartmentVCDelegate>
{
    BOOL btnFlag; // 判断点击的是标题按钮还是内容按钮 YES为标题按钮/NO为内容按钮
}
// 是否包含子部门
@property (weak, nonatomic) IBOutlet UIButton *isContainSubDepart;

/** 标题Label */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 内容Label */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/** 部门Label */
@property (weak, nonatomic) IBOutlet UILabel *departLabel;
/** 有效时间 */
@property (weak, nonatomic) IBOutlet UITextField *timeLabel;


/** 保存点击了哪一个组织 */
@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,assign) NSInteger chooseSection;

/** 是否包含部门 */
@property (nonatomic,assign) BOOL isContainDepart;
/** 覆盖view*/
@property (nonatomic,strong) UIView * coverView;
/** 时间选择器 */
@property (nonatomic,strong) UIDatePicker * datePicker;

@end


@implementation AddingAnnViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chooseSection = NSNotFound;
    self.title = @"添加公告";
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.annModel) { // 如果有值，则表明是进行编辑的。
        self.titleLabel.text    = _annModel.title; // 设置标题
        self.contentLabel.text  = _annModel.content; // 设置内容
        self.timeLabel.text     = _annModel.availableTime;// 设置有效时间
        self.departLabel.text   = _annModel.departText;
        
        // 如果，section和row有值的话 则表示  添加的
        if (_annModel.section || _annModel.row || _annModel.selectedSection != NSNotFound) {
            
            if (_annModel.selectedSection != NSNotFound) {
                self.chooseSection = _annModel.selectedSection;
                
            }else{
            self.indexPath = [NSIndexPath indexPathForRow:_annModel.row inSection:_annModel.section];
            }
        }
        
        self.isContainSubDepart.selected = _annModel.isContainSubDepart;
        self.isContainDepart    = _annModel.isContainSubDepart;
        self.annModel = nil; // 把annModel置为空，因为后面需要修改
    }
    
}
- (void)setupTime:(UITextField*)textField
{
    RMAction *selectAction = [RMAction actionWithTitle:@"确认" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        NSLog(@"Successfully selected date: %@", ((UIDatePicker *)controller.contentView).date);
        
        textField.text = [self stringFromDate:((UIDatePicker *)controller.contentView).date];
    }];
    
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Date selection was canceled");
    }];
    
    //Create date selection view controller
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleDefault selectAction:selectAction andCancelAction:cancelAction];
    
    dateSelectionController.title = @"日期选择";
    //        dateSelectionController.message = @"This is a test message.\nPlease choose a date and press 'Select' or 'Cancel'.";
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}
#pragma mark - 按钮事件
// 标题按钮
- (IBAction)titleBtn_TouchUpInside:(id)sender {
    btnFlag = YES;
    AddAnnoucneTitleVC * addTieleOrContentVC = [[AddAnnoucneTitleVC alloc]init];
    addTieleOrContentVC.titleVC = @"标题";
    addTieleOrContentVC.titleContent = self.titleLabel.text;
    //委托代理
    addTieleOrContentVC.delegate = self;
    [self.navigationController pushViewController:addTieleOrContentVC animated:YES];
}
// 内容按钮
- (IBAction)contentBtn_TouchUpInside:(id)sender {
    btnFlag = NO;
    AddAnnoucneTitleVC * addTieleOrContentVC = [[AddAnnoucneTitleVC alloc]init];
    addTieleOrContentVC.titleContent = self.contentLabel.text;
    addTieleOrContentVC.titleVC = @"内容";
    //委托代理
    addTieleOrContentVC.delegate = self;
    [self.navigationController pushViewController:addTieleOrContentVC animated:YES];
}
// 选择组织按钮
- (IBAction)organizeTouchUpInside:(id)sender {
    
    AddAnnounceDepartmentVC * departmentVC = [[AddAnnounceDepartmentVC alloc]init];
    
    if (self.chooseSection != NSNotFound) {
        departmentVC.selectedSection    = self.chooseSection;
    }else{
        departmentVC.selectedCell       = self.indexPath;
    }
    
    departmentVC.delegate           = self;
    [self.navigationController pushViewController:departmentVC animated:YES];
}
// 是否包含部门按钮
- (IBAction)containChildOrg_TouchUpInside:(UIButton*)sender {
    sender.selected = !sender.selected;
    self.isContainDepart = sender.selected;
}
// 存为草稿
- (IBAction)saveDraftBtn_TouchUpInside:(id)sender {
    /*
     “retCode”:”x” ;     0:请求成功  -1:请求失败  -2:回话sessionId 失效
     “announceList”:[{
     "hasRead": true,    是否已读过 true :读过  false:未读
     "name": "刘伟鹏",    名字
     "departName": "栾城县小组",   部门名字
     "content": "哦哦娶了",    内容
     "time": "2015-10-10 17:05:01",   时间
     "annouceId": "1305",    公告id
     "title": "唐家三少"     标题
     }]
     */
    AnnounceContentModel * draft = [[AnnounceContentModel alloc]init];
    
    if (self.indexrow > 0) { // 草稿的编辑
        NSMutableArray * allDraftArr = [AnnounceContentModel searchWithWhere:nil orderBy:nil offset:0 count:100];
        
        draft = allDraftArr[self.indexrow - 1];
        draft.title = self.titleLabel.text;
        draft.hasRead = nil;
        draft.name = @"222222";
        draft.annouceId = nil;
        draft.content = self.contentLabel.text;
        draft.departText = self.departLabel.text;
        draft.departName = @"222222";
        draft.time = [self stringFromDate:[NSDate date]];

        if (self.chooseSection == NSNotFound) {
            draft.section   = self.indexPath.section;
            draft.row       = self.indexPath.row;
        }
        draft.selectedSection       = self.chooseSection;
        draft.availableTime         = self.timeLabel.text;
        draft.isContainSubDepart    = self.isContainDepart;

    }else { // 直接添加的
        draft.title = self.titleLabel.text;
        draft.hasRead = nil;
        draft.name = @"222222";
        draft.annouceId     = nil;
        draft.content       = self.contentLabel.text;
        draft.departText = self.departLabel.text;
        draft.departName    = @"222222";
        draft.time = [self stringFromDate:[NSDate date]];
        
        if (self.chooseSection == NSNotFound) {
            draft.section   = self.indexPath.section;
            draft.row       = self.indexPath.row;
        }
        
        draft.selectedSection   = self.chooseSection;
        draft.availableTime         = self.timeLabel.text;
        draft.isContainSubDepart    = self.isContainDepart;

    }
    [draft saveToDB];
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"已存为草稿,请在“我的草稿”中查看" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    // 重置label中的值 为空
//    [self setUpLabelTextToNull];
}
/**
 requestModel  :  FSMAnnounce模块名
 requestMethod  : FSMQueryAnnounce方法名
 
 sessionId     :   会话id
 requestData   :{
 “userId”:””,   用户id
 “title”:””,    标题
 “content”:””,  内容
 “organizeId”:””  组织id
 “organizeName”:””, 组织名
 “containChildOrg”:””,  是否包含子组织,true:包含 false : 不包含
 “attachFileName”:””,  附件名(暂时不传附件,直接给null)
 “availableTime”:””    有效时间  yyyy-MM-dd
 }
 */
// 发布按钮
- (IBAction)submitBtn_TouchUpInside:(id)sender {
    
//    判断是否有未填的项目
    if ([self.titleLabel.text isEqualToString:@""] ||
        [self.contentLabel.text isEqualToString:@""] ||
        [self.departLabel.text isEqualToString:@""] ||
        [self.timeLabel.text isEqualToString:@""]) {
        
        [self.view makeToast:@"内容添加不完整，无法发布"];
        return;
    }
    // 请求数据
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:@"username"];
    NSString *sessionId = [defaults objectForKey:@"sessionId"];

    NSDictionary *params = @{
                             @"userId":userId,
                             @"title":self.titleLabel.text?self.titleLabel.text:@"",
                             @"content":self.contentLabel.text?self.contentLabel.text:@"",
                             @"organizeId":@(1),
                             @"organizeName":self.departLabel.text?self.departLabel.text:@"",
                             @"containChildOrg":_isContainDepart?@"true":@"false",
                             @"attachFileName":@"",
                             @"availableTime":_timeLabel.text?_timeLabel.text:@""
                             };
    
    NSString * sopeStr = [[SoapUtility shareInstance]BuildSoapWithModelName:@"FSMAnnounce" methodName:@"FSMPostAnnounce" sessonId:sessionId requestData:params];
    
    [MBProgressHUD showMessage:@"正在发布数据,请稍后"];
    
    // 异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            
            // 发布成功 --> 跳转到 我的公告列表
            [self setUpLabelTextToNull];
            
            if (self.indexrow > 0) {// 如果是从 草稿编辑的 删除草稿中数据
            [self deleteDraftData];
            }
            
            NSArray *navArray = self.navigationController.viewControllers;
            
            NSMutableArray * newNavArray = [[NSMutableArray alloc]init];

            for (int i = 0; i < 2; i++) {
                [newNavArray addObject:navArray[i]];
            }
            
            
            AllAnnounceViewController * vc = [[AllAnnounceViewController alloc]init];
            vc.navTitle = @"全部公告";
            vc.annoucneType = 0;
            [newNavArray addObject:vc];
            [self.navigationController setViewControllers:newNavArray];
            
            
        }else if([dic[@"retCode"] isEqual:@(-1)]) {
            
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]) {
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
    } falure:^(NSError *response) {
        NSLog(@"response : %@",response);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
        
    }];
}
// 发布成功，删除草稿中编辑的数据
- (void)deleteDraftData
{
    AnnounceContentModel * draft = [[AnnounceContentModel alloc]init];
    
    if (self.indexrow > 0) {
        NSMutableArray * allDraftArr = [AnnounceContentModel searchWithWhere:nil orderBy:nil offset:0 count:100];
        
        draft = allDraftArr[self.indexrow - 1];
        [AnnounceContentModel deleteToDB:draft];
    }
}
// 将Label的text置为空
- (void)setUpLabelTextToNull
{
    // 重置label中的值 为空
    self.titleLabel.text    = @"";
    self.contentLabel.text  = @"";
    self.departLabel.text   = @"";
    self.timeLabel.text     = @"";
    self.isContainDepart    = NO;
    self.isContainSubDepart.selected = NO;
    
}
// 有效时间
- (IBAction)timeSelectedBtn:(id)sender {
    [self setupTime:self.timeLabel];
}


#pragma mark - Delegate
- (void)submitBtnSelected:(NSString *)content
{
    if (btnFlag) { // YES 为标题按钮
        self.titleLabel.text = content;
    }else { // NO 为内容按钮
        self.contentLabel.text = content;
    }
}

// 代理回调，把所有的值 存放的数据库中
- (void)submitDepartmentSelected:(NSString *)depart indexPath:(NSIndexPath *)selectedCell integer:(NSInteger)selectedSection
{
    self.departLabel.text = depart;
    self.indexPath      = selectedCell; // 如果有值，则表示为选择的是cell
    self.chooseSection  = selectedSection; // 选中的section，如果是为NSNotFound则选择的是cell
}

#pragma mark - others
// datePicker上的时间 转换成  NSString格式
- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * str = [formatter stringFromDate:date];
    return str;
}

// 把NSString 转换成 NSDate
- (NSDate *)dateFromString:(NSString*)dateString
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [formatter dateFromString:dateString];
    return date;
}
@end


// 删除之前的
//    NSString * sqlStr = [NSString stringWithFormat:@"select *from @t where rowid = '%ld'",self.flag+ 1];
//    NSMutableArray * announeceArray = [[MyLKDBHelper getUsingLKDBHelper]searchWithSQL:sqlStr toClass:[AnnounceContentModel class]];
//    for (AnnounceContentModel * model in announeceArray) {
//        [AnnounceContentModel deleteToDB:model];
//    }
//