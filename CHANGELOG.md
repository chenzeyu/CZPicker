### v0.4.3 - 2016-08-12

- Added ```- (void)czpickerViewWillDisplay:(CZPickerView *)pickerView;```
- Added ```- (void)czpickerViewDidDisplay:(CZPickerView *)pickerView;```
- Added ```- (void)czpickerViewWillDismiss:(CZPickerView *)pickerView;```
- Added ```- (void)czpickerViewDidDismiss:(CZPickerView *)pickerView;```
- Added ```- (void)reloadData``` to reload picker.
- Added ```- (void)showInContainer:(id)container```.

### v0.4.2 - 2016-04-12
- Improve orientation handler to avoid unnecessary pop up animations.

### v0.4.1 - 2016-04-10
- Remove bundle resources setting in podspec file.

### v0.4.0 - 2016-04-09
- Added ```pickerWidth``` for setting picker width.

### v0.3.9 - 2016-03-24

#### Added
- Added ```checkmarkColor``` for cell checkmark.

### v0.3.8 - 2016-03-08

#### Added
- Added ```headerTitleFont``` for title setting font.

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

### v0.3.4 - 2015-07-20
#### Fixed
- Fixed multiple selection mode cell selection not remembered issue. [#8](https://github.com/chenzeyu/CZPicker/issues/8)

### v0.3.3 - 2015-07-20
#### Fixed
- Listen to orientation change when needed. (App supports landscape & portrait)
- Animate picker only on supported orientations.
- Fixed multiple selection mode cell selection not remembered issue. [#8](https://github.com/chenzeyu/CZPicker/issues/8)

### v0.3.2 - 2015-07-16
#### Changed
- Changed return type of ```CZPickerView:titleForRow:``` to NSString.

#### Added
- Added ```CZPickerView:attributedTitleForRow``` to support attributed row title, reference: [#3](https://github.com/chenzeyu/CZPicker/issues/3)

### v0.2.2 - 2015-07-14
#### Added
- Added ```allowMultipleSelection``` flag to support multiple selections, reference: [#1](https://github.com/chenzeyu/CZPicker/issues/1)

### v0.2.1 - 2015-07-14
#### Fixed
- Fixed orientation issue, reference: [#2](https://github.com/chenzeyu/CZPicker/issues/2).
