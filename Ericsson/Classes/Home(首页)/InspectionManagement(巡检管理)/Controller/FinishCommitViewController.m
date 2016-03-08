//
//  FinishCommitViewController.m
//  Ericsson
//
//  Created by Slark on 16/1/7.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "FinishCommitViewController.h"
#import "PopupObjectList.h"
#import "lastProblemViewController.h"
#import "dealViewController.h"
#import "addmessafeViewController.h"
#import "completeListViewController.h"
#import "OrderProcessingViewController.h"
#import "AttachmentDescripeViewController.h"
#import <AVFoundation/AVFoundation.h>
//把播放视频需要头文件 导入
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AttachModel.h"
#import "AttachTableViewCell.h"
#import <sys/socket.h>
#import <arpa/inet.h>
#import "ShareManager.h"
#import "MediaTitleViewController.h"
#import "AsyncSocket.h"
#import "AttachGroupModels.h"
#import "AFNetworkReachabilityManager.h"
@interface FinishCommitViewController ()<PopupObjectListDelegate,sendMessage,lastMessage,dealMessage,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,AsyncSocketDelegate,NSStreamDelegate>{
    
    BOOL isClick;
    UIAlertView *alert;
    AVAudioRecorder *recorder;//定义一个录制声音的的变量
    AttachmentDescripeViewController *attachment;
    CFSocketRef _socket;
    BOOL isONLINE;
    BOOL isCANCEL;
    AsyncSocket *clientSocket;
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    NSInteger flag;
    int count;
    BOOL  isConnected;
    int i;
    BOOL isWifi;
    
}
#define SRV_CONNECTED 2
#define SRV_CONNECT_SUC 1
#define SRV_CONNECT_FAIL 0
#define HOST_IP @"121.28.82.70"
#define HOST_PORT 7979

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)PopupObjectList * pop;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *canceldataArray;
@property (nonatomic,strong)UIImagePickerController *picker;
@property(nonatomic,strong)NSMutableArray *attachDataMutableArray;

@end

static NSString *btn1;
static NSString *btn2;
static int idx;


@implementation FinishCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"巡检处理结束";
    [self addData];
    
    isClick = YES;
    [self.FButton addTarget:self action:@selector(BTclick:) forControlEvents:UIControlEventTouchUpInside];
    self.finishTypeTextField.userInteractionEnabled = NO;
    
    count = 0;
    isConnected = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goMediaVc:) name:@"goToMediaVCNotification" object:nil];
    ShareManager *shareManager = [ShareManager sharedManager];
    [LKDBHelper clearTableData:[AttachModel class]];
    //    [shareManager.attachDataMutableArray removeAllObjects];
    shareManager.titleText = @"";
    //    self.attachDataMutableArray = [[NSMutableArray alloc]init];
    _picker=[[UIImagePickerController alloc]init];
    //设置委托
    _picker.delegate=self;
    self.tableview.delegate = self;
    self.tableview.dataSource =self;
    
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (int)connectServer:(NSString *)hostIP port:(int)hostPort
{
    if (clientSocket == nil)
    {
        // 在需要联接地方使用connectToHost联接服务器
        clientSocket = [[AsyncSocket alloc] initWithDelegate:self];
        clientSocket.delegate = self;
        NSError *err = nil;
        if (![clientSocket connectToHost:hostIP onPort:hostPort error:&err])
        {
            NSLog(@"Error %ld:%@", (long)err.code, [err localizedDescription]);
            
            UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:[@"Connection failed to host" stringByAppendingString:hostIP] message:[NSString stringWithFormat:@"%ld:%@",(long)err.code,err.localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alerts show];
            return SRV_CONNECT_FAIL;
        } else {
            NSLog(@"Connected!");
            return SRV_CONNECT_SUC;
        }
    }
    else {
        return SRV_CONNECTED;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self reachability];
    
    ShareManager *shareManager = [ShareManager sharedManager];
    //self.titleLabel.text = shareManager.titleText;
    self.dataArray = [AttachModel searchWithWhere:nil orderBy:nil offset:0 count:100];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview reloadData];
    
}




