//
//  PNEffectsTextField.h
//  PNTextFieldEffects
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PNTextAnimationType) {
    PNTextAnimationTypeEntry,
    PNTextAnimationTypeDisplay,
};

typedef void (^PNAnimationCompletionHandler)(PNTextAnimationType);

@interface PNEffectsTextField : UITextField

@property (nonatomic, readonly) UILabel *placeHolderLabel;
@property (nonatomic, copy) PNAnimationCompletionHandler animationCompletionHandler;
#pragma mark --- subclass hooks
- (void)animateViewsForTextEntry;

- (void)animateViewsForTextDisplay;

- (void)drawViewsForRect:(CGRect)rect;

- (void)updateViewsForBoundsChange:(CGRect)bounds;


@end
