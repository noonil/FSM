//
//  DetailViewController.m
//  Ericsson
//
//  Created by Slark on 16/1/7.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "DetailViewController.h"
#import "feedBModel.h"
#import "feedDetailTableViewCell.h"
#import "MJExtension.h"
#import "feeDetailTableViewCell.h"
#import "XJDetailViewController.h"
#import "AttachmentDescripeViewController.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "ShareManager.h"
#import "AttachTableViewCell.h"
#import "AttachModel.h"

@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,writebackdelegate,UIImagePickerControllerDelegate,UINavigationBarDelegate,UITextViewDelegate>{
    
    int _num[30];
    NSInteger _aaa;
    AttachmentDescripeViewController *attachment;
    
}
@property (nonatomic,assign)int current;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * str;//用于传递字符串
@property (nonatomic,copy)NSString * backStr;
@property (nonatomic,strong)NSDictionary * dict;
/** 标志操作的是哪一个section中的 选择照片*/
@property (strong ,nonatomic) NSMutableDictionary * chooseWhichPhotoDic;
@property (strong ,nonatomic) NSMutableDictionary * choosePhotoDataDic;
@property (nonatomic,copy)NSString * iiiStr;
@property (nonatomic,assign)BOOL isSelect;
//操作项id传值
@property (nonatomic,strong)NSMutableArray * idArray;
@property (nonatomic,copy)NSString * strrr;
@property (nonatomic,strong)NSMutableArray * dictArray;
@property (nonatomic,strong)NSMutableDictionary * sectionDict;

@property (nonatomic,strong)UIImagePickerController *picker;
@property (nonatomic, strong) NSData *imgData;
@property (nonatomic, strong) NSString *FileName;

@property (nonatomic,strong) UITextView * textview;
/** 照片对象*/
@property (strong ,nonatomic) AttachModel *  photoModel;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.current = 1;
    
    self.title = @"巡检详情";
    self.dataArr = [NSMutableArray array];
    
    _picker = [[UIImagePickerController alloc]init];
    _picker.delegate = self;
    
    self.view.backgroundColor = KBaseGray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goMediaVc:) name:@"goToMediaVCNotification" object:nil];
    
    [self requestData];
    
    [self.view addSubview:self.tableView];
    _num[10] = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"feeDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"DDD"];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"goToMediaVCNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goMediaVc:) name:@"goToMediaVCNotification" object:nil];
}


// 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (NSMutableArray *)dictArray{
    if(_dictArray == nil){
        
        self.dictArray = [[NSMutableArray alloc]init];
    }
    
    return _dictArray;
}

- (NSMutableDictionary*)sectionDict{
    
    if(!_sectionDict){
        
        _sectionDict = [[NSMutableDictionary alloc]init];
        
    }
    return _sectionDict;
}

- (NSMutableArray *)idArray{
    
    if(_idArray == nil){
        
        
        _idArray = [[NSMutableArray alloc]init];
    }
    
    return _idArray;
}

- (NSDictionary *)dict{
    
    if(_dict == nil){
        
        _dict = [[NSMutableDictionary alloc]init];
        
    }
    
    
    return _dict;
}
#pragma mark 传值
- (void)giveBackStr:(NSString *)str{
    
    
    self.backStr = str;
    
}





