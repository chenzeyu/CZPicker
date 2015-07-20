# CZPicker

[![CI Status](http://img.shields.io/travis/chenzeyu/CZPicker.svg?style=flat)](https://travis-ci.org/chenzeyu/CZPicker)
[![Version](https://img.shields.io/cocoapods/v/CZPicker.svg?style=flat)](http://cocoapods.org/pods/CZPicker)
[![License](https://img.shields.io/cocoapods/l/CZPicker.svg?style=flat)](http://cocoapods.org/pods/CZPicker)
[![Platform](https://img.shields.io/cocoapods/p/CZPicker.svg?style=flat)](http://cocoapods.org/pods/CZPicker)

## Demo
![](demo.gif)

## Change Log
2 most recent changes are listed here.

Full [change logs](CHANGELOG.md)

### v0.3.4 - 2015-07-21

#### Fixed
- Fixed multiple selection mode cell selection not remembered issue. [#8](https://github.com/chenzeyu/CZPicker/issues/8)

### v0.3.3 - 2015-07-20
#### Fixed
- Listen to orientation change when needed. (App supports landscape & portrait)
- Animate picker only on supported orientations.

## Usage

CZPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CZPicker"
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

To show the picker, simply adding the following code:

```objective-c
CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Fruits"
                        cancelButtonTitle:@"Cancel"
                        confirmButtonTitle:@"Confirm"];
picker.delegate = self;
picker.dataSource = self;
[picker show];
```
and implement the dataSource and Delegate methods:

```objective-c
#prama mark - CZPickerViewDataSource

@required
/* number of items for picker */
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView;

@optional
/*
 Implement at least one of the following method,
 CZPickerView:(CZPickerView *)pickerView
 attributedTitleForRow:(NSInteger)row has higer priority
*/

/* attributed picker item title for each row */
- (NSAttributedString *)CZPickerView:(CZPickerView *)pickerView
                            attributedTitleForRow:(NSInteger)row;

/* picker item title for each row */
- (NSString *)CZPickerView:(CZPickerView *)pickerView
                            titleForRow:(NSInteger)row;



#prama mark - CZPickerViewDelegate
@optional
/** delegate method for picking one item */
- (void)CZPickerView:(CZPickerView *)pickerView
          didConfirmWithItemAtRow:(NSInteger)row;

/** delegate method for picking multiple items,
 implement this method if allowMultipleSelection is YES,
 rows is an array of NSNumbers
 */
- (void)CZPickerView:(CZPickerView *)pickerView
          didConfirmWithItemsAtRows:(NSArray *)rows;
/** delegate method for canceling */
- (void)CZPickerViewDidClickCancelButton:(CZPickerView *)pickerView;
```

## Customization
There are a lot of things can be customized, change the following properties to customize the picker of your own:

```objective-c
/** whether to show footer (including confirm and cancel buttons), default NO */
@property BOOL needFooterView;

/** whether allow tap background to dismiss the picker, default YES */
@property BOOL tapBackgroundToDismiss;

/** whether allow selection of multiple items/rows, default NO, if this
 property is YES, then footerView will be shown */
@property BOOL allowMultipleSelection;

/** picker header background color */
@property (nonatomic, strong) UIColor *headerBackgroundColor;

/** picker header title color */
@property (nonatomic, strong) UIColor *headerTitleColor;

/** picker cancel button background color */
@property (nonatomic, strong) UIColor *cancelButtonBackgroundColor;

/** picker cancel button normal state color */
@property (nonatomic, strong) UIColor *cancelButtonNormalColor;

/** picker cancel button highlighted state color */
@property (nonatomic, strong) UIColor *cancelButtonHighlightedColor;

/** picker confirm button background color */
@property (nonatomic, strong) UIColor *confirmButtonBackgroundColor;

/** picker confirm button normal state color */
@property (nonatomic, strong) UIColor *confirmButtonNormalColor;

/** picker confirm button highlighted state color */
@property (nonatomic, strong) UIColor *confirmButtonHighlightedColor;
```



## Author

chenzeyu, zeyufly@gmail.com

## License

CZPicker is available under the MIT license. See the LICENSE file for more info.

## Credits

CZPicker is created at and supported by [Fooyo.sg](http://fooyo.sg)