- (void)sendDealMessage:(NSString *)str{
    
    
    
    self.firstLabel.text = str;
}

- (void)sendlastMessage:(NSString *)str{
    
    self.secondLabel.text = str;
    
}

- (void)addData{
    
    
    self.dataArr = [NSMutableArray array];
    
    NSArray * array =[NSArray arrayWithObjects:@"巡检完成",@"无法进入",@"未完成",@"部分完成", nil];
    
    
    self.dataArr  = [NSMutableArray arrayWithArray:array];
    
}

- (void)senbackMessage:(NSString *)str{
    
    
    self.thirdLabel.text = str;
    
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
#pragma mark 3个填充按钮
- (IBAction)SButton:(id)sender {
    dealViewController * deal = [[dealViewController alloc]init];
    deal.delegate = self;
    [self.navigationController pushViewController:deal animated:YES];
}

- (IBAction)TButton:(id)sender {
    lastProblemViewController * last = [[lastProblemViewController alloc]init];
    last.delegate = self;
    
    isClick = !isClick;
    
    if(isClick){
        
        self.lastButtton.selected = NO;
        
    }
    else{
        
        self.lastButtton.selected = YES;
    }
    
    if(self.lastButtton.selected){
        
        [self.navigationController pushViewController:last animated:YES];
        
    }

    
    
    
}

- (IBAction)FButton:(id)sender {
    addmessafeViewController * add = [[addmessafeViewController alloc]init];
    add.delegate = self;
    [self.navigationController pushViewController:add animated:YES];
}

- (IBAction)finishTypeButton:(id)sender {
    
    self.pop = [[PopupObjectList alloc]initWithData:self.dataArr selectedData:self.finishTypeTextField.text fromWhichObject:self.finishTypeTextField];
    
    [self.pop presentPopupControllerAnimated];
    self.pop.delegate = self;
    
}

- (void)BTclick:(UIButton*)button{
    
    
    self.pop = [[PopupObjectList alloc]initWithData:self.dataArr selectedData:self.finishTypeTextField.text fromWhichObject:self.finishTypeTextField];
    
    [self.pop presentPopupControllerAnimated];
    self.pop.delegate = self;
    
}
- (void)popupObjectListDidSelectRowAtIndexPath:(NSString *)selectedData fromWhichObject:(id)fromWhichObject row:(NSInteger)row{
    
    if (fromWhichObject == _finishTypeTextField) {
        
        
        self.finishTypeTextField.text = self.dataArr[row];
        
        
    }else{
       
        
    }
}


#pragma mark 备注按钮
- (IBAction)lastClick:(id)sender {
    isClick = !isClick;
    
    if(isClick){
        
        self.lastButtton.selected = NO;
        
    }
    else{
        
        self.lastButtton.selected = YES;
    }
    
    lastProblemViewController * last = [[lastProblemViewController alloc]init];

    last.delegate = self;

    if(self.lastButtton.selected){
    
    [self.navigationController pushViewController:last animated:YES];
    
    }
    
    
    
}

- (IBAction)DealProblemClick:(id)sender {
    
    dealViewController * deal = [[dealViewController alloc]init];
    deal.delegate = self;
    [self.navigationController pushViewController:deal animated:YES];
    
    
}
- (IBAction)addMessageClick:(id)sender {
  
    addmessafeViewController * add = [[addmessafeViewController alloc]init];
    add.delegate = self;
    [self.navigationController pushViewController:add animated:YES];
    
    
    
    
}


#pragma mark 拍照或悬着照片alert
- (IBAction)ImageClick:(id)sender {
    idx=3;
    btn1=@"拍照";
    btn2=@"选择图片";
    [self alert];
    
    
    
}

-(void)alert{
    alert=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:btn2, nil];
    [alert addButtonWithTitle:btn1];
    alert.delegate=self;//绑定
    [alert show];
    
    
}


