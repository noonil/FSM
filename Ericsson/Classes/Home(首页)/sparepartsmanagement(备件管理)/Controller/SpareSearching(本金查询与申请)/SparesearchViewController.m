//
//  SparesearchViewController.m
//  Ericsson
//
//  Created by 陶山强 on 15/10/14.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "SparesearchViewController.h"
#import "PopupObjectList.h"
#import "Search_1ViewController.h"
#import "sparePartNameModel.h"
#import "sparePartTypeModel.h"
#import "SparePartList.h"
#import "SpareTypes.h"
#import "SpareFactories.h"
@interface SparesearchViewController ()<PopupObjectListDelegate>

{
    __block BOOL isKeyboard;
}

/** 备件名称 */
@property (weak, nonatomic) IBOutlet UITextField *LastTextField;
/** 所属专业 */
@property (weak, nonatomic) IBOutlet UIButton *FirsyBtn;
/** 厂商 */
@property (weak, nonatomic) IBOutlet UIButton *SecondBtn;
/** 搜索按钮 */
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (nonatomic,strong)PopupObjectList * pop;

//@property (nonatomic,strong)NSMutableArray * objectArr;
//
//@property (nonatomic,strong)NSMutableArray * factoryArr;
//
//@property (nonatomic,strong)NSMutableArray * MainNameArr;
//
//@property (nonatomic,strong)NSMutableArray * factoryNameArr;

/** 存放厂商 */
@property (nonatomic,strong) NSMutableArray * factoryArray;
/** 存放所属专业 */
@property (nonatomic,strong) NSMutableArray * spareTypeNameArray;
@end


@implementation SparesearchViewController
#pragma mark - Lazy
- (NSMutableArray*)factoryArray
{
    if (!_factoryArray) {
        _factoryArray = [NSMutableArray array];
    }
    return _factoryArray;
}

- (NSMutableArray*)spareTypeNameArray
{
    if (!_spareTypeNameArray) {
        _spareTypeNameArray = [NSMutableArray array];
    }
    return _spareTypeNameArray;
}

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"备件查询与申请";
    self.LastTextField.textColor = [UIColor blackColor];
    isKeyboard = NO;
    [self loadDataFromDB];
    
    
    
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
// 通知键盘
- (void)keyBoardWillChangeFrame:(NSNotification *)notification
{
    // 如果正在切换键盘，就不要执行后面的代码
    NSDictionary * userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // 取出控件的底边的值
    UIView *view = self.LastTextField.superview;
    CGRect absoluteRect = [view convertRect:self.LastTextField.frame toView:self.view];
    CGFloat bottom = CGRectGetMaxY(absoluteRect) + 64.0;
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        if (keyboardF.origin.y >=  screenHeight) { // 键盘的Y值已经远远超过了控制器view的高度
            //            self.distinationText.y = self.view.height - self.distinationText.height;
            self.view.y = 64.0;
            isKeyboard = NO;
            
        }else if (keyboardF.origin.y < bottom){ // 如果键盘 遮盖住我的控件，就将控件上滑 ； 滑动的距离为
            
            if (isKeyboard) return ;
            CGFloat swipeHeight = bottom - keyboardF.origin.y + 15.0;
            self.view.y = self.view.y - swipeHeight;// - 64;
            isKeyboard = YES;
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark - 加载数据
- (void)loadDataFromDB{
    
    NSMutableArray * spareTypeArray=[[MyLKDBHelper getUsingLKDBHelper]searchWithSQL:@"select *from @t" toClass:[SpareTypes class]];
    for (int i=0; i<spareTypeArray.count; i++) {
        SpareTypes *model=(SpareTypes *)spareTypeArray[i];
        [self.spareTypeNameArray addObject:model.spareTypeName];
    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.LastTextField endEditing:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //SparesearchViewController
    // Dispose of any resources that can be recreated.
}


#pragma mark - btnEvent

- (IBAction)FirstClick:(UIButton*)sender {
   
    [self.view endEditing:YES];
    _pop = [[PopupObjectList alloc]initWithData:_spareTypeNameArray selectedData:_FirsyBtn.currentTitle fromWhichObject:_FirsyBtn];
    _pop.delegate = self;
    if (![sender.currentTitle isEqualToString:@"请选择"]) {
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [_pop presentPopupControllerAnimated];

}

- (IBAction)SecondClick:(UIButton*)sender {
    
    [self.view endEditing:YES];
    
    _pop = [[PopupObjectList alloc]initWithData:_factoryArray selectedData:_FirsyBtn.currentTitle fromWhichObject:_SecondBtn];
    _pop.delegate = self;
    
    if (![sender.currentTitle isEqualToString:@"请选择"]) {
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [_pop presentPopupControllerAnimated];
    
    
}

- (IBAction)SearchClick:(id)sender {

    [self.view endEditing:YES];
    
    Search_1ViewController * search = [[Search_1ViewController alloc]init];
    
    if ([self.FirsyBtn.currentTitle isEqualToString:@"请选择"]) {
        search.boardType = @"";
    }else {
        search.boardType = self.FirsyBtn.currentTitle;
    }
    if ([self.SecondBtn.currentTitle isEqualToString:@"请选择"]) {
        search.factory = @"";
    }else {
        search.factory = self.SecondBtn.currentTitle;
    }
    search.boardName = self.LastTextField.text;
    

    
    [self.navigationController pushViewController:search
                                         animated:YES];
}


#pragma PopupObjectList - Delegate

- (void)popupObjectListDidSelectRowAtIndexPath:(NSString *)selectedData fromWhichObject:(id)fromWhichObject row:(NSInteger)row{
    
    if (fromWhichObject == _FirsyBtn) {

        [_FirsyBtn setTitle:_spareTypeNameArray[row] forState:UIControlStateNormal];
        
        // 设置玩完  请求第二组的数据
        [self reloadFactoryData];
    }else{
        [_SecondBtn setTitle:_factoryArray[row] forState:UIControlStateNormal];
    }
}

- (void)reloadFactoryData
{
    // 根据第一个表来查询这里面的数据
    NSMutableArray * factoryArr = [[MyLKDBHelper getUsingLKDBHelper]searchWithSQL:[NSString stringWithFormat:@"select spareFactoryName from @t where spareTypeName ='%@'",_FirsyBtn.currentTitle] toClass:[SpareFactories class]];
    for (int i = 0; i < factoryArr.count; i++) {
        SpareFactories * model = (SpareFactories*)factoryArr[i];
        [self.factoryArray addObject:model.spareFactoryName];
    }
}

@end