//请求页面数据
- (void)requestData{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * sessionId = [defaults objectForKey:@"sessionId"];
    NSString * userId = [defaults objectForKey:@"username"];
    NSString * modelName = @"FSMworkOrder";
    NSString * methodName = @"FSMWOOprList";
    
    NSDictionary * params = @{@"woId":self.woId,@"pageIdx":@(self.current),@"userId":userId};
    
    NSString * sopStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:params];
    
    [MBProgressHUD showMessage:@"正在请求数据"];
    [[SoapService shareInstance] PostAsync:sopStr Success:^(NSDictionary *dic) {
        //赋值给模型
        if ([dic[@"retCode"] isEqual:@0]) {
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"请求成功"];
            NSArray * array = dic[@"operateItems"];
            for (NSDictionary * dict in array) {
                
                feedBModel * model = [[feedBModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dict];
                
                [self.dataArr addObject:model];
                
                
            }
            [self.tableView reloadData];
            //当无数据的时候两个按钮 关闭
            if(self.dataArr.count == 0){
                
                self.feedbackButton.enabled = NO;
                self.completeButton.enabled = NO;
                self.feedbackButton.backgroundColor = KBaseGray;
                self.completeButton.backgroundColor = KBaseGray;
                
            }
            
            
            
            
            for (int i = 0;  i<array.count; i++) {
                [self.sectionDict setObject:@NO forKey:@(i)];
                [self.chooseWhichPhotoDic setObject:@NO forKey:@(i)];
            }
            
            
            
        }
        
        
        
    } falure:^(NSError *response) {
        
        
        
        
    }];
    
    
    
}



#pragma mark tableView delegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 取出choosePhotoDataDic字典中数组(数据源)
    NSArray * photoDataArray = [self.choosePhotoDataDic objectForKey:@(indexPath.section)];

    if (indexPath.row == 0) {
        
        feeDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDD" forIndexPath:indexPath];
        cell.textView.delegate = self;
        cell.choosePic.tag = indexPath.section;
        cell.textView.tag = indexPath.section;
        self.textview = cell.textView;
        [cell.choosePic addTarget:self action:@selector(choosePicClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.takePhoto addTarget:self action:@selector(takePhotoClick:) forControlEvents:UIControlEventTouchUpInside];

    if ([self.statusDes isEqualToString:@""] && cell.tag == indexPath.section) {
        
        
    }else{
        
        self.textview.text = self.statusDes;
    }
    return cell;
        
    }else{
        
        AttachTableViewCell *cell = [AttachTableViewCell cellWithTableView:tableView];
        AttachModel *attach = (AttachModel *)photoDataArray[indexPath.row - 1];
        
        cell.fileNameText.text = attach.imgName;
        cell.detailText.text = attach.imgDetails;
        cell.deleteBtn.tag = indexPath.row;
        
        [cell.deleteBtn setTitle:[NSString stringWithFormat:@"%ld",indexPath.section] forState:UIControlStateNormal];
        NSLog(@"titleLabel - %@",cell.deleteBtn.titleLabel.text);
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([attach.fileType isEqualToString:@"image"]) {
            cell.typeImg.image = [UIImage imageNamed:@"attach_list_picture_type.png"];
        }else if ([attach.fileType isEqualToString:@"moive"]){
            
            cell.typeImg.image = [UIImage imageNamed:@"attach_list_video_type.png"];
        }else if ([attach.fileType isEqualToString:@"vido"]){
            
            //cell.typeImg.image = [UIImage imageNamed:@"attach_list_video_type.png"];
        }
        return cell;
    }
}
#pragma -mark- 删除按钮方法添加
-(void)deleteBtnClick:(UIButton *)sender{
    NSInteger row = sender.tag;
    NSInteger section = [sender.titleLabel.text integerValue];
    
    
    NSMutableArray * array = [self.choosePhotoDataDic objectForKey:@(section)];
    [array removeObject:array[row-1]];
    
    //    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    //    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadData];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([[self.sectionDict objectForKey:@(section)] isEqual:@YES]){
        
        NSArray * array = [self.choosePhotoDataDic objectForKey:@(section)];
        return ((array.count?array.count:0) + 1);
        
    }else{
        
        return 0;
        
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    
    
    return self.dataArr.count;
    
    
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 45)];
    
    feedBModel * model = self.dataArr[section];
    
    //创建段头
    for(int i = 0; i <= self.dataArr.count;i++){
        if (section == i) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.tableView.bounds.size.width / 4 * 3, 30)];
            label.numberOfLines = 2;
            label.font = [UIFont boldSystemFontOfSize:14];
            label.text = model.operateItemName;
            [view addSubview:label];
            
            //点击段头的方法按钮
            UIButton * bt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            bt.frame = CGRectMake(0, 0, self.tableView.bounds.size.width / 4 * 3, 30);
            [bt setTitle:@"" forState:UIControlStateNormal];
            [bt addTarget:self action:@selector(btClick:) forControlEvents:UIControlEventTouchUpInside];
            bt.titleLabel.text = label.text;
            bt.tag = 100 + section;
            [view addSubview:bt];
            
            
            //点击编辑/正常/异常 的按钮
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(self.tableView.bounds.size.width / 5 * 4 , 5, 60, 30);
            [button addTarget:self action:@selector(selectBTClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = section;
            
            //通过model.qrType 来判断是正常异常按钮 还是编辑按钮
            if([model.qrType isEqualToString:@"1"]){
                
                //通过model.hasOperated 是否为@"0"来判断是正常按钮还是异常按钮
                if ([model.hasOperated isEqualToString:@"0"]) {
                    
                    [button setImage:[UIImage imageNamed:@"normal.jpg"] forState:UIControlStateNormal];
                }
                else{
                    [button setImage:[UIImage imageNamed:@"abnormal.jpg"] forState:UIControlStateNormal];
                }
                
                
                
            }else{
                
                [button setImage:[UIImage imageNamed:@"edit.jpg"] forState:UIControlStateNormal];
                
            }
            
            [view addSubview:button];
            
        }
        
        
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0) {
        return 55.0;
    }else
    {
        return 132.0;
    }
}
#pragma mark  跳转详情界面的方法
- (void)btClick:(UIButton*)bt{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    feedBModel * model = self.dataArr[bt.tag - 100];
    if ([model.qrType isEqualToString:@"0"]) {
        
        _strrr = @"";//_strrr 是qr_type的值
        
    }else if([model.qrType isEqualToString:@"1"]){
        
        if ([model.hasOperated isEqualToString:@"0"]) {
            _strrr = @"1";
        }else{
            _strrr = @"0";
        }
        
    }
    
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //    if(self.iiiStr == nil){
    //        self.iiiStr = @"";
    //    }
    //
    //    if(self.backStr == nil){
    //        self.backStr=  @"";
    //    }
    //
    //
    //
    //    NSDictionary * dict = @{
    //                  @"woOperId":model.actionItemCode,
    //                  @"qr_type":model.qrType,
    //                  @"operateItemState":_strrr,
    //                  @"remark":self.backStr,
    //                  @"abnormalDesc":self.iiiStr,
    //                  @"optionData":@"",
    //                  @"lon":@"0",
    //                  @"lan":@"0",
    //                  @"accuricy":@"0",
    //                  @"time":currentDateStr};
    //
    //    [self.idArray addObject:dict];
    
    XJDetailViewController * detal = [[XJDetailViewController alloc]init];
    detal.str = bt.titleLabel.text;
    detal.firstStr = self.backStr;
    detal.mark = self.remark;
    detal.delegate = self;
    
    [self.navigationController pushViewController:detal animated:YES];
    
    
}