#pragma mark 调用相机
-(void)addCarema
{
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
    }
}

#pragma mark 录像
- (void)addVideo
{
    _picker.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        _picker.videoQuality = UIImagePickerControllerQualityTypeMedium; //录像质量
        _picker.videoMaximumDuration = 600.0f; //录像最长时间
        _picker.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
    } else {
        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前设备不支持录像功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert2 show];
    }
    //跳转到拍摄页面
    [self presentViewController:_picker animated:YES completion:nil];
}
#pragma mark 选择相册照片出发的方法
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
            
            ShareManager *shareManager = [ShareManager sharedManager];
            [shareManager.attachDataMutableArray addObject:_imgData];
            //            [self dismissViewControllerAnimated:YES completion:nil];
            [self.picker presentViewController:attachment animated:NO completion:nil];
        };
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL
                       resultBlock:resultblock
                      failureBlock:nil];
        
        
    }else if ([mediaType isEqualToString:@"public.movie"]) {
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSData *videlData = [NSData dataWithContentsOfURL:videoURL];
        //存储数据
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            
            _FileName = [representation filename];
            NSLog(@"==================%@",_FileName);
            attachment = [[AttachmentDescripeViewController alloc] initWithNibName:@"AttachmentDescripeViewController" bundle:nil];
            attachment.infoFileName = _FileName;
            attachment.fileType = @"moive";
            
            ShareManager *shareManager = [ShareManager sharedManager];
            [shareManager.attachDataMutableArray addObject:videlData];
            
            [self.picker presentViewController:attachment animated:NO completion:nil];
        };
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:videoURL
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
#pragma mark 相册点击取消的方法
//点击Cancel按钮后执行方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)goMediaVc:(NSNotification *)notify{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark 点击提交触发的方法

