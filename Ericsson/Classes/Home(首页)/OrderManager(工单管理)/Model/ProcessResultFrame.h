//
//  ProcessResultFrame.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/18.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProcessResult;

@interface ProcessResultFrame : NSObject
@property (nonatomic,strong)ProcessResult *processResult;
//@property (nonatomic,assign)BOOL isElectric;//是否是发电类工单

/**
 *  处理总结title
 */
@property (nonatomic,assign)CGRect handleSummaryTitleF;
/**
 *  处理总结value
 */
@property (nonatomic,assign)CGRect handleSummaryValueF;
/**
 *  备注title
 */
@property (nonatomic,assign)CGRect remarkTitleF;
/**
 *  备注value
 */
@property (nonatomic,assign)CGRect remarkValueF;
/**
 *  完成类型title
 */
@property (nonatomic,assign)CGRect finishTypeTitleF;
/**
 *  完成类型value
 */
@property (nonatomic,assign)CGRect finishTypeValueF;
/**
 *  遗留问题title
 */
@property (nonatomic,assign)CGRect legacyProblemDescTitleF;
/**
 *  遗留问题value
 */
@property (nonatomic,assign)CGRect legacyProblemDescValueF;

/**
 *  实际结束时间title
 */
@property (nonatomic,assign)CGRect endTimeTitleF;
/**
 *  实际结束时间value
 */
@property (nonatomic,assign)CGRect endTimeValueF;
/**
 *  发电时长title
 */
@property (nonatomic,assign)CGRect powerTimeTitleF;
/**
 *  发电时长value
 */
@property (nonatomic,assign)CGRect powerTimeValueF;



/**
 *  cell高度
 */
@property (nonatomic,assign)CGFloat cellHeight;
@end
