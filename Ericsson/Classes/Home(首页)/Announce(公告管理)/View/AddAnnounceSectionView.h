//
//  AddAnnounceSectionView.h
//  Ericsson
//
//  Created by Min on 15/12/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AddAnnounceSectionViewDelegate <NSObject>
@optional
- (void)SectionHeaderBtnClick:(NSInteger) section;
- (void)changeSectionSelectedBtn:(NSInteger) section;
@end


@interface AddAnnounceSectionView : UIView

/** section是否展开 */
@property (weak, nonatomic) IBOutlet UIButton *isFoldBtn;

/** 按钮是否被选中 */
@property (weak, nonatomic) IBOutlet UIButton *isSelectedBtn;
/** 组织名 */
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;


@property (nonatomic,assign)NSInteger section;

@property (nonatomic,assign)BOOL isShow;

/** 代理 */
@property (nonatomic,weak) id<AddAnnounceSectionViewDelegate> delegate;

+(AddAnnounceSectionView *)SectionHeaderView;
@end
