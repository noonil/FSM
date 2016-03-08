//
//  OilMachineInfoCell.m
//  Ericsson
//
//  Created by 范传斌 on 15/11/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "OilMachineInfoCell.h"
#import "WorkOrderOilMachine.h"

@implementation OilMachineInfoCell

-(void)setOilMachineInfo:(WorkOrderOilMachine *)oilMachineInfo{
    _oilMachineInfo = oilMachineInfo;
    
    self.OilMachineID.text = oilMachineInfo.resSerial;
    self.OilMachineType.text = oilMachineInfo.oil_model;
    self.Owner.text = oilMachineInfo.vendor;
    self.OilMachinePower.text = oilMachineInfo.power;
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
    static NSString *ID = @"OilMachineInfoCell";
    OilMachineInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (OilMachineInfoCell *)[[[NSBundle mainBundle] loadNibNamed:@"OilMachineInfoCell" owner:nil options:nil] lastObject];
    }
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.OilMachineID.text = @"油机编号";
    cell.OilMachineType.text = @"油机型号";
    cell.Owner.text = @"厂家";
    cell.OilMachinePower.text = @"油机功率";
    return cell;
}
@end
