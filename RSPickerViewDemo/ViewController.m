//
//  ViewController.m
//  RSPickerViewDemo
//
//  Created by MB6 on 2018/7/25.
//  Copyright © 2018年 Rebecca Huang. All rights reserved.
//

#import "ViewController.h"
#import "CZPickerView.h"
#import "UsefulTool.h"

@interface ViewController () <CZPickerViewDelegate, CZPickerViewDataSource> {
    NSInteger _selectedIndex;
    NSArray *_titleList;
    UILabel *_showSelectedTitleLabel;
}

@end

@implementation ViewController

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedIndex = 0;
    
    _titleList = @[@"This is the First row Of the Picker",
                   @"This is the Second row Of the Picker",
                   @"This is the Third row Of the Picker",
                   @"This is the Fourth row Of the Picker",
                   @"This is the Fifth row Of the Picker"];
    
    [self.view setBackgroundColor:IsIPhoneX ? [UIColor blackColor] : [UIColor whiteColor]];

    //  showing picker button
    CGRect rect = CGRectMake(0, 0, 120 * Scale, 50 * Scale);
    rect.origin.x = (CGRectGetWidth(self.view.frame) - CGRectGetWidth(rect)) / 2;
    rect.origin.y = (CGRectGetHeight(self.view.frame) - CGRectGetHeight(rect)) / 2;
    
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    [button setTitle:@"SHOW PICKER" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:PICKER_TEXT_FONT];
    [button.layer setBorderColor:[UIColor orangeColor].CGColor];
    [button.layer setBorderWidth:2];
    [button addTarget:self action:@selector(onShowingPickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //  Show the Selected Title Text UILabel
    rect = CGRectMake(BASE_BLANK_WIDTH, CGRectGetMaxY(button.frame) + BASE_BLANK_WIDTH, CGRectGetWidth(self.view.frame), 31 * Scale);
    rect.size.width -= rect.origin.x * 2;
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:IsIPhoneX ? [UIColor whiteColor] : [UIColor blackColor]];
    [label setFont:PICKER_TEXT_FONT];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setMinimumScaleFactor:10 * Scale];
    [self.view addSubview:label];
    _showSelectedTitleLabel = label;
    label = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Events Functions

- (void)onShowingPickerButton:(UIButton *)aButton {
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"CHOOSE ONE ROW" cancelButtonTitle:@"CANCEL" confirmButtonTitle:@"CONFIRM"];
    [picker setDelegate:self];
    [picker setDataSource:self];
    [picker setNeedFooterView:YES];
    [picker setCheckmarkColor:[UIColor orangeColor]];
    [picker setSelectedRows:@[[NSNumber numberWithInteger:_selectedIndex]]];
    [picker show];
}

#pragma mark - CZPickerViewDataSource, CZPickerViewDelegate

- (NSString *)czpickerView:(CZPickerView *)pickerView titleForRow:(NSInteger)row {
    return [_titleList objectAtIndex:row];
}

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView {
    return _titleList.count;
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row {
    _selectedIndex = row;
    
    [_showSelectedTitleLabel setText:[_titleList objectAtIndex:row]];
}

- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView {
}

- (void)czpickerViewDidDismiss:(CZPickerView *)pickerView {
}


@end
