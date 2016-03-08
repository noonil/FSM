//
//  NetResourceEditViewController.m
//  Ericsson
//
//  Created by xuming on 15/12/5.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//


typedef NS_ENUM(NSInteger, NetResourceModelType) {
    Common,//
    Select ,//点击出来选择框类型的cell
    OneButton,//带一个按钮的cell
    TwoButton//带两个按钮的cell
};

#import "NetResourceEditViewController.h"
#import "OneLabelOneTextFieldOneBtnCell.h"
#import "OneButtonCell.h"
#import "TwoButtonCell.h"
#import "PopupObjectList.h"
#import "MatainObjectBaseInfo.h"
#import "PopupObjectList.h"
#import "NetResourceSearchViewController.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import "RMDateSelectionViewController.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>


#define mmTextType @"num"
#define mmSelectTextType @"char" //en name=lonLan
#define mmPhotoType @"file"
//#define mmOneButtonType @"char"


@interface NetResourceEditViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDataSource,UITableViewDelegate, PopupObjectListDelegate, UIGestureRecognizerDelegate, OneLabelOneTextFieldOneBtnCellDelegate,OneButtonCellSetupCoordinateOrTime,BMKLocationServiceDelegate ,UIAlertViewDelegate,TwoButtonCellDelegate>
{

    NSMutableArray * textTypeCellArray;//textfield类型的cell数组
    NSDictionary *labelDic;
    PopupObjectList *popList;
    NSMutableDictionary *popDataDic;//存放pop展示数据的dic
    BMKLocationService * _locService;
    TwoButtonCell * twoButtonCell;

}
- (IBAction)backBtn_TouchUpInside:(id)sender;
- (IBAction)ReportBtn_TouchUpInside:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;
@property (nonatomic,strong) UIImagePickerController *picker;
@property (nonatomic, strong) NSData *imgData;


@end

@implementation NetResourceEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    
    [self setOthers];
}
-(void)setOthers{
    
    self.title=@"资源变更";
    self.backBtn.backgroundColor= KBaseBlue;
    self.reportBtn.backgroundColor=KBaseBlue;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    textTypeCellArray=[NSMutableArray new];
    [self picker];

    
    labelDic=@{@"录入时间":@"选择时间",
               @"经纬度":@"获取位置"};
    
    
    [self addTapGesture];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

#pragma mark - 隐藏键盘

-(void)handleSingleTap{
    for (int i=0; i<textTypeCellArray.count; i++) {
        OneLabelOneTextFieldOneBtnCell *cell=(OneLabelOneTextFieldOneBtnCell *)textTypeCellArray[i];
        [cell.oneTextField resignFirstResponder];
    }
    
    
}

-(void)addTapGesture{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.view addGestureRecognizer:singleTap];
    singleTap.delegate = self;
}


#pragma mark - 消息通知



- (void)keyboardWillShow:(NSNotification *)notification{
    CGRect keyboardBounds = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, keyboardBounds.size.height, 0);

}


