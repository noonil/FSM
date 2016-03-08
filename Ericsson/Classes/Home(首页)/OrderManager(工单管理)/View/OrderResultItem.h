//
//  OrderResultItem.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/7.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderResultItemDelegate <NSObject>

-(void)OrderResultItemClick:(UIButton *)btn;

@end

@interface OrderResultItem : UIView

+(instancetype)itemWithHandleType:(NSString *)type HandelBtnSelected:(BOOL)selected NormalImage:(NSString *)normalImage SelectedImage:(NSString *)selectedImage;

@property (weak, nonatomic) IBOutlet UILabel *handleType;
@property (weak, nonatomic) IBOutlet UILabel *handleTypeValue;
@property (weak, nonatomic) IBOutlet UIButton *handleBtn;
@property (weak, nonatomic) IBOutlet UIView *seprator;

@property (nonatomic,weak)id<OrderResultItemDelegate> delegate;
- (IBAction)handleClick:(UIButton *)sender;

@end
