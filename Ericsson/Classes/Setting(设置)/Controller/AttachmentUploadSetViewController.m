//
//  AttachmentUploadSetViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/10.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "AttachmentUploadSetViewController.h"
#import "HeaderView.h"


@interface AttachmentUploadSetViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@end

static BOOL chooseFlg=true;

@implementation AttachmentUploadSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"附件上传设置";
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置tableView头部视图
    self.headerView.imageView.image = [UIImage imageNamed:@"spare_search"];
    
    //需要根据具体类型改变，暂不处理
    self.headerView.title.text = @"附件上传设置";
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *btnstate=[defaults objectForKey:@"choose"];
    NSLog(@"按钮什么吊回事儿---%@",[defaults objectForKey:@"choose"]);
    if ([btnstate isEqualToString:@"Y"]) {
       [self.btn setImage:[UIImage imageNamed:@"check_choosed"] forState:UIControlStateNormal];
        chooseFlg=false;
    }else if ([btnstate isEqualToString:@"N"]){
        [self.btn setImage:[UIImage imageNamed:@"check_not_choosed"] forState:UIControlStateNormal];
        chooseFlg=true;
    }

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickbtn:(id)sender {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

    if (chooseFlg) {
       NSString *btnstate=[defaults objectForKey:@"choose"];
        chooseFlg=false;
        if ([btnstate isEqualToString:@"N"]) {
            [self.btn setImage:[UIImage imageNamed:@"check_choosed"] forState:UIControlStateNormal];
            
            NSString *onbtn=@"Y";
            [defaults setValue:onbtn forKey:@"choose"];
            NSLog(@"按钮选中啦---%@",[defaults objectForKey:@"choose"]);

            
        }else{
            
            [self.btn setImage:[UIImage imageNamed:@"check_not_choosed"] forState:UIControlStateNormal];
            
            NSString *onbtn=@"N";
            [defaults setValue:onbtn forKey:@"choose"];
            NSLog(@"按钮怎么还没选中---%@",[defaults objectForKey:@"choose"]);
        }

        
    }else{
        chooseFlg=true;
    
    [self.btn setImage:[UIImage imageNamed:@"check_not_choosed"] forState:UIControlStateNormal];
    
    NSString *onbtn=@"N";
    [defaults setValue:onbtn forKey:@"choose"];
    NSLog(@"按钮怎么还没选中---%@",[defaults objectForKey:@"choose"]);
  }
}

@end
