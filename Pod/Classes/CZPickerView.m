#import "CZPickerView.h"

@interface CZPickerView ()
@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) NSString *confirmButtonTitle;
@property (nonatomic, strong) UIView *backgroundDimmingView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableOrderedSet<NSNumber *> *selection;
@property (nonatomic) BOOL dismissing;
@end

@implementation CZPickerView

- (id)initWithHeaderTitle:(NSString *)headerTitle cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _headerTitle = [headerTitle copy] ?: @"";
        _cancelButtonTitle = [cancelButtonTitle copy] ?: @"Cancel";
        _confirmButtonTitle = [confirmButtonTitle copy] ?: @"Confirm";
        _selection = [NSMutableOrderedSet orderedSet];
        _tapBackgroundToDismiss = YES;
        _animationDuration = 0.25;
        _headerTitleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _headerTitleColor = UIColor.labelColor;
        _headerBackgroundColor = UIColor.secondarySystemBackgroundColor;
        _cancelButtonNormalColor = UIColor.labelColor;
        _cancelButtonHighlightedColor = UIColor.secondaryLabelColor;
        _cancelButtonBackgroundColor = UIColor.secondarySystemBackgroundColor;
        _confirmButtonNormalColor = UIColor.whiteColor;
        _confirmButtonHighlightedColor = UIColor.lightGrayColor;
        _confirmButtonBackgroundColor = UIColor.systemTealColor;
        self.accessibilityViewIsModal = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)show {
    // Never guess between multiple foreground windows. Explicit presentation is preferred.
    NSMutableArray<UIWindow *> *windows = [NSMutableArray array];
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (scene.activationState != UISceneActivationStateForegroundActive || ![scene isKindOfClass:UIWindowScene.class]) continue;
        for (UIWindow *window in ((UIWindowScene *)scene).windows) {
            if (window.isKeyWindow) [windows addObject:window];
        }
    }
    if (windows.count == 1) [self showInContainer:windows.firstObject];
}

- (void)showInContainer:(id)container {
    if (![container isKindOfClass:UIView.class] || self.superview || self.dismissing) return;
    UIView *host = container;
    if ([self.delegate respondsToSelector:@selector(czpickerViewWillDisplay:)]) [self.delegate czpickerViewWillDisplay:self];
    if (self.allowMultipleSelection) self.needFooterView = YES;
    [self validateSelection];
    self.frame = host.bounds;
    [host addSubview:self];
    [self setupSubviews];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.alpha = 0;
    [UIView animateWithDuration:[self effectiveDuration] animations:^{ self.alpha = 1; } completion:^(BOOL finished) {
        if (!finished || !self.superview || self.dismissing) return;
        if ([self.delegate respondsToSelector:@selector(czpickerViewDidDisplay:)]) [self.delegate czpickerViewDidDisplay:self];
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.headerLabel);
    }];
}

- (NSTimeInterval)effectiveDuration { return UIAccessibilityIsReduceMotionEnabled() ? 0 : MAX(0, self.animationDuration); }

- (void)setupSubviews {
    for (UIView *view in self.subviews.copy) [view removeFromSuperview];
    self.backgroundDimmingView = [[UIView alloc] init];
    self.backgroundDimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    if (self.tapBackgroundToDismiss) {
        [self.backgroundDimmingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonPressed:)]];
    }
    [self addSubview:self.backgroundDimmingView];
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = UIColor.systemBackgroundColor;
    self.containerView.layer.cornerRadius = 16;
    self.containerView.clipsToBounds = YES;
    [self addSubview:self.containerView];
    self.headerLabel = [[UILabel alloc] init];
    self.headerLabel.text = self.headerTitle;
    self.headerLabel.font = self.headerTitleFont;
    self.headerLabel.adjustsFontForContentSizeCategory = YES;
    self.headerLabel.textColor = self.headerTitleColor;
    self.headerLabel.backgroundColor = self.headerBackgroundColor;
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    self.headerLabel.numberOfLines = 0;
    self.headerLabel.accessibilityTraits = UIAccessibilityTraitHeader;
    [self.containerView addSubview:self.headerLabel];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 52;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.containerView addSubview:self.tableView];
    self.footerView = [[UIView alloc] init];
    [self.containerView addSubview:self.footerView];
    self.cancelButton = [self buttonWithTitle:self.cancelButtonTitle action:@selector(cancelButtonPressed:) background:self.cancelButtonBackgroundColor normal:self.cancelButtonNormalColor highlighted:self.cancelButtonHighlightedColor];
    self.confirmButton = [self buttonWithTitle:self.confirmButtonTitle action:@selector(confirmButtonPressed:) background:self.confirmButtonBackgroundColor normal:self.confirmButtonNormalColor highlighted:self.confirmButtonHighlightedColor];
    [self.footerView addSubview:self.cancelButton];
    [self.footerView addSubview:self.confirmButton];
}

