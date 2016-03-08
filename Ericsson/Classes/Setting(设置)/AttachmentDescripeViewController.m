//
//  AttachmentDescripeViewController.m
//  Ericsson
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "AttachmentDescripeViewController.h"
#import "PopupObjectList.h"
#import "mediaViewController.h"
#import "AttachModel.h"
@interface AttachmentDescripeViewController ()<PopupObjectListDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnText;
@property (weak, nonatomic) IBOutlet UITextView *descripetf;
@property (nonatomic,strong)PopupObjectList * pop;
@property (nonatomic,strong)NSMutableArray * array;
@property (nonatomic,strong)NSArray * objectArr;
@property (nonatomic,strong) UIButton * submitBtn;

@end

@implementation AttachmentDescripeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataFromDB];

    // Do any additional setup after loading the view from its nib.
    mediaViewController *media = [[mediaViewController alloc]init
                                  ];
    
    UIButton * submitBtn = [[UIButton alloc]init];
    submitBtn.backgroundColor = KBaseBlue;
    CGFloat submitBtnW = KIphoneWidth;
    CGFloat submitBtnH = 50;
    CGFloat submitBtnX = 0;
    CGFloat submitBtnY = KIphoneHeight - submitBtnH;
    
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.frame = CGRectMake(submitBtnX, submitBtnY, submitBtnW, submitBtnH);
    [submitBtn addTarget:self action:@selector(submitContent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    self.submitBtn = submitBtn;
    

    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
// 通知键盘
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // 如果正在切换键盘，就不要执行后面的代码
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y >= self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            self.submitBtn.y = self.view.height - self.submitBtn.height;
        } else {
            self.submitBtn.y = keyboardF.origin.y - self.submitBtn.height;
        }
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)loadDataFromDB{
    
    self.objectArr = [NSArray new];
    
    self.objectArr = [NSArray arrayWithObjects:@"正常图片", @"隐患图片",  nil];
    
    _array = [NSMutableArray new];
    
    for (int i = 0; i < _objectArr.count; i ++) {
        
        [_array addObject:_objectArr[i]];
        
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pictureBtn:(id)sender {//选图
    _pop = [[PopupObjectList alloc]initWithData:self.array selectedData:self.btnText.titleLabel.text fromWhichObject:self.btnText];
    _pop.delegate = self;
    
    [_pop presentPopupControllerAnimated];
    
    
}

#pragma PopupObjectList - Delegate

- (void)popupObjectListDidSelectRowAtIndexPath:(NSString *)selectedData fromWhichObject:(id)fromWhichObject row:(NSInteger)row{
    
    if (fromWhichObject == self.btnText) {
        
        self.btnText.titleLabel.text= self.array[row];
        
    }
    
}
-(void)submitContent{
    AttachModel *attachModel = [[AttachModel alloc]init];
    attachModel.imgName = self.infoFileName;
    attachModel.imgDetails = self.descripetf.text;
    attachModel.fileType = self.fileType;
    [attachModel saveToDB];
    //    mediaViewController *mediaVC = [[mediaViewController alloc]init];
    //
    //    [self presentViewController:mediaVC.navigationController animated:NO completion:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"goToMediaVCNotification" object:nil];

}





@end
