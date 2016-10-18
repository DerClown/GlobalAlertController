//
//  GlobalAlertController.h
//  SCE
//
//  Created by xdliu on 16/9/27.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GlobalAlertController;

@protocol GlobalAlertControllerDelegate <NSObject>

@optional;

- (void)alertController:(nonnull GlobalAlertController *)alertController clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface GlobalAlertController : UIViewController


- (nonnull instancetype)initWithDelegate:(nullable id<GlobalAlertControllerDelegate>)delegate otherButtonTitles:(nullable NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

- (nonnull instancetype)initWithTitle:(nullable NSString *)title delegate:(nullable id<GlobalAlertControllerDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;


// NSAttributedString

- (nonnull instancetype)initWithDelegate:(nullable id<GlobalAlertControllerDelegate>)delegate otherButtonAttributeTitles:(nullable NSAttributedString *)otherButtonAttributeTitles, ...NS_REQUIRES_NIL_TERMINATION;

- (nonnull instancetype)initWithAttributeTitle:(nullable NSAttributedString *)attributeTitle delegate:(nullable id<GlobalAlertControllerDelegate>)delegate cancelButtonAttributeTitle:(nullable NSAttributedString *)cancelButtonAttributeTitle otherButtonAttributeTitles:(nullable NSAttributedString *)otherButtonAttributeTitles, ...NS_REQUIRES_NIL_TERMINATION;

@property (nullable, nonatomic, weak) id<GlobalAlertControllerDelegate>delegate;

- (void)showAlertController;

@end
