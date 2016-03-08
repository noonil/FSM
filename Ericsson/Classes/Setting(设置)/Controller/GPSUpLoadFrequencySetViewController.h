//
//  GPSUpLoadFrequencySetViewController.h
//  Ericsson
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeaderView;

@interface GPSUpLoadFrequencySetViewController : BaseViewController
@property (weak, nonatomic) IBOutlet HeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIView *frequencyView;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UILabel *frequencytf;
//@property (weak, nonatomic) IBOutlet UITextField *frequencytf;


@end
