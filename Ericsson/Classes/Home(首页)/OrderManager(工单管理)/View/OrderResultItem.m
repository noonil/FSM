//
//  OrderResultItem.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/7.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "OrderResultItem.h"

@implementation OrderResultItem

+(instancetype)itemWithHandleType:(NSString *)type HandelBtnSelected:(BOOL)selected NormalImage:(NSString *)normalImage SelectedImage:(NSString *)selectedImage
{
    OrderResultItem *item = [[[NSBundle mainBundle] loadNibNamed:@"OrderResultItem" owner:nil options:nil] lastObject];
    item.handleType.text = type;
    
    item.handleBtn.selected = selected;
    [item.handleBtn setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [item.handleBtn setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];

    return item;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.handleType.textColor = [UIColor blueColor];
}

//-(void)setup
//{
//    [[[NSBundle mainBundle] loadNibNamed:@"OrderResultItem" owner:self options:nil] lastObject];
//    [self addSubview:self.view];
//    
//}

- (IBAction)handleClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(OrderResultItemClick:)]) {
        [self.delegate OrderResultItemClick:sender];
    }
}
@end
