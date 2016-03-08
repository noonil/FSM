
  //
//  Search_4ViewController.m
//  Ericsson
//
//  Created by slark on 15/12/24.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "Search_4ViewController.h"
#import "SparesearchViewController.h"
#import "SpareApplyTableViewCell.h"
#import "SecondSectionView.h"
#import "SparePartsAddedModel.h"
#import "SparePartList.h"
#import "SparePartStoresModel.h"
#import "SearchAssociateViewController.h"
#import "SparePartsAssociateOrderModel.h"
#import "UnclosedSpareViewController.h"
#import "WorkOrder.h"
#import "HandlingOrderDetailController.h"

/** view之间的间隔 */
#define kViewMargin 5
#define kNavigationBarHeight 64

@interface Search_4ViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray * _spareApplyArray;
    NSUserDefaults * defaults;
    __block BOOL isKeyboard;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *testView1;
@property (weak, nonatomic) IBOutlet UIView *testView4;

/** tableView */
@property (weak, nonatomic) UITableView *tableView;

@property (nonatomic,strong) NSDictionary * dicOrder;
/** applyDistination */
@property (nonatomic,strong) UIView * applyDistination;
/** 申请原因 */
@property (nonatomic,strong) UITextView * reasonText;
/** 备件目的地 */
@property (nonatomic,strong) UITextView * distinationText;

/** 列表数组 */
@property (nonatomic,strong) NSMutableArray * listDataArray;

/** 关联工单 */
@property (weak, nonatomic) IBOutlet UILabel *relatedOrderLabel;
/** 申请仓库名称 */
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;

/** 继续添加 */
- (IBAction)GoOnAddClick:(id)sender;
/** 提交申请 */
- (IBAction)commitApplicationClick:(id)sender;

@end

@implementation Search_4ViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _spareApplyArray = [NSMutableArray array];
     self.scrollView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    self.title = @"备件申请";
    //
    isKeyboard = NO;
    
    defaults = [NSUserDefaults standardUserDefaults];
    self.dicOrder = [defaults objectForKey:@"dicAssociateOrder"];
    
    // 请求数据
    self.listDataArray = [SparePartsAddedModel searchWithWhere:nil orderBy:nil offset:0 count:100];
    // 设置UI
    [self setupUI];
    [self addTapGesture];
    self.edgesForExtendedLayout=NO;
    
}
#pragma mark -隐藏键盘

-(void)handleSingleTap{
    [_reasonText resignFirstResponder];
    [_distinationText resignFirstResponder];
    isKeyboard = NO;
}

