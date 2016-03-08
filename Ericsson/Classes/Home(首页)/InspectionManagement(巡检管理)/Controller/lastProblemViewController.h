//
//  lastProblemViewController.h
//  Ericsson
//
//  Created by Slark on 16/1/11.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol lastMessage <NSObject>;
- (void)sendlastMessage:(NSString*)str;



@end

@interface lastProblemViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *lastProblem;
@property (nonatomic,weak) id<lastMessage>delegate;
- (IBAction)commitClick:(id)sender;

@end
