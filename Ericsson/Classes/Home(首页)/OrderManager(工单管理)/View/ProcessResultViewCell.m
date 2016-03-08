//
//  ProcessResultViewCell.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/18.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#define CellTitleFont [UIFont systemFontOfSize:17]
#define CellValueFont [UIFont systemFontOfSize:13]

#import "ProcessResultViewCell.h"
#import "ProcessResult.h"
#import "ProcessResultFrame.h"

@interface ProcessResultViewCell()
/**
 *  处理总结title
 */
@property (nonatomic,weak)UILabel *handleSummaryTitle;
/**
 *  处理总结value
 */
@property (nonatomic,weak)UILabel *handleSummaryValue;
/**
 *  备注title
 */
@property (nonatomic,weak)UILabel *remarkTitle;
/**
 *  备注value
 */
@property (nonatomic,weak)UILabel *remarkValue;
/**
 *  完成类型title
 */
@property (nonatomic,weak)UILabel *finishTypeTitle;
/**
 *  完成类型value
 */
@property (nonatomic,weak)UILabel *finishTypeValue;
/**
 *  遗留问题title
 */
@property (nonatomic,weak)UILabel *legacyProblemDescTitle;
/**
 *  遗留问题value
 */
@property (nonatomic,weak)UILabel *legacyProblemDescValue;
/**
 *  实际结算时间title
 */
@property (nonatomic,weak)UILabel *endTimeTitle;
/**
 *  实际结算时间value
 */
@property (nonatomic,weak)UILabel *endTimeValue;
/**
 *  发电时长title
 */
@property (nonatomic,weak)UILabel *powerTimeTitle;
/**
 *  发电时长value
 */
@property (nonatomic,weak)UILabel *powerTimeValue;

@end

@implementation ProcessResultViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化处理结束cell布局
        [self setupOriginal];
    }
    
    return self;
}

- (void)setupOriginal{
    //处理总结title
    UILabel *handleSummaryTitle = [[UILabel alloc] init];
    handleSummaryTitle.numberOfLines = 0;
    [self.contentView addSubview:handleSummaryTitle];
    self.handleSummaryTitle = handleSummaryTitle;

    //处理总结Value
    UILabel *handleSummaryValue = [[UILabel alloc] init];
    handleSummaryValue.numberOfLines = 0;
    [self.contentView addSubview:handleSummaryValue];
    self.handleSummaryValue = handleSummaryValue;
    
    //备注title
    UILabel *remarkTitle = [[UILabel alloc] init];
    remarkTitle.numberOfLines = 0;
    [self.contentView addSubview:remarkTitle];
    self.remarkTitle = remarkTitle;
    
    //备注Value
    UILabel *remarkValue = [[UILabel alloc] init];
    remarkValue.numberOfLines = 0;
    [self.contentView addSubview:remarkValue];
    self.remarkValue = remarkValue;
    
    //完成类型title
    UILabel *finishTypeTitle = [[UILabel alloc] init];
    finishTypeTitle.numberOfLines = 0;
    [self.contentView addSubview:finishTypeTitle];
    self.finishTypeTitle = finishTypeTitle;
    
    //完成类型Value
    UILabel *finishTypeValue = [[UILabel alloc] init];
    finishTypeValue.numberOfLines = 0;
    [self.contentView addSubview:finishTypeValue];
    self.finishTypeValue = finishTypeValue;
    
    //遗留问题title
    UILabel *legacyProblemDescTitle = [[UILabel alloc] init];
    legacyProblemDescTitle.numberOfLines = 0;
    [self.contentView addSubview:legacyProblemDescTitle];
    self.legacyProblemDescTitle = legacyProblemDescTitle;
    
    //遗留问题Value
    UILabel *legacyProblemDescValue = [[UILabel alloc] init];
    legacyProblemDescValue.numberOfLines = 0;
    [self.contentView addSubview:legacyProblemDescValue];
    self.legacyProblemDescValue = legacyProblemDescValue;
    
    
    
    //实际结算时间title
    UILabel *endTimeTitle = [[UILabel alloc] init];
    endTimeTitle.numberOfLines = 0;
    [self.contentView addSubview:endTimeTitle];
    self.endTimeTitle = endTimeTitle;
    
    //实际结算时间Value
    UILabel *endTimeValue = [[UILabel alloc] init];
    endTimeValue.numberOfLines = 0;
    [self.contentView addSubview:endTimeValue];
    self.endTimeValue = endTimeValue;
    
    //发电时长title
    UILabel *powerTimeTitle = [[UILabel alloc] init];
    powerTimeTitle.numberOfLines = 0;
    [self.contentView addSubview:powerTimeTitle];
    self.powerTimeTitle = powerTimeTitle;
    
    //发电时长Value
    UILabel *powerTimeValue = [[UILabel alloc] init];
    powerTimeValue.numberOfLines = 0;
    [self.contentView addSubview:powerTimeValue];
    self.powerTimeValue = powerTimeValue;
    


    
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ProcessResultViewCell";
    ProcessResultViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ProcessResultViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}


