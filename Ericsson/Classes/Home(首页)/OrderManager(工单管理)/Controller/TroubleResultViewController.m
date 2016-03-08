//
//  TroubleResultViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/9.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "TroubleResultViewController.h"
#import "OrderResultItem.h"
#import "UIView+Extension.h"
#import "WorkOrder.h"
#import "WorkOrderStep.h"
#import "WorkOrderDetail.h"
#import "KeyMap.h"
#import "TroubleDomain.h"
#import "ToolBar.h"
#import "PhaseFeedBackDescInputViewController.h"
#include "FDAlertView.h"
#include "AlertInputView.h"

#define DescriptionFont 15///mmmm
#define TableViewCellH 50 //每个 tableViewCell 的高度

@interface TroubleResultViewController ()<OrderResultItemDelegate,UITableViewDataSource,UITableViewDelegate,PhaseFeedBackDescInputDelegate,AlertInputViewDelegate>

//完成类型
@property (nonatomic,strong)OrderResultItem *finishTypeItem;
@property (nonatomic,strong)UITableView *finishTypeTableView;
@property (nonatomic,strong)KeyMap *selectedfinishType;

//故障域
@property (nonatomic,strong)OrderResultItem *troubleDomainItem;
@property (nonatomic,strong)UITableView *troubleDomainTableView;
@property (nonatomic,strong)TroubleDomain *selectedtroubleDomain;

//故障类别
@property (nonatomic,strong)OrderResultItem *bugTypeItem;
@property (nonatomic,strong)UITableView *bugTypeTableView;
@property (nonatomic,strong)KeyMap *selectedbugType;

//故障原因
@property (nonatomic,strong)OrderResultItem *bugReasonItem;
@property (nonatomic,strong)UITableView *bugReasonTableView;
@property (nonatomic,strong)KeyMap *selectedbugReason;

//退服类型
@property (nonatomic,strong)OrderResultItem *takeBackTypeItem;
@property (nonatomic,strong)UITableView *takeBackTypeTableView;
@property (nonatomic,strong)KeyMap *selectedtakeBackType;

//退服原因
@property (nonatomic,strong)OrderResultItem *takeBackReasonItem;
@property (nonatomic,strong)UITableView *takeBackReasonTableView;
@property (nonatomic,strong)KeyMap *selectedtakeBackReason;

//退服子原因
@property (nonatomic,strong)OrderResultItem *takeBackSubReasonItem;
@property (nonatomic,strong)UITableView *takeBackSubReasonTableView;
@property (nonatomic,strong)KeyMap *selectedtakeBackSubReason;

//处理总结
@property (nonatomic,strong)OrderResultItem *handleSummaryItem;
@property (nonatomic,strong)UILabel *handleSummaryLabel;
//有无遗留问题
@property (nonatomic,strong)OrderResultItem *leftProblemItem;
@property (nonatomic,strong)UILabel *leftProblemDescLabel;
//备注
@property (nonatomic,strong)OrderResultItem *remarkItem;
@property (nonatomic,strong)UILabel *remarkDescLabel;

////附件上传工具栏
//@property (nonatomic,strong)OrderResultItem *toolBarItem;
//@property (nonatomic,strong)ToolBar *toolBar;

//完成类型列表
@property (nonatomic,strong)NSMutableArray *finishTypes;
//故障域列表
@property (nonatomic,strong)NSMutableArray *troubleDomains;
//故障类别列表
@property (nonatomic,strong)NSMutableArray *bugTypes;
//故障原因列表
@property (nonatomic,strong)NSMutableArray *bugReasons;
//退服类型列表
@property (nonatomic,strong)NSMutableArray *takeBackTypes;
//退服原因列表
@property (nonatomic,strong)NSMutableArray *takeBackReasons;
//退服子原因列表
@property (nonatomic,strong)NSMutableArray *takeBackSubReasons;


@property (nonatomic,strong)UIScrollView *contentScrollView;

@property (nonatomic,strong)UIButton *commitBtn;

//超时工单超时原因填写
@property (nonatomic,strong)FDAlertView *alert;

@end

@implementation TroubleResultViewController

-(NSMutableArray *)finishTypes{
    if (!_finishTypes) {
        _finishTypes = [[NSMutableArray alloc] init];
    }
    return _finishTypes;
}

-(void)setSelectedfinishType:(KeyMap *)selectedfinishType{
    _selectedfinishType = selectedfinishType;
    self.finishTypeItem.handleTypeValue.text = selectedfinishType.name;
}

-(NSMutableArray *)troubleDomains{
    if (!_troubleDomains) {
        _troubleDomains = [[NSMutableArray alloc] init];
    }
    return _troubleDomains;
}

-(void)setSelectedtroubleDomain:(TroubleDomain *)selectedtroubleDomain{
    _selectedtroubleDomain = selectedtroubleDomain;
    self.troubleDomainItem.handleTypeValue.text = selectedtroubleDomain.name;
}

-(NSMutableArray *)bugTypes{
    if (!_bugTypes) {
        _bugTypes = [[NSMutableArray alloc] init];
    }
    return _bugTypes;
}

-(void)setSelectedbugType:(KeyMap *)selectedbugType{
    _selectedbugType = selectedbugType;
    self.bugTypeItem.handleTypeValue.text = selectedbugType.name;
}

-(NSMutableArray *)bugReasons{
    if (!_bugReasons) {
        _bugReasons = [[NSMutableArray alloc] init];
    }
    return _bugReasons;
}

