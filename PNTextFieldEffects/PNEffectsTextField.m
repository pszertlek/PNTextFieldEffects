//
//  PNEffectsTextField.m
//  PNTextFieldEffects
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

#import "PNEffectsTextField.h"

@interface PNEffectsTextField()

@end

@implementation PNEffectsTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSLog(@"sss%s",__PRETTY_FUNCTION__);
    }
    return self;
}

#pragma mark --- Subclass hooks

- (void)animteViewsForTextEntry {
    NSAssert(false, @"must be overridden", __PRETTY_FUNCTION__);
}

- (void)animateViewsForTextDisplay {
    NSAssert(false, @"must be ovverridden", __PRETTY_FUNCTION__);
}

- (void)drawViewsForRect:(CGRect)rect {
    NSAssert(false, @"must be ovverridden", __PRETTY_FUNCTION__);
}

- (void)updateViewsForBoundsChange:(CGRect)bounds {
    NSAssert(false, @"must be ovverridden", __PRETTY_FUNCTION__);
}

#pragma mark --- overridden

- (void)drawRect:(CGRect)rect {
    if (!self.isFirstResponder) {
        [self drawViewsForRect:rect];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if (text && text.length != 0) {
        [self animteViewsForTextEntry];
    } else {
        [self animateViewsForTextDisplay];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing) name:UITextFieldTextDidEndEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing) name:UITextFieldTextDidBeginEditingNotification object:self];

    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)textFieldDidBeginEditing {
    [self animateViewsForTextDisplay];
}

- (void)textFieldDidEndEditing {
    [self animteViewsForTextEntry];
}

// MARK: - Interface Buider

- (void)prepareForInterfaceBuilder {
    [self drawViewsForRect:self.frame];
}

@end