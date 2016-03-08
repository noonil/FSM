//
//  ResourceInfo.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/15.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ResourceInfo.h"
#import "ResourceInfoCell.h"
#import "FSMResource.h"

@interface ResourceInfo()

@property (nonatomic,strong)NSMutableArray *contactedOrdersInfo;
@end

@implementation ResourceInfo

-(void)setResource:(FSMResource *)resource
{
    _resource = resource;
    
    self.resourceName.text = _resource.resourceName;
    self.resouceCode.text = _resource.resourceNumber;
    
    //获取占用资源的人以及工单信息
    [self loadContactedOrders];
}

-(NSMutableArray *)contactedOrdersInfo
{
    if (!_contactedOrdersInfo) {
        _contactedOrdersInfo = [[NSMutableArray alloc] init];
    }
    return _contactedOrdersInfo;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setup];
    
    return self;
}

-(void)setup{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)loadContactedOrders
{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"resCode":self.resource.resourceNumber};
    
    NSString *modelName=@"FSMres";
    NSString *methodName=@"FSMGetResUserWO";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);

    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        NSLog(@"获取占用资源的人以及工单信息成功:%@",dic);
        if ([dic[@"retCode"] isEqual:@0]) {
            self.contactedOrdersInfo = dic[@"userWorkOrders"];
            [self.tableView reloadData];
        }
    } falure:^(NSError *err) {
        NSLog(@"获取占用资源的人以及工单信息失败");
    }];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

#pragma mark - datasource,delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.contactedOrdersInfo.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info = self.contactedOrdersInfo[indexPath.row];
    
    ResourceInfoCell *cell = [ResourceInfoCell cellWithTableView:tableView];
    
    cell.resourceOwner.font = [UIFont systemFontOfSize:15];
//    cell.resourceOwner.text = @"冯军伟（组长）";
    cell.resourceOwner.text = info[@"userName"];
    cell.resourceOrder.font = [UIFont systemFontOfSize:13];
//    cell.resourceOrder.text = @"石家庄外事学院正定校区-9_06-10 18:01_故障抢修_石家庄外事学院正定校区-9故障";
//    NSLog(@"woInfos:%@",info[@"woInfos"][0]);
    NSMutableString *orders = [[NSMutableString alloc] init];
    for (NSString *order in info[@"woInfos"]) {
        [orders appendString:order];
        [orders appendString:@"\n"];
    }
    cell.resourceOrder.text = orders;

    NSLog(@"cell.resourceOrder.frame:%@",NSStringFromCGRect(cell.resourceOrder.frame));
    
//    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *info = self.contactedOrdersInfo[indexPath.row];
    NSMutableString *orders = [[NSMutableString alloc] init];
    for (NSString *order in info[@"woInfos"]) {
        [orders appendString:order];
        [orders appendString:@"\n"];
    }
    //计算cell的resourceOrder的宽度
    CGFloat width = 150;
    CGSize size = [self sizeWithText:orders font:[UIFont systemFontOfSize:13] maxW:width];
    
    return (size.height+20) > 60 ? (size.height + 20) : 60;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
