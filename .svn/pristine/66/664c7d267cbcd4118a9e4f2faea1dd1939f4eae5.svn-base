//
//  XJDetailViewController.m
//  Ericsson
//
//  Created by Slark on 16/1/12.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "XJDetailViewController.h"
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

@interface XJDetailViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,AsyncSocketDelegate,NSStreamDelegate>{
    
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
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *canceldataArray;
@property (nonatomic,strong)UIImagePickerController *picker;
@property(nonatomic,strong)NSMutableArray *attachDataMutableArray;
@end

static NSString *btn1;
static NSString *btn2;
static int idx;
@implementation XJDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阶段反馈详情";
    
    
    self.leftLabel.text = self.str;
    
    if (!self.mark) {
        
        self.backTextField.text = self.firstStr;
    }else{
    
    self.backTextField.text = self.mark;
    }
    count = 0;
    isConnected = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goXJDetail:) name:@"goToMediaVCNotification" object:nil];
    ShareManager *shareManager = [ShareManager sharedManager];
    [LKDBHelper clearTableData:[AttachModel class]];
    
    shareManager.titleText = @"";
   
    _picker=[[UIImagePickerController alloc]init];
   
    //设置委托
    _picker.delegate=self;
    self.tableview.delegate = self;
    self.tableview.dataSource =self;
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
  //  self.titleLabel.text = shareManager.titleText;
    self.dataArray = [AttachModel searchWithWhere:nil orderBy:nil offset:0 count:100];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview reloadData];
    
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



- (IBAction)imageClick:(id)sender {
    idx=3;
    btn1=@"拍照";
    btn2=@"选择图片";
    [self alert];
    
    
    
}

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
//点击Cancel按钮后执行方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)goXJDetail:(NSNotification *)notify{
    
    [self imagePickerControllerDidCancel:_picker];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



- (IBAction)goBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark
- (IBAction)completeClick:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.delegate giveBackStr:self.backTextField.text];
    
    

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


@end
