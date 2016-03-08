//
//  versionIntroduceViewController.m
//  Ericsson
//
//  Created by apple on 16/1/11.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "versionIntroduceViewController.h"

@interface versionIntroduceViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textfiled;

@end

@implementation versionIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"版本说明";
    [self show];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)show{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *myVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    self.textfiled.text = newVersionInstruction;
    
    }

- (IBAction)sureBtn:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
