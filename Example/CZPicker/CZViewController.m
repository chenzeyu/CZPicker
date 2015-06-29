//
//  CZViewController.m
//  CZPicker
//
//  Created by chenzeyu on 06/27/2015.
//  Copyright (c) 2014 chenzeyu. All rights reserved.
//

#import "CZViewController.h"

@interface CZViewController ()
@property NSArray *fruits;
@end

@implementation CZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fruits = @[@"Apple", @"Banana", @"Grape", @"Watermelon", @"Lychee"];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSAttributedString *)CZPickerView:(CZPickerView *)pickerView
                         titleForRow:(NSInteger)row{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.fruits[row]];
    return str;
}
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    return self.fruits.count;
}
- (void)CZPickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
    NSLog(@"%@ is chosen!", self.fruits[row]);
}

- (void)CZPickerViewDidClickCancelButton:(CZPickerView *)pickerView{
    NSLog(@"Canceled.");
}

- (IBAction)showWithFooter:(id)sender {
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Header" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Confirm"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    [picker show];
}

- (IBAction)showWithoutFooter:(id)sender {
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Header" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Confirm"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = NO;
    [picker show];
}
@end
