//
//  ResourceAddViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/9.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ResourceAddViewController.h"
#import "HeaderView.h"
#import "ResourceDetailViewController.h"
#import "ContactOrderViewCell.h"
#import "FSMResourceType.h"

@interface ResourceAddViewController ()<UITableViewDelegate,UITableViewDataSource,ContactOrderCellClickDelegate>
@property (nonatomic,strong)NSMutableArray *resourceTypes;
@property (nonatomic,strong)NSIndexPath *selectedIndexpath;

- (IBAction)endInputCode:(id)sender;

@end

@implementation ResourceAddViewController

-(NSMutableArray *)resourceTypes{
    if (!_resourceTypes) {
        _resourceTypes = [[NSMutableArray alloc] init];
    }
    return _resourceTypes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    [self setOthers];
    
}

-(void)setOthers{
    self.title = @"资源添加";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Do any additional setup after loading the view from its nib.
    //初始化resourceCategory头视图
    self.ResourceCategory.imageView.image = [UIImage imageNamed:@"spare_search"];
    self.ResourceCategory.title.text = @"资源类型";
    
    //初始化searchCode头视图
    self.SearchCode.imageView.image = [UIImage imageNamed:@"spare_search"];
    self.SearchCode.title.text = @"编号";
    
    
    self.searchBtn.backgroundColor = [UIColor colorWithRed:97/255.0 green:162/255.0 blue:210/255.0 alpha:1.0];
    
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    
    self.codeField.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    
    self.resourceTypes = [self queryResourceTypes];
    
    //处理提交按钮位置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notice_number.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    
    [[self navigationItem] setLeftBarButtonItem:leftItem];
}

-(void)back{
    if (self.handlingOrderDetail!=nil) {
        _handlingOrderDetail.popButtonView.hidden=NO;
    }
    else if (self.handledOrderDetail!=nil) {
        _handledOrderDetail.popButtonView.hidden=NO;
    }

    
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)keyboardWillChange:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.view.y = keyboardRect.origin.y - self.view.size.height;
    //    NSLog(@"userInfo:%@",userInfo);
}

- (NSMutableArray *)queryResourceTypes{
    FMDatabase * db = [FMDatabase databaseWithPath:DBPATH];
    NSMutableArray *resourceTypes = [[NSMutableArray alloc] init];
    
    if ([db open]) {
        NSString * sql = @"select * from resTypes";
        FMResultSet * rs = [db executeQuery:sql];
        
        while ([rs next]) {
            FSMResourceType *resourceType = [[FSMResourceType alloc] init];
            
            resourceType.resourceTypeId = [rs stringForColumn:@"resourceTypeId"];
            resourceType.resourceTypeName = [rs stringForColumn:@"resourceTypeName"];
            [resourceTypes addObject:resourceType];
    
        }
        [db close];
    }
    return resourceTypes;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.resourceTypes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSMResourceType *resourceType = self.resourceTypes[indexPath.row];
    
    ContactOrderViewCell *cell = [ContactOrderViewCell cellWithTableView:tableView];
    
    cell.switchFlag = false;
    if (indexPath == self.selectedIndexpath) {
        [cell.doneBtn setImage:[UIImage imageNamed:@"dialog_choosed"] forState:UIControlStateNormal];
    }else{
        [cell.doneBtn setImage:[UIImage imageNamed:@"dialog_not_choose"] forState:UIControlStateNormal];
    }
    
    cell.orderName.text = resourceType.resourceTypeName;
    
    //设置cell尾部按钮相关处理
    cell.delegate = self;
    cell.tableView = tableView;
    cell.indexPath = indexPath;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexpath = indexPath;
    
    [self.tableView reloadData];
}

- (IBAction)searchClick:(id)sender {
    if (self.selectedIndexpath == nil) {
        [MBProgressHUD showError:@"请选择资源类型"];
        return;
    }
    
    ResourceDetailViewController *resourceList = [[ResourceDetailViewController alloc] initWithNibName:@"ResourceDetailViewController" bundle:nil];
    resourceList.SelectedResourceType = self.resourceTypes[self.selectedIndexpath.row];
    resourceList.resourceCode = self.codeField.text;
    [self.navigationController pushViewController:resourceList animated:YES];
}

#pragma mark - ContactOrderCellClickDelegate
-(void)CellChooseClickInTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexpath = indexPath;
    [self.tableView reloadData];
}

-(void)CellCancelClickInTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

//结束输入编号
- (IBAction)endInputCode:(id)sender {
    [self.view endEditing:YES];
}
@end
