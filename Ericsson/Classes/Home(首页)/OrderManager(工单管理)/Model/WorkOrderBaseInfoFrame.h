//
//  WorkOrderBaseInfoFrame.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/18.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WorkOrderBaseInfo;

@interface WorkOrderBaseInfoFrame : NSObject

@property (nonatomic,strong)WorkOrderBaseInfo *baseInfo;
/**
 *  维护对象类型title
 */
@property (nonatomic,assign)CGRect maintenanceObjectTypeTitleF;
/**
 *  维护对象类型value
 */
@property (nonatomic,assign)CGRect maintenanceObjectTypeValueF;
/**
 *  维护对象类型seprator
 */
@property (nonatomic,assign)CGRect maintenanceObjectTypeSepratorF;

/**
 *  维护对象等级title
 */
@property (nonatomic,assign)CGRect maintenanceObjectLevelTitleF;
/**
 *  维护对象等级value
 */
@property (nonatomic,assign)CGRect maintenanceObjectLevelValueF;
/**
 *  维护对象等级seprator
 */
@property (nonatomic,assign)CGRect maintenanceObjectLevelSepratorF;

/**
 *  优先级title
 */
@property (nonatomic,assign)CGRect priorityTitleF;
/**
 *  优先级value
 */
@property (nonatomic,assign)CGRect priorityValueF;
/**
 *  优先级seprator
 */
@property (nonatomic,assign)CGRect prioritySepratorF;

/**
 *  工单类别title
 */
@property (nonatomic,assign)CGRect woTypeTitleF;
/**
 *  工单类别value
 */
@property (nonatomic,assign)CGRect woTypeValueF;
/**
 *  工单类别seprator
 */
@property (nonatomic,assign)CGRect woTypeSepratorF;

/**
 *  告警级别title
 */
@property (nonatomic,assign)CGRect alertRuleTitleF;
/**
 *  告警级别value
 */
@property (nonatomic,assign)CGRect alertRuleValueF;
/**
 *  告警级别seprator
 */
@property (nonatomic,assign)CGRect alertRuleSepratorF;

/**
 *  工单编号title
 */
@property (nonatomic,assign)CGRect woNumberTitleF;
/**
 *  工单编号value
 */
@property (nonatomic,assign)CGRect woNumberValueF;
/**
 *  工单编号seprator
 */
@property (nonatomic,assign)CGRect woNumberSepratorF;

/**
 *  要求达到时间title
 */
@property (nonatomic,assign)CGRect planArriveTimeTitleF;
/**
 *  要求达到时间value
 */
@property (nonatomic,assign)CGRect planArriveTimeValueF;
/**
 *  要求达到时间seprator
 */
@property (nonatomic,assign)CGRect planArriveTimeSepratorF;

/**
 *  要求完成时间title
 */
@property (nonatomic,assign)CGRect planFinishTimeTitleF;
/**
 *  要求完成时间value
 */
@property (nonatomic,assign)CGRect planFinishTimeValueF;
/**
 *  要求完成时间seprator
 */
@property (nonatomic,assign)CGRect planFinishTimeSepratorF;

/**
 *  内容描述title
 */
@property (nonatomic,assign)CGRect contentDescribeTitleF;
/**
 *  内容描述value
 */
@property (nonatomic,assign)CGRect contentDescribeValueF;
/**
 *  内容描述seprator
 */
@property (nonatomic,assign)CGRect contentDescribeSepratorF;

/**
 *  工单影响范围title
 */
@property (nonatomic,assign)CGRect scopeTitleF;
/**
 *  工单影响范围value
 */
@property (nonatomic,assign)CGRect scopeValueF;
/**
 *  工单影响范围seprator
 */
@property (nonatomic,assign)CGRect scopeSepratorF;

/**
 *  工单状态title
 */
@property (nonatomic,assign)CGRect stateTitleF;
/**
 *  工单状态value
 */
@property (nonatomic,assign)CGRect stateValueF;
/**
 *  工单状态seprator
 */
@property (nonatomic,assign)CGRect stateSepratorF;

/**
 *  cell高度
 */
@property (nonatomic,assign)CGFloat cellHeight;

@end
