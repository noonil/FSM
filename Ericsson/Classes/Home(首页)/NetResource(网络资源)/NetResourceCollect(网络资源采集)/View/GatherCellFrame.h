//
//  GatherCellFrame.h
//  Ericsson
//
//  Created by xuming on 16/2/19.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GatherObject;

@interface GatherCellFrame : NSObject

//采集对象的各个属性
@property(nonatomic, strong) GatherObject *gatherObject;

//星形图片
@property(nonatomic, assign, readonly) CGRect starImgViewF;
//标题label
@property(nonatomic, assign, readonly) CGRect titleLabelF;
//输入框
@property(nonatomic, assign, readonly) CGRect textFieldF;
//选择按钮
@property(nonatomic, assign, readonly) CGRect buttonF;

//选择按钮下面的背景图片
@property(nonatomic, assign, readonly) CGRect buttonImgViewF;


@end
