//
//  GlobalAlertController.m
//  SCE
//
//  Created by xdliu on 16/9/27.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "GlobalAlertController.h"

#define BUTTON_HEIGHT       45.0f

@interface GlobalAlertController ()

@property (nonatomic, copy) NSAttributedString *attributeTitle;

@property (nonatomic, copy) NSString *alertTitle;

// button titles
@property (nonatomic, strong) NSArray<NSAttributedString *> *buttonAttributeTitles;

@property (nonatomic, copy) NSAttributedString *cancelButtonTitle;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIView *mainContentView;

@property (nonatomic, strong) UITapGestureRecognizer *hideTapGesture;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation GlobalAlertController

- (void)dealloc {
    self.delegate = nil;
}

- (id)init {
    if (self = [super init]) {
        _selectedIndex = -1;
    }
    return self;
}

- (nonnull instancetype)initWithDelegate:(nullable id<GlobalAlertControllerDelegate>)delegate otherButtonTitles:(nullable NSString *)otherButtonTitles, ... {
    if (self = [self init]) {
        self.delegate = delegate;
        
        NSMutableArray *buttonAttributeTitles = [NSMutableArray new];
        if (otherButtonTitles) {
            [buttonAttributeTitles addObject:[[NSAttributedString alloc] initWithString:otherButtonTitles]];
            
            id buttonTitle = nil;
            va_list argumentList;
            va_start(argumentList, otherButtonTitles);
            
            while ((buttonTitle=(__bridge NSString *)va_arg(argumentList, void *))) {
                [buttonAttributeTitles addObject:[[NSAttributedString alloc] initWithString:buttonTitle]];
            }
            
            va_end(argumentList);
        }
        
        self.cancelButtonTitle = [[NSAttributedString alloc] initWithString:@"取消"];
        [buttonAttributeTitles addObject:self.cancelButtonTitle];
        
        self.buttonAttributeTitles = buttonAttributeTitles;
    }
    return self;
}

- (nonnull instancetype)initWithTitle:(nullable NSString *)title delegate:(nullable id<GlobalAlertControllerDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION {
    if (self = [self init]) {
        self.attributeTitle = title != nil ? [[NSAttributedString alloc] initWithString:title] : nil;
        self.delegate = delegate;
        
        NSMutableArray *buttonAttributeTitles = [NSMutableArray new];
        if (otherButtonTitles) {
            [buttonAttributeTitles addObject:[[NSAttributedString alloc] initWithString:otherButtonTitles]];
            
            id buttonTitle = nil;
            va_list argumentList;
            va_start(argumentList, otherButtonTitles);
            
            while ((buttonTitle=(__bridge NSString *)va_arg(argumentList, void *))) {
                [buttonAttributeTitles addObject:[[NSAttributedString alloc] initWithString:buttonTitle]];
            }
            
            va_end(argumentList);
        }
        
        if (cancelButtonTitle) {
            self.cancelButtonTitle = [[NSAttributedString alloc] initWithString:cancelButtonTitle];
            [buttonAttributeTitles addObject:[[NSAttributedString alloc] initWithString:cancelButtonTitle]];
        }
        
        self.buttonAttributeTitles = buttonAttributeTitles;
    }
    return self;
}

- (nonnull instancetype)initWithDelegate:(nullable id<GlobalAlertControllerDelegate>)delegate otherButtonAttributeTitles:(nullable NSAttributedString *)otherButtonAttributeTitles, ... {
    if (self = [super init]) {
        self.delegate = delegate;
        
        NSMutableArray *buttonAttributeTitles = [NSMutableArray new];
        if (otherButtonAttributeTitles) {
            [buttonAttributeTitles addObject:otherButtonAttributeTitles];
            
            id buttonAttributeTitle = nil;
            va_list argumentList;
            va_start(argumentList, otherButtonAttributeTitles);
            
            while ((buttonAttributeTitle=(__bridge NSAttributedString *)va_arg(argumentList, void *))) {
                [buttonAttributeTitles addObject:[[NSAttributedString alloc] initWithString:buttonAttributeTitle]];
            }
            
            va_end(argumentList);
        }
        
        self.cancelButtonTitle = [[NSAttributedString alloc] initWithString:@"取消" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName:[UIColor colorWithWhite:0 alpha:0.95]}];
        [buttonAttributeTitles addObject:self.cancelButtonTitle];
        
        self.buttonAttributeTitles = buttonAttributeTitles;
    }
    return self;
}

