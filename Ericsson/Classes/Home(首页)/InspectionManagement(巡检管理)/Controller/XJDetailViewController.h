//
//  XJDetailViewController.h
//  Ericsson
//
//  Created by Slark on 16/1/12.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol writebackdelegate <NSObject>

- (void)giveBackStr:(NSString*)str;

@end

@interface XJDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,weak) id<writebackdelegate>delegate;
@property (nonatomic,copy)NSString * str;//用于接收传递字符串
@property (nonatomic,copy)NSString * sss;
@property (nonatomic,copy)NSString * mark;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
- (IBAction)imageClick:(id)sender;

- (IBAction)goBackClick:(id)sender;
- (IBAction)completeClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *backTextField;

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
@property (nonatomic,strong) NSString * woId;
@property (nonatomic,strong)NSString * firstStr;

@end
