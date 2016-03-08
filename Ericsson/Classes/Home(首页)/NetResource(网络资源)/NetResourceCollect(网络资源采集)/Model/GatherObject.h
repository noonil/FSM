//
//  GatherObject.h
//  Ericsson
//
//  Created by xuming on 16/2/19.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GatherObject : NSObject

@property(nonatomic, strong)NSString *isSelect;
@property(nonatomic, strong)NSString *enfield;
@property(nonatomic, strong)NSString *chfield;
@property(nonatomic, strong)NSString *tablename;
@property(nonatomic, strong)NSString *isnull;
@property(nonatomic, strong)NSString *datatype;
@property(nonatomic, strong)NSMutableArray * selectDatas;

@property(nonatomic, strong)NSString * value;//上传的属性值
@property(nonatomic, strong)NSString * chineseValue;//弹出显示列表的，中文属性值


@end
