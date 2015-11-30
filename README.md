# CZPicker

[![CI Status](http://img.shields.io/travis/chenzeyu/CZPicker.svg?style=flat)](https://travis-ci.org/chenzeyu/CZPicker)
[![Version](https://img.shields.io/cocoapods/v/CZPicker.svg?style=flat)](http://cocoapods.org/pods/CZPicker)
[![License](https://img.shields.io/cocoapods/l/CZPicker.svg?style=flat)](http://cocoapods.org/pods/CZPicker)
[![Platform](https://img.shields.io/cocoapods/p/CZPicker.svg?style=flat)](http://cocoapods.org/pods/CZPicker)

## Demo
![](demo.gif)

## Change Log
3 most recent changes are listed here.

Full [change logs](CHANGELOG.md)
### v0.3.7 - 2015-11-29

#### Added
- Added ```- (UIImage *)czpickerView:(CZPickerView *)pickerView imageForRow:(NSInteger)row``` for setting images for every item [#20](https://github.com/chenzeyu/CZPicker/issues/20)

### v0.3.6 - 2015-09-11

#### Added
- Added ```animationDuration``` for setting duration of animation (both showing and dismissing) [#14](https://github.com/chenzeyu/CZPicker/issues/14)
- Added ```- (NSArray *)selectedRows``` to return previously selected items.[#10](https://github.com/chenzeyu/CZPicker/issues/10)
- Added ```setSelectedRows:rows``` to pre-set selected items before showing.[#15](https://github.com/chenzeyu/CZPicker/issues/15)


### v0.3.5 - 2015-07-21

#### Changed
- Change delegate & dataSource methods names to conform to apple's guideline and avoid error in swift.(methods' names start with 'CZPicker' to 'czpicker')[#5](https://github.com/chenzeyu/CZPicker/issues/5)
- Make picker higher in landscape mode.

## Usage

CZPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CZPicker"
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

If you are using swift, please refer to [CZPicker Swift Demo](https://gist.github.com/chenzeyu/6d19a343ffc8d6530fd0)

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
 czpickerView:(CZPickerView *)pickerView
 attributedTitleForRow:(NSInteger)row has higer priority
*/

/* attributed picker item title for each row */
- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView
                            attributedTitleForRow:(NSInteger)row;

/* picker item title for each row */
- (NSString *)czpickerView:(CZPickerView *)pickerView
                            titleForRow:(NSInteger)row;



#prama mark - CZPickerViewDelegate
@optional
/** delegate method for picking one item */
- (void)czpickerView:(CZPickerView *)pickerView
          didConfirmWithItemAtRow:(NSInteger)row;

/** delegate method for picking multiple items,
 implement this method if allowMultipleSelection is YES,
 rows is an array of NSNumbers
 */
- (void)czpickerView:(CZPickerView *)pickerView
          didConfirmWithItemsAtRows:(NSArray *)rows;
/** delegate method for canceling */
- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView;
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

/** picker's animation duration for showing and dismissing*/
@property CGFloat animationDuration;

```



## Author

chenzeyu, zeyufly@gmail.com

## License

CZPicker is available under the MIT license. See the LICENSE file for more info.

## Credits

CZPicker is created at and supported by [Fooyo.sg](http://fooyo.sg)
