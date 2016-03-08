//
//  AnnounceContentDetailsView.h
//  Ericsson
//
//  Created by Min on 15/12/23.
//  Copyright © 2015年 范传斌. All rights reserved.

// 内容详情View

#import <UIKit/UIKit.h>
@class AnnounceContentModel;
@class AnnoucneItemDetailModel;



@protocol AnnounceContentDetailsViewEditBtn <NSObject>
- (void)editMyDraft:(NSInteger)flag;
@end



@interface AnnounceContentDetailsView : UIView

@property (nonatomic,assign) NSInteger  flag; // 点击的是哪一个cell
@property (nonatomic,weak) id<AnnounceContentDetailsViewEditBtn> delegate;
/** btn是否隐藏 如果是从草稿 就显示，其他全部隐藏 */
@property (nonatomic,assign) BOOL isHiddenEditBtn;
/** 内容数据源 */
//@property (nonatomic,strong) AnnounceContentModel * contentModel;
/** 内容数据源 */
@property (nonatomic,strong) AnnoucneItemDetailModel * contentModel;

@end