-(void)setSelectedbugReason:(KeyMap *)selectedbugReason{
    _selectedbugReason = selectedbugReason;
    self.bugReasonItem.handleTypeValue.text = selectedbugReason.name;
}

-(NSMutableArray *)takeBackTypes{
    if (!_takeBackTypes) {
        _takeBackTypes = [[NSMutableArray alloc] init];
    }
    return _takeBackTypes;
}

-(void)setSelectedtakeBackType:(KeyMap *)selectedtakeBackType{
    _selectedtakeBackType = selectedtakeBackType;
    self.takeBackTypeItem.handleTypeValue.text = selectedtakeBackType.name;
}

-(NSMutableArray *)takeBackReasons{
    if (!_takeBackReasons) {
        _takeBackReasons = [[NSMutableArray alloc] init];
    }
    return _takeBackReasons;
}

-(void)setSelectedtakeBackReason:(KeyMap *)selectedtakeBackReason{
    _selectedtakeBackReason = selectedtakeBackReason;
    self.takeBackReasonItem.handleTypeValue.text = selectedtakeBackReason.name;
}

-(NSMutableArray *)takeBackSubReasons{
    if (!_takeBackSubReasons) {
        _takeBackSubReasons = [[NSMutableArray alloc] init];
    }
    return _takeBackSubReasons;
}

-(void)setSelectedtakeBackSubReason:(KeyMap *)selectedtakeBackSubReason{
    _selectedtakeBackSubReason = selectedtakeBackSubReason;
    self.takeBackSubReasonItem.handleTypeValue.text = selectedtakeBackSubReason.name;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"处理结束";
    
    //获取完成类型列表
    [self queryFinishTypes];
    
    //添加界面元素
    //完成类型
    self.finishTypeItem = [OrderResultItem itemWithHandleType:@"完成类型" HandelBtnSelected:YES NormalImage:@"downpoint" SelectedImage:@"uppoint"];
    self.finishTypeItem.delegate = self;
    
    //完成类型选择列表
    self.finishTypeTableView = [[UITableView alloc] init];
    self.finishTypeTableView.dataSource = self;
    self.finishTypeTableView.delegate = self;
    self.finishTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.finishTypeTableView.scrollEnabled = NO;
    
    //故障域
    self.troubleDomainItem = [OrderResultItem itemWithHandleType:@"故障域" HandelBtnSelected:YES NormalImage:@"downpoint" SelectedImage:@"uppoint"];
    self.troubleDomainItem.delegate = self;
    //故障域列表
    self.troubleDomainTableView = [[UITableView alloc] init];
    self.troubleDomainTableView.dataSource = self;
    self.troubleDomainTableView.delegate = self;
    self.troubleDomainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.troubleDomainTableView.scrollEnabled = NO;

    //故障类别
    self.bugTypeItem = [OrderResultItem itemWithHandleType:@"故障类别" HandelBtnSelected:YES NormalImage:@"downpoint" SelectedImage:@"uppoint"];
    self.bugTypeItem.delegate = self;
    //故障类别列表
    self.bugTypeTableView = [[UITableView alloc] init];
    self.bugTypeTableView.dataSource = self;
    self.bugTypeTableView.delegate = self;
    self.bugTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bugTypeTableView.scrollEnabled = NO;

    //故障原因
    self.bugReasonItem = [OrderResultItem itemWithHandleType:@"故障原因" HandelBtnSelected:YES NormalImage:@"downpoint" SelectedImage:@"uppoint"];
    self.bugReasonItem.delegate = self;
    //故障原因列表
    self.bugReasonTableView = [[UITableView alloc] init];
    self.bugReasonTableView.dataSource = self;
    self.bugReasonTableView.delegate = self;
    self.bugReasonTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bugReasonTableView.scrollEnabled = NO;
    
    //退服类型
    self.takeBackTypeItem = [OrderResultItem itemWithHandleType:@"退服类型" HandelBtnSelected:YES NormalImage:@"downpoint" SelectedImage:@"uppoint"];
    self.takeBackTypeItem.delegate = self;
    //退服类型列表
    self.takeBackTypeTableView = [[UITableView alloc] init];
    self.takeBackTypeTableView.dataSource = self;
    self.takeBackTypeTableView.delegate = self;
    self.takeBackTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.takeBackTypeTableView.scrollEnabled = NO;
    
    //退服原因
    self.takeBackReasonItem = [OrderResultItem itemWithHandleType:@"退服原因" HandelBtnSelected:YES NormalImage:@"downpoint" SelectedImage:@"uppoint"];
    self.takeBackReasonItem.delegate = self;
    //退服原因列表
    self.takeBackReasonTableView = [[UITableView alloc] init];
    self.takeBackReasonTableView.dataSource = self;
    self.takeBackReasonTableView.delegate = self;
    self.takeBackReasonTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.takeBackReasonTableView.scrollEnabled = NO;
    
    //退服子原因
    self.takeBackSubReasonItem = [OrderResultItem itemWithHandleType:@"退服子原因" HandelBtnSelected:YES NormalImage:@"downpoint" SelectedImage:@"uppoint"];
    self.takeBackSubReasonItem.delegate = self;
    //退服子原因列表
    self.takeBackSubReasonTableView = [[UITableView alloc] init];
    self.takeBackSubReasonTableView.dataSource = self;
    self.takeBackSubReasonTableView.delegate = self;
    self.takeBackSubReasonTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.takeBackSubReasonTableView.scrollEnabled = NO;
    
    
    //处理总结
    self.handleSummaryItem = [[[NSBundle mainBundle] loadNibNamed:@"OrderResultItem" owner:nil options:nil] lastObject];
    self.handleSummaryItem.delegate = self;
    self.handleSummaryItem.handleType.text = @"处理总结";
    [self.handleSummaryItem.handleBtn setImage:[UIImage imageNamed:@"edit_bg"] forState:UIControlStateNormal];
    
    self.handleSummaryLabel = [[UILabel alloc] init];
    self.handleSummaryLabel.numberOfLines = 0;
    self.handleSummaryLabel.font = [UIFont systemFontOfSize:DescriptionFont];
    self.handleSummaryLabel.text = @"";
    
    //有无遗留问题
    self.leftProblemItem = [[[NSBundle mainBundle] loadNibNamed:@"OrderResultItem" owner:nil options:nil] lastObject];
    self.leftProblemItem.delegate = self;
    self.leftProblemItem.handleType.text = @"有无遗留问题";
    self.leftProblemItem.handleBtn.selected = NO;
    [self.leftProblemItem.handleBtn setImage:[UIImage imageNamed:@"nonelegacy.png"] forState:UIControlStateNormal];
    [self.leftProblemItem.handleBtn setImage:[UIImage imageNamed:@"legacy.png"] forState:UIControlStateSelected];

    
    self.leftProblemDescLabel = [[UILabel alloc] init];
    self.leftProblemDescLabel.numberOfLines = 0;
    self.leftProblemDescLabel.font = [UIFont systemFontOfSize:DescriptionFont];
    self.leftProblemDescLabel.text = @"";
    
    //备注
    self.remarkItem = [[[NSBundle mainBundle] loadNibNamed:@"OrderResultItem" owner:nil options:nil] lastObject];
    self.remarkItem.delegate = self;
    self.remarkItem.handleType.text = @"备注";
    [self.remarkItem.handleBtn setImage:[UIImage imageNamed:@"edit_bg"] forState:UIControlStateNormal];
    
    self.remarkDescLabel = [[UILabel alloc] init];
    self.remarkDescLabel.numberOfLines = 0;
    self.remarkDescLabel.font = [UIFont systemFontOfSize:DescriptionFont];
    self.remarkDescLabel.text = @"";
    
//    //附件上传工具栏
//    self.toolBarItem = [[[NSBundle mainBundle] loadNibNamed:@"OrderResultItem" owner:nil options:nil] lastObject];
//    self.toolBarItem.handleType.text = @"上传附件";
//    
//    self.toolBar = [[ToolBar alloc] init];
//    self.toolBar.view.frame = self.toolBar.bounds;
//    //附件列表内容暂不添加（待后续附件上传功能处理好再补）
//#warning 附件列表内容暂不添加
    
    //提交按钮
    self.commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 114, [UIScreen mainScreen].bounds.size.width, 50)];
    [self.commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.commitBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searchbg.png"]];
    [self.commitBtn addTarget:self action:@selector(EndOrderCommit) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 50)];
    
    [self.contentScrollView addSubview:self.finishTypeItem];
    [self.contentScrollView addSubview:self.finishTypeTableView];