- (nonnull instancetype)initWithAttributeTitle:(nullable NSAttributedString *)attributeTitle delegate:(nullable id<GlobalAlertControllerDelegate>)delegate cancelButtonAttributeTitle:(nullable NSAttributedString *)cancelButtonAttributeTitle otherButtonAttributeTitles:(nullable NSAttributedString *)otherButtonAttributeTitles, ... {
    if (self = [super init]) {
        self.attributeTitle = attributeTitle;
        self.delegate = delegate;
        
        NSMutableArray *buttonAttributeTitles = [NSMutableArray new];
        if (otherButtonAttributeTitles) {
            [buttonAttributeTitles addObject:otherButtonAttributeTitles];
            
            id buttonAttributeTitle = nil;
            va_list argumentList;
            va_start(argumentList, otherButtonAttributeTitles);
            
            while ((buttonAttributeTitle=(__bridge NSAttributedString *)va_arg(argumentList, void *))) {
                [buttonAttributeTitles addObject:[[NSAttributedString alloc] initWithString:buttonAttributeTitle]];
            }
            
            va_end(argumentList);
        }
        
        if (cancelButtonAttributeTitle) {
            self.cancelButtonTitle = cancelButtonAttributeTitle;
            [buttonAttributeTitles addObject:self.cancelButtonTitle];
        }
        
        self.buttonAttributeTitles = buttonAttributeTitles;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addPageSubviews];
}

- (void)addPageSubviews {
    self.mainContentView = [UIView new];
    self.mainContentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainContentView];
    
    // 标题高度
    CGSize titleSize = CGSizeZero;
    if (self.attributeTitle) {
        UIView *titleContentView = [UIView new];
        titleContentView.backgroundColor = [UIColor whiteColor];
        [self.mainContentView addSubview:titleContentView];
        [titleContentView addSubview:self.titleLbl];
        
        NSRange eRange = {0, self.attributeTitle.string.length};
        NSDictionary *titleAttribute = [self.attributeTitle attributesAtIndex:0 effectiveRange:&eRange];
        if (!titleAttribute) {
            self.titleLbl.text = self.attributeTitle.string;
            titleAttribute = @{NSFontAttributeName:self.titleLbl.font, NSForegroundColorAttributeName:self.titleLbl.textColor};
        } else {
            self.titleLbl.attributedText = self.attributeTitle;
        }
        titleSize = [[[NSAttributedString alloc] initWithString:self.attributeTitle.string attributes:titleAttribute] boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT) options:0 context:nil].size;
        
        CGFloat contentViewHeight = titleSize.height + 15*2 + 0.5 >= BUTTON_HEIGHT ? titleSize.height + 15*2 + 0.5 : BUTTON_HEIGHT;
        
        titleContentView.frame = CGRectMake(0, 0, self.view.frame.size.width, contentViewHeight);
        
        self.titleLbl.frame = CGRectMake(15.0f, (contentViewHeight-titleSize.height)/2.0, self.view.frame.size.width - 30.0f, titleSize.height);
        
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, contentViewHeight - 0.5, self.view.frame.size.width, 0.5)];
        sepView.backgroundColor = [UIColor colorWithRed:(234/255.0f) green:(234/255.0f) blue:(234/255.0f) alpha:1.0];
        [titleContentView addSubview:sepView];
        
        titleSize.height = contentViewHeight;
    }
    
    CGFloat height = self.buttonAttributeTitles.count * BUTTON_HEIGHT + (self.buttonAttributeTitles.count > 2 ? (self.buttonAttributeTitles.count - 2)*0.5 + 5 : self.buttonAttributeTitles.count == 1 ? 0 : 5.0f);
    
    // 间距 8 分割线高度 0.5
    height += titleSize.height != 0 ? titleSize.height : 0;
    
    self.mainContentView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, height);
    
    
    //buttons
    
    NSRange effectiveRange = {0, self.buttonAttributeTitles.firstObject.string.length};
    BOOL attributeBtn = [self.buttonAttributeTitles.firstObject attributesAtIndex:0 effectiveRange:&effectiveRange] ? YES : NO;
    
    CGFloat originY = titleSize.height != 0 ? titleSize.height : 0;
    for (int i = 0; i < self.buttonAttributeTitles.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(clickButtonIndex:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"global_alert_highlight"] forState:UIControlStateHighlighted];
        btn.exclusiveTouch = YES;
        if (attributeBtn) {
            [btn setAttributedTitle:self.buttonAttributeTitles[i] forState:UIControlStateNormal];
            [btn setAttributedTitle:self.buttonAttributeTitles[i] forState:UIControlStateHighlighted];
        } else {
            [btn setTitle:self.buttonAttributeTitles[i].string forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
            [btn setTitleColor:[UIColor colorWithWhite:0 alpha:0.95] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithWhite:0 alpha:0.95] forState:UIControlStateHighlighted];
        }
        btn.frame = CGRectMake(0, originY, self.view.frame.size.width, BUTTON_HEIGHT);
        btn.tag = i;
        
        [self.mainContentView addSubview:btn];
        originY += BUTTON_HEIGHT;
        if (self.buttonAttributeTitles.count > 1) {
            UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, self.view.frame.size.width, 0.5)];
            sepView.backgroundColor = [UIColor colorWithRed:(234/255.0f) green:(234/255.0f) blue:(234/255.0f) alpha:1.0];
            [self.mainContentView addSubview:sepView];
            if (self.buttonAttributeTitles.count - 2 == i) {
                sepView.frame = CGRectMake(0, originY, self.view.frame.size.width, 5);
                sepView.backgroundColor = [UIColor colorWithRed:(234/255.0f) green:(231/255.0f) blue:(233/255.0f) alpha:1.0];
                originY += 5;
            } else {
                originY += 0.5;
            }
        } else {
            originY += 0.5;
        }
    }
}