- (IBAction)commitClick:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL wifiOpen = [[defaults objectForKey:@"choose"]isEqualToString:@"Y"];
    
    if (isWifi || !wifiOpen) {
        if (self.dataArray.count > 0) {
            [MBProgressHUD showMessage:@"正在反馈"];
            isConnected = [self connectServer:HOST_IP port:HOST_PORT];
            [self jsonInfowoId:self.woId];
            if (_attachGroupId) {
                [self socketImg];
                
                [MBProgressHUD hideHUD];
                
                
                
             //   [self.navigationController popViewControllerAnimated:YES];
                
                
            }else{
                [self.view makeToast:@"反馈失败"];
            }
            
        }else{
            [self.view makeToast:@"无数据"];
        }
    }else{
        [self.view makeToast:@"非wifi网络下禁止上传"];

    
    }
    
    if([self.finishTypeTextField.text isEqualToString:@""]){
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入完成类型!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];

        [alert show];
        
    }else{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * userId = [defaults objectForKey:@"username"];
    NSString * sessionId = [defaults objectForKey:@"sessionId"];
    
    NSString * modelName = @"FSMworkOrder";
    NSString * methodName = @"FSMSubmitCompeleteWO";
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDictionary * dict = @{@"userId":userId,
                            @"woId":self.woId,
                            @"localTs":currentDateStr,
                            @"finishType":self.finishTypeTextField.text,
                            @"handleSummary":self.firstLabel.text,
                            @"questionDescribe":self.secondLabel.text,
                            @"remark":self.thirdLabel.text,
                            @"operMBPS":@"处理结束",@"processId":@"0"};
    
    
    NSString * sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:dict];
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD showMessage:@"正在请求数据"];
     
        if([dic[@"retCode"] isEqual:@0]){
            [MBProgressHUD hideHUD];
             [MBProgressHUD showSuccess:@"请求成功"];
            NSLog(@"%@",dic[@"timeOut"]);
            OrderProcessingViewController * order = [[OrderProcessingViewController alloc]init];
            [self.navigationController pushViewController:order animated:YES];
            
            NSMutableArray * navArray = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            NSLog(@"%@",self.navigationController.viewControllers);
            NSRange range = NSMakeRange(0, 2);
            NSArray * subArr = [navArray subarrayWithRange:range];
            NSMutableArray * array = [[NSMutableArray alloc]initWithArray:subArr];
            [array addObject:order];
            
            [self.navigationController setViewControllers:array];
            
            
        }
        
       

        
    } falure:^(NSError *response) {
        
        
    }];
    
    }
}
#pragma socket方法
-(void)socketImg{
        i = 0;
    
        
        ShareManager *shareManager = [ShareManager sharedManager];
        NSData *infoData = (NSData *)shareManager.attachDataMutableArray[i];
        NSDate *now = [NSDate date];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];
        NSString * serverSavedFileNames = [NSString stringWithFormat:@"%@.jpg",timeSp];
        //        serverSavedFileName = serverSavedFileNames;
        
        AttachGroupModels *attachGroupModels = [[AttachGroupModels alloc]init];
        attachGroupModels.groupId = _attachGroupId;
        attachGroupModels.serveId = [NSString stringWithFormat:@"%d",2*i+1];
        attachGroupModels.serveName = serverSavedFileNames;
        [attachGroupModels saveToDB];
        NSString *header = [NSString stringWithFormat:@"Content-Length=%lu;filename=%@;sourceid=%@"
                            ,infoData.length,serverSavedFileNames,@""];
        
        NSString * content = [header stringByAppendingString:@"\r\n"];
        NSLog(@"%@",content);
        NSData *dataFinal = [content dataUsingEncoding:NSUTF8StringEncoding];
        if(isConnected){
            [clientSocket writeData:dataFinal withTimeout:-1 tag:0];
            [clientSocket readDataWithTimeout:-1 tag:1];
            
            
        }else{
            NSLog(@"socket连接失败");
        }
        
        
        NSLog(@"发送成功");
    }
    

    
    
    
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%@",[alertView buttonTitleAtIndex:buttonIndex]);
    NSLog(@"%ld",buttonIndex);
    switch (buttonIndex) {
            
        case 0:
            
            break;
            
        case 1:{
            if (idx==1){
                //选择视频文件
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    //把系统视频库调给picker用
                    _picker.mediaTypes= [[NSArray alloc] initWithObjects:(NSString*) kUTTypeMovie, (NSString*) kUTTypeVideo, nil];
                    [self presentViewController:_picker animated:YES completion:^{
                        
                    }];
                    
                    break;
                }
            }else if (idx==2){
                //选择音频文件
                MPMediaQuery *everything = [[MPMediaQuery alloc] init];
                NSLog(@"Logging items from a generic query...");
                NSArray *itemsFromGenericQuery = [everything items];
                for (MPMediaItem *song in itemsFromGenericQuery) {
                    NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
                    NSLog (@"%@", songTitle);
                }
                break;
            }else if (idx==3){
                //选择照片文件
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    //把系统照片库调给picker用
                    _picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    [self presentViewController:_picker animated:YES completion:^{
                        
                    }];
                    
                }
                
                break;
            }
            
        case 2:{
            if (idx==1) {
                [self addVideo];
                
                break;
            }else if (idx==2){
                
                break;
            }else if (idx==3){
                [self addCarema];
                
                break;
            }
            
            
        }
            
        }
    }
    
}





