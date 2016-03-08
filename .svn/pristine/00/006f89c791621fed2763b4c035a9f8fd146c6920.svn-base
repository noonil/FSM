//
//  NetResourceSearchViewController.m
//  Ericsson
//
//  Created by xuming on 15/10/8.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "NetResourceSearchViewController.h"
#import "PopupObjectList.h"
#import "NetResourceListViewController.h"
#import "MBProgressHUD.h"
#import "MaintenanceObjectTypes.h"
#import "Organization.h"
#import "MatainObject.h"
#import "LKDBHelper.h"
#import "MaintenanceObjectTypes.h"
#import "ZCZBarViewController.h"
#import "NetResourceInfoViewController.h"

@interface NetResourceSearchViewController ()<PopupObjectListDelegate,MBProgressHUDDelegate,UIGestureRecognizerDelegate>
{
    PopupObjectList *pop;
    NSMutableArray *matainObjectArr;
    NSMutableArray *orgnizerArr;
    NSMutableArray *matainObjectNameArr;
    NSMutableArray *orgnizerNmaeArr;
    MaintenanceObjectTypes *selectedMOT;
    Organization *selectedOrganization;
    
    
}
@property(nonatomic, strong) UIView *popupView;
@property(nonatomic, strong) UIView *maskView;
@property (weak, nonatomic) IBOutlet UITextField *matainObjectType;//维护对象类型
@property (weak, nonatomic) IBOutlet UITextField *orgnizer;//组织机构
@property (weak, nonatomic) IBOutlet UITextField *matainObjectName;//维护对象名称


- (IBAction)selectMatainObject_TouchUpInside:(id)sender;
- (IBAction)selectOrgnizer_TouchUpInside:(id)sender;
- (IBAction)searchBtn_TouchUpInside:(id)sender;

@end

@implementation NetResourceSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setOthers];
    
    [self loadDataFromDB];
}
-(void)setOthers{
    self.title=@"网络资源查询与变更";
    
    selectedMOT=[[MaintenanceObjectTypes alloc]init];
    selectedOrganization=[[Organization alloc]init];
    
    [self addTapGesture];
    
}

#pragma mark -隐藏键盘
-(void)handleSingleTap{
    [_matainObjectName resignFirstResponder];
    
    
}


-(void)addTapGesture{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.view addGestureRecognizer:singleTap];
    singleTap.delegate = self;
}

-(void)loadDataFromDB{
    
    
    
    matainObjectArr = [[MyLKDBHelper getUsingLKDBHelper] searchWithSQL:@"select * from @t" toClass:[MaintenanceObjectTypes class]];
    
    matainObjectNameArr=[NSMutableArray new];
    for (int i=0; i<matainObjectArr.count; i++) {
        MaintenanceObjectTypes * model=matainObjectArr[i];
        [matainObjectNameArr addObject:model.maintenanceTypeName];
    }
    
    
    orgnizerArr = [[MyLKDBHelper getUsingLKDBHelper] searchWithSQL:@"select * from @t" toClass:[Organization class]];
    
    orgnizerNmaeArr=[NSMutableArray new];
    for (int i=0; i<orgnizerArr.count; i++) {
        Organization * model=orgnizerArr[i];
        [orgnizerNmaeArr addObject:model.orgName];
    }    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)selectMatainObject_TouchUpInside:(id)sender {
    
    
    pop=[[PopupObjectList alloc]initWithData:matainObjectNameArr selectedData:_matainObjectType.text fromWhichObject:_matainObjectType];
    
    
    pop.delegate=self;
    [pop presentPopupControllerAnimated];
    
    
}



- (IBAction)selectOrgnizer_TouchUpInside:(id)sender {
    
    pop=[[PopupObjectList alloc]initWithData:orgnizerNmaeArr selectedData:_matainObjectType.text fromWhichObject:_orgnizer];
    pop.delegate=self;
    [pop presentPopupControllerAnimated];
}

- (IBAction)searchBtn_TouchUpInside:(id)sender {
    
    
    NetResourceListViewController *list=[NetResourceListViewController new];
    MatainObject *model=[[MatainObject alloc]init];
    if (selectedMOT.maintenanceTypeId==nil ) {
        [MBProgressHUD showError:@"请选择维护对象类型"];
        return;
    }
    
    if (selectedOrganization.orgId==nil) {
        selectedOrganization.orgId=@"";
    }



    model.maintenanceObjectType=selectedMOT.maintenanceTypeId;
    model.orgId=selectedOrganization.orgId;
    model.maintenanceObjectName=_matainObjectName.text;
    model.maintenanceTypeName=selectedMOT.maintenanceTypeName;
    list.matainObject=model;
    [self.navigationController pushViewController:list animated:YES];
    
    
    
}




#pragma mark -request Data



#pragma mark - popupObjectList delegate

- (void)popupObjectListDidSelectRowAtIndexPath:(NSString *)selectedData fromWhichObject:(id)fromWhichObject row:(NSInteger)row{
    
    if (fromWhichObject==_matainObjectType) {
        selectedMOT=matainObjectArr[row];
        _matainObjectType.text=matainObjectNameArr[row];
        
    }
    else{
        selectedOrganization=orgnizerArr[row];
        _orgnizer.text=orgnizerNmaeArr[row];
    }
}
- (IBAction)scanBarCode:(id)sender {
    ZCZBarViewController * zbar = [[ZCZBarViewController alloc]initWithBlock:^(NSString * str, BOOL isSucceed) {
        
        if(isSucceed){
            // 扫描成功
            NSLog(@"ssss %@",str);
            MatainObject * model = [[MatainObject alloc]init];
            
            // tableName=RES_MOBILE_GSM&resource_code=SYW0464
            /*
           
             */
            if(str.length){
                NSRange firstLocation   = [str rangeOfString:@"="];
                NSRange andSymbol       = [str rangeOfString:@"&"];
                NSRange lastLocation    = [str rangeOfString:@"=" options:NSBackwardsSearch];
                
                if (firstLocation.length && andSymbol.length) {
                    NSRange typeStr;
                    typeStr.location    = firstLocation.location + 1;
                    typeStr.length      = andSymbol.location - firstLocation.location -1;
                    
                    NSString * objectName = [str substringWithRange:typeStr];
                    NSString * maintenanceId = [str substringFromIndex:lastLocation.location + 1];
                    
                    model.maintenanceId=maintenanceId;
                    model.maintenanceObjectName=objectName;
                    model.maintenanceObjectType = @"";
                    NetResourceInfoViewController *vc=[[NetResourceInfoViewController alloc]init];
                    vc.matainObject = model;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else{
                    [self.view makeToast:@"扫描到的格式不正确!"];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                
            }
            else{
                [self.view makeToast:@"无效的二维码!"];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }
        else{
            [self.view makeToast:@"扫描结束"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
    
    [self presentViewController:zbar animated:YES completion:nil];
    
}




@end
