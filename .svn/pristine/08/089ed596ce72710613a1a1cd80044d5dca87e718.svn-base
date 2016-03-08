//
//  AnnounceContentModel.h
//  Ericsson
//
//  Created by Min on 15/12/22.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnounceContentModel : NSObject
/*
 “retCode”:”x” ;     0:请求成功  -1:请求失败  -2:回话sessionId 失效
 “announceList”:[{
     "hasRead": true,    是否已读过 true :读过  false:未读
     "name": "刘伟鹏",    名字
     "departName": "栾城县小组",   部门名字
     "content": "哦哦娶了",    内容
     "time": "2015-10-10 17:05:01",   时间
     "annouceId": "1305",    公告id
     "title": "唐家三少"     标题
 }]
 */

/** 公告列表 是否已阅读 */
@property (nonatomic,assign) BOOL  hasRead;
/** 公告列表 名字 */
@property (nonatomic,copy) NSString * name;
/** 公告列表 部门名字 */
@property (nonatomic,copy) NSString * departName;
/** 公告列表 内容 */
@property (nonatomic,copy) NSString * content;
/** 公告列表 时间 */
@property (nonatomic,copy) NSString * time;
/** 公告列表 公告id */
@property (nonatomic,  strong ) NSString * annouceId;
/** 公告列表 标题 */
@property (nonatomic,copy) NSString * title;

/** 有效时间 */
@property (copy ,nonatomic) NSString * availableTime;
/** 是否包含子部门 */
@property (assign ,nonatomic) BOOL isContainSubDepart;

/** 选中的组织的indexPath */
@property (assign ,nonatomic) NSInteger section;
@property (assign ,nonatomic) NSInteger row;

/** 选中的组织的是section(为NSNotFound的时候，选择的为cell) */
@property (assign ,nonatomic) NSInteger selectedSection;

/** departText 显示的内容*/
@property (copy ,nonatomic) NSString * departText;




@end
