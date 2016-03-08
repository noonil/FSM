//
//  AnnoucneContentListView.h
//  Ericsson
//
//  Created by Min on 15/12/22.
//  Copyright © 2015年 范传斌. All rights reserved.

// 每个公告的 公告列表 == tableView + Button 

#import <UIKit/UIKit.h>

typedef enum {
    AnnounceContentBtnSearching = 0, // 查找
    AnnounceContentBtnAdding = 1 // 添加
}AnnounceContentBtnType;

@class AnnounceContentFrame;
@class AnnounceContentModel;
@protocol AnnoucneContentListViewDelegate;




@interface AnnoucneContentListView : UIView
@property (nonatomic,weak) id<AnnoucneContentListViewDelegate> delegate;

@property (nonatomic,strong) UITableView * tableView;

/** 公告内容数据  NSMutableArray*/
@property (nonatomic,strong) NSMutableArray * contentArray;
/** 按钮的显示与否 */
@property (nonatomic,assign) BOOL  btnViewHidden;

@end




@protocol AnnoucneContentListViewDelegate <NSObject>
@optional
/** 点击cell 进行跳转 */
- (void)clickedCellPushVC:(AnnounceContentModel *)contentModel withFlag:(NSInteger)flag;
/** 点击按钮 跳转到新控制器 */
- (void)clickedBtnPsuhVC:(AnnounceContentBtnType)type withData:(NSMutableArray *)dateArray;
@end