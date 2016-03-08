//
//  AttachmentDescripeViewController.h
//  Ericsson
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachmentDescripeViewController : UIViewController

@property (nonatomic, strong) NSData *infoData;
@property (nonatomic, strong) NSString *infoFileName;
@property (nonatomic, strong) NSString *fileType;

@property (nonatomic, strong) NSString *attachGroupId;//根据不同类型的附件attachGroupId

@property (nonatomic, strong) NSString *mainType;   // mainType, 0阶性性反馈 1   工单操作项 2 工单处理 3操作规程 4 技术手册
@end
