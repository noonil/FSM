//
//  ConsumeDetailViewController.m
//  Ericsson
//
//  Created by xuming on 15/12/17.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ConsumeApplyCountViewController.h"
#import "ImgLabelHeadView.h"
#import "OneLabelView.h"
#import "Consume.h"
#import "OneButtonView.h"
#import "ConsumeApplyOhtersViewController.h"

@interface ConsumeApplyCountViewController ()<UIGestureRecognizerDelegate, OneButtonViewDelegate, UITextFieldDelegate>
{
    
    //申请数量的背景view相对于viewController的view的frame值。
    CGRect applyNumberBackView_Frame;
    CGFloat heightSub;//view要向上移动的距离。

}
@property (weak, nonatomic) IBOutlet UILabel *consumeName_Lab;
@property (weak, nonatomic) IBOutlet UILabel *depotName_Lab;
@property (weak, nonatomic) IBOutlet UILabel *depotNumber_Lab;
@property (weak, nonatomic) IBOutlet UILabel *deportIphone_Lab;
@property (weak, nonatomic) IBOutlet UITextField *applyNumber_Txt;
@property (weak, nonatomic) IBOutlet UIView *applyNumberBack_View;


@property (weak, nonatomic) IBOutlet ImgLabelHeadView *headView;
@property (weak, nonatomic) IBOutlet OneButtonView *footView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) ConsumeApplyOhtersViewController *consumeApplyOhtersViewController;



@end

@implementation ConsumeApplyCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setOthers];
    
    [MBProgressHUD showMessage:KHudIsRequestMessage];
    
    [self loadData];
}

-(void)setOthers{
    self.title = @"耗材库存详情";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
    
    self.headView.oneLabel.text=[NSString stringWithFormat:@"库存详情"];
    [self.footView.button setTitle:@"确定" forState:UIControlStateNormal];
    self.footView.delegate=self;
    
    
    
    _consumeName_Lab.text=[NSString stringWithFormat:@"申请耗材为:%@",self.consume.consumableName];
    _depotName_Lab.text=[NSString stringWithFormat:@"所在仓库:%@",self.consume.depotName];
    _depotNumber_Lab.text=[NSString stringWithFormat:@"库存数量:%@",self.consume.depotNumber];
    

    [self addTapGesture];

    
}

-(void)viewDidAppear:(BOOL)animated{

}



#pragma mark - 键盘弹出隐藏

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    applyNumberBackView_Frame =[self.view convertRect:self.applyNumberBack_View.frame fromView:self.applyNumberBack_View.superview];
    //CGRectMake(0, 250+5*4, KIphoneWidth, 50);
    NSLog(@"applyNumberBackView_Frame=%@",NSStringFromCGRect(applyNumberBackView_Frame));


}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    

}


//注册键盘出现消失通知
- (void)keyboardWillShow:(NSNotification *)notification
{
    heightSub = 0;
    CGRect keyboardBounds = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat height = CGRectGetMaxY(applyNumberBackView_Frame) + keyboardBounds.size.height +64;
    
    NSLog(@"KIphoneHeight=%f",KIphoneHeight);

    if (height>KIphoneHeight) {
        heightSub =  height -KIphoneHeight;
        
        CGRect rect = self.view.frame;
        rect.origin.y-=heightSub;
        self.view.frame=rect;
        NSLog(@"self.view.frame=%@",NSStringFromCGRect( self.view.frame));
        
    }
    

    

    
}

//键盘将要消失的通知回调方法
- (void)keyboardWillHide:(NSNotification *)notification
{
    CGRect keyboardBounds = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect rect = self.view.frame;
    rect.origin.y+=heightSub;
    self.view.frame=rect;
    NSLog(@"self.view.frame=%@",NSStringFromCGRect( self.view.frame));



    
}



-(void)handleSingleTap{
    [_applyNumber_Txt resignFirstResponder];
    
    
}


#pragma mark - 手势
-(void)addTapGesture{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.view addGestureRecognizer:singleTap];
    singleTap.delegate = self;
}

#pragma mark - request Data
- (void)loadData
{
    //请求数据示例
    
    NSDictionary *params = @{
                             @"consumableId":self.consume.consumableId,
                             @"depotId":self.consume.depotId,
                             };
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMConsumable" methodName:@"FSMConsumableDepotDetail" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"]  isEqual: @0]) {
            Consume *model = [Consume objectWithKeyValues:dic[@"phoneNum"]];
            if (model!=nil) {
                _consume.phoneNumber=model.phoneNumber;
            }
            _deportIphone_Lab.text=[NSString stringWithFormat:@"仓库管理员联系电话:%@",self.consume.phoneNumber];

        }
        else{
            [self.view makeToast:KHudResponse1];
        
        }
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];


        [self.view makeToast:KHudErrorMessage];
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - OneButtonView delegate
-(void)OneButtonViewDidTouchDown{
    
    
    self.consumeApplyOhtersViewController.consume=self.consume;
    _consumeApplyOhtersViewController.consume.applyNumber=_applyNumber_Txt.text;
    
    [self.navigationController pushViewController:_consumeApplyOhtersViewController animated:YES];
    
    
}

#pragma mark -get/set
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(ConsumeApplyOhtersViewController *) consumeApplyOhtersViewController{

    if (_consumeApplyOhtersViewController==nil) {
        _consumeApplyOhtersViewController=[[ConsumeApplyOhtersViewController alloc]init];
    }
    return _consumeApplyOhtersViewController;
}






@end
