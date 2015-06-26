//
//  CZPickerView.h
//  Tut
//
//  Created by chenzeyu on 9/6/15.
//  Copyright (c) 2015 chenzeyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Pop/POP.h>

@class CZPickerView;

@protocol CZPickerViewDataSource <NSObject>

@required
- (NSAttributedString *)CZPickerView:(CZPickerView *)pickerView
                            titleForRow:(NSInteger)row;
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView;
@end

@protocol CZPickerViewDelegate <NSObject>

@optional
- (void)CZPickerView:(CZPickerView *)pickerView
          didConfirmWithItemAtRow:(NSInteger)row;
- (void)CZPickerViewDidClickCancelButton:(CZPickerView *)pickerView;
@end

@interface CZPickerView : UIView<UITableViewDataSource, UITableViewDelegate, POPAnimationDelegate>

@property BOOL footerViewNeeded;
@property BOOL canClickBackgroudToDismiss;

- (id)initWithHeaderTitle:(NSString *)headerTitle
        cancelButtonTitle:(NSString *)cancelButtonTitle
       confirmButtonTitle:(NSString *)confirmButtonTitle;

@property id<CZPickerViewDelegate> delegate;
@property id<CZPickerViewDataSource> dataSource;
- (void)show;

@end
