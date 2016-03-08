//
//  OrderInfoCell.m
//  Ericsson
//
//  Created by 范传斌 on 15/11/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//
#define FSMTitleFont [UIFont boldSystemFontOfSize:17]
#define FSMValueFont [UIFont systemFontOfSize:13]
#define FSMTitleTextColor [UIColor blackColor]
#define FSMValueTextColor [UIColor lightGrayColor]
#define FSMCellSepratorColor [UIColor lightGrayColor]

#import "OrderInfoCell.h"
#import "WorkOrderBaseInfo.h"
#import "WorkOrderBaseInfoFrame.h"

@interface OrderInfoCell()
//维护对象类型title
@property (weak, nonatomic) UILabel *maintenanceObjectTypeTitle;
//维护对象类型value
@property (weak, nonatomic) UILabel *maintenanceObjectTypeValue;
//维护对象类型seprator
@property (weak, nonatomic) UIView *maintenanceObjectTypeSeprator;

//维护对象等级title
@property (weak, nonatomic) UILabel *maintenanceObjectLevelTitle;
//维护对象等级value
@property (weak, nonatomic) UILabel *maintenanceObjectLevelValue;
//维护对象等级seprator
@property (weak, nonatomic) UIView *maintenanceObjectLevelSeprator;

//优先级title
@property (weak, nonatomic) UILabel *priorityTitle;
//优先级value
@property (weak, nonatomic) UILabel *priorityValue;
//优先级seprator
@property (weak, nonatomic) UIView *prioritySeprator;

//工单类别title
@property (weak, nonatomic) UILabel *woTypeTitle;
//工单类别value
@property (weak, nonatomic) UILabel *woTypeValue;
//工单类别seprator
@property (weak, nonatomic) UIView *woTypeSeprator;

//告警级别title
@property (weak, nonatomic) UILabel *alertRuleTitle;
//告警级别value
@property (weak, nonatomic) UILabel *alertRuleValue;
//告警级别seprator
@property (weak, nonatomic) UIView *alertRuleSeprator;

//工单编号title
@property (weak, nonatomic) UILabel *woNumberTitle;
//工单编号value
@property (weak, nonatomic) UILabel *woNumberValue;
//工单编号seprator
@property (weak, nonatomic) UIView *woNumberSeprator;

//要求达到时间title
@property (weak, nonatomic) UILabel *planArriveTimeTitle;
//要求达到时间value
@property (weak, nonatomic) UILabel *planArriveTimeValue;
//要求达到时间seprator
@property (weak, nonatomic) UIView *planArriveTimeSeprator;

//要求完成时间title
@property (weak, nonatomic) UILabel *planFinishTimeTitle;
//要求完成时间value
@property (weak, nonatomic) UILabel *planFinishTimeValue;
//要求完成时间seprator
@property (weak, nonatomic) UIView *planFinishTimeSeprator;

//内容描述title
@property (weak, nonatomic) UILabel *contentDescribeTitle;
//内容描述value
@property (weak, nonatomic) UILabel *contentDescribeValue;
//内容描述seprator
@property (weak, nonatomic) UIView *contentDescribeSeprator;

//工单影响范围title
@property (weak, nonatomic) UILabel *scopeTitle;
//工单影响范围value
@property (weak, nonatomic) UILabel *scopeValue;
//工单影响范围seprator
@property (weak, nonatomic) UIView *scopeSeprator;

//工单状态title
@property (weak, nonatomic) UILabel *stateTitle;
//工单状态value
@property (weak, nonatomic) UILabel *stateValue;
//工单状态seprator
@property (weak, nonatomic) UIView *stateSeprator;

@end

@implementation OrderInfoCell

-(WorkOrderBaseInfoFrame *)workOrderBaseInfoFrame{
    if (!_workOrderBaseInfoFrame) {
        _workOrderBaseInfoFrame = [[WorkOrderBaseInfoFrame alloc] init];
    }
    return _workOrderBaseInfoFrame;
}

