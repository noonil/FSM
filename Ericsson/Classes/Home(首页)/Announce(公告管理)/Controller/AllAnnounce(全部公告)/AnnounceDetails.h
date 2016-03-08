//
//  AnnounceDetails.h
//  Ericsson
//
//  Created by Min on 15/12/22.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AnnounceContentModel;

@interface AnnounceDetails : BaseViewController

@property (nonatomic,assign)NSInteger indexrow;
/** 标记为已阅读 */
@property (nonatomic,assign) BOOL isReaded;

@property (nonatomic,assign) NSInteger  flag;

@property (nonatomic,assign) BOOL  isComeFromDraft;

/** 字典内容数据 */
@property (nonatomic,strong)  AnnounceContentModel * contentModel;
/** announceId */
@property (nonatomic,copy) NSString * annoucneId;
@end
