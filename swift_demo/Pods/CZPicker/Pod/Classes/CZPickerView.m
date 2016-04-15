//
//  CZPickerView.h
//
//  Created by chenzeyu on 9/6/15.
//  Copyright (c) 2015 chenzeyu. All rights reserved.
//

#import "CZPickerView.h"

#define CZP_FOOTER_HEIGHT 44.0
#define CZP_HEADER_HEIGHT 44.0
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1 
#define CZP_BACKGROUND_ALPHA 0.9
#else
#define CZP_BACKGROUND_ALPHA 0.3
#endif



typedef void (^CZDismissCompletionCallback)(void);

@interface CZPickerView ()
@property NSString *headerTitle;
@property NSString *cancelButtonTitle;
@property NSString *confirmButtonTitle;
@property UIView *backgroundDimmingView;
@property UIView *containerView;
@property UIView *headerView;
@property UIView *footerview;
@property UITableView *tableView;
@property NSMutableArray *selectedIndexPaths;
@property CGRect previousBounds;
@end

@implementation CZPickerView

- (id)initWithHeaderTitle:(NSString *)headerTitle
        cancelButtonTitle:(NSString *)cancelButtonTitle
       confirmButtonTitle:(NSString *)confirmButtonTitle{
    self = [super init];
    if(self){
        if([self needHandleOrientation]){
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector:@selector(deviceOrientationDidChange:)
                                                         name:UIDeviceOrientationDidChangeNotification
                                                       object: nil];
        }
        self.tapBackgroundToDismiss = YES;
        self.needFooterView = NO;
        self.allowMultipleSelection = NO;
        self.animationDuration = 0.5f;
        
        self.confirmButtonTitle = confirmButtonTitle;
        self.cancelButtonTitle = cancelButtonTitle;
        
        self.headerTitle = headerTitle ? headerTitle : @"";
        self.headerTitleColor = [UIColor whiteColor];
        self.headerBackgroundColor = [UIColor colorWithRed:56.0/255 green:185.0/255 blue:158.0/255 alpha:1];
        
        self.cancelButtonNormalColor = [UIColor colorWithRed:59.0/255 green:72/255.0 blue:5.0/255 alpha:1];
        self.cancelButtonHighlightedColor = [UIColor grayColor];
        self.cancelButtonBackgroundColor = [UIColor colorWithRed:236.0/255 green:240/255.0 blue:241.0/255 alpha:1];
        
        self.confirmButtonNormalColor = [UIColor whiteColor];
        self.confirmButtonHighlightedColor = [UIColor colorWithRed:236.0/255 green:240/255.0 blue:241.0/255 alpha:1];
        self.confirmButtonBackgroundColor = [UIColor colorWithRed:56.0/255 green:185.0/255 blue:158.0/255 alpha:1];
        
        _previousBounds = [UIScreen mainScreen].bounds;
        self.frame = _previousBounds;
    }
    return self;
}

- (void)setupSubviews{
    if(!self.backgroundDimmingView){
        self.backgroundDimmingView = [self buildBackgroundDimmingView];
        [self addSubview:self.backgroundDimmingView];
    }
    
    self.containerView = [self buildContainerView];
    [self addSubview:self.containerView];
    
    self.tableView = [self buildTableView];
    [self.containerView addSubview:self.tableView];
    
    self.headerView = [self buildHeaderView];
    [self.containerView addSubview:self.headerView];
    
    self.footerview = [self buildFooterView];
    [self.containerView addSubview:self.footerview];
    
    CGRect frame = self.containerView.frame;
    
    self.containerView.frame = CGRectMake(frame.origin.x,
                                          frame.origin.y,
                                          frame.size.width,
                                          self.headerView.frame.size.height + self.tableView.frame.size.height + self.footerview.frame.size.height);
    self.containerView.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height);
    
}

- (void)performContainerAnimation {
    
    [UIView animateWithDuration:self.animationDuration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.containerView.center = self.center;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)show{
    
    if(self.allowMultipleSelection && !self.needFooterView){
        self.needFooterView = self.allowMultipleSelection;
    }
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    self.frame = mainWindow.frame;
    [mainWindow addSubview:self];
    [self setupSubviews];
    [self performContainerAnimation];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundDimmingView.alpha = CZP_BACKGROUND_ALPHA;
    }];
}

- (void)dismissPicker:(CZDismissCompletionCallback)completion{
    [UIView animateWithDuration:self.animationDuration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.containerView.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height);
    }completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundDimmingView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if(finished){
            if(completion){
                completion();
            }
            [self removeFromSuperview];
        }
    }];
}

- (UIView *)buildContainerView{
    CGFloat widthRatio = _pickerWidth ? _pickerWidth / [UIScreen mainScreen].bounds.size.width : 0.8;
    CGAffineTransform transform = CGAffineTransformMake(widthRatio, 0, 0, 0.8, 0, 0);
    CGRect newRect = CGRectApplyAffineTransform(self.frame, transform);
    UIView *cv = [[UIView alloc] initWithFrame:newRect];
    cv.layer.cornerRadius = 6.0f;
    cv.clipsToBounds = YES;
    cv.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height);
    return cv;
}

