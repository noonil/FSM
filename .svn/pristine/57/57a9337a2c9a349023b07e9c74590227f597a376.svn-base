//
//  addmessafeViewController.h
//  Ericsson
//
//  Created by Slark on 16/1/11.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendMessage <NSObject>

- (void)senbackMessage:(NSString *)str;

@end

@interface addmessafeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *addmessage;
@property (nonatomic,weak) id<sendMessage>delegate;
- (IBAction)commitClick:(id)sender;

@end
