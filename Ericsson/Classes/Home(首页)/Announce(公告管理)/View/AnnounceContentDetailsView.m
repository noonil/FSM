//
//  AnnounceContentDetailsView.m
//  Ericsson
//
//  Created by Min on 15/12/23.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "AnnounceContentDetailsView.h"
#import "AnnounceContentModel.h"
#import "NSString+Extension.h"
#import "AnnoucneItemDetailModel.h"

// 左边间距
#define AnnContentDetailsLeftMargin 20

#define AnnContentDetailsBoarder 5.0

// 字体
#define AnnContentDetailsTitleFont [UIFont systemFontOfSize:23.0]
#define AnnContentDetailsNmaeOrTimeFont [UIFont systemFontOfSize:18.0]
#define AnnContentDetailsContentFont [UIFont systemFontOfSize:23]


// 字体颜色
#define txtColor [UIColor colorWithRed:48/255.0 green:88/255.0 blue:148/255.0 alpha:1]

@interface AnnounceContentDetailsView()
/** titleLabel*/
@property (nonatomic,weak) UILabel * titleLabel;
/** nameLabel*/
@property (nonatomic,weak) UILabel * nameLabel;
/** timeLabel*/
@property (nonatomic,weak) UILabel * timeLabel;
/** 分割线 ImageView*/
@property (nonatomic,weak) UIView * separateView;
/** contentLabel*/
@property (nonatomic,weak) UILabel * contentLabel;
/** editBtn */
@property (nonatomic,weak) UIButton *editBtn;

@end
@implementation AnnounceContentDetailsView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加内容
        [self setupContent];
    }
    return self;
}
/**
 *  添加内容
 */
- (void)setupContent
{
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.font = AnnContentDetailsTitleFont;
    titleLabel.textColor = txtColor;
    titleLabel.numberOfLines = 0;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.font = AnnContentDetailsNmaeOrTimeFont;
    [self addSubview:nameLabel];
    nameLabel.textColor = txtColor;
    self.nameLabel = nameLabel;
    
    UILabel * timeLabel = [[UILabel alloc]init];
    timeLabel.font = AnnContentDetailsNmaeOrTimeFont;
    [self addSubview:timeLabel];
    timeLabel.textColor = txtColor;
    self.timeLabel = timeLabel;
    
    UIView * separateView = [[UIView alloc]init];
    separateView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blue_full_bt_bg"]];
    [self addSubview:separateView];
    self.separateView = separateView;
    
    UILabel * contentLabel = [[UILabel alloc]init];
    contentLabel.font = AnnContentDetailsContentFont;
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = txtColor;
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    UIButton * btn = [[UIButton alloc]init];
    btn.backgroundColor = KBaseBlue;
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(editMyDraft) forControlEvents:UIControlEventTouchUpInside];
    self.editBtn = btn;
    [self addSubview:btn];	
}

- (void)editMyDraft
{
// 通知控制前进行跳转
    if ([self.delegate respondsToSelector:@selector(editMyDraft:)]) {
        [self.delegate editMyDraft:self.flag];
    }
}

#pragma mark - setter方法
- (void)setContentModel:(AnnoucneItemDetailModel *)contentModel
{
    self.titleLabel.text = contentModel.title;
    self.timeLabel.text = contentModel.time;
    if ([contentModel.name isEqualToString:@"222222"]) {
        self.nameLabel.text = @"";
        
    }else{
    NSString * name = [NSString stringWithFormat:@"%@(%@)",contentModel.name,contentModel.departName];
    self.nameLabel.text = name;
    }
    self.contentLabel.text = contentModel.content;
    
    CGFloat viewW = self.width;
    CGFloat viewH = self.height;
    
    CGFloat titleLabelX = AnnContentDetailsLeftMargin;
    CGFloat titleLabelY = 10;
    CGFloat titleMaxW = viewW - 2*titleLabelX;
    CGSize titleSize = [self.titleLabel.text sizeWithFont:AnnContentDetailsTitleFont maxW:titleMaxW];
    
    if (titleSize.height == 0) titleSize.height = 27.44; // 如果没有给一个固定高度
    self.titleLabel.frame = (CGRect){{titleLabelX,titleLabelY},titleSize};
    
    CGFloat nameLabelX = AnnContentDetailsLeftMargin;
    CGFloat nameLabelY = CGRectGetMaxY(self.titleLabel.frame) + AnnContentDetailsBoarder;
    CGSize nameSize = [self.nameLabel.text sizeWithFont:AnnContentDetailsNmaeOrTimeFont];
    if (nameSize.height == 0) nameSize.height = 27.44; // 如果没有给一个固定高度
    self.nameLabel.frame = (CGRect){{nameLabelX,nameLabelY},nameSize};
    
    
    CGSize timeSize = [self.timeLabel.text sizeWithFont:AnnContentDetailsTitleFont];
    CGFloat timeLabelX = AnnContentDetailsLeftMargin;
    CGFloat timeLabelY = CGRectGetMaxY(self.nameLabel.frame);
    
    self.timeLabel.frame = (CGRect){{timeLabelX,timeLabelY},timeSize};
    
    CGFloat separateViewX = 0;
    CGFloat separateViewY = CGRectGetMaxY(self.timeLabel.frame);
    CGFloat separateViewW = viewW;
    CGFloat separateViewH = 5;
    self.separateView.frame = CGRectMake(separateViewX, separateViewY, separateViewW, separateViewH);
    
    CGFloat contentLabelX = AnnContentDetailsLeftMargin;
    CGFloat contentLabelY = CGRectGetMaxY(self.separateView.frame) + AnnContentDetailsBoarder;
    CGFloat contentMaxW = titleMaxW;
    CGSize contentSize = [self.contentLabel.text sizeWithFont:AnnContentDetailsTitleFont maxW:contentMaxW];
    self.contentLabel.frame = (CGRect){{contentLabelX,contentLabelY},contentSize};
    
    CGFloat editBtnW = viewW;
    CGFloat editBtnH = 60;
    CGFloat editBtnX = 0;
    CGFloat editBtnY = viewH - 124;
    self.editBtn.hidden = !_isHiddenEditBtn;
    self.editBtn.frame = CGRectMake(editBtnX, editBtnY, editBtnW, editBtnH);
    
}


@end
