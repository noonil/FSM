//
//  AlertInputView.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/9.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "AlertInputView.h"

@interface AlertInputView ()<UITextViewDelegate, UIGestureRecognizerDelegate>

@end

@implementation AlertInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)commit:(UIButton *)sender {
    if (self.inputTextView.text.length <= 0) {
        NSLog(@"超时原因不能为空");
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(AlertViewFinishInput:)]) {
        [self.delegate AlertViewFinishInput:self.inputTextView.text];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
    self.inputTextView.delegate=self;
   // NSLog(@"awakeFromNib textView.frame=%@",NSStringFromCGRect(self.frame));

    [self addGesture];
}


//单击alertinputview隐藏键盘
-(void)addGesture{
    UITapGestureRecognizer* recognizer;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    recognizer.delegate=self;
    [self addGestureRecognizer:recognizer];
}


-(void)hideKeyboard{
    [self.inputTextView resignFirstResponder];
    //NSLog(@"hideKeyboard textView.frame=%@",NSStringFromCGRect(self.frame));


}

#pragma mark - text view delegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
//    NSLog(@"textViewDidBeginEditing textView.frame=%@",NSStringFromCGRect(self.frame));

}

-(void)textViewDidEndEditing:(UITextView *)textView{
    //NSLog(@"textViewDidEndEditing textView.frame=%@",NSStringFromCGRect(self.frame));

    self.center=CGPointMake(KIphoneWidth/2, KIphoneHeight/2);
    
}


@end