//    [self.contentScrollView addSubview:self.troubleDomainItem];
//    [self.contentScrollView addSubview:self.troubleDomainTableView];
//    [self.contentScrollView addSubview:self.bugTypeItem];
//    [self.contentScrollView addSubview:self.bugTypeTableView];
//    [self.contentScrollView addSubview:self.bugReasonItem];
//    [self.contentScrollView addSubview:self.bugReasonTableView];
//    [self.contentScrollView addSubview:self.takeBackTypeItem];
//    [self.contentScrollView addSubview:self.takeBackTypeTableView];
//    [self.contentScrollView addSubview:self.takeBackReasonItem];
//    [self.contentScrollView addSubview:self.takeBackReasonTableView];
//    [self.contentScrollView addSubview:self.takeBackSubReasonItem];
//    [self.contentScrollView addSubview:self.takeBackSubReasonTableView];
    
    [self.contentScrollView addSubview:self.handleSummaryItem];
    [self.contentScrollView addSubview:self.handleSummaryLabel];
    [self.contentScrollView addSubview:self.leftProblemItem];
    [self.contentScrollView addSubview:self.leftProblemDescLabel];
    [self.contentScrollView addSubview:self.remarkItem];
    [self.contentScrollView addSubview:self.remarkDescLabel];
//    [self.contentScrollView addSubview:self.toolBarItem];
//    [self.contentScrollView addSubview:self.toolBar];
    
    [self.view addSubview:self.contentScrollView];
    [self.view addSubview:self.commitBtn];
    
    //控制alerView视图随键盘显示隐藏而改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGPoint center = self.alert.contentView.center;
    center.y = keyboardRect.origin.y - self.alert.contentView.frame.size.height / 2;
    self.alert.contentView.center = center;
}