-(void)setWorkOrderBaseInfo:(WorkOrderBaseInfo *)workOrderBaseInfo{
    _workOrderBaseInfo = workOrderBaseInfo;
    
    self.workOrderBaseInfoFrame.baseInfo = workOrderBaseInfo;
    
    //维护对象类型
    self.maintenanceObjectTypeTitle.text = @"维护对象类型";
    self.maintenanceObjectTypeTitle.frame = self.workOrderBaseInfoFrame.maintenanceObjectTypeTitleF;
    self.maintenanceObjectTypeTitle.textColor = FSMTitleTextColor;
    self.maintenanceObjectTypeTitle.font = FSMTitleFont;
    
    self.maintenanceObjectTypeValue.text = workOrderBaseInfo.maintenanceObjectType;
    self.maintenanceObjectTypeValue.frame = self.workOrderBaseInfoFrame.maintenanceObjectTypeValueF;
    self.maintenanceObjectTypeValue.textColor = FSMValueTextColor;
    self.maintenanceObjectTypeValue.font = FSMValueFont;
    
    self.maintenanceObjectLevelSeprator.frame = self.workOrderBaseInfoFrame.maintenanceObjectTypeSepratorF;
    self.maintenanceObjectTypeSeprator.backgroundColor = FSMCellSepratorColor;
    
    //维护对象等级
    self.maintenanceObjectLevelTitle.text = @"维护对象等级";
    self.maintenanceObjectLevelTitle.frame = self.workOrderBaseInfoFrame.maintenanceObjectLevelTitleF;
    self.maintenanceObjectLevelTitle.textColor = FSMTitleTextColor;
    self.maintenanceObjectLevelTitle.font = FSMTitleFont;
    
    self.maintenanceObjectLevelValue.text = workOrderBaseInfo.maintenanceObjectLevel;
    self.maintenanceObjectLevelValue.frame = self.workOrderBaseInfoFrame.maintenanceObjectLevelValueF;
    self.maintenanceObjectLevelValue.textColor = FSMValueTextColor;
    self.maintenanceObjectLevelValue.font = FSMValueFont;
    
    self.maintenanceObjectLevelSeprator.frame = self.workOrderBaseInfoFrame.maintenanceObjectLevelSepratorF;
    self.maintenanceObjectLevelSeprator.backgroundColor = FSMCellSepratorColor;
    
    
    //优先级
    self.priorityTitle.text = @"优先级";
    self.priorityTitle.frame = self.workOrderBaseInfoFrame.priorityTitleF;
    self.priorityTitle.textColor = FSMTitleTextColor;
    self.priorityTitle.font = FSMTitleFont;
    
    self.priorityValue.text = workOrderBaseInfo.priority;
    self.priorityValue.frame = self.workOrderBaseInfoFrame.priorityValueF;
    self.priorityValue.textColor = FSMValueTextColor;
    self.priorityValue.font = FSMValueFont;
    
    self.prioritySeprator.frame = self.workOrderBaseInfoFrame.prioritySepratorF;
    self.prioritySeprator.backgroundColor = FSMCellSepratorColor;
    
    
    //工单类别
    self.woTypeTitle.text = @"工单类别";
    self.woTypeTitle.frame = self.workOrderBaseInfoFrame.woTypeTitleF;
    self.woTypeTitle.textColor = FSMTitleTextColor;
    self.woTypeTitle.font = FSMTitleFont;
    
    self.woTypeValue.text = workOrderBaseInfo.woType;
    self.woTypeValue.frame = self.workOrderBaseInfoFrame.woTypeValueF;
    self.woTypeValue.textColor = FSMValueTextColor;
    self.woTypeValue.font = FSMValueFont;
    
    self.woTypeSeprator.frame = self.workOrderBaseInfoFrame.woTypeSepratorF;
    self.woTypeSeprator.backgroundColor = FSMCellSepratorColor;

    //告警级别
    self.alertRuleTitle.text = @"告警级别";
    self.alertRuleTitle.frame = self.workOrderBaseInfoFrame.alertRuleTitleF;
    self.alertRuleTitle.textColor = FSMTitleTextColor;
    self.alertRuleTitle.font = FSMTitleFont;
    
    self.alertRuleValue.text = workOrderBaseInfo.alertRule;
    self.alertRuleValue.frame = self.workOrderBaseInfoFrame.alertRuleValueF;
    self.alertRuleValue.textColor = FSMValueTextColor;
    self.alertRuleValue.font = FSMValueFont;
    
    self.alertRuleSeprator.frame = self.workOrderBaseInfoFrame.alertRuleSepratorF;
    self.alertRuleSeprator.backgroundColor = FSMCellSepratorColor;
    
    //工单编号
    self.woNumberTitle.text = @"工单编号";
    self.woNumberTitle.frame = self.workOrderBaseInfoFrame.woNumberTitleF;
    self.woNumberTitle.textColor = FSMTitleTextColor;
    self.woNumberTitle.font = FSMTitleFont;
    
    self.woNumberValue.text = workOrderBaseInfo.woNumber;
    self.woNumberValue.frame = self.workOrderBaseInfoFrame.woNumberValueF;
    self.woNumberValue.textColor = FSMValueTextColor;
    self.woNumberValue.font = FSMValueFont;
    
    self.woNumberSeprator.frame = self.workOrderBaseInfoFrame.woNumberSepratorF;
    self.woNumberSeprator.backgroundColor = FSMCellSepratorColor;
    
    //要求达到时间
    self.planArriveTimeTitle.text = @"要求达到时间";
    self.planArriveTimeTitle.frame = self.workOrderBaseInfoFrame.planArriveTimeTitleF;
    self.planArriveTimeTitle.textColor = FSMTitleTextColor;
    self.planArriveTimeTitle.font = FSMTitleFont;
    
    self.planArriveTimeValue.text = workOrderBaseInfo.planArriveTime;
    self.planArriveTimeValue.frame = self.workOrderBaseInfoFrame.planArriveTimeValueF;
    self.planArriveTimeValue.textColor = FSMValueTextColor;
    self.planArriveTimeValue.font = FSMValueFont;
    
    self.planArriveTimeSeprator.frame = self.workOrderBaseInfoFrame.planArriveTimeSepratorF;
    self.planArriveTimeSeprator.backgroundColor = FSMCellSepratorColor;
    
    //要求完成时间
    self.planFinishTimeTitle.text = @"要求完成时间";
    self.planFinishTimeTitle.frame = self.workOrderBaseInfoFrame.planFinishTimeTitleF;
    self.planFinishTimeTitle.textColor = FSMTitleTextColor;
    self.planFinishTimeTitle.font = FSMTitleFont;
    
    self.planFinishTimeValue.text = workOrderBaseInfo.planFinishTime;
    self.planFinishTimeValue.frame = self.workOrderBaseInfoFrame.planFinishTimeValueF;
    self.planFinishTimeValue.textColor = FSMValueTextColor;
    self.planFinishTimeValue.font = FSMValueFont;
    
    self.planFinishTimeSeprator.frame = self.workOrderBaseInfoFrame.planFinishTimeSepratorF;
    self.planFinishTimeSeprator.backgroundColor = FSMCellSepratorColor;

    
    //内容描述
    self.contentDescribeTitle.text = @"内容描述";
    self.contentDescribeTitle.frame = self.workOrderBaseInfoFrame.contentDescribeTitleF;
    self.contentDescribeTitle.textColor = FSMTitleTextColor;
    self.contentDescribeTitle.font = FSMTitleFont;
    
    self.contentDescribeValue.text = workOrderBaseInfo.contentDescribe;
    self.contentDescribeValue.frame = self.workOrderBaseInfoFrame.contentDescribeValueF;
    self.contentDescribeValue.textColor = FSMValueTextColor;
    self.contentDescribeValue.font = FSMValueFont;
    
    self.contentDescribeSeprator.frame = self.workOrderBaseInfoFrame.contentDescribeSepratorF;
    self.contentDescribeSeprator.backgroundColor = FSMCellSepratorColor;
    
    //工单影响范围
    self.scopeTitle.text = @"工单影响范围";
    self.scopeTitle.frame = self.workOrderBaseInfoFrame.scopeTitleF;
    self.scopeTitle.textColor = FSMTitleTextColor;
    self.scopeTitle.font = FSMTitleFont;
    
    self.scopeValue.text = workOrderBaseInfo.scope;
    self.scopeValue.frame = self.workOrderBaseInfoFrame.scopeValueF;
    self.scopeValue.textColor = FSMValueTextColor;
    self.scopeValue.font = FSMValueFont;
    
    self.scopeSeprator.frame = self.workOrderBaseInfoFrame.scopeSepratorF;
    self.scopeSeprator.backgroundColor = FSMCellSepratorColor;
    
    //工单状态
    self.stateTitle.text = @"工单状态";
    self.stateTitle.frame = self.workOrderBaseInfoFrame.stateTitleF;
    self.stateTitle.textColor = FSMTitleTextColor;
    self.stateTitle.font = FSMTitleFont;
    
    self.stateValue.text = workOrderBaseInfo.state;
    self.stateValue.frame = self.workOrderBaseInfoFrame.stateValueF;
    self.stateValue.textColor = FSMValueTextColor;
    self.stateValue.font = FSMValueFont;
    
    self.stateSeprator.frame = self.workOrderBaseInfoFrame.stateSepratorF;
    self.stateSeprator.backgroundColor = FSMCellSepratorColor;
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"OrderInfoCell";
    OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OrderInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化工单信息cell布局
        [self setupOriginal];
    }
    
    return self;
}