- (void)keyboardWillHide:(NSNotification *)notification
{
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, 0, 0);
    //NSLog(@"消失self.tableVeiw.contentInset =%@",NSStringFromUIEdgeInsets( self.tableView.contentInset));
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    MatainObjectBaseInfo *model=_dataArray[indexPath.row];
    
    if (
        [model.fieldType isEqualToString: @"date"] ||
        [model.fieldEnName isEqualToString: @"lonLan"]  ||
        [model.fieldEnName isEqualToString: @"CREATE_TIME"]||
        [model.fieldType isEqualToString: @"file"]
        
        )
    {
        return 100;
    }
    else
        return 70;


    return 0;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [_dataArray count];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MatainObjectBaseInfo *model=_dataArray[indexPath.row];

    
    
    if ([model.fieldType isEqualToString:@"date"] ||[model.fieldEnName isEqualToString: @"CREATE_TIME"] ||[model.fieldEnName isEqualToString: @"lonLan"]) {
        OneButtonCell  *cell=[OneButtonCell cellWithTableView:tableView];
        cell.oneLabel.text=model.fieldChName;
        cell.delegate = self;
        cell.oneTextField.text=[model.showChgData isEqualToString:@""]?model.showOldData:model.showChgData;
        cell.oneTextField.enabled=NO;
        [cell.oneButton setTitle:@"选择时间" forState:UIControlStateNormal];
        cell.model=model;
        cell.tag=indexPath.row;
        
        if ([model.fieldEnName isEqualToString: @"lonLan"]) {
            [cell.oneButton setTitle:@"获取经纬度" forState:UIControlStateNormal];

        }
        
        
        return cell;
        
    }
    
    //显示图片cell
    else if ([model.fieldType isEqualToString: @"file"]  )
    {
        TwoButtonCell  *cell=[TwoButtonCell cellWithTableView:tableView];
        cell.oneLabel.text=model.fieldChName;
        cell.oneTextField.text=[model.showChgData isEqualToString:@""]?model.showOldData:model.showChgData;
        cell.oneTextField.enabled=NO;
        cell.model=model;
        cell.tag=indexPath.row;
        cell.delegate=self;
        twoButtonCell=cell;

        return cell;
        
    }
    
    //显示数字键盘
    else if ([model.fieldType isEqualToString:@"num"] )
    {
        
        OneLabelOneTextFieldOneBtnCell  *cell=[OneLabelOneTextFieldOneBtnCell cellWithTableView:tableView];
        cell.oneLabel.text=model.fieldChName;
        cell.oneTextField.text=[model.showChgData isEqualToString:@""]?model.showOldData:model.showChgData;
        [cell.oneTextField setEnabled:YES];
        cell.oneTextField.keyboardType=UIKeyboardTypeNumberPad;
        cell.oneImgView.hidden=YES;
        cell.oneButton.hidden=YES;
        [textTypeCellArray addObject:cell];
        cell.model=model;
        cell.tag=indexPath.row;
        
        return cell;
        
    }
    
    
    //显示普通键盘
    else if ([model.fieldType isEqualToString:@"char"] && [model.isChoose isEqualToString: @"0"] )
    {
        
        OneLabelOneTextFieldOneBtnCell  *cell=[OneLabelOneTextFieldOneBtnCell cellWithTableView:tableView];
        cell.oneLabel.text=model.fieldChName;
        cell.oneTextField.text=[model.showChgData isEqualToString:@""]?model.showOldData:model.showChgData;
        [cell.oneTextField setEnabled:YES];
        cell.model=model;
        cell.delegate=self;
        cell.tag=indexPath.row;
        

        //显示普通键盘
        cell.oneImgView.hidden=YES;
        cell.oneButton.hidden=YES;
        [textTypeCellArray addObject:cell];

        
        return cell;
        
    }
    
    //显示选择cell
    else if ([model.fieldType isEqualToString:@"char"] && [model.isChoose isEqualToString: @"1"] )
    {
        
        OneLabelOneTextFieldOneBtnCell  *cell=[OneLabelOneTextFieldOneBtnCell cellWithTableView:tableView];
        cell.oneLabel.text=model.fieldChName;
        cell.oneTextField.text=[model.showChgData isEqualToString:@""]?model.showOldData:model.showChgData;
        [cell.oneTextField setEnabled:NO];
        cell.model=model;
        cell.delegate=self;
        cell.tag=indexPath.row;
        
        return cell;
        
    }
    
    
    

    return nil;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    
}



-(void)selectBtn_TouchUpInside:(UIButton *)button{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
//    
//
//    Cell2 *cell=(Cell2 *)[_tableView cellForRowAtIndexPath:indexPath];
//    
//    NSMutableArray * dataArr=[[NSMutableArray alloc]initWithObjects:@"好的",@"你们", nil];
//    pop=[[PopupObjectList alloc]initWithData:dataArr selectedData:cell.infoTextView.text fromWhichObject:cell];
//    pop.delegate=self;
//    [pop presentPopupControllerAnimated];
}



#pragma mark - 没有button的cell的Delegate

-(void)OneLabelOneTextFieldOneBtnCellTouchDown:(OneLabelOneTextFieldOneBtnCell *)cell{
    //隐藏键盘
    for (int i=0; i<textTypeCellArray.count; i++) {
        OneLabelOneTextFieldOneBtnCell *cell=(OneLabelOneTextFieldOneBtnCell *)textTypeCellArray[i];
        [cell.oneTextField resignFirstResponder];
    }

    [self loadListData:cell];
}

-(void)OneLabelOneTextFieldOneBtnCell_textFieldDidEndEditing:(OneLabelOneTextFieldOneBtnCell *)cell{

    MatainObjectBaseInfo *model=_dataArray[cell.tag];
    model.showChgData=cell.oneTextField.text;

}

