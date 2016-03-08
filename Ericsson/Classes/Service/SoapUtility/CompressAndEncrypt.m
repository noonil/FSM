
//  CommonFunc.m
//  PRJ_base64
//
//  Created by wangzhipeng on 12-11-29.
//  Copyright (c) 2012年 com.comsoft. All rights reserved.
//

#import "CompressAndEncrypt.h"

//引入IOS自带密码库
//#import <CommonCrypto/CommonCryptor.h>
#import "LFCGzipUtillity.h"
#import "DDXMLDocument.h"


//空字符串
#define     LocalStr_None           @""

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
NSString *originStr=@"Man";
//NSString *encodeResult=@"H8KLCAAAAAAAAAAlwozCsQrDgjAURXfDgX/CkDdXw4jCi8Ktw5Fsw5YScHEQf8Kgw6jCsxbDmsKkJMKpUMOEw53DjcOVw43DrxDDvBwdw7wLwqPDnsOxcMOOPUJtdMOpwo1ddw3CgcKEwqXDscO7UhcQQWXCilLCr8OIwrXClQfDiSJwwp3DnsKoKi9Aw67DssOKUQTCrSPCu8OMw6tvw7U6X8Kfwo/Dm8O7fgldY01Dw5Z3AcKzw58QA8K1w6TDp2ZLw78ncsKuNHrCsQ3Cikg5T0Q2VsKKccKMwrlQwonCisOHwrM0wpvCosKYwol0MsKHwq9uD2TDly7DmMKcYTJENsOEw5EAUcOywpHCjCdww6rDtz7Dn1LDucOsw4UAAAA=";

//NSString *encodeResult=@"H8KLCAAAAAAAAADCq1YqSi1xw45PSVXCslLDkjVUwqoFAEtlIzgQAAAA";
//NSString *encodeResult=@"H8KLCAAAAAAAAABVwo3DjQrDgjAQwoRfZcOJw5nClMOdbcOSw5TDnMKkFwvCoh4qeCvCpQYUahVTw7EPw5/DnVXDtMOgwrAww4t8DMOzUMOxw5bCt8KzJg7DtRDClVfCjMOEGnM5YMO2w4Z5IjVSw53CoW3CusOqw4vCrSbDlMOEQMOWY8OmUyt8wr/Dmm0Ew6LCv8O0wrQqYMORB1jCgwbCk3DDgsOiwpNlCcOkw6RxwoxXw6IcwqV+wrzCvMObw4TCqcKxw5lvLUhyw5/DlsOFXMKCcwzCp8OyM0A5wo1ZPV9LHsObwp/CtgAAAA==";

//NSString *encodeResult=@"TWFuJKIGUFYF89745675hvhvchcgcxklnln8574674 bjbvjgfhujgjhgGHJKGH90TYTY";



//压缩加密前的数据
//{"syncLast_ts":"2012-08-08 22:47:11","localTs":"2015-10-12 15:06:35","mUid":"000000000000000-HTC One X - 4.2.2 - API 17 - 720x1280","pwd":"123456","locale":"zh_CN","userId":"018192"}
//压缩加密后的数据
//H8KLCAAAAAAAAABVwo3DjQrDgjAQwoRfZcOJw5nClMOdbcOSw5TDnMKkFwvCoh4qeCvCpQYUahVTw7EPw5/DnVXDtMOgwrAww4t8DMOzUMOxw5bCt8KzJg7DtRDClVfCjMOEGnM5YMO2w4Z5IjVSw53CoW3CusOqw4vCrSbDlMOEQMOWY8OmUyt8wr/Dmm0Ew6LCv8O0wrQqYMORB1jCgwbCk3DDgsOiwpNlCcOkw6RxwoxXw6IcwqV+wrzCvMObw4TCqcKxw5lvLUhyw5/DlsOFXMKCcwzCp8OyM0A5wo1ZPV9LHsObwp/CtgAAAA==

//B to 161 B
//2015-10-14 14:36:56.588 SOAP-IOS[3082:110885] +[LFCGzipUtillity gzipData:]: Compressed file from 182 B to 161 B
//2015-10-14 14:36:57.158 SOAP-IOS[3082:110885] ====<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soap:Body><ns1:redirectResponse xmlns:ns1="http://webService.ailixin.com"><ns1:out>H8KLCAAAAAAAAAAlwow7CsOCQBRFe8OBPcOIwqsTwpg3w7kYwqfDsxPDgSbChWQDQcKfMcKQw4zChMKZUQhib2drw6c6BMKXwqPChcK7cMKiwrc8wpxzT8OQKFlZwqXDs8KuJRDCkCnCu8KvZAkew5TCqsKsw6TCmsOMwqHCtiDCmAfCpsKTwptlXcKUIHZFbcOIwoPCgyHCnRVNX8K9L8K3w5fDs8O+eVxdw5dqw5XCksK2wp3Dg8OsN0RHNcOZwrnDmsOSw7/CicKMwqnClFxtwp3CgsOBIsKNw5I4DcOGw7PDqWQ5SyI2W8KEwpzDo8KUYcKcBEkIwr3CrsKPwqRzw6Nsw44ww7LCkcO5GMKOMBRBLDjCh8OzcMOwBS/CksKbbcOFAAAA</ns1:out></ns1:redirectResponse></soap:Body></soap:Envelope>
//

