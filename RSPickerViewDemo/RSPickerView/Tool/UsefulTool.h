//
//  UsefulTool.h
//  RSPickerViewDemo
//
//  Created by MB6 on 2018/7/25.
//  Copyright © 2018年 Rebecca Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define Scale       UsefulTool.singleton.scale

#define BASE_BLANK_WIDTH          15 * Scale

#define PICKER_TEXT_FONT   [UIFont boldSystemFontOfSize:15 * Scale]

#define IsIPhoneX        ([UsefulTool singleton].deviceType == DeviceTypeX)

#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define ScreenWidth (IS_OS_8_OR_LATER ? (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height) : [UIScreen mainScreen].bounds.size.width)

#define ScreenHeight (IS_OS_8_OR_LATER ? (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width) : [UIScreen mainScreen].bounds.size.height)

typedef NS_ENUM(NSInteger, CurrentDeviceType) {
    DeviceTypeClassic = 0,
    DeviceType4Or4s,
    DeviceType5Or5sOr5cOrSE,
    DeviceType6Or6sOr7Or8,
    DeviceType6PlusOr6sPlus,
    DeviceType8,
    DeviceTypeX,
    DeviceTypeUnknown,
};

@interface UsefulTool : NSObject

/** SINGLETON */
+ (instancetype)singleton;

#pragma mark - Property

/** SCALE OF INTERFACE */
@property (nonatomic, readonly) CGFloat scale;

/** DEVICE TYPE */
@property (nonatomic, assign) CurrentDeviceType deviceType;

#pragma mark - Public

/** CALCULATE HEIGHT OF TEXT */
+ (CGRect)alterHeightByTextString:(NSString *)aTextString originalRect:(CGRect)aOriginalRect font:(UIFont *)aFont;


@end