#pragma mark - 一个button的cell的Delegate
- (void)clickBtnToSetupCoordinateOrWithCell:(OneButtonCell *)cell
{
    
    // 获取经纬度
    if ([cell.oneLabel.text isEqualToString:@"经纬度"]) {
        
        [self localCoordinate:cell];
        
    }
    
    //选择时间
    else {

        //Create select action
        RMAction *selectAction = [RMAction actionWithTitle:@"确认" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
            
            cell.oneTextField.text = [self stringFromDate:((UIDatePicker *)controller.contentView).date];
            MatainObjectBaseInfo *model=_dataArray[cell.tag];
            model.showChgData=[self stringFromDate:((UIDatePicker *)controller.contentView).date];;
            
        }];
        
        //Create cancel action
        RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
            NSLog(@"Date selection was canceled");
        }];
        
        //Create date selection view controller
        RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleDefault selectAction:selectAction andCancelAction:cancelAction];
        
        dateSelectionController.title = @"录入时间选择";

        
        //Now just present the date selection controller using the standard iOS presentation method
        [self presentViewController:dateSelectionController animated:YES completion:nil];
    
    }
}


#pragma mark - two button cell delegate

- (void)twoButtonCell_firstButton_touchUpInside{
    
    
    [self takePicture];
}

- (void)twoButtonCell_secondButton_touchUpInside{
    [self choosePicture];
    
}

#pragma mark - imagePickerController delegate

//实现选择完毕图片或视频时候响应的函数－－-----------选择
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        //得到照片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //全局保存图片二进制的
        NSData *newImageData = [self compressImage:image toMaxFileSize:10000];
        
        _imgData = newImageData;

        //通过字典里面的key信息 把图片对象取出来
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        
        {
            
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            
            NSString * imgName = [representation filename];
            imgName = imgName?imgName:[NSString stringWithFormat:@"%ld.jpg", (long)[[NSDate date] timeIntervalSince1970]];
            twoButtonCell.oneTextField.text=imgName;
            
            
            //修改图片的名称
            MatainObjectBaseInfo *model=_dataArray[twoButtonCell.tag];
            model.showChgData=twoButtonCell.oneTextField.text;

        };
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL
                       resultBlock:resultblock
                      failureBlock:nil];
        
    
    }
    
}
#pragma -mark- 图片压缩
- (NSData *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        //        NSLog(@"%ld",[imageData length]);
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    //     NSLog(@"===========%ld",[imageData length]);
    //    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return imageData;
}

#pragma mark - popupObjectList delegate

- (void)popupObjectListDidSelectRowAtIndexPath:(NSString *)selectedData fromWhichObject:(id)fromWhichObject row:(NSInteger)row{
    
    if ([fromWhichObject isMemberOfClass:[OneLabelOneTextFieldOneBtnCell class]]) {
        OneLabelOneTextFieldOneBtnCell *cell=(OneLabelOneTextFieldOneBtnCell *)fromWhichObject;
        cell.oneTextField.text=selectedData;
        MatainObjectBaseInfo *model=_dataArray[cell.tag];
        model.showChgData=selectedData;
    }

}


#pragma mark - 私有方法
-(void)takePicture{
    //判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        _picker.allowsEditing = YES;  //是否可编辑
        //摄像头presentViewController:animated:completion:
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_picker animated:YES completion:nil];
    }else{
        //如果没有提示用户
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert1 show];
    }}

-(void)choosePicture{
    //选择照片文件
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //把系统照片库调给picker用
        _picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:_picker animated:YES completion:^{
            
        }];
        
    }
}



#pragma  mark - server data

/*请求列表的数据*/
- (void) loadListData:(OneLabelOneTextFieldOneBtnCell *)cell
{
    
    [MBProgressHUD showMessage:KHudIsRequestMessage];
    
    MatainObjectBaseInfo *model=cell.model;

    NSDictionary *params = @{@"tableName":_matainObject.tablename,
                             @"enField":model.fieldEnName,
                             };
    
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMInformation" methodName:@"FSMGetMObjectAttrChooseValues" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"]  isEqual: @0]) {

            popList=[[PopupObjectList alloc]initWithData:dic[@"attrChooseValues"] selectedData:cell.oneTextField.text fromWhichObject:cell];
            NSLog(@"popList=%@",dic[@"attrChooseValues"]);
            popList.delegate=self;
            [popList presentPopupControllerAnimated];
            
        }
        else  if ([dic[@"retCode"]  isEqual: @(-1)]) {
            [self.view makeToast:KHudResponse1];
            
        }
        else  if ([dic[@"retCode"]  isEqual: @(-2)]) {
            [self.view makeToast:KHudResponse2];
            
        }
        else{
            [self.view makeToast:@"请求列表数据失败"];
        }

        
        
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];


        [self.view makeToast:KHudErrorMessage];

    }
     ];
    
}