#pragma mark textViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    
    
    
    
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    
    
    
    
    
    
    
}

#pragma mark编辑点击
- (void)selectBTClick:(UIButton*)button{
    
    [self.dictArray removeAllObjects];
    
    feedBModel * model = self.dataArr[button.tag];
    
    if ([model.qrType isEqualToString:@"0"]) {
        
        _strrr = @"";//_strrr 是qr_type的值
        
    }else if([model.qrType isEqualToString:@"1"]){
        
        if ([model.hasOperated isEqualToString:@"0"]) {
            _strrr = @"1";
        }else{
            _strrr = @"0";
        }
        
    }
    
    
    
    
    
    //判断按钮正常异常状态
    if ([model.hasOperated isEqualToString:@"0"]) {
        model.hasOperated = @"1";
    }else{
        model.hasOperated = @"0";
    }
    
    self.moto = model.actionItemCode;//requestData所需参数
    self.idd = model.idd;//requestData数据
    _aaa =button.tag;
    
    NSNumber * flag = [self.sectionDict objectForKey:@(button.tag)];
    
    if ([flag boolValue] == NO) {
        [self.sectionDict setObject:@(![flag boolValue]) forKey:@(button.tag)];
        // 请求数据
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * sessionId = [defaults objectForKey:@"sessionId"];
        NSString * modelName = @"FSMworkOrder";
        NSString * methodName = @"FSMWOOprInfos";
        
        NSDictionary * requestData = @{@"woOperId":self.idd,
                                       @"woOperCode":self.moto,
                                       @"formId":self.woId};
        
        NSString * sope = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:requestData];
        [MBProgressHUD showMessage:@"正在请求数据"];
        [[SoapService shareInstance] PostAsync:sope Success:^(NSDictionary *dic) {
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"请求成功"];
            if([dic[@"retCode"] isEqual:@0]){
                NSLog(@"服务器的数值为%@",dic);
                
                self.remark = dic[@"remark"];
                self.statusDes = dic[@"statusDes"];
                
                
            }
            
            [self.tableView reloadData];
            
        } falure:^(NSError *response) {
            
            
        }];
        
    }else{
        
        [self.sectionDict setObject:@(![flag boolValue]) forKey:@(button.tag)];
        
    }
    
    
    
    
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:_aaa] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark 选择照片按钮
- (void)choosePicClick:(UIButton*)button{
     NSInteger tag = button.tag;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //把系统照片库调给picker用
        _picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:_picker animated:YES completion:^{
            // 在section字典中，把值改成YES
            [self.chooseWhichPhotoDic setObject:@YES forKey:@(tag)];
        }];
        
    }
    
}