#pragma mark  附件描述信息
-(void)jsonAttachDescripemainType:(NSString *)mainType mainRecId:(NSString *)mainRecId fileTitle:(NSString *)fileTitle attachType:(NSString *)attachType tag:(long)tag{
        //    int i;
        NSMutableArray *modelArray = [NSMutableArray array];
        NSString *sql = [NSString stringWithFormat:@"select *from @t where groupId = %@",_attachGroupId];
        modelArray = [AttachGroupModels searchWithSQL:sql];
        ShareManager *shareManager = [ShareManager sharedManager];
        if (shareManager.dataArray.count > 0) {
            
            AttachModel *attachModel = (AttachModel *)shareManager.dataArray[(tag-1)/2];
            NSString *serveName;
            for (AttachGroupModels *model in modelArray) {
                NSLog(@"%d",[model.serveId intValue]);
                if ([model.serveId intValue] == tag && [model.groupId isEqualToString:_attachGroupId]) {
                    serveName = model.serveName;
                }
            }
            
            
            //请求数据示例
            NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
            NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
            NSString *fileType = attachModel.fileType?attachModel.fileType:@"";
            fileType = @"0";
            NSString *fileName = attachModel.imgName?attachModel.imgName:@"";
            NSString *attachSpec = attachModel.imgDetails?attachModel.imgDetails:@"";
            NSString *attachGroupId = _attachGroupId;
            NSLog(@"1%@   2%@   3%@   4%@  5%@ ",fileType,fileName,attachSpec,serveName,attachGroupId);
            
            NSDictionary *params = @{@"mainType":@"0",//随附件类型变化
                                     @"mainRecId":@"123456",
                                     @"attachSpec":attachSpec,
                                     @"fileTitle":@"ceshi",
                                     @"attachType":@"5",
                                     @"fileType":fileType,
                                     @"fileName":fileName,
                                     @"attachGroupId":attachGroupId,//随附件类型变化
                                     @"tableName":@"123",
                                     @"serverSavedFileName":serveName};
            
            NSString *modelName=@"FSMAttachUpload";
            NSString *methodName=@"FSMuploadAttachInfo";
            NSString *sessonId= sessionId;
            
            NSString *sopeStr=
            [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
            //            NSLog(@"sopeStr:%@",sopeStr);
            
            //            [MBProgressHUD showMessage:@"正在请求数据"];
            //异步请求
            NSDictionary *dic =  [[SoapService shareInstance]PostSync:sopeStr];
            if ([dic[@"retCode"] isEqual:@0]) {
                count ++;
                //                    [MBProgressHUD showSuccess:@"数据请求成功"];
                
                //
                
            }else if ([dic[@"retCode"] isEqual:@(-1)]){
                
                [MBProgressHUD showError:@"附件信息上传失败"];
                
            }else if ([dic[@"retCode"] isEqual:@(-2)]){
                
                
                [MBProgressHUD showError:@"附件信息上传超时"];
                
                
            }
        }
        
        
    }
#pragma -mark- 反馈的内容
    -(void)jsonInfowoId:(NSString *)woId{
        
        //请求数据示例
        ShareManager *shareManager = [ShareManager sharedManager];
        NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
        NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
        NSDate *now = [NSDate date];
        NSString *nowStr = [NSString stringWithFormat:@"%@",now];
        NSString *userId = [defaulsts objectForKey:@"username"];
        shareManager.titleText = shareManager.titleText?shareManager.titleText:@"";
        NSDictionary *params = @{@"userId":userId,
                                 @"woId":woId?woId:@"0",//随附件类型变化
                                 @"feedBackRemark":shareManager.titleText,//阶段反馈的内容
                                 @"time":nowStr,
                                 @"operMBPS":@"阶段性反馈"};
        
        NSString *modelName=@"FSMworkOrder";
        NSString *methodName=@"FSMPostAttachInfo";
        NSString *sessonId= sessionId;
        
        NSString *sopeStr=
        [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
        NSLog(@"sopeStr:%@",sopeStr);
        
        //    [MBProgressHUD showMessage:@"正在请求数据"];
        //异步请求
        NSDictionary *dic = [[SoapService shareInstance]PostSync:sopeStr];
        _attachGroupId = [dic valueForKey:@"attachGroupId"];
    }
    
    
    
#pragma -mark- 监测网络
- (void)reachability
{
    // 检测网络连接状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 连接状态回调处理
    /* AFNetworking的Block内使用self须改为weakSelf, 避免循环强引用, 无法释放 */
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         switch (status)
         {
             case AFNetworkReachabilityStatusUnknown:
                 // 回调处理
                 isWifi = NO;
                 break;
             case AFNetworkReachabilityStatusNotReachable:
                 // 回调处理
                 isWifi = NO;
                 break;
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 // 回调处理
                 isWifi = NO;
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 // 回调处理
                 isWifi = YES;
                 break;
             default:
                 break;
         }
     }];
}
#pragma -mark- tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AttachTableViewCell *cell = [AttachTableViewCell cellWithTableView:tableView];
    AttachModel *attach = (AttachModel *)self.dataArray[indexPath.row];
    cell.fileNameText.text = attach.imgName;
    cell.detailText.text = attach.imgDetails;
    cell.deleteBtn.tag = indexPath.row;
    //    NSLog(@"indexrow:%ld",(long)indexPath.row);
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

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
#pragma -mark- 删除按钮方法添加
-(void)deleteBtnClick:(UIButton *)sender{
    
    [AttachModel deleteToDB:(AttachModel *)self.dataArray[sender.tag]];
    ShareManager *shareManager = [ShareManager sharedManager];
    [shareManager.attachDataMutableArray removeObject:shareManager.attachDataMutableArray[sender.tag]];
    [self viewWillAppear:YES];
    
}
#pragma -mark- socket delegate
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    //    [clientSocket readDataWithTimeout:-1 tag:0];
    //    [clientSocket readDataWithTimeout:-1 tag:1];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"Error:%@",err);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSString *msg = @"Sorry this connect is failure";
    NSLog(@"%@",msg);
    clientSocket = nil;
    if (i == self.dataArray.count) {
        [[[UIApplication sharedApplication].windows lastObject] makeToast:@"反馈成功"];
        
        
    }
}

