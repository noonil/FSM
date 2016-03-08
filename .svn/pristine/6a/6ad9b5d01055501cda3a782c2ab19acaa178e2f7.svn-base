//
//  dealViewController.h
//  Ericsson
//
//  Created by Slark on 16/1/11.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol dealMessage <NSObject>

- (void)sendDealMessage:(NSString * )str;

@end

@interface dealViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *deal;

@property (nonatomic,weak) id<dealMessage>delegate;


@end
