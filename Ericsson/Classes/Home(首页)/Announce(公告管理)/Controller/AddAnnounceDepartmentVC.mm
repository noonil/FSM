//
//  AddAnnounceDepartmentVC.m
//  Ericsson
//
//  Created by Min on 15/12/28.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "AddAnnounceDepartmentVC.h"
#import "AddAnnounceSectionView.h"
#import "AddAnnounceTableViewCell.h"

@interface AddAnnounceDepartmentVC () <UITableViewDataSource,UITableViewDelegate,AddAnnounceSectionViewDelegate,AddAnnounceTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray * orgArray;
/** 数据源子部门 */
@property (nonatomic,strong) NSMutableArray * departArray;
/** 标记section是否展开*/
@property (nonatomic,assign) NSInteger isFold;


@end

static int idx1=0;
static int idx2=0;
static int idx3=0;


@implementation AddAnnounceDepartmentVC
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择组织";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化
    if (!self.selectedCell) {
        self.selectedCell = [[NSIndexPath alloc]init];
    }
    // 下面加1000,这边进行判断是 编辑的时候 上一次是否有值在里面
    if (self.selectedSection >999 && self.selectedSection <1999) {
        self.selectedSection -= 1000;
    }else{
        self.selectedSection = NSNotFound;
    }


    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    NSArray * dataSource =@[@{@"海口片区":@[@"基站清秀(府城)",@"基站清秀(府城)",@"基站清秀(龙华)",@"基站抢修(秀英)"]},
                            @{@"三亚片区":@[@"室分抢修(三亚1)",@"基站抢修(河东组)",@"基站抢修(河西组)",@"基站抢修(西线组)"]},
                            @{@"五指山片区":@[@"基站抢修(五指山)"]}
                            ];
    _orgArray = [NSMutableArray arrayWithArray:dataSource];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 确认选择 */
- (IBAction)chooseBtn:(id)sender {
    // 判断是否有选择
    /*
    if (如果没有选择cell) {
        if (有选择section) {
            
            返回section
        }else { // 没有返回setion
          提示需要选择
            return 0;
        }
    }else { // 选择的是cell
     直接返回cell
    }
    */
    NSString * departName;
    if (self.selectedCell.length == 0) {
        if (self.selectedSection != NSNotFound) {
            // 返回这个section中的数据
            departName = [[_orgArray[self.selectedSection] allKeys] lastObject];
        }else{
            // 弹出一个提示框
//            [self displayAlertLabel:@"请选择公告发布范围"];
            [self.view makeToast:@"请选择公告发布范围"];
            return ;
        }
    }else { // 选择的是cell
        // 返回cell中的数据
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:_orgArray[self.selectedCell.section]];
        NSString * org = [[dic allKeys]lastObject];
        departName = [dic valueForKey:org][self.selectedCell.row];
    }
    
    // 这边可以获得，点击cell的indexPath。通过代理进行传值  需要传递:self.selectedCell（NSIndexPath）selectedSection (NSInteger)
    if ([self.delegate respondsToSelector:@selector(submitDepartmentSelected:indexPath:integer:)]) {
        if (self.selectedSection != NSNotFound) {
            self.selectedSection += 1000;
        }
        [self.delegate submitDepartmentSelected:departName indexPath:self.selectedCell integer:(self.selectedSection)];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return _orgArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSArray * array;
    
    if (section==0) {
        if (idx1%2==1) {
            array = _orgArray[section][@"海口片区"];
            return array.count;
        }else{
            
            return 0;
        }
    }
    if (section==1) {
        if (idx2%2==1) {
            array = _orgArray[section][@"三亚片区"];
            return array.count;
        }else{
            
            return 0;
        }
    }
    if (section==2) {
        if (idx3%2==1) {
            array = _orgArray[section][@"五指山片区"];
            return array.count;
        }else{
            
            return 0;
        }
    }
    
    return 0;
}

// UITableView cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddAnnounceTableViewCell * cell = [AddAnnounceTableViewCell cellWithTableView:tableView];
    
    /**==========================================
     ============================================*/
    cell.delegate = self;
    
    if (self.selectedCell == indexPath && self.selectedSection == NSNotFound) { // 如果点击的是cell，获取到对应的indexPath并且把 selectedSection的值改为无限大
        
        cell.isSelectedBtn.selected = YES;
    }
    
    if (indexPath.section == 0) {
        cell.departName.text = _orgArray[indexPath.section][@"海口片区"][indexPath.row];
        
    }else if (indexPath.section == 1) {
        cell.departName.text = _orgArray[indexPath.section][@"三亚片区"][indexPath.row];
        
    }else {
    
        cell.departName.text = _orgArray[indexPath.section][@"五指山片区"][indexPath.row];
    }
    return cell;
}

