# RSPickerView

Watch the demo video：

[![RSPickerView](http://img.youtube.com/vi/36i5PN2-MBQ/0.jpg)](https://youtu.be/36i5PN2-MBQ)


---------------------------------------


## Calculate Height of text:

<p>(UsefulTool.h/UsefulTool.m 46)</p>
<pre><code>+ (CGRect)alterHeightByTextString:(NSString *)aTextString originalRect:(CGRect)aOriginalRect font:(UIFont *)aFont {
    CGSize size = CGSizeMake(aOriginalRect.size.width, 99999999);
    CGRect textRect = [aTextString boundingRectWithSize:size
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:aFont}
                                                context:nil];
    aOriginalRect.size.height = textRect.size.height;
    return aOriginalRect;
}
</code></pre>

* * *


## If you want to close picker by clicking background

<p>(CZPickerView.h/CZPickerView.m 237)</p>
<pre><code>- (UIView *)buildBackgroundDimmingView {
    ...
    if (self.tapBackgroundToDismiss) {
        [bgView addGestureRecognizer:
         [[UITapGestureRecognizer alloc] initWithTarget:self
                                                 action:@selector(cancelButtonPressed:)]];
    }
}
</code></pre>

* * *


## Use Custom Cell setting default textLabel frame and get it:

<p>(CZPickerView.h/CZPickerView.m 360)</p>
<pre><code>- (CGFloat)getTextHeight:(NSString *)aText {
    PickerViewTableViewCell *cell = [[PickerViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PickerViewTableViewCell reusableIdentifer]];
    return [UsefulTool alterHeightByTextString:aText originalRect:cell.originalTextLabelFrame font:PICKER_TEXT_FONT].size.height;
}
</code></pre>

* * *

## Change the TextLabel Height

<p>(CZPickerView.h/CZPickerView.m 405)</p>
<pre><code>- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ...
    NSString *text = [cell.textLabel.text isEqualToString:@""] ? cell.textLabel.attributedText.string : cell.textLabel.text;
    //  REBECCA MARK - CALCULATE HEIGHT AND CHANGE UILABEL HEIGHT
    CGFloat defaultH = [self getTextHeight:text];
    [cell setTitleHeight:defaultH];
}
</code></pre>

* * *

## Get the text height to set tableView cell height

<p>(CZPickerView.h/CZPickerView.m 419)</p>
<pre><code>- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ...
    //  REBECCA MARK - CALCULATE HEIGHT AND CHANGE CELL HEIGHT
    CGFloat defaultH = [self getTextHeight:title];
    return defaultH + 10 * Scale > CZP_HEIGHT ? defaultH + 10 * Scale : CZP_HEIGHT;
}
</code></pre>
