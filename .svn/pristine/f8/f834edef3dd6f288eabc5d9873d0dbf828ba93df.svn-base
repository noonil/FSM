//
//  HelpObjectList.h
//  Ericsson
//
//  Created by admin on 15/12/9.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol HelpObjectListDelegate;
@interface HelpObjectList : NSObject
@property (nonatomic, weak) id <HelpObjectListDelegate> delegate;
@property (nonatomic,copy) NSString *name;
- (instancetype)initWithData:(NSMutableArray *)dataArr selectedData:(NSString *)selectedData selectedObject:( id)selectedObject;

- (void)presentPopupControllerAnimated ;
@end



@protocol HelpObjectListDelegate <NSObject>
@optional
- (void)popupObjectListWillPresent:(HelpObjectList *)controller;
- (void)popupObjectListDidPresent:(HelpObjectList *)controller;
- (void)popupObjectListWillDismiss:(HelpObjectList *)controller;
- (void)popupObjectListDidDismiss:(HelpObjectList *)controller;
- (void)popupObjectListDidSelectRowAtIndexPath:(NSString *)selectedData selectedObject:(id)selectedObject;


@end
