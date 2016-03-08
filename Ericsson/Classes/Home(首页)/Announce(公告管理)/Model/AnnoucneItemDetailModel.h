//
//  AnnoucneItemDetailModel.h
//  Ericsson
//
//  Created by Min on 16/1/15.
//  Copyright © 2016年 范传斌. All rights reserved.
//
/**
 {
 content = “鞭炮鞭炮鞭炮”
 departName = "中国";
 id = 935;
 name = Ryan;
 time = "2016-01-15 12:44:43";
 title = "鞭炮厂爆炸";
 */
#import <Foundation/Foundation.h>

@interface AnnoucneItemDetailModel : NSObject

@property (nonatomic,copy) NSString * content;
@property (nonatomic,copy) NSString * departName;
@property (nonatomic,copy) NSString * ID;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * time;
@property (nonatomic,copy) NSString * title;

@end
