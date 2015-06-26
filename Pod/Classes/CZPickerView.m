//
//  CZPickerView.h
//  Tut
//
//  Created by chenzeyu on 9/6/15.
//  Copyright (c) 2015 chenzeyu. All rights reserved.
//

#import "CZPickerView.h"
#define TP_FOOTER_HEIGHT 44.0
#define TP_HEADER_HEIGHT 44.0
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1 
#define TP_BACKGROUND_ALPHA 0.9
#else
#define TP_BACKGROUND_ALPHA 0.3
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
@property NSIndexPath *selectedIndexPath;

@end

@implementation CZPickerView{
    CZDismissCompletionCallback callback;
}

- (id)initWithHeaderTitle:(NSString *)headerTitle
        cancelButtonTitle:(NSString *)cancelButtonTitle
       confirmButtonTitle:(NSString *)confirmButtonTitle{
    self = [super init];
    if(self){
        self.canClickBackgroudToDismiss = YES;
        self.footerViewNeeded = NO;
        self.confirmButtonTitle = confirmButtonTitle;
        self.cancelButtonTitle = cancelButtonTitle;
        self.headerTitle = headerTitle ? headerTitle : @"";
        CGRect rect= [UIScreen mainScreen].bounds;
        self.frame = rect;
    }
    return self;
}

- (void)setupSubviews{
    
    self.backgroundDimmingView = [self buildBackgroundDimmingView];
    [self addSubview:self.backgroundDimmingView];
    
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

- (void)show{
    [self setupSubviews];
    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    self.frame = mainWindow.frame;
    [mainWindow addSubview:self];
    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    springAnimation.toValue = [NSValue valueWithCGPoint:self.center];
    springAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
    springAnimation.springBounciness = 10.f;
    [self.containerView pop_addAnimation:springAnimation forKey:@"springAnimation_in"];
    
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.toValue = @(TP_BACKGROUND_ALPHA);
    [self.backgroundDimmingView pop_addAnimation:alphaAnimation forKey:@"diming_view_in"];
}

- (void)dismissPicker:(CZDismissCompletionCallback)completion{
    callback = completion;
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    springAnimation.toValue = [NSValue valueWithCGPoint:(CGPointMake(self.center.x, self.center.y + 600))];
    springAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
    springAnimation.springBounciness = 10.f;
    [self.containerView pop_addAnimation:springAnimation forKey:@"springAnimation_out"];
    
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.toValue = @(0.0);
    alphaAnimation.delegate = self;
    [self.backgroundDimmingView pop_addAnimation:alphaAnimation forKey:@"diming_view_out"];
    
}

- (UIView *)buildContainerView{
    CGAffineTransform transform = CGAffineTransformMake(0.8, 0, 0, 0.6, 0, 0);
    CGRect newRect = CGRectApplyAffineTransform(self.frame, transform);
    UIView *cv = [[UIView alloc] initWithFrame:newRect];
    cv.layer.cornerRadius = 6.0f;
    cv.clipsToBounds = YES;
    cv.center = CGPointMake(self.center.x, self.center.y + 600);
    return cv;
}

- (UITableView *)buildTableView{
    CGAffineTransform transform = CGAffineTransformMake(0.8, 0, 0, 0.6, 0, 0);
    CGRect newRect = CGRectApplyAffineTransform(self.frame, transform);
    NSInteger n = [self.dataSource numberOfRowsInPickerView:self];
    CGRect tableRect;
    float heightOffset = TP_HEADER_HEIGHT + TP_FOOTER_HEIGHT;
    if(n > 0){
        float height = n * 46.0;
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
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        UIBlurEffect *eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        bgView = [[UIVisualEffectView alloc] initWithEffect:eff];
        bgView.frame = self.frame;
    }
    else {
        bgView = [[UIView alloc] initWithFrame:self.frame];
        bgView.backgroundColor = [UIColor blackColor];
    }
    bgView.alpha = 0.0;
    if(self.canClickBackgroudToDismiss){
        [bgView addGestureRecognizer:
         [[UITapGestureRecognizer alloc] initWithTarget:self
                                                 action:@selector(cancelButtonPressed:)]];
    }
    return bgView;
}

- (UIView *)buildFooterView{
    if (!self.footerViewNeeded){
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    CGRect rect = self.tableView.frame;
    CGRect newRect = CGRectMake(0,
                                rect.origin.y + rect.size.height,
                                rect.size.width,
                                TP_FOOTER_HEIGHT);
    CGRect leftRect = CGRectMake(0,0, newRect.size.width /2, TP_FOOTER_HEIGHT);
    CGRect rightRect = CGRectMake(newRect.size.width /2,0, newRect.size.width /2, TP_FOOTER_HEIGHT);
    
    UIView *view = [[UIView alloc] initWithFrame:newRect];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:leftRect];
    [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    cancelButton.backgroundColor = [UIColor grayColor];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelButton];
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:rightRect];
    [confirmButton setTitle:self.confirmButtonTitle forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    confirmButton.backgroundColor = [UIColor greenColor];
    [confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:confirmButton];
    return view;
}

- (UIView *)buildHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, TP_HEADER_HEIGHT)];
    view.backgroundColor = [UIColor greenColor];
    NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                           NSFontAttributeName: [UIFont systemFontOfSize:18.0]
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
        if([self.delegate respondsToSelector:@selector(CZPickerViewDidClickCancelButton:)]){
            [self.delegate CZPickerViewDidClickCancelButton:self];
        }
    }];
}

- (IBAction)confirmButtonPressed:(id)sender{
    [self dismissPicker:^{
        if(self.selectedIndexPath && [self.delegate respondsToSelector:@selector(CZPickerView:didConfirmWithItemAtRow:)]){
            [self.delegate CZPickerView:self didConfirmWithItemAtRow:self.selectedIndexPath.row];
        }
    }];
}


#pragma mark - POPAnimationDelegate
- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished{
    if(finished){
        if(callback){
            callback();
        }
        [self removeFromSuperview];
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
    static NSString *cellIdentifier = @"picker_view_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
    }
    if(self.selectedIndexPath && [self.selectedIndexPath isEqual:indexPath]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([self.dataSource respondsToSelector:@selector(CZPickerView:titleForRow:)]) {
        cell.textLabel.attributedText = [self.dataSource CZPickerView:self titleForRow:indexPath.row];
    }
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(self.selectedIndexPath){
        UITableViewCell *prevCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
        if(prevCell){
            prevCell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    self.selectedIndexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(!self.footerViewNeeded && [self.delegate respondsToSelector:@selector(CZPickerView:didConfirmWithItemAtRow:)]){
        [self dismissPicker:^{
            [self.delegate CZPickerView:self didConfirmWithItemAtRow:indexPath.row];
        }];
    }
}
@end
