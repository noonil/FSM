//
//  FeedBackInfoCell.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/1.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "FeedBackInfoCell.h"
#import "WorkOrderPhaseFeedBack.h"
#import "FeedBackInfoSectionHeaderView.h"

@implementation FeedBackInfoCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FeedBackInfoCell";
    FeedBackInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (FeedBackInfoCell *)[[[NSBundle mainBundle] loadNibNamed:@"FeedBackInfoCell" owner:nil options:nil] lastObject];
    }
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.FeedBacks.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WorkOrderPhaseFeedBack *feedBack = self.FeedBacks[section];

    return feedBack.attachFiles.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WorkOrderPhaseFeedBack *feedBack = self.FeedBacks[section];
    
    FeedBackInfoSectionHeaderView *headerView = [FeedBackInfoSectionHeaderView feedBackInfoSectionHeaderView];
    headerView.time.text = feedBack.time;
    headerView.content.text = feedBack.content;
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkOrderPhaseFeedBack *feedBack = self.FeedBacks[indexPath.section];
    WorkOrderAttachFile *attachInfo = feedBack.attachFiles[indexPath.row];
    
    FeedBackAttachmentViewCell *cell = [FeedBackAttachmentViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.attachInfo = attachInfo;
    cell.indexPath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

#pragma mark - FeedBackAttachmentViewCellDelegate
-(void)FeedBackAttachmentDeleteClick:(NSIndexPath *)indexPath{
    WorkOrderPhaseFeedBack *feedBack = self.FeedBacks[indexPath.section];
    WorkOrderAttachFile *attachInfo = feedBack.attachFiles[indexPath.row];
    
    [feedBack.attachFiles removeObject:attachInfo];

    if ([self.delegate respondsToSelector:@selector(FeedBackInfoRefreshWith:)]) {
        [self.delegate FeedBackInfoRefreshWith:self.section];
    }
    
    //发送请求删除附件
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"attachId":attachInfo.id};
    
    NSString *modelName=@"FSMAttachUpload";
    NSString *methodName=@"FSMDeleteAttachInfo";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
//    [MBProgressHUD showMessage:@"正在发送附件删除请求"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        if ([dic[@"retCode"] isEqual:@0]) {
            [MBProgressHUD showSuccess:@"附件删除成功"];
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [MBProgressHUD showError:@"附件删除失败，请重试"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [MBProgressHUD showError:@"会话超时，请重新登录"];
            
        }
//        NSLog(@"删除附件成功");
    } falure:^(NSError *err) {
//        NSLog(@"删除附件失败，错误信息:%@",err);
//        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"附件删除请求发送错误,err:%@",err]];
    }];

}
@end
