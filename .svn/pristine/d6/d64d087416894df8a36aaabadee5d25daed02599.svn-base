//
//  PopupObjectList.h
//  Ericsson
//
//  Created by xuming on 15/11/30.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol PopupObjectListDelegate;

@interface PopupObjectList : NSObject
@property (nonatomic, weak) id <PopupObjectListDelegate> delegate;
-(instancetype)init;
/*
 dataArr 要显示的文本数组
 selectedData 要选中文本数组中得哪个值
 fromWhichObject 从哪个对象点过来的
 */
- (instancetype)initWithData:(NSMutableArray *)dataArr selectedData:(NSString *)selectedData fromWhichObject:( id)fromWhichObject;

- (void)presentPopupControllerAnimated ;
@end



@protocol PopupObjectListDelegate <NSObject>
@optional
- (void)popupObjectListWillPresent:(PopupObjectList *)controller;
- (void)popupObjectListDidPresent:(PopupObjectList *)controller;
- (void)popupObjectListWillDismiss:(PopupObjectList *)controller;
- (void)popupObjectListDidDismiss:(PopupObjectList *)controller;
- (void)popupObjectListDidSelectRowAtIndexPath:(NSString *)selectedData fromWhichObject:(id)fromWhichObject row:(NSInteger)row;




@end