- (UITableView *)buildTableView{
    CGFloat widthRatio = _pickerWidth ? _pickerWidth / [UIScreen mainScreen].bounds.size.width : 0.8;
    CGAffineTransform transform = CGAffineTransformMake(widthRatio, 0, 0, 0.8, 0, 0);
    CGRect newRect = CGRectApplyAffineTransform(self.frame, transform);
    NSInteger n = [self.dataSource numberOfRowsInPickerView:self];
    CGRect tableRect;
    float heightOffset = CZP_HEADER_HEIGHT + CZP_FOOTER_HEIGHT;
    if(n > 0){
        float height = n * 44.0;
        height = height > newRect.size.height - heightOffset ? newRect.size.height -heightOffset : height;
        tableRect = CGRectMake(0, 44.0, newRect.size.width, height);
    } else {
        tableRect = CGRectMake(0, 44.0, newRect.size.width, newRect.size.height - heightOffset);
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return tableView;
}

- (UIView *)buildBackgroundDimmingView{
    
    UIView *bgView;
    //blur effect for iOS8
    CGFloat frameHeight = self.frame.size.height;
    CGFloat frameWidth = self.frame.size.width;
    CGFloat sideLength = frameHeight > frameWidth ? frameHeight : frameWidth;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        UIBlurEffect *eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        bgView = [[UIVisualEffectView alloc] initWithEffect:eff];
        bgView.frame = CGRectMake(0, 0, sideLength, sideLength);
    }
    else {
        bgView = [[UIView alloc] initWithFrame:self.frame];
        bgView.backgroundColor = [UIColor blackColor];
    }
    bgView.alpha = 0.0;
    if(self.tapBackgroundToDismiss){
        [bgView addGestureRecognizer:
         [[UITapGestureRecognizer alloc] initWithTarget:self
                                                 action:@selector(cancelButtonPressed:)]];
    }
    return bgView;
}

- (UIView *)buildFooterView{
    if (!self.needFooterView){
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    CGRect rect = self.tableView.frame;
    CGRect newRect = CGRectMake(0,
                                rect.origin.y + rect.size.height,
                                rect.size.width,
                                CZP_FOOTER_HEIGHT);
    CGRect leftRect = CGRectMake(0,0, newRect.size.width /2, CZP_FOOTER_HEIGHT);
    CGRect rightRect = CGRectMake(newRect.size.width /2,0, newRect.size.width /2, CZP_FOOTER_HEIGHT);
    
    UIView *view = [[UIView alloc] initWithFrame:newRect];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:leftRect];
    [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor: self.cancelButtonNormalColor forState:UIControlStateNormal];
    [cancelButton setTitleColor:self.cancelButtonHighlightedColor forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    cancelButton.backgroundColor = self.cancelButtonBackgroundColor;
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelButton];
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:rightRect];
    [confirmButton setTitle:self.confirmButtonTitle forState:UIControlStateNormal];
    [confirmButton setTitleColor:self.confirmButtonNormalColor forState:UIControlStateNormal];
    [confirmButton setTitleColor:self.confirmButtonHighlightedColor forState:UIControlStateHighlighted];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    confirmButton.backgroundColor = self.confirmButtonBackgroundColor;
    [confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:confirmButton];
    return view;
}

- (UIView *)buildHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, CZP_HEADER_HEIGHT)];
    view.backgroundColor = self.headerBackgroundColor;
    
    UIFont *headerFont = self.headerTitleFont == nil ? [UIFont systemFontOfSize:18.0] : self.headerTitleFont;
    
    NSDictionary *dict = @{
                           NSForegroundColorAttributeName: self.headerTitleColor,
                           NSFontAttributeName:headerFont
                           };
    NSAttributedString *at = [[NSAttributedString alloc] initWithString:self.headerTitle attributes:dict];
    UILabel *label = [[UILabel alloc] initWithFrame:view.frame];
    label.attributedText = at;
    [label sizeToFit];
    [view addSubview:label];
    label.center = view.center;
    return view;
}

- (IBAction)cancelButtonPressed:(id)sender{
    [self dismissPicker:^{
        if([self.delegate respondsToSelector:@selector(czpickerViewDidClickCancelButton:)]){
            [self.delegate czpickerViewDidClickCancelButton:self];
        }
    }];
}

- (IBAction)confirmButtonPressed:(id)sender{
    [self dismissPicker:^{
        if(self.allowMultipleSelection && [self.delegate respondsToSelector:@selector(czpickerView:didConfirmWithItemsAtRows:)]){
            [self.delegate czpickerView:self didConfirmWithItemsAtRows:[self selectedRows]];
        }
        
        else if(!self.allowMultipleSelection && [self.delegate respondsToSelector:@selector(czpickerView:didConfirmWithItemAtRow:)]){
            if (self.selectedIndexPaths.count > 0){
                NSInteger row = ((NSIndexPath *)self.selectedIndexPaths[0]).row;
                [self.delegate czpickerView:self didConfirmWithItemAtRow:row];
            }
        }
    }];
}

