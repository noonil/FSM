//
//  DraftModel.h
//  Ericsson
//
//  Created by Min on 15/12/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DraftModel : NSObject

/** "departName": "栾城县小组",部门名字 */
@property (nonatomic,copy) NSString * departName;

/** "content": "哦哦娶了",    内容 */
@property (nonatomic,copy) NSString * content;

/** "time": "2015-10-10 17:05:01",   时间 */
@property (nonatomic,copy) NSString * time;


/** "title": "唐家三少"     标题 */
@property (nonatomic,copy) NSString * title;

@end
