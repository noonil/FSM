//
//  SoapService.h
//  SOAP-IOS
//
//  Created by Elliott on 13-7-26.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface ResponseData : NSObject

@property NSInteger StatusCode;
@property NSDictionary *jsonDic;
@end



typedef void (^SuccessBlock) (NSDictionary *dic);
typedef void (^FailureBlock) (NSError *response);

@interface SoapService : NSObject


@property (nonatomic,strong) SuccessBlock success;
@property (nonatomic,strong) FailureBlock failure;

+(SoapService *)shareInstance;

-(NSDictionary *)PostSync:(NSString *)postData;
-(void)PostAsync:(NSString *)postData Success:(SuccessBlock)success falure:(FailureBlock)falure;

@end
