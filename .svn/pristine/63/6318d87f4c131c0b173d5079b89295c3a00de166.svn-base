//
//  FeedBackAttachmentViewCell.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/1.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "FeedBackAttachmentViewCell.h"
#import "WorkOrderAttachFile.h"

@implementation FeedBackAttachmentViewCell

-(void)setAttachInfo:(WorkOrderAttachFile *)attachInfo{
    _attachInfo = attachInfo;
    self.typeImage.image = [UIImage imageNamed:[self iconNameWithType:attachInfo.type]];
    self.name.text = attachInfo.name;
    self.desc.text = attachInfo.desc;
}

- (NSString *)iconNameWithType:(NSString *)type{
    if ([type isEqualToString:@"0"]) {
        return @"attach_list_picture_type";
    }else if ([type isEqualToString:@"1"]){
        return @"attach_list_file_type";
    }else if ([type isEqualToString:@"2"]){
        return @"attach_list_audio_type";
    }else
        return @"attach_list_video_type";
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteAttachFile:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(FeedBackAttachmentDeleteClick:)]) {
        [self.delegate FeedBackAttachmentDeleteClick:self.indexPath];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FeedBackAttachmentViewCell";
    FeedBackAttachmentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (FeedBackAttachmentViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"FeedBackAttachmentViewCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