NSString *encodeResult=@"H8KLCAAAAAAAAAAlwow7CsOCQBRFe8OBPcOIwqsTwpg3w7kYwqfDsxPDgSbChWQDQcKfMcKQw4zChMKZUQhib2drw6c6BMKXwqPChcK7cMKiwrc8wpxzT8OQKFlZwqXDs8KuJRDCkCnCu8KvZAkew5TCqsKsw6TCmsOMwqHCtiDCmAfCpsKTwptlXcKUIHZFbcOIwoPCgyHCnRVNX8K9L8K3w5fDs8O+eVxdw5dqw5XCksK2wp3Dg8OsN0RHNcOZwrnDmsOSw7/CicKMwqnClFxtwp3CgsOBIsKNw5I4DcOGw7PDqWQ5SyI2W8KEwpzDo8KUYcKcBEkIwr3CrsKPwqRzw6Nsw44ww7LCkcO5GMKOMBRBLDjCh8OzcMOwBS/CksKbbcOFAAAA";




@implementation CompressAndEncrypt

/******************************************************************************
 函数名称 :
 函数描述 :将要发送到服务器端的json数据，zip格式压缩，进行base64编码。
 备注信息 :
 ******************************************************************************/
+(NSString *)compressAndEncrypt_jsonStr:(NSString *)jsonStr{
    
    NSData *dataUtf8=[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dataZip= [LFCGzipUtillity gzipData:dataUtf8];
    NSString *str8899=[[NSString alloc]initWithData:dataZip encoding:NSISOLatin1StringEncoding];
    NSData *dataUtf82=[str8899 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* result = [dataUtf82 base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString *mm=[self untie_EncryptAndcompress_jsonStr_local:result];
    return result;
}

+(NSString *)untie_EncryptAndcompress_jsonStr_local:(NSString *)str{
    NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:str options:0];
    NSString *decodeStr=[[NSString alloc]initWithData:decodeData encoding:NSUTF8StringEncoding];
    NSData *data8899=[decodeStr dataUsingEncoding:NSISOLatin1StringEncoding];

    //解压缩
    NSData* data13 = [LFCGzipUtillity uncompressZippedData:data8899];
    
    NSString* decodeResult = [[NSString alloc] initWithData:data13 encoding:NSUTF8StringEncoding];
    // NSLog(@"decode Result  :%@",decodeResult);
    return decodeResult;
    
}
/******************************************************************************
 函数名称 :
 函数描述 :将本地压缩，编码的数据，进行反操作。
 备注信息 :
 ******************************************************************************/
/******************************************************************************
 函数名称 :
 函数描述 :将服务器端返回的数据，进行base64解码，zip格式解压，转换成json数据。
 备注信息 :
 ******************************************************************************/
+(NSString *)untie_EncryptAndcompress_jsonStr:(NSString *)str{
    
    
    NSString * ns1OutStr=[self getNs1OutStr:str];
    NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:ns1OutStr options:0];
    NSString *decodeStr=[[NSString alloc]initWithData:decodeData encoding:NSUTF8StringEncoding];
    NSData *decodeData8899=[decodeStr dataUsingEncoding:NSISOLatin1StringEncoding];
    
    //解压缩
    NSData* data13 = [LFCGzipUtillity uncompressZippedData:decodeData8899];
    
    NSString* decodeResult = [[NSString alloc] initWithData:data13 encoding:NSUTF8StringEncoding];
    // NSLog(@"decode Result  :%@",decodeResult);
    return decodeResult;
    
}

/******************************************************************************
 函数名称 :
 函数描述 : 取得服务器端<Ns1：Out>节点返回的数据，
 备注信息 :
 ******************************************************************************/
+(NSString *)getNs1OutStr:(NSString *)str{
    
    NSData *xmlData=[str dataUsingEncoding:NSASCIIStringEncoding];
    DDXMLDocument *xmlDoc=[[DDXMLDocument alloc]initWithData:xmlData options:0 error:nil];
    DDXMLElement *rootElement=[xmlDoc rootElement];
    
    NSArray *children= [rootElement elementsForName:@"Body"];
    
    DDXMLElement *children0=[children objectAtIndex:0];
    
    NSArray *children1= [children0 elementsForName:@"redirectResponse"];
    
    DDXMLElement *children2=[children1 objectAtIndex:0];
    
    NSArray *children3= [children2 elementsForName:@"out"];
    
    DDXMLElement *children4=[children3 objectAtIndex:0];
    
    NSString *mm=[children4 stringValue];
    return mm;
}


@end
