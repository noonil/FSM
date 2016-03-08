//
//  PhaseFeedBackDescInputViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/2.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "PhaseFeedBackDescInputViewController.h"
#import "UIView+Extension.h"

@interface PhaseFeedBackDescInputViewController ()

@property (nonatomic,strong)UITextView *inputView;
@property (nonatomic,strong)UIButton *commitBtn;
@end

@implementation PhaseFeedBackDescInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"阶段反馈";
    
    self.inputView = [[UITextView alloc] initWithFrame:CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width - 40, 200)];
    self.inputView.backgroundColor = [UIColor lightGrayColor];
    self.inputView.font = [UIFont systemFontOfSize:15];
    self.inputView.text = self.content;

    [self.view addSubview:self.inputView];
    
    self.commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - (50 + 64), [UIScreen mainScreen].bounds.size.width, 50)];
    
    [self.commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.commitBtn setTintColor:[UIColor whiteColor]];
    self.commitBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searchbg.png"]];
    [self.commitBtn addTarget:self action:@selector(commitInput) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.commitBtn];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //处理提交按钮位置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)commitInput{
    if (self.item) {
        if ([self.delegate respondsToSelector:@selector(ContentDidInputWithItem:Content:)]) {
            [self.delegate ContentDidInputWithItem:self.item Content:self.inputView.text];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(PhaseFeedBackDescInputWithContent:)]) {
            [self.delegate PhaseFeedBackDescInputWithContent:self.inputView.text];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)keyboardWillChange:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
     NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.commitBtn.y = keyboardRect.origin.y - (50 + 64);
//    NSLog(@"userInfo:%@",userInfo);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
@end