- (UIButton *)buttonWithTitle:(NSString *)title action:(SEL)action background:(UIColor *)background normal:(UIColor *)normal highlighted:(UIColor *)highlighted {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:normal forState:UIControlStateNormal];
    [button setTitleColor:highlighted forState:UIControlStateHighlighted];
    button.backgroundColor = background;
    button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    button.titleLabel.adjustsFontForContentSizeCategory = YES;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundDimmingView.frame = self.bounds;
    CGRect safe = UIEdgeInsetsInsetRect(self.bounds, self.safeAreaInsets);
    CGFloat availableWidth = MAX(0, safe.size.width - 32);
    CGFloat width = MIN(self.pickerWidth > 0 ? self.pickerWidth : MIN(420, availableWidth), availableWidth);
    CGFloat headerHeight = MAX(52, [self.headerLabel sizeThatFits:CGSizeMake(MAX(1, width - 24), CGFLOAT_MAX)].height + 24);
    CGFloat footerHeight = self.needFooterView ? MAX(52, self.confirmButton.titleLabel.font.lineHeight + 24) : 0;
    CGFloat availableHeight = MAX(0, safe.size.height - 32);
    CGFloat rowHeight = MAX(52, [UIFont preferredFontForTextStyle:UIFontTextStyleBody].lineHeight + 24);
    CGFloat tableHeight = MIN(MAX(0, availableHeight - headerHeight - footerHeight), MAX(1, [self rowCount]) * rowHeight);
    CGFloat height = MIN(availableHeight, headerHeight + tableHeight + footerHeight);
    self.containerView.frame = CGRectMake(CGRectGetMidX(safe) - width / 2, CGRectGetMidY(safe) - height / 2, width, height);
    self.headerLabel.frame = CGRectMake(0, 0, width, headerHeight);
    self.tableView.frame = CGRectMake(0, headerHeight, width, tableHeight);
    self.footerView.frame = CGRectMake(0, headerHeight + tableHeight, width, footerHeight);
    self.footerView.hidden = !self.needFooterView;
    self.cancelButton.frame = CGRectMake(0, 0, width / 2, footerHeight);
    self.confirmButton.frame = CGRectMake(width / 2, 0, width / 2, footerHeight);
}

- (NSInteger)rowCount {
    return [self.dataSource respondsToSelector:@selector(numberOfRowsInPickerView:)] ? MAX(0, [self.dataSource numberOfRowsInPickerView:self]) : 0;
}

- (void)validateSelection {
    NSInteger count = [self rowCount];
    NSMutableOrderedSet *valid = [NSMutableOrderedSet orderedSet];
    for (NSNumber *row in self.selection) {
        if (row.integerValue >= 0 && row.integerValue < count && (self.allowMultipleSelection || valid.count == 0)) [valid addObject:row];
    }
    self.selection = valid;
}

