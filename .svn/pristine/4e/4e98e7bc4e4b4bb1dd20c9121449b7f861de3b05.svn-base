//
//  AddAnnounceDepartmentVC.h
//  Ericsson
//
//  Created by Min on 15/12/28.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddAnnounceDepartmentVCDelegate <NSObject>
@optional
- (void)submitDepartmentSelected:(NSString*)depart indexPath:(NSIndexPath*)selectedCell integer:(NSInteger)selectedSection;

@end

@interface AddAnnounceDepartmentVC : BaseViewController

/** 标记哪一个cell被选中 */
@property (nonatomic,strong) NSIndexPath * selectedCell;
/** 标记哪一个section被选中*/
@property (nonatomic,assign) NSInteger selectedSection;

/** 确认提交按钮 */
@property (nonatomic,weak) id<AddAnnounceDepartmentVCDelegate> delegate;
@end
