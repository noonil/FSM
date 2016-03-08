//
//  writeViewController.h
//  Ericsson
//
//  Created by Slark on 16/1/9.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol popdelegate <NSObject>

- (void)sendBackstring:(NSString *)str;

@end
@interface writeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *writeText;
@property (nonatomic,weak)id<popdelegate>delegate;

- (IBAction)commitClick:(id)sender;

@end
