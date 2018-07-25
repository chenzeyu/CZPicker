//
//  PickerViewTableViewCell.m
//  TBBMobileBank
//
//  Created by MB6 on 2018/7/24.
//  Copyright © 2018年 Taiwan Business Bank. All rights reserved.
//

#import "PickerViewTableViewCell.h"
#import "UsefulTool.h"

@implementation PickerViewTableViewCell

#pragma mark - Initalized

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self != [super initWithStyle:style reuseIdentifier:reuseIdentifier]) return nil;
    
    self.accessoryType = UITableViewCellAccessoryNone;
    
    //  init UILabel
    [self.textLabel setTextAlignment:NSTextAlignmentLeft];
    [self.textLabel setTextColor:[UIColor blackColor]];
    [self.textLabel setFont:PICKER_TEXT_FONT];
    [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.textLabel setNumberOfLines:0];
    [self.textLabel setAdjustsFontSizeToFitWidth:YES];
    [self.textLabel setMinimumScaleFactor:10 * Scale];
    
    return self;
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect textLabelFrame = [self originalTextLabelFrame];
    if (self.titleHeight > 0.0f)
        textLabelFrame.size.height = self.titleHeight;
    [self.textLabel setFrame:textLabelFrame];
    [self.textLabel setCenter:CGPointMake(self.textLabel.center.x, CGRectGetHeight(self.frame) / 2)];
    
    [self.accessoryView setCenter:CGPointMake(self.accessoryView.center.x, CGRectGetHeight(self.frame) / 2)];
}

#pragma mark - Property

- (void)setTitleHeight:(CGFloat)aTitleHeight {
    _titleHeight = aTitleHeight;
}

- (CGRect)originalTextLabelFrame {
    CGRect rect = CGRectMake(BASE_BLANK_WIDTH, BASE_BLANK_WIDTH / 2, 200 * Scale, 31 * Scale);
    return rect;
}

#pragma mark - Public Functions

+ (NSString *)reusableIdentifer {
    return @"czpicker_view_identifier";
}

@end