/*提交字段修改请求*/
- (void) upLoadData
{
    
    [MBProgressHUD showMessage:KHudIsUpdataMessage];

    
    NSMutableArray *arr=[NSMutableArray array];
    for (int i=0; i<_dataArray.count; i++) {
        MatainObjectBaseInfo *baseInfo=(MatainObjectBaseInfo *)_dataArray[i];
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setObject:self.matainObject.tablename forKey:@"tableName"];
        [dic setObject:baseInfo.fieldEnName forKey:@"fieldName"];
        [dic setObject:baseInfo.fieldChName forKey:@"fieldChnName"];
        [dic setObject:baseInfo.oldData forKey:@"oldData"];
        [dic setObject:baseInfo.showOldData forKey:@"showOldData"];
        [dic setObject:baseInfo.showChgData forKey:@"showChgData"];
        [arr addObject:dic];
    }
    
    
    NSDictionary *params = @{@"objectCode":_matainObject.maintenanceId,
                             @"objectName":_matainObject.maintenanceObjectTitle?_matainObject.maintenanceObjectTitle:_matainObject.maintenanceObjectName,
                             @"objectTypeCode":_matainObject.maintenanceObjectType,
                             @"objectTypeName":_matainObject.maintenanceTypeName?_matainObject.maintenanceTypeName:@"",
                             @"attrChangeDetails":arr
                             
                             };
  
    NSLog(@"params===%@",params);
    
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMInformation" methodName:@"FSMPostMObjectChgInfo" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"]  isEqual: @0]) {
            
            [MBProgressHUD showSuccess:KHudSuccessMessage];
            
            for (int i=0 ; i<self.navigationController.viewControllers.count; i++) {
                UIViewController *vc=self.navigationController.viewControllers[i];
                if ([vc isMemberOfClass:[NetResourceSearchViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            
        }
        else if ([dic[@"retCode"]  isEqual: @(-1)]) {
            [MBProgressHUD showError:KHudResponse1];
            
        }
        else if ([dic[@"retCode"]  isEqual: @(-2)]) {
            [MBProgressHUD showError:KHudResponse2];
            
        }
        
        
        
        
    } falure:^(NSError *err) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:KHudErrorMessage];
        
        
    }
     ];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma  mark - 底部的两个按钮调用的方法
- (IBAction)backBtn_TouchUpInside:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)ReportBtn_TouchUpInside:(id)sender {
    //如果有没有修改的数据，这里给出提示。
    for (MatainObjectBaseInfo *model  in  _dataArray) {
        if ([model.showChgData isEqualToString:@""]) {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"有没有修改的属性，是否提交修改？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.delegate=self;
            [alertView show];
            return;
        }
    }
    
    //如果都修改了，那么直接提交。
    [self upLoadData];

    
}


#pragma mark - alert view delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self upLoadData];

    }

}

#pragma mark - get/set
-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
    
}

-(UIImagePickerController *)picker{
    if (_picker==nil) {
        _picker=[[UIImagePickerController alloc]init];
        _picker.delegate=self;
    }
    
    return _picker;
    

}
#pragma mark - other
//处理位置坐标更新
- (void)localCoordinate:(OneButtonCell*)cell
{
    // 启动LocaltionSerview
    [_locService startUserLocationService];
    
     cell.oneTextField.text= [NSString stringWithFormat:@"%f、%f",_latitude,_longitude];
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cell.oneTextField.text= [NSString stringWithFormat:@"%f %f",_latitude,_longitude];
        MatainObjectBaseInfo *model=_dataArray[cell.tag];
        model.showChgData=[NSString stringWithFormat:@"%f %f",_latitude,_longitude];
    });
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _latitude = userLocation.location.coordinate.latitude;
    _longitude = userLocation.location.coordinate.longitude;
    
}

- (NSString*)stringFromDate:(NSDate*)date
{
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString * dateStr = [fmt stringFromDate:date];
    return dateStr;
}


#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end
