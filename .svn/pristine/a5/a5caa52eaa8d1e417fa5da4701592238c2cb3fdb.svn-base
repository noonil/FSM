//
//  mediaViewController.m
//  Ericsson
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "mediaViewController.h"
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
@interface mediaViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,AsyncSocketDelegate,NSStreamDelegate>{
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
//    NSString *serverSavedFileName;
}

#define SRV_CONNECTED 2
#define SRV_CONNECT_SUC 1
#define SRV_CONNECT_FAIL 0
#define HOST_IP @"121.28.82.70"
#define HOST_PORT 7979
@property (weak, nonatomic) IBOutlet UITableView *tableview;


@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *canceldataArray;
@property (nonatomic,strong)UIImagePickerController *picker;
@property(nonatomic,strong)NSMutableArray *attachDataMutableArray;

@end

static NSString *btn1;
static NSString *btn2;
static int idx;
// static int i;


@implementation mediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.navigationTitle;
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
    
//    clientSocket = [[AsyncSocket alloc]init];
//    clientSocket.delegate = self;
//    [self connectServer:HOST_IP port:HOST_PORT];
  
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

//-(void)readStream{
//    char buffer[1024];
//    int hasRead;
//    //循环读取
//    hasRead = recv(CFSocketGetNative(_socket), buffer, sizeof(buffer), 0);
//
//    while (hasRead) {
//        NSLog(@"hasread:%d",hasRead);
//        perror(buffer);
//        NSLog(@"readStream:%@",[[NSString alloc]initWithBytes:buffer length:hasRead encoding:NSUTF8StringEncoding]);
//    }
//
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent; 
    ShareManager *shareManager = [ShareManager sharedManager];
    self.titleLabel.text = shareManager.titleText;
    self.dataArray = [AttachModel searchWithWhere:nil orderBy:nil offset:0 count:100];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)chooseimage{
    idx=3;
    btn1=@"拍照";
    btn2=@"选择图片";
    [self alert];

}
-(void)chooseSound{
    idx=2;
    btn1=@"录音";
    btn2=@"选择音频文件";
    [self alert];

}
-(void)chooseVido{
    idx=1;
    btn1=@"录像";
    btn2=@"选择视频文件";
    [self alert];


}

- (IBAction)vido:(id)sender {
    idx=1;
    btn1=@"录像";
    btn2=@"选择视频文件";
    [self alert];

}
- (IBAction)sound:(id)sender {
    idx=2;
    btn1=@"录音";
    btn2=@"选择音频文件";
    [self alert];
    
}
- (IBAction)image:(id)sender {
    idx=3;
    btn1=@"拍照";
    btn2=@"选择图片";
    [self alert];
    
}
- (IBAction)editBtnClick:(id)sender {
    MediaTitleViewController *mediaTitleVC = [[MediaTitleViewController alloc]init];
    [self.navigationController pushViewController:mediaTitleVC animated:YES];
    
    
    
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


-(void)alert{
    alert=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:btn2, nil];
    [alert addButtonWithTitle:btn1];
    alert.delegate=self;//绑定
    [alert show];


}


// 触发事件－调用相机
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

//触发事件：录像
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
            attachment.infoFileName = _FileName;
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
#pragma mark  请求反馈内容
- (IBAction)uploadBtnClick:(id)sender {
   isConnected = [self connectServer:HOST_IP port:HOST_PORT];
    
    [self jsonInfowoId:self.woId];
    if (_attachGroupId) {
        [self socketImg];
    }else{
        [self.view makeToast:@"反馈失败"];
    }
    
    
  


//
 
//用socket上传附件
//-(void)socket{
////    ShareManager *shareManager = [ShareManager sharedManager];
//    if (isONLINE) {
//        
//        for (int i =0 ; i <self.dataArray.count; i++) {
//            
//            
//            NSData *infoData = (NSData *)self.dataArray[i];
//            const char *data=[infoData bytes];
//            send(CFSocketGetNative(_socket), data, strlen(data), 0);
//            [self.dataArray removeObject:self.dataArray[i]];
//            NSLog(@"发送成功");
//        }
//        
//        [self.dataArray removeAllObjects];
//        [LKDBHelper clearTableData:[AttachModel class]];//删除数据库里的数据
//        
//        
//    }else{
//        NSLog(@"未连接服务器");
//    }
//
//
}
-(void)socketImg{
      i = 0;
//    for ( i =0 ; i <self.dataArray.count; i++) {
    
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
           
//            [clientSocket disconnect];
//            clientSocket = nil;
      
            //                NSLog(@"%@",infoData);
        }else{
            NSLog(@"socket连接失败");
        }
        
        
        //            const char *headerdata=[header UTF8String];
        //            send(CFSocketGetNative(_socket), headerdata, strlen(headerdata), 0);
        //            [self.dataArray removeObject:self.dataArray[i]];
        NSLog(@"发送成功");
//    }
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
            NSLog(@"%ld",[model.serveId intValue]);
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
    //    if (count == self.dataArray.count) {
    //        dispatch_async(dispatch_get_main_queue(), ^(void){
    ////            [self.dataArray removeAllObjects];
    //            [MBProgressHUD showSuccess:@"附件上传成功"];
    ////            [LKDBHelper clearTableData:[AttachModel class]];//删除数据库里的数据
    //        });
    //    }
    
    
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
                             @"woId":woId?woId:@"3398186",//随附件类型变化
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
        [self.navigationController popViewControllerAnimated:YES];

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

