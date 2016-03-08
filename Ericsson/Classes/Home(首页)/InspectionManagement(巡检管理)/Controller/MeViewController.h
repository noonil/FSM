//
//  MeViewController.h
//  Ericsson
//
//  Created by Slark on 16/1/25.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol sendBackDelegate <NSObject>

-(void)feedBackValues:(NSString *)str andTimeString:(NSString *)timeStr;


@end
@interface MeViewController : BaseViewController

-(int) connectServer: (NSString *) hostIP port:(int) hostPort;
-(void)chooseVido;
-(void)chooseimage;
-(void)chooseSound;
//反馈内容请求
-(void)jsonInfowoId:(NSString *)woId;
//附件描述信息请求
-(void)jsonAttachDescripemainType:(NSString *)mainType mainRecId:(NSString *)mainRecId fileTitle:(NSString *)fileTitle attachType:(NSString *)attachType;
//实现选择完毕图片或视频时候响应的函数
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
//socket附件上传
//-(void)socket;

@property (nonatomic, strong) NSData *imgData;
@property (nonatomic, strong) NSString *FileName;
//附件描述信息,接口参数
@property (nonatomic, strong) NSString *attachGroupId;
@property (weak, nonatomic) IBOutlet UILabel *TextLabel;
@property (nonatomic,copy)NSString * woId;
@property (nonatomic,copy)NSString * str;
@property (nonatomic,copy)NSString * timeStr;
@property (nonatomic,weak) id <sendBackDelegate>delegate;




@end