- (NSArray *)selectedRows {
    NSMutableArray *rows = [NSMutableArray new];
    for (NSIndexPath *ip in self.selectedIndexPaths) {
        [rows addObject:@(ip.row)];
    }
    return rows;
}

- (void)setSelectedRows:(NSArray *)rows{
    if (![rows isKindOfClass: NSArray.class]) {
        return;
    }
    self.selectedIndexPaths = [NSMutableArray new];
    for (NSNumber *n in rows){
        NSIndexPath *ip = [NSIndexPath indexPathForRow:[n integerValue] inSection: 0];
        [self.selectedIndexPaths addObject:ip];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.dataSource respondsToSelector:@selector(numberOfRowsInPickerView:)]) {
        return [self.dataSource numberOfRowsInPickerView:self];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"czpicker_view_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    for(NSIndexPath *ip in self.selectedIndexPaths){
        if(ip.row == indexPath.row){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    if([self.dataSource respondsToSelector:@selector(czpickerView:titleForRow:)] && [self.dataSource respondsToSelector:@selector(czpickerView:imageForRow:)]){
        cell.textLabel.text = [self.dataSource czpickerView:self titleForRow:indexPath.row];
        cell.imageView.image = [self.dataSource czpickerView:self imageForRow:indexPath.row];
    } else if ([self.dataSource respondsToSelector:@selector(czpickerView:attributedTitleForRow:)] && [self.dataSource respondsToSelector:@selector(czpickerView:imageForRow:)]){
        cell.textLabel.attributedText = [self.dataSource czpickerView:self attributedTitleForRow:indexPath.row];
        cell.imageView.image = [self.dataSource czpickerView:self imageForRow:indexPath.row];
    } else if ([self.dataSource respondsToSelector:@selector(czpickerView:attributedTitleForRow:)]) {
        cell.textLabel.attributedText = [self.dataSource czpickerView:self attributedTitleForRow:indexPath.row];
    } else if([self.dataSource respondsToSelector:@selector(czpickerView:titleForRow:)]){
        cell.textLabel.text = [self.dataSource czpickerView:self titleForRow:indexPath.row];
    }
    
    if(self.checkmarkColor){
        cell.tintColor = self.checkmarkColor;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(!self.selectedIndexPaths){
        self.selectedIndexPaths = [NSMutableArray new];
    }
    // the row has already been selected
    
    if (self.allowMultipleSelection){
        
        if([self.selectedIndexPaths containsObject:indexPath]){
            [self.selectedIndexPaths removeObject:indexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            [self.selectedIndexPaths addObject:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    } else { //single selection mode
        
        if (self.selectedIndexPaths.count > 0){// has selection
            NSIndexPath *prevIp = (NSIndexPath *)self.selectedIndexPaths[0];
            UITableViewCell *prevCell = [tableView cellForRowAtIndexPath:prevIp];
            if(indexPath.row != prevIp.row){ //different cell
                prevCell.accessoryType = UITableViewCellAccessoryNone;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [self.selectedIndexPaths removeObject:prevIp];
                [self.selectedIndexPaths addObject:indexPath];
            } else {//same cell
                cell.accessoryType = UITableViewCellAccessoryNone;
                self.selectedIndexPaths = [NSMutableArray new];
            }
        } else {//no selection
            [self.selectedIndexPaths addObject:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        if(!self.needFooterView && [self.delegate respondsToSelector:@selector(czpickerView:didConfirmWithItemAtRow:)]){
            [self dismissPicker:^{
                [self.delegate czpickerView:self didConfirmWithItemAtRow:indexPath.row];
            }];
        }
    }
    
}

#pragma mark - Notification Handler

- (BOOL)needHandleOrientation{
    NSArray *supportedOrientations = [[[NSBundle mainBundle] infoDictionary]
                                      objectForKey:@"UISupportedInterfaceOrientations"];
    NSMutableSet *set = [NSMutableSet set];
    for(NSString *o in supportedOrientations){
        NSRange range = [o rangeOfString:@"Portrait"];
        if (range.location != NSNotFound) {
            [set addObject:@"Portrait"];
        }
        
        range = [o rangeOfString:@"Landscape"];
        if (range.location != NSNotFound) {
            [set addObject:@"Landscape"];
        }
    }
    return set.count == 2;
}

- (void)deviceOrientationDidChange:(NSNotification *)notification{
    CGRect rect = [UIScreen mainScreen].bounds;
    if (CGRectEqualToRect(rect, _previousBounds)) {
        return;
    }
    _previousBounds = rect;
    self.frame = rect;
    for(UIView *v in self.subviews){
        if([v isEqual:self.backgroundDimmingView]) continue;
        
        [UIView animateWithDuration:0.2f animations:^{
            v.alpha = 0.0;
        } completion:^(BOOL finished) {
            [v removeFromSuperview];
            //as backgroundDimmingView will not be removed
            if(self.subviews.count == 1){
                [self setupSubviews];
                [self performContainerAnimation];
            }
        }];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
