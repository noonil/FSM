//
//  feeDetailTableViewCell.m
//  Ericsson
//
//  Created by Slark on 16/1/12.
//  Copyright © 2016年 范传斌. All rights reserved.
//
#import "feeDetailTableViewCell.h"

@implementation feeDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.textView.delegate = self;
    if (![self.textView.text isEqualToString:@""]) {
        self.placehoderLabel.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""]) {
        _placehoderLabel.hidden = YES;
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        _placehoderLabel.hidden = NO;
    }
    
    return YES;
}

- (IBAction)comclick:(id)sender {
}

- (IBAction)chooseImage:(id)sender {
}

@end
