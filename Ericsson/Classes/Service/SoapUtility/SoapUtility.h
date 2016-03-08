//
//  SoapUtility.h
//  SOAP-IOS
//
//  Created by Elliott on 13-7-26.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXML.h"


@interface SoapUtility : NSObject

+(SoapUtility *)shareInstance;
-(NSString *)BuildSoapWithModelName:(NSString *)modelname methodName:(NSString *)methodName sessonId:(NSString *)sessonId requestData:(NSDictionary *)jsonDic ;


@end
