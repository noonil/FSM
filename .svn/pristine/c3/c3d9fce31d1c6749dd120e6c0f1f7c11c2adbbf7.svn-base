//
//  AnnounceContentCell.m
//  Ericsson
//
//  Created by Min on 15/12/22.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "AnnounceContentCell.h"
#import "AnnounceContentFrame.h"
#import "AnnounceContentModel.h"


#define txtGrayColor [UIColor colorWithRed:118/255.0 green:118/255.0 blue:118/255.0 alpha:1]
#define txtBlueColor [UIColor colorWithRed:29/255.0 green:95/255.0 blue:176/255.0 alpha:1]

@interface AnnounceContentCell()
/** 顶部的灰色视图 */
@property (nonatomic,strong) UIView * grayView;

/** cell的内容View */
@property (nonatomic,strong) UIView * contentV;

/** 标题label*/
@property (nonatomic,strong) UILabel * titleLabel;
/** 内容label*/
@property (nonatomic,strong) UILabel * contentLabel;
/** 名字label*/
@property (nonatomic,strong) UILabel * nameLabel;
/** 部门名字label*/
@property (nonatomic,strong) UILabel * departNameLabel;
/** 时间label*/
@property (nonatomic,strong) UILabel * timeLabel;

@end

@implementation AnnounceContentCell
#pragma mark - 初始化 initilize
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"contentList";
    AnnounceContentCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[AnnounceContentCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
       
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化工作
        
        // 设置cell顶部 灰色分割线
        [self setupTopGrayView];
        
        // 设置 内容
        [self setupContentView];
    }
    return self;
}
/**
 *  添加顶部的View
 */
- (void)setupTopGrayView
{
    UIView * grayView = [[UIView alloc]init];
    grayView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    self.grayView = grayView;
    [self.contentView addSubview:grayView];
}
/**
 *  添加所有内容的Label
 */
- (void)setupContentView
{
    // 内容
    UIView * contentV = [[UIView alloc] init];
    contentV.backgroundColor = [UIColor whiteColor];
    self.contentV = contentV;
    [self.contentView addSubview:contentV];
    
    // 标题
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.font = AnnounceTitleFont;
    titleLabel.numberOfLines = 0;
    self.titleLabel = titleLabel;
    [contentV addSubview:titleLabel];
    
    // 内容
    UILabel * contentLabel = [[UILabel alloc]init];
    contentLabel.font = AnnoucneContentFont;
//    contentLabel.numberOfLines = 1;
    self.contentLabel = contentLabel;
    [contentV addSubview:contentLabel];
    
    // 名字
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.font = AnnounceOthersFont;
//    nameLabel.numberOfLines = 1;
    self.nameLabel = nameLabel;
    [contentV addSubview:nameLabel];
    
    // 部门名字
    UILabel * departNameLabel = [[UILabel alloc]init];
    departNameLabel.font = AnnounceOthersFont;
//    departNameLabel.numberOfLines = 1;
    self.departNameLabel = departNameLabel;
    [contentV addSubview:departNameLabel];
    
    // 时间
    UILabel * timeLabel = [[UILabel alloc]init];
    timeLabel.font = AnnounceOthersFont;
//    timeLabel.numberOfLines = 1;
    self.timeLabel = timeLabel;
    [contentV addSubview:timeLabel];
}


- (void)setContentFrame:(AnnounceContentFrame *)contentFrame
{
    _contentFrame = contentFrame;
    AnnounceContentModel * contentModel = contentFrame.contentModel;
    
    BOOL hasRead = contentModel.hasRead;
    // 设置颜色
    UIColor * textColor = nil;
    if (hasRead) {
        textColor = txtGrayColor;
    } else {
        textColor = txtBlueColor;
    }
    
    // 顶部的灰色视图
    self.grayView.frame = contentFrame.grayViewF;
    
    // cell的内容View
    self.contentV.frame = contentFrame.contentVF;

    // 标题label
    self.titleLabel.frame = contentFrame.titleLabelF;
    self.titleLabel.text = contentModel.title;
    self.titleLabel.textColor = textColor ? textColor :txtGrayColor;
    // 内容label
    self.contentLabel.frame = contentFrame.contentLabelF;
    self.contentLabel.text = contentModel.content;
    self.contentLabel.textColor = textColor ? textColor :txtGrayColor;
    
    // 名字label
    self.nameLabel.frame = contentFrame.nameLabelF;
    if ([contentModel.name isEqualToString:@"222222"]) {
        self.nameLabel.text = @"";
    }else{
        self.nameLabel.text = contentModel.name;
    }
    self.nameLabel.textColor = textColor ? textColor :txtGrayColor;
    
    // 部门名字label
    self.departNameLabel.frame = contentFrame.departNameLabelF;
    if ([contentModel.departName isEqualToString:@"222222"]) {
        self.departNameLabel.text = @"";
    }else{
        self.departNameLabel.text = [NSString stringWithFormat:@"(%@)",contentModel.departName];
    }
    self.departNameLabel.textColor = textColor ? textColor :txtGrayColor;
    
    // 时间label
    self.timeLabel.frame    = contentFrame.timeLabelF;
    self.timeLabel.text     = contentModel.time;
    self.timeLabel.textColor = textColor ? textColor :txtGrayColor;
}

@end