- (void)takePhotoClick:(UIButton*)bt{
    NSInteger tag = bt.tag;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        _picker.allowsEditing = YES;  //是否可编辑
        //摄像头presentViewController:animated:completion:
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_picker animated:YES completion:^{
            // 在section字典中，把值改成YES
            [self.chooseWhichPhotoDic setObject:@YES forKey:@(tag)];
        }];
    }else{
        //如果没有提示用户
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert1 show];
    }
    
    
    
}
#pragma mark 选择图片
//实现选择完毕图片或视频时候响应的函数－－-----------选择
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        //得到照片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //全局保存图片二进制的
        NSData *newImageData = [self compressImage:image toMaxFileSize:10000];
        
        _imgData = newImageData;
        NSLog(@"imgdata:%ld",_imgData.length);
        attachment.infoData = _imgData;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //图片存入相册
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
        //通过字典里面的key信息 把图片对象取出来
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            _FileName = [representation filename];
            NSLog(@"==================%@",_FileName);
            attachment = [[AttachmentDescripeViewController alloc] initWithNibName:@"AttachmentDescripeViewController" bundle:nil];
            attachment.infoFileName = _FileName?_FileName:[NSString stringWithFormat:@"%ld.jpg", (long)[[NSDate date] timeIntervalSince1970]];
            attachment.fileType = @"image";
            
            self.photoModel = [[AttachModel alloc]init];
            self.photoModel.imgName = attachment.infoFileName; // 给photo赋值
            self.photoModel.fileType = @"image";
            
            ShareManager *shareManager = [ShareManager sharedManager];
            [shareManager.attachDataMutableArray addObject:_imgData];
            //            [self dismissViewControllerAnimated:YES completion:nil];
            [self.picker presentViewController:attachment animated:NO completion:nil];
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
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    return imageData;
}
//点击Cancel按钮后执行方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)goMediaVc:(NSNotification *)notify{
    
    for (int i = 0; i < self.chooseWhichPhotoDic.count; i++) {
        if ([[self.chooseWhichPhotoDic objectForKey:@(i)] isEqual:@YES]) {
            
            // 把模型数据加入到，字典的第i个数据源
            NSMutableArray * photoListData = [[NSMutableArray alloc]init];
            // 取出字典中的数据
            photoListData.array = [self.choosePhotoDataDic objectForKey:@(i)];
            // 把新选的数据 加入到数组中
            [photoListData addObject:self.photoModel];
            // 把数组添加的  字典中
            [self.choosePhotoDataDic setObject:photoListData forKey:@(i)];
            // 把这个标志符，改成NO
            [self.chooseWhichPhotoDic setObject:@NO forKey:@(i)];
            
        }
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tableView reloadData];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)click:(UIButton*)bt{
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark 阶段反馈
- (IBAction)feedClick:(id)sender {
    
    feedBModel * model = self.dataArr[self.textview.tag];
    self.iiiStr = self.textview.text;
    self.backStr = self.backStr;
    
    if(self.iiiStr == nil){
        self.iiiStr = @"";
    }
    
    if(self.backStr == nil){
        self.backStr=  @"";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDictionary * dict = @{
                            @"woOperId":model.actionItemCode,
                            @"qr_type":model.qrType,
                            @"operateItemState":_strrr,
                            @"remark":self.backStr,
                            @"abnormalDesc":self.iiiStr,
                            @"optionData":@"",
                            @"lon":@"0",
                            @"lan":@"0",
                            @"accuricy":@"0",
                            @"time":currentDateStr};
    
    [self.idArray addObject:dict];
    
    
    
    
    NSDictionary * feedBackDict = @{@"woOperId":model.idd,
                                    @"remark":self.backStr,//第二界面传值
                                    @"qr_type":model.qrType,
                                    @"operateItemState":self.strrr,//qrtype的值
                                    @"abnormalDesc":self.iiiStr,//textView里面的值
                                    @"optionData":@""};
    
    [self.dictArray addObject:feedBackDict];
    
    NSLog(@"请求的字典为%@",self.dictArray);
    
    NSUserDefaults * defaulst = [NSUserDefaults standardUserDefaults];
    
    NSString * longitude = [defaulst objectForKey:@"longitude"];
    NSString * latitude = [defaulst objectForKey:@"latitude"];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * sessionId = [defaults objectForKey:@"sessionId"];
    NSString * modelName  = @"FSMworkOrder";
    NSString * methodName = @"FSMPostWOOprListTmpData";
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDictionary * requestData = @{@"longitude":longitude?longitude:@"",
                                   @"latitude":latitude?latitude:@"",
                                   @"uploadTime":currentDateStr,
                                   @"accuracy":@"0",
                                   @"woOperInfos":self.dictArray};
    
    NSString * sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:requestData];
    
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD showMessage:@"正在请求数据"];
        
        if([dic[@"retCode"] isEqual:@0]){
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"请求成功"];
            self.iiiStr = @"";
        }
        
    } falure:^(NSError *response) {
        
    }];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark 完成
