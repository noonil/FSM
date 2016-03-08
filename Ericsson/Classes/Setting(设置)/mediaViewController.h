//
//  mediaViewController.h
//  Ericsson
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mediaViewController : UIViewController

/*
 点击请求  1.先把反馈内容通过接口请求上去，会返回一个attachgroupID
          2.请求成功之后，再开一个子线程，在后台用socket把附件文件上传上去
          3.socket 成功之后 在用之前的attachgroupID作为参数 通过另一个接口把附件信息上传上去
 
 
 */
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
/** 导航控制器的标题 */
@property (nonatomic,copy) NSString * navigationTitle;
@property (nonatomic, strong) NSData *imgData;
@property (nonatomic, strong) NSString *FileName;
//附件描述信息,接口参数
@property (nonatomic, strong) NSString *attachGroupId;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) NSString * woId;

@end