- (void)onSocketDidSecure:(AsyncSocket *)sock
{
    
}

// 接收到数据（可以通过tag区分）
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    ShareManager *shareManager = [ShareManager sharedManager];
    NSData *infoData = (NSData *)shareManager.attachDataMutableArray[i];
    if (isConnected) {
        [clientSocket writeData:infoData withTimeout:-1 tag:2*i+1];
        i++;
    }
    
    
}
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
    if ((tag % 2) == 1) {
        [self jsonAttachDescripemainType:@"0" mainRecId:@"123456" fileTitle:@"ceshi" attachType:@"5" tag:tag];
        if (i == self.dataArray.count) {
            [clientSocket disconnect];
            clientSocket = nil;
            clientSocket.delegate = nil;
            return;
        }
        ShareManager *shareManager = [ShareManager sharedManager];
        NSData *infoData = (NSData *)shareManager.attachDataMutableArray[i];
        
        NSDate *now = [NSDate date];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];
        NSString * serverSavedFileNames = [NSString stringWithFormat:@"%@.jpg",timeSp];
        //        serverSavedFileName = serverSavedFileNames;
        
        AttachGroupModels *attachGroupModels = [[AttachGroupModels alloc]init];
        attachGroupModels.groupId = _attachGroupId;
        attachGroupModels.serveId = [NSString stringWithFormat:@"%d",2*i+1];
        attachGroupModels.serveName = serverSavedFileNames;
        [attachGroupModels saveToDB];
        NSString *header = [NSString stringWithFormat:@"Content-Length=%lu;filename=%@;sourceid=%@"
                            ,infoData.length,serverSavedFileNames,@""];
        
        NSString * content = [header stringByAppendingString:@"\r\n"];
        NSLog(@"%@",content);
        NSData *dataFinal = [content dataUsingEncoding:NSUTF8StringEncoding];
        [clientSocket disconnect];
        clientSocket = nil;
        clientSocket.delegate = nil;
        if([self connectServer:HOST_IP port:HOST_PORT]){
            [clientSocket writeData:dataFinal withTimeout:-1 tag:2*i];
            [clientSocket readDataWithTimeout:-1 tag:2*i+1];
        }
        
    }
    
}


@end
