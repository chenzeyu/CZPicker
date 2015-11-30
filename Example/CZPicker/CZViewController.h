//
//  CZViewController.h
//  CZPicker
//
//  Created by chenzeyu on 06/27/2015.
//  Copyright (c) 2014 chenzeyu. All rights reserved.
//

@import UIKit;
#import <CZPicker.h>

@interface CZViewController : UIViewController<CZPickerViewDataSource, CZPickerViewDelegate>
- (IBAction)showWithImages:(id)sender;
- (IBAction)showWithFooter:(id)sender;
- (IBAction)showWithoutFooter:(id)sender;
- (IBAction)showWithMultipleSelection:(id)sender;
@end