-(void)keyboardWillHide:(NSNotification *)notification{
    self.alert.contentView.center = CGPointMake(self.alert.center.x, 100);
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat MaxY;
    
    [self.finishTypeItem setFrame:CGRectMake(20, 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
    MaxY = CGRectGetMaxY(self.finishTypeItem.frame);
    
    if (self.finishTypeItem.handleBtn.selected) {
        [self.finishTypeTableView setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, self.finishTypes.count * TableViewCellH)];
        MaxY = CGRectGetMaxY(self.finishTypeTableView.frame);
    }else{
        [self.finishTypeTableView setFrame:CGRectZero];
    }
    
    if (self.troubleDomains.count > 0) {
        [self.troubleDomainItem setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
        MaxY = CGRectGetMaxY(self.troubleDomainItem.frame);
        if (self.troubleDomainItem.handleBtn.selected) {
            [self.troubleDomainTableView setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, self.troubleDomains.count * TableViewCellH)];
            MaxY = CGRectGetMaxY(self.troubleDomainTableView.frame);
        }else{
            [self.troubleDomainTableView setFrame:CGRectZero];
        }
        [self.contentScrollView addSubview:self.troubleDomainItem];
        [self.contentScrollView addSubview:self.troubleDomainTableView];
    }else{
        [self.troubleDomainItem setFrame:CGRectZero];
        [self.troubleDomainTableView setFrame:CGRectZero];
    }
    
    if (self.bugTypes.count > 0) {
        [self.bugTypeItem setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
        MaxY = CGRectGetMaxY(self.bugTypeItem.frame);
        
        if (self.bugTypeItem.handleBtn.selected) {
            [self.bugTypeTableView setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, self.bugTypes.count * TableViewCellH)];
            MaxY = CGRectGetMaxY(self.bugTypeTableView.frame);
        }else{
            [self.bugTypeTableView setFrame:CGRectZero];
        }
        [self.contentScrollView addSubview:self.bugTypeItem];
        [self.contentScrollView addSubview:self.bugTypeTableView];
    }else{
        [self.bugTypeItem setFrame:CGRectZero];
        [self.bugTypeTableView setFrame:CGRectZero];
    }
    
    if (self.bugReasons.count > 0) {
        
        [self.bugReasonItem setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
        MaxY = CGRectGetMaxY(self.bugReasonItem.frame);
        if (self.bugReasonItem.handleBtn.selected) {
            [self.bugReasonTableView setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, self.bugReasons.count * TableViewCellH)];
            MaxY = CGRectGetMaxY(self.bugReasonTableView.frame);
        }else{
            [self.bugReasonTableView setFrame:CGRectZero];
        }
        [self.contentScrollView addSubview:self.bugReasonItem];
        [self.contentScrollView addSubview:self.bugReasonTableView];
    }else{
        [self.bugReasonItem setFrame:CGRectZero];
        [self.bugReasonTableView setFrame:CGRectZero];
    }
    
    if (self.takeBackTypes.count > 0) {
        [self.takeBackTypeItem setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
        MaxY = CGRectGetMaxY(self.takeBackTypeItem.frame);
        if (self.takeBackTypeItem.handleBtn.selected) {
            [self.takeBackTypeTableView setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, self.takeBackTypes.count * TableViewCellH)];
            MaxY = CGRectGetMaxY(self.takeBackTypeTableView.frame);
        }else{
            [self.takeBackTypeTableView setFrame:CGRectZero];
        }
        [self.contentScrollView addSubview:self.takeBackTypeItem];
        [self.contentScrollView addSubview:self.takeBackTypeTableView];
    }else{
        [self.takeBackTypeItem setFrame:CGRectZero];
        [self.takeBackTypeTableView setFrame:CGRectZero];
    }
    
    if (self.takeBackReasons.count > 0) {
        [self.takeBackReasonItem setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
        MaxY = CGRectGetMaxY(self.takeBackReasonItem.frame);
        if (self.takeBackReasonItem.handleBtn.selected) {
            [self.takeBackReasonTableView setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, self.takeBackReasons.count * TableViewCellH)];
            MaxY = CGRectGetMaxY(self.takeBackReasonTableView.frame);
        }else{
            [self.takeBackReasonTableView setFrame:CGRectZero];
        }
        [self.contentScrollView addSubview:self.takeBackReasonItem];
        [self.contentScrollView addSubview:self.takeBackReasonTableView];
    }else{
        [self.takeBackReasonItem setFrame:CGRectZero];
        [self.takeBackReasonTableView setFrame:CGRectZero];
    }
    
    if (self.takeBackSubReasons.count > 0) {
        [self.takeBackSubReasonItem setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
        MaxY = CGRectGetMaxY(self.takeBackSubReasonItem.frame);
        if (self.takeBackSubReasonItem.handleBtn.selected) {
            [self.takeBackSubReasonTableView setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, self.takeBackSubReasons.count * TableViewCellH)];
            MaxY = CGRectGetMaxY(self.takeBackSubReasonTableView.frame);
        }else{
            [self.takeBackSubReasonTableView setFrame:CGRectZero];
        }
        [self.contentScrollView addSubview:self.takeBackSubReasonItem];
        [self.contentScrollView addSubview:self.takeBackSubReasonTableView];
    }else{
        [self.takeBackSubReasonItem setFrame:CGRectZero];
        [self.takeBackSubReasonTableView setFrame:CGRectZero];
    }

    
    [self.handleSummaryItem setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
    MaxY = CGRectGetMaxY(self.handleSummaryItem.frame);
    
    if (self.handleSummaryLabel.text.length > 0) {
        CGSize textSize = [self sizeWithText:self.handleSummaryLabel.text font:[UIFont systemFontOfSize:DescriptionFont] maxW:[UIScreen mainScreen].bounds.size.width - 40];
        
        [self.handleSummaryLabel setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, textSize.height)];
        MaxY = CGRectGetMaxY(self.handleSummaryLabel.frame);
    }else{
        [self.handleSummaryLabel setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 10)];
        MaxY = CGRectGetMaxY(self.handleSummaryLabel.frame);
    }
    
    
    [self.leftProblemItem setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
    MaxY = CGRectGetMaxY(self.leftProblemItem.frame);
    
    if (self.leftProblemItem.handleBtn.selected) {
        CGSize TextSize = [self sizeWithText:self.leftProblemDescLabel.text font:[UIFont systemFontOfSize:DescriptionFont] maxW:[UIScreen mainScreen].bounds.size.width - 40];
        
        [self.leftProblemDescLabel setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, TextSize.height)];
        MaxY = CGRectGetMaxY(self.leftProblemDescLabel.frame);
    }else{
        [self.leftProblemDescLabel setFrame:CGRectZero];
    }
    
    
    [self.remarkItem setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
    MaxY = CGRectGetMaxY(self.remarkItem.frame);
    
    if (self.remarkDescLabel.text.length > 0) {
        CGSize textSize = [self sizeWithText:self.remarkDescLabel.text font:[UIFont systemFontOfSize:DescriptionFont] maxW:[UIScreen mainScreen].bounds.size.width - 40];
        
        [self.remarkDescLabel setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, textSize.height)];
        MaxY = CGRectGetMaxY(self.remarkDescLabel.frame);
    }else{
        [self.remarkDescLabel setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 10)];
        MaxY = CGRectGetMaxY(self.remarkDescLabel.frame);
    }
    
