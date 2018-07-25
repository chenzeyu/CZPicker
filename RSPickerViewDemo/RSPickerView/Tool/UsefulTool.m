//
//  UsefulTool.m
//  RSPickerViewDemo
//
//  Created by MB6 on 2018/7/25.
//  Copyright © 2018年 Rebecca Huang. All rights reserved.
//

#import "UsefulTool.h"

@implementation UsefulTool

/** SINGLETON */
+ (instancetype)singleton {
    static UsefulTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UsefulTool alloc] init];
    });
    return instance;
}

#pragma mark - Initialized

- (instancetype)init {
    if (self != [super init]) return nil;
    
    // SCALE OF INTERFACE

    //  Default SIZE：SE point 568 x 320
    CGSize designSize = CGSizeMake(320, 568);
    if (!UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
        designSize = CGSizeMake(569, 320);
    
    CGPoint scaling = CGPointMake(ScreenWidth / designSize.width,
                                  ScreenHeight / designSize.height);
//    _scale = scaling.x < scaling.y ? scaling.x : scaling.y;
    _scale = scaling.x;
    
    return self;
}

#pragma mark - Public

/** CALCULATE HEIGHT OF TEXT */
+ (CGRect)alterHeightByTextString:(NSString *)aTextString originalRect:(CGRect)aOriginalRect font:(UIFont *)aFont {
    CGSize size = CGSizeMake(aOriginalRect.size.width, 99999999);
    CGRect textRect = [aTextString boundingRectWithSize:size
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:aFont}
                                                context:nil];
    aOriginalRect.size.height = textRect.size.height;
    return aOriginalRect;
}

/** GET DEVICE TYPE */
- (CurrentDeviceType)deviceType {
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
            case 480:
                return DeviceTypeClassic;
                break;
            case 960:
                return DeviceType4Or4s;
                break;
            case 1136:
                return DeviceType5Or5sOr5cOrSE;
                break;
            case 1334:
                return DeviceType6Or6sOr7Or8;
                break;
            case 2208:
                return DeviceType6PlusOr6sPlus;
                break;
            case 2436:
                return DeviceTypeX;
                break;
            default:
                return DeviceTypeUnknown;
        }
    }
    
    return DeviceTypeUnknown;
}

@end
