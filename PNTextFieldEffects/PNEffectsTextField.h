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

#pragma mark --- subclass hooks
- (void)animteViewsForTextEntry;

- (void)animateViewsForTextDisplay;

- (void)drawViewsForRect:(CGRect)rect;

- (void)updateViewsForBoundsChange:(CGRect)bounds;


@end