//    [self.toolBarItem setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
//    MaxY = CGRectGetMaxY(self.toolBarItem.frame);
//    
//    [self.toolBar setFrame:CGRectMake(20, MaxY + 5, [UIScreen mainScreen].bounds.size.width - 40, 50)];
//    MaxY = CGRectGetMaxY(self.toolBar.frame);
    
    [self.contentScrollView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 50)];
    self.contentScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, MaxY + 70);
}

//进行发电类工单处理结束提交
- (void)EndOrderCommit{
    //数据检查
    if (!self.finishTypeItem.handleTypeValue.text.length > 0) {
        [MBProgressHUD showError:@"请选择完成类型"];
        return;
    }
    
    if (!self.handleSummaryLabel.text.length > 0) {
        [MBProgressHUD showError:@"请填写处理总结"];
    }
    
    if ([self.selectedfinishType.value isEqualToString:@"000101"] || [self.selectedfinishType.value isEqualToString:@"000105"] || [self.selectedfinishType.value isEqualToString:@"000106"]) {
        // 完成类别为处理恢复，无需处理，其他时故障类型及故障原因不能空
        if (self.selectedbugType == nil || self.selectedbugReason == nil) {
            [MBProgressHUD showError:@"请选择故障类别及故障原因"];
            return;
        }
    }
    
    if (self.selectedtakeBackType == nil) {
        [MBProgressHUD showError:@"请选择退服类型"];

    }
    
    if (![self.selectedtakeBackType.value isEqualToString:@"1001"]) {
        if (self.selectedtakeBackReason == nil || self.selectedtakeBackSubReason == nil) {
            [MBProgressHUD showError:@"请选择退服原因及退服子原因"];
        }
    }
    
    //请求数据示例
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:@"username"];
    NSString *sessionId = [defaults objectForKey:@"sessionId"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"处理结束" forKey:@"taskId"];
    [params setObject:@"处理结束" forKey:@"operMBPS"];
    [params setObject:self.remarkDescLabel.text forKey:@"remark"];
    [params setObject:@"0" forKey:@"processId"];
    [params setObject:currentDateStr forKey:@"localTs"];
    if (self.selectedtakeBackReason) {
        [params setObject:self.selectedtakeBackReason.value forKey:@"takeBackReason"];
    }
    
    [params setObject:@"处理结束" forKey:@"taskName"];
    [params setObject:self.handleSummaryLabel.text forKey:@"handleSummary"];
    
    if (self.selectedtakeBackSubReason) {
        [params setObject:self.selectedtakeBackSubReason.value forKey:@"childTakeBackReason"];
    }
    
    if (self.selectedbugType) {
        [params setObject:self.selectedbugType.value forKey:@"bugType"];
    }
    
    if (self.selectedfinishType) {
        [params setObject:self.selectedfinishType.value forKey:@"finishType"];
    }
    
    [params setObject:userId forKey:@"userId"];
    
    if (self.selectedtakeBackType) {
        [params setObject:self.selectedtakeBackType.value forKey:@"takeBackType"];
    }
    
    [params setObject:self.workOrder.woId forKey:@"woId"];
    
    if (self.selectedbugReason) {
        [params setObject:self.selectedbugReason.value forKey:@"bugReason"];
    }
    
    [params setObject:self.leftProblemDescLabel.text forKey:@"questionDescribe"];
    
    if (self.selectedtroubleDomain) {
        [params setObject:self.selectedtroubleDomain.value forKey:@"faultDomain"];
    }
    
    if (_electricTime.startElectricTime) {
        [[MyLKDBHelper getUsingLKDBHelper]deleteToDB:_electricTime];
        [params setObject:_electricTime.startElectricTime forKey:@"elecStartTime"];
    }
    if (_electricTime.endElectricTime) {
        [params setObject:_electricTime.endElectricTime forKey:@"elecStopTime"];
    }

    
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMSubmitCompeleteWO";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    
    
    [MBProgressHUD showMessage:@"正在发送处理结束操作请求"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            if ([dic[@"timeOut"] isEqualToString:@"true"]) {
                //弹出密码格式提醒
                self.alert = [[FDAlertView alloc] init];
                AlertInputView *contentView = [[NSBundle mainBundle] loadNibNamed:@"AlertInputView" owner:nil options:nil].lastObject;
                contentView.frame = CGRectMake(0, 0, 300, 350);
                contentView.delegate = self;
                self.alert.contentView = contentView;
                [self.alert show];
                
            }else{
//                NSLog(@"处理结束成功");
                [self.navigationController popToViewController:self.rootController animated:YES];
                [self.navigationController.view makeToast:@"请求成功"];
            }
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
}

