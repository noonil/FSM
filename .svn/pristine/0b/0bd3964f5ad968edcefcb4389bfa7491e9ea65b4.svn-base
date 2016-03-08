//
//  AllAnnounceViewController.m
//  Ericsson
//
//  Created by Min on 16/1/14.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "AllAnnounceViewController.h"
#import "AnnounceContentModel.h"
#import "AnnounceContentCell.h"
#import "AnnounceContentFrame.h"
#import "SearchingAnnViewController.h"
#import "AddingAnnViewController.h"
#import "AnnounceDetails.h"


@interface AllAnnounceViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _currentPage;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 请求数据模型数组 */
@property (nonatomic,strong) NSMutableArray * announceDataArray;
/** 带尺寸的模型数组 */
@property (nonatomic,strong) NSMutableArray * anncounceFrameDataAray;


@end

@implementation AllAnnounceViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _currentPage = 1;
    
    self.title = _navTitle?_navTitle:@"";
 
    self.view.backgroundColor = KBaseGray;
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    [self.tableView addFooterWithTarget:self action:@selector(reloadNewResources)];
    
}

- (void)reloadResources{
    _currentPage = 1;
   [self requestAnnounceData];
}
- (void)reloadNewResources{
    _currentPage ++;
    [self requestAnnounceData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     [self requestAnnounceData];
}

- (void)requestAnnounceData
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [defaults objectForKey:@"sessionId"];
    NSString *userId = [defaults objectForKey:@"userId"];
    
    NSString * modelName = @"FSMAnnounce";
    NSString * methodName = nil;
    
    NSDictionary *params = nil;

        params = @{  @"userId":userId,
                     @"type":@(_annoucneType),
                     @"pageIdx":@(_currentPage)
                     };
        methodName = @"FSMGetAnnounce";
    //请求数据示例
    
    params = @{@"userId":userId,
                             @"type":@(_annoucneType),
                             @"pageIdx":@(_currentPage)
                             };
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:params];
    
    [MBProgressHUD showMessage:@"正在获取公告列表"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            
            // 将 字典数组 转换 模型数组
            NSMutableArray * modelArray = [AnnounceContentModel objectArrayWithKeyValuesArray:dic[@"announceList"]];
            NSMutableArray * newFrames = [self contentFramesWithContentModel:modelArray];
            
            if (_currentPage == 1) {
                [self.announceDataArray removeAllObjects];
                [self.anncounceFrameDataAray removeAllObjects];
            }
            
            // 将 AnnoucneContentModel 数组 转化成 AnnoucneContentFrame数组
            [self.announceDataArray addObjectsFromArray:modelArray];
            [self.anncounceFrameDataAray addObjectsFromArray:newFrames];
            [self.tableView reloadData];
            
            // ？？？？？？？
            if (modelArray == nil || modelArray == 0) {
                _currentPage --;
            }

            
        }else if([dic[@"retCode"] isEqual:@(-1)]) {
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]) {
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
            
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];

}
#pragma mark - BtnEvent
- (IBAction)searchBtn:(id)sender {
    
    SearchingAnnViewController * searchingVC = [[SearchingAnnViewController alloc]init];
    searchingVC.announceContentData = self.announceDataArray;
    searchingVC.navTitle = self.title;
    searchingVC.requestType = _annoucneType;
//    searchingVC.announceContentData = dateArray;
    [self.navigationController pushViewController:searchingVC animated:YES];
    
}

- (IBAction)addBtn:(id)sender {
    AddingAnnViewController * searchingVC = [[AddingAnnViewController alloc]init];
//    NSMutableArray * allDraftArr = [AnnounceContentModel searchWithWhere:nil orderBy:nil offset:0 count:100];
//    searchingVC.indexrow = allDraftArr.count;
    [self.navigationController pushViewController:searchingVC animated:YES];
    
}


#pragma mark - TableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.announceDataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    AnnounceContentCell * cell = [AnnounceContentCell cellWithTableView:tableView];
    
    if (self.anncounceFrameDataAray) {
        cell.contentFrame = self.anncounceFrameDataAray[indexPath.row];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnounceContentModel * contentModel = self.announceDataArray[indexPath.row];
    
    AnnounceDetails * vc    = [[AnnounceDetails alloc]init];
    vc.annoucneId           = contentModel.annouceId;
    vc.indexrow             = indexPath.row;
    vc.contentModel         = contentModel;
    if ([self.title isEqualToString:@"我的草稿"]) {
        vc.isComeFromDraft     = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnounceContentFrame * frames = self.anncounceFrameDataAray[indexPath.row];
    return frames.cellHeight;
}


#pragma mark - Lazy
- (NSMutableArray *)announceDataArray
{
    if (!_announceDataArray) {
        _announceDataArray = [NSMutableArray array];
    }
    return _announceDataArray;
}
- (NSMutableArray *)anncounceFrameDataAray
{
    if (!_anncounceFrameDataAray) {
        _anncounceFrameDataAray = [NSMutableArray array];
    }
    return _anncounceFrameDataAray;
}
#pragma mark - custome method
- (NSMutableArray*)contentFramesWithContentModel:(NSArray *)contentArray {
    NSMutableArray * frames = [NSMutableArray array];
    for (AnnounceContentModel *contentModel in contentArray) {
        AnnounceContentFrame *f = [[AnnounceContentFrame alloc]init];
        f.contentModel = contentModel;
        [frames addObject:f];
    }
    return frames;
}

@end
