//
//  ProcessResultFrame.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/18.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#define FSMTitleFont [UIFont boldSystemFontOfSize:17]
#define FSMValueFont [UIFont systemFontOfSize:13]

#import "ProcessResultFrame.h"
#import "ProcessResult.h"

@implementation ProcessResultFrame
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

-(void)setProcessResult:(ProcessResult *)processResult{
    _processResult = processResult;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /** 完成类型title */
    self.finishTypeTitleF = CGRectMake(5, 0, cellW, 30);
    
    /** 完成类型value */
    CGSize finishTypeValueSize = [self sizeWithText:processResult.finishType font:FSMValueFont maxW:cellW];
    
    self.finishTypeValueF = CGRectMake(5, CGRectGetMaxY(self.finishTypeTitleF), cellW, finishTypeValueSize.height);
    
    
    if (_processResult.endTime!=nil) {
        /** 发电时长（小时）title */
        self.powerTimeTitleF = CGRectMake(5, CGRectGetMaxY(self.finishTypeValueF), cellW, 30);
        
        /** 发电时长（小时）value */
        CGSize powerTimeValueSize = [self sizeWithText:processResult.powerTime font:FSMValueFont maxW:cellW];
        
        self.powerTimeValueF = CGRectMake(5, CGRectGetMaxY(self.powerTimeTitleF), cellW, powerTimeValueSize.height);
        
        
        
        /**实际结束时间 title */
        self.endTimeTitleF = CGRectMake(5, CGRectGetMaxY(self.powerTimeValueF), cellW, 30);
        
        /**实际结束时间 value */
        CGSize endTimeValueSize = [self sizeWithText:processResult.endTime font:FSMValueFont maxW:cellW];
        
        self.endTimeValueF = CGRectMake(5, CGRectGetMaxY(self.endTimeTitleF), cellW, endTimeValueSize.height);
        
        
        
        
        /** 遗留问题描述title */
        self.legacyProblemDescTitleF = CGRectMake(5, CGRectGetMaxY(self.endTimeValueF), cellW, 30);
        
        /** 遗留问题描述value */
        CGSize legacyProblemDescValueSize = [self sizeWithText:processResult.legacyProblemDesc font:FSMValueFont maxW:cellW];
        
        self.legacyProblemDescValueF = CGRectMake(5, CGRectGetMaxY(self.legacyProblemDescTitleF), cellW, legacyProblemDescValueSize.height);
    }
    else{
        
        
        /** 遗留问题描述title */
        self.legacyProblemDescTitleF = CGRectMake(5, CGRectGetMaxY(self.finishTypeValueF), cellW, 30);
        
        /** 遗留问题描述value */
        CGSize legacyProblemDescValueSize = [self sizeWithText:processResult.legacyProblemDesc font:FSMValueFont maxW:cellW];
        
        self.legacyProblemDescValueF = CGRectMake(5, CGRectGetMaxY(self.legacyProblemDescTitleF), cellW, legacyProblemDescValueSize.height);
    
    
    }
    
  
    

    
    
    
    /** 处理总结title */
    self.handleSummaryTitleF = CGRectMake(5, CGRectGetMaxY(self.legacyProblemDescValueF), cellW, 30);
    
    /** 处理总结value */
    CGSize handleSummaryValueSize = [self sizeWithText:processResult.handleSummary font:FSMValueFont maxW:cellW];
    
    self.handleSummaryValueF = CGRectMake(5, CGRectGetMaxY(self.handleSummaryTitleF), cellW, handleSummaryValueSize.height);
    
    
    /** 备注title */
    self.remarkTitleF= CGRectMake(5, CGRectGetMaxY(self.handleSummaryValueF), cellW, 30);
    
    /** 备注value */
    CGSize remarkValueSize = [self sizeWithText:processResult.remark font:FSMValueFont maxW:cellW];
    self.remarkValueF = CGRectMake(5, CGRectGetMaxY(self.remarkTitleF), cellW, remarkValueSize.height);
    
    self.cellHeight = CGRectGetMaxY(self.remarkValueF);
}

@end