#pragma mark - private methods

- (void)addHideGesture {
    UITapGestureRecognizer *hideTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideGesture:)];
    [self.view addGestureRecognizer:hideTapGesture];
    _hideTapGesture = hideTapGesture;
}

#pragma mark - response events

- (void)clickButtonIndex:(UIButton *)button {
    CGFloat duration = 0.1;
    if (button.tag == self.buttonAttributeTitles.count - 1) {
        duration = 0.25;
    }
    
    _selectedIndex = button.tag;
    [self hideWithDuration:duration animated:YES];
}

- (void)hideWithDuration:(CGFloat)duration animated:(BOOL)animated {
    if (animated) {
        [self.view removeGestureRecognizer:_hideTapGesture];
        _hideTapGesture = nil;
        [UIView animateWithDuration:duration animations:^{
            self.mainContentView.transform = CGAffineTransformIdentity;
            self.view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [self dismissController:nil];
        }];
    } else {
        [self dismissController:nil];
    }
}

- (void)hideGesture:(id)sender {
    [self hideWithDuration:0.25 animated:YES];
}

- (void)dismissController:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertController:clickedButtonAtIndex:)] && _selectedIndex != -1) {
            [self.delegate alertController:self clickedButtonAtIndex:_selectedIndex];
        }
    }];
}

#pragma mark - public methods

- (void)showAlertController {
    self.modalPresentationStyle = UIModalPresentationCustom;
    [self.currTopViewController presentViewController:self animated:NO completion:^{
        self.view.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.25 animations:^{
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
            self.mainContentView.transform = CGAffineTransformTranslate(self.mainContentView.transform, 0, -self.mainContentView.frame.size.height);
        } completion:^(BOOL finished) {
            [self addHideGesture];
        }];
    }];
}

- (UIViewController *)currTopViewController {
    UIViewController *currViewController = nil;
    id  nextResponder = nil;
    UIViewController *rootViewController = [[UIApplication sharedApplication].delegate window].rootViewController;
    if (rootViewController.presentedViewController) {
        nextResponder = rootViewController.presentedViewController;
    }else{
        UIView *frontView = [[[[UIApplication sharedApplication].delegate window] subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController *nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        currViewController = nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        currViewController = nav.childViewControllers.lastObject;
    }else{
        currViewController = nextResponder;
    }
    
    return currViewController;
}

#pragma mark - getters

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.numberOfLines = 0;
        _titleLbl.font = [UIFont systemFontOfSize:14.0f];
        _titleLbl.textColor = [UIColor colorWithWhite:(132/255.0) alpha:0.85];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}

#pragma mark - memory manage

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
