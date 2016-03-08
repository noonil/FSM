//
//  OrderResourceViewCell.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/1.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "OrderResourceViewCell.h"
#import "WorkOrderResource.h"

@implementation OrderResourceViewCell
-(void)setResource:(WorkOrderResource *)resource{
    _resource = resource;
    self.resoureName.text = resource.resoureName;
    self.resourceNumber.text = resource.resourceNumber;
    self.Status.image = [UIImage imageNamed:[self iconNameWith:resource.use]];
}

- (NSString *)iconNameWith:(BOOL)use
{
    if (use) {
        return @"resource_take";
    }else
        return @"resource_release";
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"OrderResourceViewCell";
    OrderResourceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (OrderResourceViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"OrderResourceViewCell" owner:nil options:nil] lastObject];
    }
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
