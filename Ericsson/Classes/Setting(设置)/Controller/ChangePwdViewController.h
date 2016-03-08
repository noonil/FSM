//
//  ChangePwdViewController.h
//  Ericsson
//
//  Created by 范传斌 on 15/10/9.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeaderView;

@interface ChangePwdViewController : BaseViewController
@property (weak, nonatomic) IBOutlet HeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *oldPwd;
@property (weak, nonatomic) IBOutlet UITextField *presentPwd;
@property (weak, nonatomic) IBOutlet UITextField *comfirmNewPwd;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
- (IBAction)changeClick:(id)sender;

@end
