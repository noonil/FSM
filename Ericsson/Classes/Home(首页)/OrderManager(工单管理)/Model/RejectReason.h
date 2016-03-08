//
//  RejectReason.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/4.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RejectReason : NSObject

//原因id
@property (nonatomic,strong)NSString *reasonId;

//原因名称
@property (nonatomic,strong)NSString *reasonName;

@end