// 定义头标题的视图，添加点击事件
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AddAnnounceSectionView * sectionView = [AddAnnounceSectionView SectionHeaderView];
    
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:_orgArray[section]];
    sectionView.orgNameLabel.text = [dic.allKeys lastObject];
    
    sectionView.section = section;
    
    sectionView.delegate = self;
    
    // 设置section上按钮的图片
    if (self.selectedSection == section) {
        sectionView.isSelectedBtn.selected = YES;
    }
    // 设置section是否展开
    if (section == 0) {
        if (idx1%2==1) {
            sectionView.isFoldBtn.selected = YES;
        }
    }
    
    if (section ==1) {

        if (idx2%2==1) {
            sectionView.isFoldBtn.selected = YES;
        }
    }
    
    if (section ==2) {
        
        if (idx3%2==1) {
            sectionView.isFoldBtn.selected = YES;
        }
    }

    return  sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

// 点击cell设置 是否选中图片
- (void)setupSelectedBtnImage:(NSIndexPath *)indexPath
{
        self.selectedCell = indexPath;
        [self.tableView reloadData];
}

#pragma mark - delegate section中的加号减号的  按钮事件
- (void)SectionHeaderBtnClick:(NSInteger)section
{
    //切换展开收缩
    if (section == 0) {
        idx1++;
        if (idx1%2==1) {
            [self.tableView reloadData];
        }else{
            [self.tableView reloadData];
        }
        
    }
    if (section ==1) {
        idx2++;
        if (idx2%2==1) {
            [self.tableView reloadData];
        }else{
            [self.tableView reloadData];
        }
    }
    if (section ==2) {
        idx3++;
        if (idx3%2==1) {
            [self.tableView reloadData];
        }else{
            [self.tableView reloadData];
        }
    }
}
// cell中的代理方法
- (void)chooseBtnClick:(AddAnnounceTableViewCell *)cell
{
    NSIndexPath * indexPath = [_tableView indexPathForCell:cell];
    self.selectedSection = NSNotFound; // 点击cell，把section的标记置为NSNotFound
    self.selectedCell = indexPath;
    // 设置图片
    [self setupSelectedBtnImage:indexPath];
}
// 修改section上面图片
- (void)changeSectionSelectedBtn:(NSInteger)section
{
    self.selectedSection = section;
    [self.tableView reloadData];
}


@end
//
//#pragma mark - Tabel View data source
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//   return _orgArray.count;
//}
//
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    AddAnnounceDepartCell * cell;
//    static NSString *ID = @"departCell";
//    cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        NSArray * array = [[NSBundle mainBundle]loadNibNamed:@"AddAnnounceDepartCell" owner:self options:nil];
//        cell = array[0];
//        cell.delagate = self;
//        // 设置cell点击无任何效果和背景色
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    UIButton * btn = (UIButton *)[cell viewWithTag:11];
//    btn.tag = indexPath.row;
//    [btn addTarget:self action:@selector(foldTableView:) forControlEvents:UIControlEventTouchUpInside];
//
//    DepartModel * child = _orgArray[indexPath.row];
//    cell.label.text = child.departName;
//    // 该组下面的部门
//    cell.departArray = child.children;
//    return cell;
//}
//
//- (void)foldTableView:(UIButton*)button
//{
//
////    button.selected = !button.selected;
//    DepartModel * child = _orgArray[button.tag];
//
//    // 是否展开
//    child.unfold = !child.unfold;
////    button.selected = child.unfold;
////    [button setImage:[UIImage imageNamed:@"add_resource"] forState:UIControlStateNormal];
////
////    NSLog(@"selected-%d",button.selected);
////    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView reloadData];
//
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//{
//    DepartModel * child = _orgArray[indexPath.row];
//
//    if (child.unfold) {
//        return child.children.count * 60 + 60 + 5;
//    }
//    return  60 + 5;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    DepartModel * child = _orgArray[indexPath.row];
////
////    // 是否展开
////    child.unfold = !child.unfold;
////
////    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//
////    // 设置图片
//    AddAnnounceDepartCell * cell = (AddAnnounceDepartCell*)[tableView cellForRowAtIndexPath:indexPath];
//    [cell changeBtnImage:indexPath.row];
//
//
//    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//}
//

/*// 动画展示
- (void)displayAlertLabel:(NSString*)str
{
    UIWindow * window = [[UIApplication sharedApplication].windows lastObject];
    // 弹出提示框
    UILabel * label = [[UILabel alloc]init];
    
    label.x = (window.width / 2) - 100;
    label.y = window.height - 150;
    label.width = 200;
    label.height = 50;
    
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = str;
    [window addSubview:label];
    
    [UIView animateKeyframesWithDuration:1 delay:1 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        label.alpha = 0;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
}*/