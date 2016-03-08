//
//  SearchViewController.m
//  Ericsson
//
//  Created by xuming on 15/12/15.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCell.h"
#import "PopupObjectList.h"
#import "MyLKDBHelper.h"
#import "SpareTypes.h"
#import "ConsumableVerdor.h"
#import "HandlingOrderDetailController.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,SearchCellDelegate,PopupObjectListDelegate,UIGestureRecognizerDelegate>
{
    PopupObjectList *pop;
    SearchCell *selectedCell;
    
    SearchCell *cell1;
    SearchCell *cell2;
    SearchCell *cell3;
    
    NSMutableArray * spareTypeNameArray;
    //NSMutableArray * spareFactoryArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSMutableArray * spareFactoryNameArray;

- (IBAction)search_TouchUpInside:(id)sender;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"耗材查询与申请";
    [self loadFromDb];
    [self setOthers];

}

-(void)loadFromDb{
    
    spareTypeNameArray=[NSMutableArray new];
    NSMutableArray * spareTypeArray=[[MyLKDBHelper getUsingLKDBHelper]searchWithSQL:@"select *from @t" toClass:[SpareTypes class]];
    for (int i=0; i<spareTypeArray.count; i++) {
        SpareTypes *model=(SpareTypes *)spareTypeArray[i];
        [spareTypeNameArray addObject:model.spareTypeName];
    }

}

-(void)setOthers{
    
    [self addTapGesture];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notice_number.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    
    [[self navigationItem] setLeftBarButtonItem:leftItem];
}


-(void)back{
//    [self.navigationController popViewControllerAnimated:YES];
//    if (_showButtonsBlock!=nil) {
//        _showButtonsBlock();
//    }
    
    
    if (self.handlingOrderDetail!=nil) {
        _handlingOrderDetail.popButtonView.hidden=NO;
    }
    else if (self.handledOrderDetail!=nil) {
        _handledOrderDetail.popButtonView.hidden=NO;
    }else if (self.handlingDetail != nil) {
        _handlingDetail.popButtonView.hidden = NO;
    }else if (self.completeDetail != nil){
        _completeDetail.popButtonView.hidden = NO;
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}



-(void)addTapGesture{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.view addGestureRecognizer:singleTap];
    singleTap.delegate = self;
}


-(void)handleSingleTap{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    SearchCell *cell=(SearchCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [cell.textField resignFirstResponder];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCell *cell=[SearchCell cellWithTableView:tableView];
    
    cell.delegate=self;
    cell.indexPath=indexPath;
    
    if (indexPath.row==0 ) {
        cell.textField_btn.hidden=NO;
        cell.label.text=@"所属专业:";
        cell1=cell;
    }
    else if (indexPath.row==1) {
        cell.textField_btn.hidden=NO;
        cell.label.text=@"厂商:";
        cell2=cell;
    }
    
    else if (indexPath.row==2) {
        cell.btn.hidden=YES;
        cell.label.text=@"耗材名称:";
        cell.textField_btn.hidden=YES;
        
        cell3=cell;
        
    }
    return cell;

}

#pragma mark - search cell delegate
-(void)searchCellEditDidBegin:(NSIndexPath *)indexPath  searchCell:(SearchCell *)cell{
    

    [cell3.textField resignFirstResponder];
 

    if (indexPath.row==0) {
        [cell.textField resignFirstResponder];
        cell2.textField.text=@"";
        
        pop=[[PopupObjectList alloc]initWithData:spareTypeNameArray selectedData:cell.textField.text fromWhichObject:cell];
        pop.delegate=self;
        [pop presentPopupControllerAnimated];
    }
    else if (indexPath.row==1) {
        [cell.textField resignFirstResponder];
        NSString * spareTypeStr=cell1.textField.text;
        NSMutableArray *arr=[[MyLKDBHelper getUsingLKDBHelper]searchWithSQL:[NSString stringWithFormat:@"select consumableVendor from @t where consumableType ='%@'",spareTypeStr] toClass:[ConsumableVerdor class]];
        
        [self.spareFactoryNameArray removeAllObjects];
        for (int i=0; i<arr.count; i++) {
            ConsumableVerdor *model=(ConsumableVerdor *)arr[i];
            [_spareFactoryNameArray addObject:model.consumableVendor];
        }
        
        pop=[[PopupObjectList alloc]initWithData:self.spareFactoryNameArray selectedData:cell.textField.text fromWhichObject:cell];
        pop.delegate=self;
        [pop presentPopupControllerAnimated];
    }
    


}

-(void)popupObjectListDidSelectRowAtIndexPath:(NSString *)selectedData fromWhichObject:(id)fromWhichObject row:(NSInteger)row{
    SearchCell *cell=(SearchCell *)fromWhichObject;
    cell.textField.text=selectedData;

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - search
- (IBAction)search_TouchUpInside:(id)sender {
    self.consumeList.vendor=cell2.textField.text;
    _consumeList.consumableName=cell3.textField.text;
    _consumeList.consuableType=cell1.textField.text;
    
    [self.navigationController pushViewController:_consumeList animated:YES];
}

#pragma mark -get/set
-(NSMutableArray *)spareFactoryNameArray{
    if (_spareFactoryNameArray ==nil) {
        _spareFactoryNameArray=[NSMutableArray new];
    }
    return _spareFactoryNameArray;

}

-(ConsumeList *)consumeList{
    if (_consumeList==nil) {
        _consumeList=[[ConsumeList alloc]init];
        
    }
    return _consumeList;

}
@end
