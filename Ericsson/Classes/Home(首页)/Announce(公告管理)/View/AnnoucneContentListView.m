//
//  AnnoucneContentListView.m
//  Ericsson
//
//  Created by Min on 15/12/22.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "AnnoucneContentListView.h"
#import "AnnounceContentCell.h"
#import "AnnounceContentFrame.h"


@interface  AnnoucneContentListView() <UITableViewDataSource,UITableViewDelegate>



/** 存放公告内容的所有信息*/
@property (nonatomic,strong) NSMutableArray * contentFrames;

/** 按钮的容器view */
@property (nonatomic,strong) UIView * btnContainerView;
@end

@implementation AnnoucneContentListView
#pragma mark - 懒加载
- (NSMutableArray *)contentFrames
{
    if (!_contentFrames) {
        _contentFrames = [NSMutableArray array];
    }
    return _contentFrames;
}
#pragma mark - setter方法
- (void)setContentArray:(NSMutableArray *)contentArray
{
    _contentArray = contentArray;
    // 将 AnnoucneContentModel 数组 转化成 AnnoucneContentFrame数组
    NSArray * newFrames = [self contentFramesWithContentModel:contentArray];
    [self.contentFrames addObjectsFromArray:newFrames];
    [self.tableView reloadData];
}

- (void)setBtnViewHidden:(BOOL)btnViewHidden
{
    _btnViewHidden = btnViewHidden;
    self.btnContainerView.hidden = btnViewHidden;
}
#pragma mark - initialize 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        if (_contentFrames) {
            [self.contentFrames removeAllObjects];
        }
        // 设置tableView
        [self setupTableView];
        // 设置按钮
        [self setupButton];
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}
- (void)setupTableView
{
    CGFloat tableViewX = 5;
    CGFloat tableViewy = 0;
    CGFloat tableViewW = self.width - 2 * tableViewX;
    CGFloat tableViewH = self.height- 60;
    
    UITableView * tv = [[UITableView alloc]initWithFrame:CGRectMake(tableViewX, tableViewy, tableViewW, tableViewH)];
    tv.delegate = self;
    tv.dataSource = self;
    self.tableView = tv;
    [self addSubview:tv];
    
}
- (void)setupButton
{
    UIView * btnContainerView = [[UIView alloc]init];
    btnContainerView.hidden = _btnViewHidden;
    btnContainerView.backgroundColor = [UIColor whiteColor];
    btnContainerView.height = 60;
    btnContainerView.width = self.width;
    btnContainerView.x = 0;
    btnContainerView.y = self.height - btnContainerView.height - 64;
    NSLog(@"btnViewFrame - %@",NSStringFromCGRect(btnContainerView.frame));
    [self addSubview:btnContainerView];
    self.btnContainerView = btnContainerView;
    
    // 添加search按钮
    UIButton * searchBtn = [[UIButton alloc]init];
    searchBtn.width = (self.width - 10) / 2.0;
    searchBtn.height = 60;
    searchBtn.x = 0;
    searchBtn.y = 0;
    searchBtn.tag = AnnounceContentBtnSearching;
    [searchBtn setTitle:@"查找" forState:UIControlStateNormal];
    [searchBtn setBackgroundColor:[UIColor colorWithRed:29/255.0 green:95/255.0 blue:176/255.0 alpha:1]];
    [searchBtn addTarget:self action:@selector(clickSearching:) forControlEvents:UIControlEventTouchUpInside];
    [btnContainerView addSubview:searchBtn];
    
    // 添加add按钮
    UIButton * addBtn = [[UIButton alloc]init];
    addBtn.width = (self.width - 10) / 2.0;
    addBtn.height = 60;
    addBtn.x = searchBtn.width + 10.0;
    addBtn.y = 0;
    addBtn.tag = AnnounceContentBtnAdding;
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor colorWithRed:29/255.0 green:95/255.0 blue:176/255.0 alpha:1]];
    [addBtn addTarget:self action:@selector(clickAdding:) forControlEvents:UIControlEventTouchUpInside];
    [btnContainerView addSubview:addBtn];
}



#pragma mark - clickBtn Event 

- (void)clickSearching:(UIButton*)sender
{
#warning TODO - 需要添加代理
    NSLog(@"clickSearching");
    [self.delegate clickedBtnPsuhVC:(AnnounceContentBtnType)sender.tag withData:self.contentArray];
    
}
- (void)clickAdding:(UIButton*)sender
{
    NSLog(@"clickAdding");
    [self.delegate clickedBtnPsuhVC:(AnnounceContentBtnType)sender.tag withData:self.contentArray];
}



#pragma mark - TableView  Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return   self.contentFrames.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnounceContentCell * cell = [AnnounceContentCell cellWithTableView:tableView];
    
    if (self.contentFrames) {
        cell.contentFrame = self.contentFrames[indexPath.row];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnounceContentFrame * frames = self.contentFrames[indexPath.row];
    
    return frames.cellHeight;

}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate clickedCellPushVC:self.contentArray[indexPath.row] withFlag:indexPath.row];
}

/**
 *  将AnnoucneContentModel模型转为AnnoucneContentFrame模型
 */
- (NSArray*)contentFramesWithContentModel:(NSArray *)contentArray {
    NSMutableArray * frames = [NSMutableArray array];
    for (AnnounceContentModel *contentModel in contentArray) {
        AnnounceContentFrame *f = [[AnnounceContentFrame alloc]init];
        f.contentModel = contentModel;
        [frames addObject:f];
    }
    return frames;
}
@end