- (NSArray *)selectedRows { return self.selection.array ?: @[]; }
- (void)setSelectedRows:(NSArray *)rows {
    if (![rows isKindOfClass:NSArray.class]) return;
    self.selection = [NSMutableOrderedSet orderedSet];
    for (id row in rows) {
        if (![row isKindOfClass:NSNumber.class]) continue;
        double value = [row doubleValue];
        if (isfinite(value) && value >= 0 && value < (double)NSIntegerMax && floor(value) == value) [self.selection addObject:@([row integerValue])];
    }
    // Permit preselection before the caller assigns its data source.
    if (self.dataSource) [self validateSelection];
    [self.tableView reloadData];
}
- (void)unselectAll { [self.selection removeAllObjects]; [self.tableView reloadData]; }
- (void)reloadData { [self validateSelection]; [self.tableView reloadData]; [self setNeedsLayout]; }
- (void)dismiss { [self dismissPicker:nil]; }

- (void)dismissPicker:(void (^)(void))completion {
    if (!self.superview || self.dismissing) return;
    self.dismissing = YES;
    if ([self.delegate respondsToSelector:@selector(czpickerViewWillDismiss:)]) [self.delegate czpickerViewWillDismiss:self];
    [UIView animateWithDuration:[self effectiveDuration] animations:^{ self.alpha = 0; } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.dismissing = NO;
        if ([self.delegate respondsToSelector:@selector(czpickerViewDidDismiss:)]) [self.delegate czpickerViewDidDismiss:self];
        if (completion) completion();
    }];
}
- (void)cancelButtonPressed:(id)sender {
    [self dismissPicker:^{
        if ([self.delegate respondsToSelector:@selector(czpickerViewDidClickCancelButton:)]) [self.delegate czpickerViewDidClickCancelButton:self];
    }];
}
- (BOOL)accessibilityPerformEscape { [self cancelButtonPressed:nil]; return YES; }
- (void)confirmButtonPressed:(id)sender {
    [self validateSelection];
    NSArray *rows = self.selectedRows;
    BOOL multiple = self.allowMultipleSelection;
    [self dismissPicker:^{
        if (multiple && [self.delegate respondsToSelector:@selector(czpickerView:didConfirmWithItemsAtRows:)]) [self.delegate czpickerView:self didConfirmWithItemsAtRows:rows];
        else if (!multiple && rows.count && [self.delegate respondsToSelector:@selector(czpickerView:didConfirmWithItemAtRow:)]) [self.delegate czpickerView:self didConfirmWithItemAtRow:[rows.firstObject integerValue]];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [self rowCount]; }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CZPickerRow"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CZPickerRow"];
    cell.textLabel.text = nil;
    cell.textLabel.attributedText = nil;
    cell.imageView.image = nil;
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cell.textLabel.adjustsFontForContentSizeCategory = YES;
    cell.textLabel.numberOfLines = 0;
    if ([self.dataSource respondsToSelector:@selector(czpickerView:attributedTitleForRow:)]) cell.textLabel.attributedText = [self.dataSource czpickerView:self attributedTitleForRow:indexPath.row];
    else if ([self.dataSource respondsToSelector:@selector(czpickerView:titleForRow:)]) cell.textLabel.text = [self.dataSource czpickerView:self titleForRow:indexPath.row];
    if ([self.dataSource respondsToSelector:@selector(czpickerView:imageForRow:)]) cell.imageView.image = [self.dataSource czpickerView:self imageForRow:indexPath.row];
    BOOL selected = [self.selection containsObject:@(indexPath.row)];
    cell.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.accessibilityTraits = UIAccessibilityTraitButton | (selected ? UIAccessibilityTraitSelected : 0);
    cell.tintColor = self.checkmarkColor ?: self.tintColor;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dismissing || indexPath.row >= [self rowCount]) return;
    NSNumber *row = @(indexPath.row);
    if ([self.selection containsObject:row]) [self.selection removeObject:row];
    else { if (!self.allowMultipleSelection) [self.selection removeAllObjects]; [self.selection addObject:row]; }
    [tableView reloadData];
    if (!self.allowMultipleSelection && !self.needFooterView) {
        // A tap is an immediate choice in the legacy footerless mode.
        self.selection = [NSMutableOrderedSet orderedSetWithObject:row];
        [self confirmButtonPressed:nil];
    }
}
@end