-(void)addTapGesture{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.view addGestureRecognizer:singleTap];
    singleTap.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.applyDistination.frame));

    // 判断 SparesearchViewController 控制器中saveAssociateModel模型中 是否有数据
    
    NSMutableArray * navArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [navArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:[SparesearchViewController class]]) {
            SparesearchViewController * vc = obj;
            if (vc.saveAssociateOrder.woNo) {
                self.associateOrderModel = vc.saveAssociateOrder;
                
                self.relatedOrderLabel.text = vc.saveAssociateOrder.woNo;
                self.reasonText.text        = vc.saveAssociateOrder.woFormContent;
                self.distinationText.text   = vc.saveAssociateOrder.woObj;
                return ;
            }
        }
    }];
    
    if (self.dicOrder) { // 采用字典判断
        self.relatedOrderLabel.text = _dicOrder[@"woNumber"];
        self.associateOrderModel.woId   = _dicOrder[@"woId"];
        _reasonText.text            = _dicOrder[@"applyReason"];
        _distinationText.text       = _dicOrder[@"applyDestination"];
        
        // 保存数据
        self.associateOrderModel.woNo   = _dicOrder[@"woNumber"];
        self.associateOrderModel.woFormContent = _dicOrder[@"applyReason"];
        self.associateOrderModel.woObj   = _dicOrder[@"applyDestination"];
        
        [defaults removeObjectForKey:@"dicAssociateOrder"];
    }
}
- (void)setupUI
{
    // setup
    self.storeNameLabel.text = _storeModel_4.storeroomName;
    
  
    
    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.testView4.frame)+2, KIphoneWidth, _listDataArray.count * 52) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    self.tableView = table;
    [self.scrollView addSubview:table];
    
  
    UIView * applyReason = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(table.frame)+5, KIphoneWidth, 50)];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 50)];
    label.text = @"申请原因 :";
    UITextView * reason = [[UITextView alloc]initWithFrame:CGRectMake(115, 5, 220, 40)];
    reason.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    reason.font = [UIFont systemFontOfSize:18.0];
    self.reasonText = reason;
    
    [applyReason addSubview:reason];
    [applyReason addSubview:label];
    applyReason.backgroundColor = [UIColor whiteColor];
    
    
    UIView * applyDistination = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(applyReason.frame)+5, KIphoneWidth, 50)];
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 50)];
    
    label2.text = @"备件目的地 :";
    
    UITextView * distionation = [[UITextView alloc]initWithFrame:CGRectMake(115, 5, 220, 40)];
    distionation.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    distionation.font = [UIFont systemFontOfSize:18.0];
    self.distinationText = distionation;

    [applyDistination addSubview:label2];
    [applyDistination addSubview:distionation];
    applyDistination.backgroundColor = [UIColor whiteColor];
    self.applyDistination = applyDistination;
    [self.scrollView addSubview:applyReason];
    [self.scrollView addSubview:applyDistination];
    
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
// 通知键盘
- (void)keyBoardWillChangeFrame:(NSNotification *)notification
{
    // 如果正在切换键盘，就不要执行后面的代码
    NSDictionary * userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        if (keyboardF.origin.y >=  screenHeight) { // 键盘的Y值已经远远超过了控制器view的高度
            //            self.distinationText.y = self.view.height - self.distinationText.height;
            self.view.y = 64.0;
            isKeyboard = NO;
            
        } else {
            
            if (isKeyboard) return ;
          
            self.view.y = self.view.y - keyboardF.size.height;// - 64;
            isKeyboard = YES;
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SparePartsAddedModel * model = _listDataArray[indexPath.
row];
        SpareApplyTableViewCell * cell = [SpareApplyTableViewCell cellWithTableView:tableView];
    cell.spareName.text =model.sparePartName;
    cell.spareType.text = model.sparePartType;
    cell.applyNum.text  = model.spareApplyNum;
    cell.editing = YES;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SparePartsAddedModel * selectModel = self.listDataArray[indexPath.row];
        // 把数据删除  然后刷新tableView
    [self.listDataArray removeObjectAtIndex:indexPath.row];
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [SparePartsAddedModel deleteToDB:selectModel];

}

#pragma mark - Button Event
- (IBAction)GoOnAddClick:(id)sender
{
    /**************************************
     *  设置当继续添加后，把导航控制器中的栈，删除 直接跳转到条件查询页面
     *
     *  1.当备件中查询的时候，删除数组中
     *  2.当用户从 工单中点击过来的时候，需要删除后面的4个控制器
     */
    
//    NSLog(@"%@",self.navigationController.viewControllers);
    // 初始化
    SparesearchViewController * searchVC = [[SparesearchViewController alloc]init];
    searchVC.saveAssociateOrder =  self.associateOrderModel;
    
    NSMutableArray * navArray  = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSRange range;
    range.location  = 0;
    range.length    = navArray.count - 5;
    NSArray * newNavArray = [navArray subarrayWithRange:range];
    NSMutableArray * newNavArr = [NSMutableArray arrayWithArray:newNavArray];
    [newNavArr addObject:searchVC];
    [self.navigationController setViewControllers:newNavArr];
}

- (IBAction)commitApplicationClick:(id)sender {
    
    if ([self.relatedOrderLabel.text isEqualToString:@"未进行工单关联"]) {
        
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未关联工单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关联工单",nil];
        alert.tag = 11;
        [alert show];
        return ;
    }
    // 选择了关联工单
    
    if ([self.reasonText.text isEqualToString:@""]) {
        [self.view makeToast:@"请填写申请原因"];
        return;
    }
    // 提交申请 --> 申请成功后 跳转页面
    [self submitSpareApply];
   
}
// 提交申请
- (void)submitSpareApply
{
    NSMutableArray * spares = [[NSMutableArray alloc]init];
    for (SparePartsAddedModel * model in self.listDataArray) {
        NSDictionary * dic = @{
                               @"sparePartId":model.sparePartId,
                               @"applyNumber":model.spareApplyNum
                               };
        [spares addObject:dic];
    }
    
    NSDictionary *params = @{@"woId":self.associateOrderModel.woId,
                             @"storeRoomId":_storeModel_4.storeroomId,
                             @"applyReason":_reasonText.text,
                             @"destination":_distinationText.text,
                             @"spares":spares
                             };
    
    NSString *modelName=@"FSMSparePart";
    NSString *methodName=@"FSMApplySparePart";
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    
    [MBProgressHUD showMessage:@"正在提交备件申请列表"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"]  isEqual: @0]) {
            
            BOOL fromWorkOrder;//是否从工单跳转过来
            fromWorkOrder=false;
            
            //  NSArray *vcArray=self.navigationController.viewControllers;
            NSMutableArray *navVCsArray=[NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            for (long i=navVCsArray.count-1; i>0; i--) { // 是否从工单跳转过来的
                UIViewController *vc=navVCsArray[i];
                if ([vc isMemberOfClass:[HandlingOrderDetailController class]])
                {
//                    HandlingOrderDetailController * handling = (HandlingOrderDetailController*)vc;
//                    // [self setValue:@NO forKeyPath:handling.popButtonView.hidden];
//                    handling.popButtonView.hidden = NO;
                    fromWorkOrder=true;
                    break;
                }
            }
            
            for (long i=navVCsArray.count-1; i>0; i--) {
                UIViewController *vc=navVCsArray[i];
                //如果不是从工单跳转过来的，跳转 未申请工单
                if ( /*[vc isMemberOfClass:[Search_4ViewController class]] &&*/ fromWorkOrder == false){ // 把栈控制器删除中间的
                
                    UnclosedSpareViewController * unClosed = [[UnclosedSpareViewController alloc]init];
                    unClosed.isColosed = @"1";
                    unClosed.navTitle = @"未关闭申请单";
                    // 重置 导航控制器 栈
                    
                    [navVCsArray addObject:unClosed];
                    NSRange range = {2,5};
                    NSArray * array = [navVCsArray subarrayWithRange:range];
                    [navVCsArray removeObjectsInArray:array];
                    
                    [self.navigationController setViewControllers:navVCsArray animated:YES];
                    break;
                    
                }
                else if ( [vc isMemberOfClass:[HandlingOrderDetailController class]] && fromWorkOrder==true){
                    
                    //如果是从工单跳转过来的，跳转到我的申请页面
                    UnclosedSpareViewController * unClosed = [[UnclosedSpareViewController alloc]init];
                    unClosed.isColosed = @"1";
                    unClosed.navTitle = @"未关闭申请单";
                    [navVCsArray addObject:unClosed];
                    
                    [self.navigationController setViewControllers:navVCsArray];
                    //  [self.navigationController pushViewController:myVc animated:YES];
                    break;
                }
                else{
                    [navVCsArray removeObject:vc];
                }
            }
            [LKDBHelper clearTableData:[SparePartsAddedModel class]];
            // 成功后删除数据库中所有申请的工单
//            [self clearApplyData];
            
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
        [MBProgressHUD hideHUD];
    } falure:^(NSError *err) {
        
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
}

- (void)clearApplyData
{
    
    // 请求数据
    self.listDataArray = [SparePartsAddedModel searchWithWhere:nil orderBy:nil offset:0 count:100];
    self.reasonText.text        = @"";
    self.distinationText.text   = @"";
    [_tableView reloadData];
}
#pragma mark - delete
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) return;
    [self associateOrder];
  
}
- (void)associateOrder
{
    // 进行关联工单
    SearchAssociateViewController * associate = [[SearchAssociateViewController alloc]init];
    // 回调
    associate.settingBlock = ^(SparePartsAssociateOrderModel * orderOrderModel){
        self.associateOrderModel = orderOrderModel;
        
        self.relatedOrderLabel.text = orderOrderModel.woNo;
        self.reasonText.text        = orderOrderModel.woFormContent;
        self.distinationText.text   = orderOrderModel.woObj;
        //        [self viewWillLayoutSubviews];
    };
    
    [self.navigationController pushViewController:associate animated:YES];

}
- (void)deleteTheOrder
{
    NSLog(@"sssss");

}
#pragma mark - Lzay
- (SparePartsAssociateOrderModel *)associateOrderModel
{
    if (!_associateOrderModel) {
        _associateOrderModel = [[SparePartsAssociateOrderModel alloc]init];
    }
    return _associateOrderModel;
}
@end
