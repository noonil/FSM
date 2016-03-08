//
//  AlertInputView.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/9.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertInputViewDelegate <NSObject>

- (void)AlertViewFinishInput:(NSString *)content;

@end

@interface AlertInputView : UIView
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

@property (nonatomic,weak)id<AlertInputViewDelegate> delegate;

- (IBAction)commit:(UIButton *)sender;

@end
