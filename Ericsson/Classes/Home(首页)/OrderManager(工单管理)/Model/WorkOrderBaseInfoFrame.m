//
//  WorkOrderBaseInfoFrame.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/18.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#define FSMTitleFont [UIFont boldSystemFontOfSize:17]
#define FSMValueFont [UIFont systemFontOfSize:13]

#import "WorkOrderBaseInfoFrame.h"
#import "WorkOrderBaseInfo.h"

@implementation WorkOrderBaseInfoFrame

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

-(void)setBaseInfo:(WorkOrderBaseInfo *)baseInfo{
    _baseInfo = baseInfo;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /**
     *  维护对象类型title
     */
    self.maintenanceObjectTypeTitleF = CGRectMake(5, 0, cellW, 30);
    /**
     *  维护对象类型value
     */
    CGSize maintenanceObjectTypeValueSize = [self sizeWithText:baseInfo.maintenanceObjectType font:FSMValueFont maxW:cellW];
    self.maintenanceObjectTypeValueF = CGRectMake(5, CGRectGetMaxY(self.maintenanceObjectTypeTitleF), cellW, maintenanceObjectTypeValueSize.height);
    
    /**
     *  维护对象类型seprator
     */
    self.maintenanceObjectTypeSepratorF = CGRectMake(5, CGRectGetMaxY(self.maintenanceObjectTypeValueF), cellW, 1);
    
    /**
     *  维护对象等级title
     */
    self.maintenanceObjectLevelTitleF = CGRectMake(5, CGRectGetMaxY(self.maintenanceObjectTypeSepratorF), cellW, 30);

    /**
     *  维护对象等级value
     */
    CGSize maintenanceObjectLevelValueSize = [self sizeWithText:baseInfo.maintenanceObjectLevel font:FSMValueFont maxW:cellW];
    self.maintenanceObjectLevelValueF = CGRectMake(5, CGRectGetMaxY(self.maintenanceObjectLevelTitleF), cellW, maintenanceObjectLevelValueSize.height);

    /**
     *  维护对象等级seprator
     */
    self.maintenanceObjectLevelSepratorF = CGRectMake(5, CGRectGetMaxY(self.maintenanceObjectLevelValueF), cellW, 1);
    
    /**
     *  优先级title
     */
    self.priorityTitleF = CGRectMake(5, CGRectGetMaxY(self.maintenanceObjectLevelSepratorF), cellW, 30);

    /**
     *  优先级value
     */
    CGSize priorityValueSize = [self sizeWithText:baseInfo.priority font:FSMValueFont maxW:cellW];
    self.priorityValueF = CGRectMake(5, CGRectGetMaxY(self.priorityTitleF), cellW, priorityValueSize.height);

    /**
     *  优先级seprator
     */
    self.prioritySepratorF = CGRectMake(5, CGRectGetMaxY(self.priorityValueF), cellW, 1);
    
    
    /**
     *  工单类别title
     */
    self.woTypeTitleF = CGRectMake(5, CGRectGetMaxY(self.prioritySepratorF), cellW, 30);

    /**
     *  工单类别value
     */
    CGSize woTypeValueSize = [self sizeWithText:baseInfo.woType font:FSMValueFont maxW:cellW];
    self.woTypeValueF = CGRectMake(5, CGRectGetMaxY(self.woTypeTitleF), cellW, woTypeValueSize.height);

    /**
     *  工单类别seprator
     */
    self.woTypeSepratorF = CGRectMake(5, CGRectGetMaxY(self.woTypeValueF), cellW, 1);
    
    
    /**
     *  告警级别title
     */
    self.alertRuleTitleF = CGRectMake(5, CGRectGetMaxY(self.woTypeSepratorF), cellW, 30);
    
    /**
     *  告警级别value
     */
    CGSize alertRuleValueSize = [self sizeWithText:baseInfo.alertRule font:FSMValueFont maxW:cellW];
    self.alertRuleValueF = CGRectMake(5, CGRectGetMaxY(self.alertRuleTitleF), cellW, alertRuleValueSize.height);
    /**
     *  告警级别seprator
     */
    self.alertRuleSepratorF = CGRectMake(5, CGRectGetMaxY(self.alertRuleValueF), cellW, 1);
    
    /**
     *  工单编号title
     */
    self.woNumberTitleF = CGRectMake(5, CGRectGetMaxY(self.alertRuleSepratorF), cellW, 30);
    /**
     *  工单编号value
     */
    CGSize woNumberValueSize = [self sizeWithText:baseInfo.woNumber font:FSMValueFont maxW:cellW];
    self.woNumberValueF = CGRectMake(5, CGRectGetMaxY(self.woNumberTitleF), cellW, woNumberValueSize.height);
    /**
     *  工单编号seprator
     */
    self.woNumberSepratorF = CGRectMake(5, CGRectGetMaxY(self.woNumberValueF), cellW, 1);
    
    /**
     *  要求达到时间title
     */
    self.planArriveTimeTitleF = CGRectMake(5, CGRectGetMaxY(self.woNumberSepratorF), cellW, 30);
    /**
     *  要求达到时间value
     */
    CGSize planArriveTimeValueSize = [self sizeWithText:baseInfo.planArriveTime font:FSMValueFont maxW:cellW];
    self.planArriveTimeValueF = CGRectMake(5, CGRectGetMaxY(self.planArriveTimeTitleF), cellW, planArriveTimeValueSize.height);
    /**
     *  要求达到时间seprator
     */
    self.planArriveTimeSepratorF = CGRectMake(5, CGRectGetMaxY(self.planArriveTimeValueF), cellW, 1);
    
    
    /**
     *  要求完成时间title
     */
    self.planFinishTimeTitleF = CGRectMake(5, CGRectGetMaxY(self.planArriveTimeSepratorF), cellW, 30);
    /**
     *  要求完成时间value
     */
    CGSize planFinishTimeValueSize = [self sizeWithText:baseInfo.planFinishTime font:FSMValueFont maxW:cellW];
    self.planFinishTimeValueF = CGRectMake(5, CGRectGetMaxY(self.planFinishTimeTitleF), cellW, planFinishTimeValueSize.height);
    /**
     *  要求完成时间seprator
     */
    self.planFinishTimeSepratorF = CGRectMake(5, CGRectGetMaxY(self.planFinishTimeValueF), cellW, 1);

    
    /**
     *  内容描述title
     */
    self.contentDescribeTitleF = CGRectMake(5, CGRectGetMaxY(self.planFinishTimeSepratorF), cellW, 30);
    /**
     *  内容描述value
     */
    CGSize contentDescribeValueSize = [self sizeWithText:baseInfo.contentDescribe font:FSMValueFont maxW:cellW];
    self.contentDescribeValueF = CGRectMake(5, CGRectGetMaxY(self.contentDescribeTitleF), cellW, contentDescribeValueSize.height);
    /**
     *  内容描述seprator
     */
    self.contentDescribeSepratorF = CGRectMake(5, CGRectGetMaxY(self.contentDescribeValueF), cellW, 1);

    
    /**
     *  工单影响范围title
     */
    self.scopeTitleF = CGRectMake(5, CGRectGetMaxY(self.contentDescribeSepratorF), cellW, 30);
    /**
     *  工单影响范围value
     */
    CGSize scopeValueSize = [self sizeWithText:baseInfo.scope font:FSMValueFont maxW:cellW];
    self.scopeValueF = CGRectMake(5, CGRectGetMaxY(self.scopeTitleF), cellW, scopeValueSize.height);
    /**
     *  工单影响范围seprator
     */
    self.scopeSepratorF = CGRectMake(5, CGRectGetMaxY(self.scopeValueF), cellW, 1);
    
    
    /**
     *  工单状态title
     */
    self.stateTitleF = CGRectMake(5, CGRectGetMaxY(self.scopeSepratorF), cellW, 30);
    /**
     *  工单状态value
     */
    CGSize stateValueSize = [self sizeWithText:baseInfo.state font:FSMValueFont maxW:cellW];
    self.stateValueF = CGRectMake(5, CGRectGetMaxY(self.stateTitleF), cellW, stateValueSize.height);
    /**
     *  工单状态seprator
     */
    self.stateSepratorF = CGRectMake(5, CGRectGetMaxY(self.stateValueF), cellW, 1);

    self.cellHeight = CGRectGetMaxY(self.stateSepratorF);
}

@end
