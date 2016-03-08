//
//  SoapUtility.m
//  SOAP-IOS
//
//  Created by Elliott on 13-7-26.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import "SoapUtility.h"
#import "CompressAndEncrypt.h"


@interface SoapUtility(){
    DDXMLElement *rootelement;
}

@end

@implementation SoapUtility

+(SoapUtility *)shareInstance{


    static SoapUtility * soatUtility=nil;
    static dispatch_once_t once;
    dispatch_once(
                  &once,^{
                      soatUtility=[[SoapUtility alloc]init];
                      
                  
                  }
            
    );
    
    return soatUtility;
}

-(NSString *)jsonDicToJsonStr:(NSDictionary *)jsonDic{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];


    return jsonStr;
    

}


-(NSString *)BuildSoapWithModelName:(NSString *)modelname methodName:(NSString *)methodName sessonId:(NSString *)sessonId requestData:(NSDictionary *)jsonDic
{


    NSString *jsonStr=[self jsonDicToJsonStr:jsonDic];
    NSString * jsonStrCompressAndEncrypt=[CompressAndEncrypt compressAndEncrypt_jsonStr:jsonStr];

    

    // <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
	//     <soap:Header/>
	//     <soap:Body>
	//     <parameters xmlns="http://xxxx.com"/>
    //          <param1></param1>
    //          <param2></param2>
    //          <param3></param3>
	//     </parameters/>
	//     </soap:Body>
	// </soap:Envelope>
    
    //根节点
    DDXMLElement *ddRoot = [DDXMLElement elementWithName:@"v:Envelope"];
    //根节点的命名空间
    [ddRoot addNamespace:[DDXMLNode namespaceWithName:@"i" stringValue:@"http://www.w3.org/2001/XMLSchema-instance"]];
    [ddRoot addNamespace:[DDXMLNode namespaceWithName:@"d" stringValue:@"http://www.w3.org/2001/XMLSchema"]];
    [ddRoot addNamespace:[DDXMLNode namespaceWithName:@"c" stringValue:@"http://schemas.xmlsoap.org/soap/encoding/"]];
    [ddRoot addNamespace:[DDXMLNode namespaceWithName:@"v" stringValue:@"http://schemas.xmlsoap.org/soap/envelope/"]];
    //头
	DDXMLElement *ddHeader = [DDXMLElement elementWithName:@"v:Header"];

    //body
    DDXMLElement *ddBody = [DDXMLElement elementWithName:@"v:Body"];
    
    //n0
    DDXMLElement *ddn0=[DDXMLElement elementWithName:@"n0:redirect"];
    [ddn0 addNamespace:[DDXMLNode namespaceWithName:@"n0" stringValue:@"http://webService.ailixin.com/"]];//[rootelement TargetNamespace]]];
    [ddn0 addAttribute:[DDXMLNode attributeWithName:@"id" stringValue:@"o0"]];
    [ddn0 addAttribute:[DDXMLNode attributeWithName:@"c:root" stringValue:@"1"]];


    DDXMLElement *requestModel=[DDXMLElement elementWithName:@"requestModel" stringValue:modelname];
    [requestModel addAttribute:[DDXMLNode attributeWithName:@"i:type" stringValue:@"d:string"]];
    DDXMLElement *requestMethod=[DDXMLElement elementWithName:@"requestMethod" stringValue:methodName];
    [requestMethod addAttribute:[DDXMLNode attributeWithName:@"i:type" stringValue:@"d:string"]];
    DDXMLElement *session=[DDXMLElement elementWithName:@"sessionId" stringValue:sessonId];
    [session addAttribute:[DDXMLNode attributeWithName:@"i:type" stringValue:@"d:string"]];
    DDXMLElement *requestData=[DDXMLElement elementWithName:@"requestData" stringValue:jsonStrCompressAndEncrypt];
    [requestData addAttribute:[DDXMLNode attributeWithName:@"i:type" stringValue:@"d:string"]];

    
    [ddn0 addChild:requestModel];
    [ddn0 addChild:requestMethod];
    [ddn0 addChild:session];
    [ddn0 addChild:requestData];
    
    ///
    [ddBody addChild:ddn0];
    [ddRoot addChild:ddHeader];
    [ddRoot addChild:ddBody];

    

    return [ddRoot XMLString];
}


@end