#pragma mark - AlertInputViewDelegate
- (void)AlertViewFinishInput:(NSString *)content
{
    [self.alert hide];
    
    //请求数据示例
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:@"username"];
    NSString *sessionId = [defaults objectForKey:@"sessionId"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"处理结束" forKey:@"taskId"];
    [params setObject:@"处理结束" forKey:@"operMBPS"];
    [params setObject:self.remarkDescLabel.text forKey:@"remark"];
    [params setObject:@"0" forKey:@"processId"];
    [params setObject:currentDateStr forKey:@"localTs"];
    if (self.selectedtakeBackReason) {
        [params setObject:self.selectedtakeBackReason.value forKey:@"takeBackReason"];
    }
    
    [params setObject:@"处理结束" forKey:@"taskName"];
    [params setObject:self.handleSummaryLabel.text forKey:@"handleSummary"];
    
    if (self.selectedtakeBackSubReason) {
        [params setObject:self.selectedtakeBackSubReason.value forKey:@"childTakeBackReason"];
    }
    
    if (self.selectedbugType) {
        [params setObject:self.selectedbugType.value forKey:@"bugType"];
    }
    
    if (self.selectedfinishType) {
        [params setObject:self.selectedfinishType.value forKey:@"finishType"];
    }
    
    [params setObject:userId forKey:@"userId"];
    
    if (self.selectedtakeBackType) {
        [params setObject:self.selectedtakeBackType.value forKey:@"takeBackType"];
    }
    
    [params setObject:self.workOrder.woId forKey:@"woId"];
    
    if (self.selectedbugReason) {
        [params setObject:self.selectedbugReason.value forKey:@"bugReason"];
    }
    
    [params setObject:self.leftProblemDescLabel.text forKey:@"questionDescribe"];
    
    if (self.selectedtroubleDomain) {
        [params setObject:self.selectedtroubleDomain.value forKey:@"faultDomain"];
    }
    
    if (_electricTime.startElectricTime) {
        [[MyLKDBHelper getUsingLKDBHelper]deleteToDB:_electricTime];
        [params setObject:_electricTime.startElectricTime forKey:@"elecStartTime"];
    }
    if (_electricTime.endElectricTime) {
        [params setObject:_electricTime.endElectricTime forKey:@"elecStopTime"];
    }
    [params setObject:content forKey:@"timeOutReason"];
    
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMinsertWOTimeout";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在发送处理结束带超时原因请求"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            [self.navigationController popToViewController:self.rootController animated:YES];
            [self.navigationController.view makeToast:@"请求成功"];
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
    
}