- (void)setupOriginal{
    //维护对象类型title
    UILabel *maintenanceObjectTypeTitle = [[UILabel alloc] init];
    maintenanceObjectTypeTitle.numberOfLines = 0;
    [self.contentView addSubview:maintenanceObjectTypeTitle];
    self.maintenanceObjectTypeTitle = maintenanceObjectTypeTitle;
    
    //维护对象类型value
    UILabel *maintenanceObjectTypeValue = [[UILabel alloc] init];
    maintenanceObjectTypeValue.numberOfLines = 0;
    [self.contentView addSubview:maintenanceObjectTypeValue];
    self.maintenanceObjectTypeValue = maintenanceObjectTypeValue;
    
    //维护对象类型seprator
    UIView *maintenanceObjectTypeSeprator = [[UIView alloc] init];
    [self.contentView addSubview:maintenanceObjectTypeSeprator];
    self.maintenanceObjectTypeSeprator = maintenanceObjectTypeSeprator;
    
    
    //维护对象等级title
    UILabel *maintenanceObjectLevelTitle = [[UILabel alloc] init];
    maintenanceObjectLevelTitle.numberOfLines = 0;
    [self.contentView addSubview:maintenanceObjectLevelTitle];
    self.maintenanceObjectLevelTitle = maintenanceObjectLevelTitle;
    
    //维护对象等级value
    UILabel *maintenanceObjectLevelValue = [[UILabel alloc] init];
    maintenanceObjectLevelValue.numberOfLines = 0;
    [self.contentView addSubview:maintenanceObjectLevelValue];
    self.maintenanceObjectLevelValue = maintenanceObjectLevelValue;
    
    //维护对象等级seprator
    UIView *maintenanceObjectLevelSeprator = [[UIView alloc] init];
    [self.contentView addSubview:maintenanceObjectLevelSeprator];
    self.maintenanceObjectLevelSeprator = maintenanceObjectLevelSeprator;

    //优先级title
    UILabel *priorityTitle = [[UILabel alloc] init];
    priorityTitle.numberOfLines = 0;
    [self.contentView addSubview:priorityTitle];
    self.priorityTitle = priorityTitle;
    
    //优先级value
    UILabel *priorityValue = [[UILabel alloc] init];
    priorityValue.numberOfLines = 0;
    [self.contentView addSubview:priorityValue];
    self.priorityValue = priorityValue;
    
    //优先级seprator
    UIView *prioritySeprator = [[UIView alloc] init];
    [self.contentView addSubview:prioritySeprator];
    self.prioritySeprator = prioritySeprator;
    
    //工单类别title
    UILabel *woTypeTitle = [[UILabel alloc] init];
    woTypeTitle.numberOfLines = 0;
    [self.contentView addSubview:woTypeTitle];
    self.woTypeTitle = woTypeTitle;
    
    //工单类别value
    UILabel *woTypeValue = [[UILabel alloc] init];
    woTypeValue.numberOfLines = 0;
    [self.contentView addSubview:woTypeValue];
    self.woTypeValue = woTypeValue;
    
    //工单类别seprator
    UIView *woTypeSeprator = [[UIView alloc] init];
    [self.contentView addSubview:woTypeSeprator];
    self.woTypeSeprator = woTypeSeprator;
    
    //告警级别title
    UILabel *alertRuleTitle = [[UILabel alloc] init];
    alertRuleTitle.numberOfLines = 0;
    [self.contentView addSubview:alertRuleTitle];
    self.alertRuleTitle = alertRuleTitle;
    
    //告警级别value
    UILabel *alertRuleValue = [[UILabel alloc] init];
    alertRuleValue.numberOfLines = 0;
    [self.contentView addSubview:alertRuleValue];
    self.alertRuleValue = alertRuleValue;
    
    //告警级别seprator
    UIView *alertRuleSeprator = [[UIView alloc] init];
    [self.contentView addSubview:alertRuleSeprator];
    self.alertRuleSeprator = alertRuleSeprator;
    
    //工单编号title
    UILabel *woNumberTitle = [[UILabel alloc] init];
    woNumberTitle.numberOfLines = 0;
    [self.contentView addSubview:woNumberTitle];
    self.woNumberTitle = woNumberTitle;
    
    //工单编号value
    UILabel *woNumberValue = [[UILabel alloc] init];
    woNumberValue.numberOfLines = 0;
    [self.contentView addSubview:woNumberValue];
    self.woNumberValue = woNumberValue;
    
    //工单编号seprator
    UIView *woNumberSeprator = [[UIView alloc] init];
    [self.contentView addSubview:woNumberSeprator];
    self.woNumberSeprator = woNumberSeprator;
    
    //要求到达时间title
    UILabel *planArriveTimeTitle = [[UILabel alloc] init];
    planArriveTimeTitle.numberOfLines = 0;
    [self.contentView addSubview:planArriveTimeTitle];
    self.planArriveTimeTitle = planArriveTimeTitle;
    
    //要求达到时间value
    UILabel *planArriveTimeValue = [[UILabel alloc] init];
    planArriveTimeValue.numberOfLines = 0;
    [self.contentView addSubview:planArriveTimeValue];
    self.planArriveTimeValue = planArriveTimeValue;
    
    //要求达到时间seprator
    UIView *planArriveTimeSeprator = [[UIView alloc] init];
    [self.contentView addSubview:planArriveTimeSeprator];
    self.planArriveTimeSeprator = planArriveTimeSeprator;

    
    //要求完成时间title
    UILabel *planFinishTimeTitle = [[UILabel alloc] init];
    planFinishTimeTitle.numberOfLines = 0;
    [self.contentView addSubview:planFinishTimeTitle];
    self.planFinishTimeTitle = planFinishTimeTitle;
    
    //要求完成时间value
    UILabel *planFinishTimeValue = [[UILabel alloc] init];
    planFinishTimeValue.numberOfLines = 0;
    [self.contentView addSubview:planFinishTimeValue];
    self.planFinishTimeValue = planFinishTimeValue;
    
    //要求完成时间seprator
    UIView *planFinishTimeSeprator = [[UIView alloc] init];
    [self.contentView addSubview:planFinishTimeSeprator];
    self.planFinishTimeSeprator = planFinishTimeSeprator;
    
    //内容描述title
    UILabel *contentDescribeTitle = [[UILabel alloc] init];
    contentDescribeTitle.numberOfLines = 0;
    [self.contentView addSubview:contentDescribeTitle];
    self.contentDescribeTitle = contentDescribeTitle;
    
    //内容描述value
    UILabel *contentDescribeValue = [[UILabel alloc] init];
    contentDescribeValue.numberOfLines = 0;
    [self.contentView addSubview:contentDescribeValue];
    self.contentDescribeValue = contentDescribeValue;
    
    //内容描述seprator
    UIView *contentDescribeSeprator = [[UIView alloc] init];
    [self.contentView addSubview:contentDescribeSeprator];
    self.contentDescribeSeprator = contentDescribeSeprator;
    
    
    //工单影响范围title
    UILabel *scopeTitle = [[UILabel alloc] init];
    scopeTitle.numberOfLines = 0;
    [self.contentView addSubview:scopeTitle];
    self.scopeTitle = scopeTitle;
    
    //工单影响范围value
    UILabel *scopeValue = [[UILabel alloc] init];
    scopeValue.numberOfLines = 0;
    [self.contentView addSubview:scopeValue];
    self.scopeValue = scopeValue;
    
    //工单影响范围seprator
    UIView *scopeSeprator = [[UIView alloc] init];
    [self.contentView addSubview:scopeSeprator];
    self.scopeSeprator = scopeSeprator;

    
    //工单状态title
    UILabel *stateTitle = [[UILabel alloc] init];
    stateTitle.numberOfLines = 0;
    [self.contentView addSubview:stateTitle];
    self.stateTitle = stateTitle;
    
    //工单状态value
    UILabel *stateValue = [[UILabel alloc] init];
    stateValue.numberOfLines = 0;
    [self.contentView addSubview:stateValue];
    self.stateValue = stateValue;
    
    //工单状态seprator
    UIView *stateSeprator = [[UIView alloc] init];
    [self.contentView addSubview:stateSeprator];
    self.stateSeprator = stateSeprator;
    
}
@end