- (IBAction)completeClick:(id)sender {
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * sessionId = [defaults objectForKey:@"sessionId"];
    
    NSString * modelName = @"FSMworkOrder";
    NSString * methodName = @"FSMPostWOOprList";
    
    NSDictionary * requestData = @{@"woId":self.woId,@"woOperInfos":self.idArray};
    
    NSString * sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:requestData];
    
    
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        
        [MBProgressHUD showMessage:@"正在请求"];
        
        if([dic[@"retCode"] isEqual:@0]){
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"请求成功"];
            
            
        }
        
    } falure:^(NSError *response) {
        
    }];
    
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - --- AttachmentDescripeDelegate ---
- (void)submitContentText:(NSString *)text
{
    self.photoModel.imgDetails = text;
}
#pragma mark - --- LAZY ---
- (NSMutableDictionary *)choosePhotoDataDic
{
    if (!_choosePhotoDataDic) {
        _choosePhotoDataDic = [[NSMutableDictionary alloc]init];
    }
    return _choosePhotoDataDic;
}
- (NSMutableDictionary *)chooseWhichPhotoDic
{
    if (!_chooseWhichPhotoDic) {
        _chooseWhichPhotoDic = [[NSMutableDictionary alloc]init];
    }
    return _chooseWhichPhotoDic;
}
@end