-(void)setProcessResultFrame:(ProcessResultFrame *)processResultFrame{
    _processResultFrame = processResultFrame;
    
    ProcessResult *processResult = processResultFrame.processResult;
    
    self.finishTypeTitle.text = @"完成类型";
    self.finishTypeTitle.frame = processResultFrame.finishTypeTitleF;
    self.finishTypeTitle.textColor = [UIColor blackColor];
    self.finishTypeTitle.font = CellTitleFont;
    
    self.finishTypeValue.text = processResult.finishType;
    self.finishTypeValue.frame = processResultFrame.finishTypeValueF;
    self.finishTypeValue.textColor = [UIColor lightGrayColor];
    self.finishTypeValue.font = CellValueFont;
    
    self.legacyProblemDescTitle.text = @"遗留问题描述";
    self.legacyProblemDescTitle.frame = processResultFrame.legacyProblemDescTitleF;
    self.legacyProblemDescTitle.textColor = [UIColor blackColor];
    self.legacyProblemDescTitle.font = CellTitleFont;
    
    self.legacyProblemDescValue.text = processResult.legacyProblemDesc;
    self.legacyProblemDescValue.frame = processResultFrame.legacyProblemDescValueF;
    self.legacyProblemDescValue.textColor = [UIColor lightGrayColor];
    self.legacyProblemDescValue.font = CellValueFont;
    
    
    self.endTimeTitle.text = @"实际结束时间";
    self.endTimeTitle.frame = processResultFrame.endTimeTitleF;
    self.endTimeTitle.textColor = [UIColor blackColor];
    self.endTimeTitle.font = CellTitleFont;
    
    self.endTimeValue.text = processResult.endTime;
    self.endTimeValue.frame = processResultFrame.endTimeValueF;
    self.endTimeValue.textColor = [UIColor lightGrayColor];
    self.endTimeValue.font = CellValueFont;
    
    
    self.powerTimeTitle.text = @"发电时长";
    self.powerTimeTitle.frame = processResultFrame.powerTimeTitleF;
    self.powerTimeTitle.textColor = [UIColor blackColor];
    self.powerTimeTitle.font = CellTitleFont;
    
    self.powerTimeValue.text = processResult.powerTime;
    self.powerTimeValue.frame = processResultFrame.powerTimeValueF;
    self.powerTimeValue.textColor = [UIColor lightGrayColor];
    self.powerTimeValue.font = CellValueFont;
    
    self.handleSummaryTitle.text = @"处理总结";
    self.handleSummaryTitle.frame = processResultFrame.handleSummaryTitleF;
    self.handleSummaryTitle.textColor = [UIColor blackColor];
    self.handleSummaryTitle.font = CellTitleFont;
    
    self.handleSummaryValue.text = processResult.handleSummary;
    self.handleSummaryValue.frame = processResultFrame.handleSummaryValueF;
    self.handleSummaryValue.textColor = [UIColor lightGrayColor];
    self.handleSummaryValue.font = CellValueFont;
    
    self.remarkTitle.text = @"备注";
    self.remarkTitle.frame = processResultFrame.remarkTitleF;
    self.remarkTitle.textColor = [UIColor blackColor];
    self.remarkTitle.font = CellTitleFont;
    
    self.remarkValue.text = processResult.remark;
    self.remarkValue.frame = processResultFrame.remarkValueF;
    self.remarkValue.textColor = [UIColor lightGrayColor];
    self.remarkValue.font = CellValueFont;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
