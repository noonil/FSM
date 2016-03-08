//
//  stateBackViewController.h
//  Ericsson
//
//  Created by Slark on 16/1/6.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendBackDelegate <NSObject>

-(void)feedBackValues:(NSString *)str andTimeString:(NSString *)timeStr;


@end

@interface stateBackViewController : BaseViewController

/** 导航控制器的标题 */
@property (nonatomic,copy) NSString * navigationTitle;
@property (nonatomic, strong) NSData *imgData;
@property (nonatomic, strong) NSString *FileName;
- (IBAction)BBClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *TextLabel;
- (IBAction)iditeClick:(id)sender;
- (IBAction)phtotClick:(id)sender;

- (IBAction)commitClick:(id)sender;
@property (nonatomic,strong)NSString * woId;
@property (nonatomic,strong)NSString * stepId;
@property (nonatomic,copy)NSString * str;
@property (nonatomic,copy)NSString * timeStr;
@property (nonatomic,weak) id <sendBackDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSString *attachGroupId;
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

//反馈内容请求
-(void)jsonInfowoId:(NSString *)woId;
//附件描述信息请求
-(void)jsonAttachDescripemainType:(NSString *)mainType mainRecId:(NSString *)mainRecId fileTitle:(NSString *)fileTitle attachType:(NSString *)attachType;

@end
