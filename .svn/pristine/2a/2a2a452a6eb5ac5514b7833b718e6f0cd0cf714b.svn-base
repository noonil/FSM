//
//  AnnounceDetails.m
//  Ericsson
//
//  Created by Min on 15/12/22.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "AnnounceDetails.h"
#import "AnnounceContentModel.h"
#import "AnnounceContentDetailsView.h"
#import "AddingAnnViewController.h"
#import "AnnoucneItemDetailModel.h"

@interface AnnounceDetails ()<AnnounceContentDetailsViewEditBtn>

@property (nonatomic,strong) AnnounceContentDetailsView * contentView;
@end

@implementation AnnounceDetails

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置内容详细
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.title = @"公告详情";
    
    // 设置内容详情
    AnnounceContentDetailsView * contentView = [[AnnounceContentDetailsView alloc]init];
    
    contentView.flag        = self.flag;
    contentView.delegate    = self;
    contentView.isHiddenEditBtn = self.isComeFromDraft;
    contentView.x       = 0;
    contentView.y       = 0;
    contentView.width   = self.view.width;
    contentView.height  = self.view.height;
    self.contentView    = contentView;
    [self.view addSubview:contentView];
    
    [self requestDetailData];

}
/** 数据请求
 FSMGetAnnounceDetail
 userId
 announceId
 */
- (void)requestDetailData
{
    if (self.isComeFromDraft) { // 如果是 上级是草稿，就直接从模型中获取数据
        self.contentView.contentModel = (AnnoucneItemDetailModel *)self.contentModel;
        return;
    }
    //请求数据示例
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *sessonId      = [defaults objectForKey:@"sessionId"];
    NSString *userId        = [defaults objectForKey:@"userId"];
    NSString * modelName    = @"FSMAnnounce";
    NSString * methodName   = @"FSMGetAnnounceDetail";
    NSDictionary *params    = @{@"userId":userId,
                                @"announceId":_annoucneId
                                };
    NSString *sopeStr       =
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    
    [MBProgressHUD showMessage:@"正在请求数据..."];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            
            
            AnnoucneItemDetailModel * model = [[AnnoucneItemDetailModel alloc]init];
            [model setValuesForKeysWithDictionary:dic[@"announceItemDetail"]];
            self.contentView.contentModel = model;
            
            
        }else if([dic[@"retCode"] isEqual:@(-1)]) {
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]) {
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
        
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发送错误"];
    }];
}

- (void)editMyDraft:(NSInteger)flag
{
    AddingAnnViewController * add = [[AddingAnnViewController alloc]init];
    
    add.annModel = self.contentModel;
    add.flag = flag;
    add.indexrow = self.indexrow + 1;
    [self.navigationController pushViewController:add animated:YES];

}

@end
