//
//  ThreeLabelOneImgView.h
//  Ericsson
//
//  Created by xuming on 15/12/20.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThreeLabelOneImgViewDelegate <NSObject>
- (void)ThreeLabelOneImgViewClick:(NSInteger)section;

@end

@interface ThreeLabelOneImgView : UIView
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@property (nonatomic,assign)NSInteger section;
@property (nonatomic,weak)id<ThreeLabelOneImgViewDelegate> delegate;
- (IBAction)button_TouchDown:(id)sender;
+ (instancetype)threeLabelOneImgView;



@end
