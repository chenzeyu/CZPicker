//
//  PickerViewTableViewCell.h
//  TBBMobileBank
//
//  Created by MB6 on 2018/7/24.
//  Copyright © 2018年 Taiwan Business Bank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerViewTableViewCell : UITableViewCell

#pragma mark - Property

@property (nonatomic, assign) CGFloat titleHeight;

#pragma mark - Public Functions

- (CGRect)originalTextLabelFrame;

+ (NSString *)reusableIdentifer;

@end
