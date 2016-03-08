//
//  GatherSearchViewController.m
//  Ericsson
//
//  Created by xuming on 16/2/18.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "GatherSearchViewController.h"
#import "SearchCell.h"
#import "PopupObjectList.h"
#import "GatherObjectType.h"
#import "ConsumableVerdor.h"
#import "GatherViewController.h"


@interface GatherSearchViewController ()<SearchCellDelegate,PopupObjectListDelegate>
{
    PopupObjectList *pop;
    NSMutableArray * gatherObjectShortArray;//采集对象，id短的那个
    NSMutableArray * gatherObjectShortNameArray;//采集对象名称，id短的那个
    NSMutableArray * gatherObjectLongArray;//采集对象，id长的那个
    NSMutableArray * gatherObjectLongNameArray;//采集对象名称，id长的那个
    
    SearchCell *cell1;
    SearchCell *cell2;
    

}


@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)GatherButton_TouchDown:(id)sender;

@end

@implementation GatherSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"网络资源采集";
    [self loadFromDb];
    [self setOthers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadFromDb{
    
    gatherObjectShortArray=[NSMutableArray new];
    gatherObjectShortNameArray=[NSMutableArray new];
    
    NSMutableArray * arr=[[MyLKDBHelper getUsingLKDBHelper]searchWithSQL:@"select * from @t where  length(maintenanceTypeId)=9 " toClass:[GatherObjectType class]];
    for (int i=0; i<arr.count; i++) {
        GatherObjectType *model=(GatherObjectType *)arr[i];
        [gatherObjectShortArray addObject:model];
        [gatherObjectShortNameArray addObject:model.maintenanceTypeName];
    }
    
}

-(void)setOthers{
    _tableView.allowsSelection=NO;
    _tableView.scrollEnabled=NO;
    

}

#pragma mark -table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCell *cell=[SearchCell cellWithTableView:tableView];
    
    cell.delegate=self;
    cell.indexPath=indexPath;
    
    if (indexPath.row==0 ) {
        cell.label.text=@"资源采集类型:";
        cell1=cell;
    }
    else if (indexPath.row==1) {
        cell.label.text=@"资源采集名称:";
        cell2=cell;
    }
    

    return cell;
    
}



#pragma mark - search cell delegate
-(void)searchCellEditDidBegin:(NSIndexPath *)indexPath  searchCell:(SearchCell *)cell{
    
    
    if (indexPath.row==0) {
        cell2.textField.text=@"";
        
        pop=[[PopupObjectList alloc]initWithData:gatherObjectShortNameArray selectedData:cell.textField.text fromWhichObject:cell];
        pop.delegate=self;
        [pop presentPopupControllerAnimated];
    }
    else if (indexPath.row==1) {
        
        NSString * gatherObjectTypeName=cell1.textField.text;
        NSString *gatherObjectTypeId=nil;
        
        //查找gatherObjectTypeName对应的id
        for (int i=0; i<gatherObjectShortArray.count; i++) {
            GatherObjectType *model=gatherObjectShortArray[i];
            if ([gatherObjectTypeName isEqualToString:model.maintenanceTypeName]) {
                gatherObjectTypeId=model.maintenanceTypeId;
                break;
            }
        }
        
        NSString *str=[NSString stringWithFormat:@"select * from @t where maintenanceTypeId like '%@%%'  and maintenanceTypeId !='%@' ",gatherObjectTypeId,gatherObjectTypeId];
        
        NSMutableArray *arr=[[MyLKDBHelper getUsingLKDBHelper]searchWithSQL:str toClass:[GatherObjectType class]];
        
        
        //释放掉原来的空间
        gatherObjectLongArray=nil;
        gatherObjectLongNameArray=nil;
        
        gatherObjectLongArray=[NSMutableArray new];
        gatherObjectLongNameArray=[NSMutableArray new];
        
        for (int i=0; i<arr.count; i++) {
            GatherObjectType *model=(GatherObjectType *)arr[i];
            [gatherObjectLongArray addObject:model];
            [gatherObjectLongNameArray addObject:model.maintenanceTypeName];
        }
        
        pop=[[PopupObjectList alloc]initWithData:gatherObjectLongNameArray selectedData:cell.textField.text fromWhichObject:cell];
        pop.delegate=self;
        [pop presentPopupControllerAnimated];
    }
    
    
    
}

#pragma mark -PopupObjectListDelegate

-(void)popupObjectListDidSelectRowAtIndexPath:(NSString *)selectedData fromWhichObject:(id)fromWhichObject row:(NSInteger)row{
    SearchCell *cell=(SearchCell *)fromWhichObject;
    cell.textField.text=selectedData;
    
}

- (IBAction)GatherButton_TouchDown:(id)sender {
    //查找gatherObjectTypeName对应的id
    NSString *gatherObjectTypeName=cell2.textField.text;
    NSString *gatherObjectTypeId;

    
    for (int i=0; i<gatherObjectLongArray.count; i++) {
        GatherObjectType *model=gatherObjectLongArray[i];
        if ([gatherObjectTypeName isEqualToString:model.maintenanceTypeName]) {
            gatherObjectTypeId=model.maintenanceTypeId;
            break;
        }
    }
    
    GatherViewController *vc=[[GatherViewController alloc]init];
    vc.resType=gatherObjectTypeName;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -get/set

@end