- (void)queryFinishTypes{
    //请求数据示例
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:@"username"];
    NSString *sessionId = [defaults objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"userId":userId,@"woId":self.workOrder.woId,@"taskName":@"处理结束",@"operMBPS":@"处理结束",@"processId":@"0"};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMGetCompelteTypes";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取完成类型"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            self.finishTypes = [KeyMap objectArrayWithKeyValuesArray:dic[@"types"]];
            
            [self.finishTypeTableView reloadData];
            
            [self.view setNeedsLayout];
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
            
        }
    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.finishTypeTableView) {
        return self.finishTypes.count;
    }else if (tableView == self.troubleDomainTableView){
        return self.troubleDomains.count;
    }else if (tableView == self.bugTypeTableView){
        return self.bugTypes.count;
    }else if (tableView == self.bugReasonTableView){
        return self.bugReasons.count;
    }else if (tableView == self.takeBackTypeTableView){
        return self.takeBackTypes.count;
    }else if (tableView == self.takeBackReasonTableView){
        return self.takeBackReasons.count;
    }else if (tableView == self.takeBackSubReasonTableView){
        return self.takeBackSubReasons.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identity"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identity"];
    }
    
    if (tableView == self.finishTypeTableView) {
        KeyMap *finishType = self.finishTypes[indexPath.row];
        cell.textLabel.text = finishType.name;
    }else if (tableView == self.troubleDomainTableView){
        KeyMap *troubleDomain = self.troubleDomains[indexPath.row];
        cell.textLabel.text = troubleDomain.name;
    }else if (tableView == self.bugTypeTableView){
        KeyMap *bugType = self.bugTypes[indexPath.row];
        cell.textLabel.text = bugType.name;
    }else if (tableView == self.bugReasonTableView){
        KeyMap *bugReason = self.bugReasons[indexPath.row];
        cell.textLabel.text = bugReason.name;
    }else if (tableView == self.takeBackTypeTableView){
        KeyMap *takeBackType = self.takeBackTypes[indexPath.row];
        cell.textLabel.text = takeBackType.name;
    }else if (tableView == self.takeBackReasonTableView){
        KeyMap *takeBackReason = self.takeBackReasons[indexPath.row];
        cell.textLabel.text = takeBackReason.name;
    }else if (tableView == self.takeBackSubReasonTableView){
        KeyMap *takeBackSubReason = self.takeBackSubReasons[indexPath.row];
        cell.textLabel.text = takeBackSubReason.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.finishTypeTableView) {
        KeyMap *type = self.finishTypes[indexPath.row];
        self.selectedfinishType = type;
        [self.finishTypeItem handleClick:self.finishTypeItem.handleBtn];
        //重置内部记录相关选择项目
        self.selectedtroubleDomain = nil;
        [self.troubleDomains removeAllObjects];
        
        self.selectedbugType = nil;
        [self.bugTypes removeAllObjects];
        
        self.selectedbugReason = nil;
        [self.bugReasons removeAllObjects];
        
        self.selectedtakeBackType = nil;
        [self.takeBackTypes removeAllObjects];
        
        self.selectedtakeBackReason = nil;
        [self.takeBackReasons removeAllObjects];
        
        self.selectedtakeBackSubReason = nil;
        [self.takeBackSubReasons removeAllObjects];
        
        //根据完成类型获得故障类别列表或者退服类型列表
        [self queryWithFinishType];
    }else if (tableView == self.troubleDomainTableView){
        TroubleDomain *troubleDomain = self.troubleDomains[indexPath.row];
        self.selectedtroubleDomain = troubleDomain;
        [self.troubleDomainItem handleClick:self.troubleDomainItem.handleBtn];
        
        //重置内部记录相关选择项目
        self.selectedbugType = nil;
        [self.bugTypes removeAllObjects];
        
        self.selectedbugReason = nil;
        [self.bugReasons removeAllObjects];
        
        self.selectedtakeBackType = nil;
        [self.takeBackTypes removeAllObjects];
        
        self.selectedtakeBackReason = nil;
        [self.takeBackReasons removeAllObjects];
        
        self.selectedtakeBackSubReason = nil;
        [self.takeBackSubReasons removeAllObjects];
        
        //根据故障域获取故障类别
        [self getBugTypsWithTroubleDomain];
    }else if (tableView == self.bugTypeTableView){
        KeyMap *bugType = self.bugTypes[indexPath.row];
        self.selectedbugType = bugType;
        [self.bugTypeItem handleClick:self.bugTypeItem.handleBtn];
        
        //重置内部记录相关选择项目
        self.selectedbugReason = nil;
        [self.bugReasons removeAllObjects];
        
        self.selectedtakeBackType = nil;
        [self.takeBackTypes removeAllObjects];
        
        self.selectedtakeBackReason = nil;
        [self.takeBackReasons removeAllObjects];
        
        self.selectedtakeBackSubReason = nil;
        [self.takeBackSubReasons removeAllObjects];
        
        //根据故障类别获取故障原因列表
        [self getBugReasonsWithBugType];
    }else if (tableView == self.bugReasonTableView){
        KeyMap *bugReason = self.bugReasons[indexPath.row];
        self.selectedbugReason = bugReason;
        [self.bugReasonItem handleClick:self.bugReasonItem.handleBtn];
        
        //重置内部记录相关选择项目
        self.selectedtakeBackType = nil;
        [self.takeBackTypes removeAllObjects];
        
        self.selectedtakeBackReason = nil;
        [self.takeBackReasons removeAllObjects];
        
        self.selectedtakeBackSubReason = nil;
        [self.takeBackSubReasons removeAllObjects];
        
        //根据故障原因获取退服类型列表
        [self getTakeBackTypesWithBugReason];
    }else if (tableView == self.takeBackTypeTableView){
        KeyMap *takeBackType = self.takeBackTypes[indexPath.row];
        self.selectedtakeBackType = takeBackType;
        [self.takeBackTypeItem handleClick:self.takeBackTypeItem.handleBtn];
        
        //重置内部记录相关选择项目
        self.selectedtakeBackReason = nil;
        [self.takeBackReasons removeAllObjects];
        
        self.selectedtakeBackSubReason = nil;
        [self.takeBackSubReasons removeAllObjects];
        
        //未退服类型则不去获取退服原因
        if (![self.selectedtakeBackType.value isEqualToString:@"1001"]) {
            //根据退服类型获取退服原因
            [self getTakeBackReasonsWithTakeBackType];
        }
        
    }else if (tableView == self.takeBackReasonTableView){
        KeyMap *takeBackReason = self.takeBackReasons[indexPath.row];
        self.selectedtakeBackReason = takeBackReason;
        [self.takeBackReasonItem handleClick:self.takeBackReasonItem.handleBtn];
        
        //重置内部记录相关选择项目
        self.selectedtakeBackSubReason = nil;
        [self.takeBackSubReasons removeAllObjects];
        //根据退服原因获取退服子原因
        [self getTakeBackSubReasonsWithTakeBackReason];
    }else if (tableView == self.takeBackSubReasonTableView){
        KeyMap *takeBackSubReason = self.takeBackSubReasons[indexPath.row];
        self.selectedtakeBackSubReason = takeBackSubReason;
        [self.takeBackSubReasonItem handleClick:self.takeBackSubReasonItem.handleBtn];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (void)queryWithFinishType{
    //请求数据示例
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *userId = [defaults objectForKey:@"username"];
    NSString *sessionId = [defaults objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"woId":self.workOrder.woId,@"compelteType":self.selectedfinishType.value,@"operCenterCode":self.workOrderDetail.baseInfo.operCenterCode};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMGetListByCondition";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取故障类别列表或者退服类型列表"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            if ([dic[@"hasTroubleDomain"] boolValue]) {
                self.troubleDomains = [TroubleDomain objectArrayWithKeyValuesArray:dic[@"troubleDoamins"]];
                [self.troubleDomainTableView reloadData];
            }else{
                self.bugTypes = [KeyMap objectArrayWithKeyValuesArray:dic[@"bugTypeList"]];
                [self.bugTypeTableView reloadData];
                
                self.takeBackTypes = [KeyMap objectArrayWithKeyValuesArray:dic[@"takeBackTypeList"]];
                [self.takeBackTypeTableView reloadData];
            }
            
            [self.view setNeedsLayout];

        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];

}

