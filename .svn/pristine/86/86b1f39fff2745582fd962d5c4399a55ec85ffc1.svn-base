//
//  AnnounceContentFrame.h
//  Ericsson
//
//  Created by Min on 15/12/22.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AnnounceContentModel;


// 标题字体
#define AnnounceTitleFont [UIFont systemFontOfSize:20]
// 内容字体
#define AnnoucneContentFont [UIFont systemFontOfSize:18]
// 时间 名字 部门
#define AnnounceOthersFont [UIFont systemFontOfSize:16]

/** 时间 名字 部门 之间的间隔*/
#define AnnouceothersBoarder 10
// cell的间距
#define AnnounceCellMargin 15

@interface AnnounceContentFrame : NSObject

@property (nonatomic,strong) AnnounceContentModel * contentModel;

/** 顶部的灰色视图 */
@property (nonatomic,assign) CGRect grayViewF;

/** cell的内容View */
@property (nonatomic,assign) CGRect contentVF;

/** 标题label*/
@property (nonatomic,assign) CGRect titleLabelF;
/** 内容label*/
@property (nonatomic,assign) CGRect contentLabelF;
/** 名字label*/
@property (nonatomic,assign) CGRect nameLabelF;
/** 部门名字label*/
@property (nonatomic,assign) CGRect departNameLabelF;
/** 时间label*/
@property (nonatomic,assign) CGRect timeLabelF;

/** cell的高度 */
@property (nonatomic,assign) CGFloat cellHeight;

@end
