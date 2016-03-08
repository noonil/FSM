//
//  FinishCommitViewController.h
//  Ericsson
//
//  Created by Slark on 16/1/7.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinishCommitViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *finishTypeTextField;
@property (weak, nonatomic) IBOutlet UIButton *FButton;
- (IBAction)SButton:(id)sender;
- (IBAction)TButton:(id)sender;
- (IBAction)FButton:(id)sender;
- (IBAction)finishTypeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *lastButtton;
@property (weak, nonatomic) IBOutlet UIButton *sameButton;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

- (IBAction)lastClick:(id)sender;
- (IBAction)DealProblemClick:(id)sender;
- (IBAction)addMessageClick:(id)sender;
@property (nonatomic,copy)NSString * woId;
@property (weak, nonatomic) IBOutlet UIButton *sendImageClick;
@property (nonatomic,strong)NSNumber * ruleId;

- (IBAction)ImageClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *firstButton;

- (IBAction)commitClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

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




@end
