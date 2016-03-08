//
//  SoapService.m
//  SOAP-IOS
//
//  Created by Elliott on 13-7-26.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import "SoapService.h"
#import "AFNetworking.h"
#import "CompressAndEncrypt.h"




//8480端口 018192 密码 123456 废弃
//8380端口 user01 密码 123456

//static NSString * PostUrl=@"http://192.168.101.105:30041/FSMAppServer/services/redirectService";

//static NSString * PostUrl=@"http://121.28.82.70:8480/FSMAppServer/services/redirectService";

static NSString * PostUrl=@"http://121.28.82.70:8380/FSMAppServer/services/redirectService";// 测试库

//static NSString * PostUrl=@"http://121.28.82.70:8680/FSMAppServer/services/redirectService";//正式库

//static NSString * PostUrl=@"http://172.16.181.1:8883/FSMAppServer/services/redirectService";

//static NSString * PostUrl=@"http://192.168.253.1:8088/FSMAppServer/services/redirectService";

//static NSString * PostUrl=@"http://172.16.181.1:8088/FSMAppServer/services/redirectService";

//static NSString * PostUrl=@"http://192.168.253.1:8883/FSMAppServer/services/redirectService";
//验收正式库版本接口
//static NSString * PostUrl=@"http://47.89.36.68:8680/FSMAppServer/services/redirectService";



@implementation ResponseData

@end

@implementation SoapService

+(SoapService *)shareInstance{

    static SoapService * soapService=nil;
    static dispatch_once_t once;
    dispatch_once (&once,^{
        soapService=[[self alloc]init];
    }
                   );
    
    return soapService;

}


-(NSDictionary *)PostSync:(NSString *)postData{
    
    NSMutableURLRequest *request=[self CreatRequest:postData];
    NSHTTPURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:&response error:nil];
    
    // 处理返回的数据
    NSString *returnStr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSString *returnJsonStr=[CompressAndEncrypt untie_EncryptAndcompress_jsonStr:returnStr];

    if (response.statusCode==200) {
        return [self dictionaryWithJsonString:returnJsonStr ];
    } 
    else{
        return  nil;
    }
}


-(void)PostAsync:(NSString *)postData Success:(SuccessBlock)success falure:(FailureBlock)failure{
    NSMutableURLRequest *request=[self CreatRequest:postData];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *returnJsonStr=[CompressAndEncrypt untie_EncryptAndcompress_jsonStr:operation.responseString];
         success([self dictionaryWithJsonString:returnJsonStr ]);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];
    [operation start];
}



-(NSMutableURLRequest *)CreatRequest:(NSString *)postData{
    // 要请求的地址
    NSString *urlString=PostUrl;
    // 将地址编码
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    // 实例化NSMutableURLRequest，并进行参数配置
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    [request setTimeoutInterval: 30];
    [request addValue:@"text/xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"IOS App (power by elliott)" forHTTPHeaderField:@"User-Agent"];

    
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}



/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];

    if(err) {
//        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end