- (void)getBugTypsWithTroubleDomain
{
    //请求数据示例
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *userId = [defaults objectForKey:@"username"];
    NSString *sessionId = [defaults objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"parentId":self.selectedtroubleDomain.value,@"operCenterCode":self.workOrderDetail.baseInfo.operCenterCode};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMGetTroubleDomainTroubles";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取故障类别"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            self.bugTypes = [KeyMap objectArrayWithKeyValuesArray:dic[@"bugTypeList"]];
            [self.bugTypeTableView reloadData];
            [self.view setNeedsLayout];

        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
}

-(void)getBugReasonsWithBugType{
    //请求数据示例
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *userId = [defaults objectForKey:@"username"];
    NSString *sessionId = [defaults objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"bug_type":self.selectedbugType.value};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMGetListByCondition";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取故障原因"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            self.bugReasons = [KeyMap objectArrayWithKeyValuesArray:dic[@"bugReasonList"]];
            [self.bugReasonTableView reloadData];
            [self.view setNeedsLayout];

        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }

    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];

}

- (void)getTakeBackTypesWithBugReason{
    //请求数据示例
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *userId = [defaults objectForKey:@"username"];
    NSString *sessionId = [defaults objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"bugReason":self.selectedbugReason.value,@"bug_type":self.selectedbugType.value};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMGetListByCondition";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取退服类型"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            self.takeBackTypes = [KeyMap objectArrayWithKeyValuesArray:dic[@"takeBackTypeList"]];
            [self.takeBackTypeTableView reloadData];
            [self.view setNeedsLayout];

        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
            
        }
    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
}

- (void)getTakeBackReasonsWithTakeBackType{
    //请求数据示例
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *userId = [defaults objectForKey:@"username"];
    NSString *sessionId = [defaults objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"takeback_type":self.selectedtakeBackType.value};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMGetListByCondition";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取退服原因"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            self.takeBackReasons = [KeyMap objectArrayWithKeyValuesArray:dic[@"takeBackReasonList"]];
            [self.takeBackReasonTableView reloadData];
            [self.view setNeedsLayout];

        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
        
    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
}

- (void)getTakeBackSubReasonsWithTakeBackReason{
    //请求数据示例
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *userId = [defaults objectForKey:@"username"];
    NSString *sessionId = [defaults objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"takeback_childreason":self.selectedtakeBackReason.value};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMGetListByCondition";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取退服子原因"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
            self.takeBackSubReasons = [KeyMap objectArrayWithKeyValuesArray:dic[@"takeBackChildReasonList"]];
            [self.takeBackSubReasonTableView reloadData];
            [self.view setNeedsLayout];

        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];

}

#pragma mark - OrderResultItemDelegate
-(void)OrderResultItemClick:(UIButton *)btn{
    if (btn == self.finishTypeItem.handleBtn) {
        //细节操作实现于此
    }else if (btn == self.troubleDomainItem.handleBtn){
        //细节操作实现于此
    }else if (btn == self.bugTypeItem.handleBtn){
        //细节操作实现于此
    }else if (btn == self.bugReasonItem.handleBtn){
        //细节操作实现于此
    }else if (btn == self.takeBackTypeItem.handleBtn){
        //细节操作实现于此
    }else if (btn == self.takeBackReasonItem.handleBtn){
        //细节操作实现于此
    }else if (btn == self.takeBackSubReasonItem.handleBtn){
        //细节操作实现于此
    }else if (btn == self.handleSummaryItem.handleBtn){
        PhaseFeedBackDescInputViewController *summaryInput = [[PhaseFeedBackDescInputViewController alloc] init];
        summaryInput.content = self.handleSummaryLabel.text;
        summaryInput.delegate = self;
        summaryInput.item = self.handleSummaryItem;
        
        [self.navigationController pushViewController:summaryInput animated:YES];
    }else if (btn == self.leftProblemItem.handleBtn){
        if (btn.selected == YES) {
            PhaseFeedBackDescInputViewController *leftProblemInput = [[PhaseFeedBackDescInputViewController alloc] init];
            leftProblemInput.delegate = self;
            leftProblemInput.item = self.leftProblemItem;
            
            [self.navigationController pushViewController:leftProblemInput animated:YES];
        }else{
            self.leftProblemDescLabel.text = @"";
        }
    }else if (btn == self.remarkItem.handleBtn){
        PhaseFeedBackDescInputViewController *remarkInput = [[PhaseFeedBackDescInputViewController alloc] init];
        remarkInput.content = self.remarkDescLabel.text;
        remarkInput.delegate = self;
        remarkInput.item = self.remarkItem;
        
        [self.navigationController pushViewController:remarkInput animated:YES];
    }
    
    [self.view setNeedsLayout];
    
}

#pragma mark - PhaseFeedBackDescInputDelegate
-(void)ContentDidInputWithItem:(OrderResultItem *)item Content:(NSString *)content{
    if (item == self.handleSummaryItem) {
        self.handleSummaryLabel.text = content;
    }else if (item == self.leftProblemItem){
        self.leftProblemDescLabel.text = content;
    }else if (item == self.remarkItem){
        self.remarkDescLabel.text = content;
    }
}
@end
