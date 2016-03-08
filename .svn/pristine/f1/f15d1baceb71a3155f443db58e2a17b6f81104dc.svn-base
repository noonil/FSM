//
//  LogSectionHeader.h
//  Ericsson
//
//  Created by 范传斌 on 15/10/9.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LogSectionHeaderDelegate <NSObject>
-(void)SectionHeaderBtnClick:(NSInteger) section;
@end

@interface LogSectionHeader : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tailIcon;

- (IBAction)ChangeStatus:(UIButton *)sender;
@property (nonatomic,assign)NSInteger section;

@property (nonatomic,assign)BOOL isShow;

@property (nonatomic,strong)id<LogSectionHeaderDelegate> delegate;

+(LogSectionHeader *)SectionHeaderView;

@end
