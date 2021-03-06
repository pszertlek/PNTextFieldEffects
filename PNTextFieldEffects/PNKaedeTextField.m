//
//  PNKaedeTextField.m
//  PNTextFieldEffects
//
//  Created by apple on 2018/2/7.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

#import "PNKaedeTextField.h"

@interface PNKaedeTextField ()

@property (nonatomic, strong) UIView *foregroundView;
@property (nonatomic, assign) CGPoint placeholderInsets;
@property (nonatomic, assign) CGPoint textFieldInsets;


@end

IB_DESIGNABLE
@implementation PNKaedeTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.placeholderFontScale = 0.8;
        self.foregroundView = [[UIView alloc] init];
        self.placeholderInsets = CGPointMake(10, 5);
        self.textFieldInsets = CGPointMake(10, 0);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.placeholderFontScale = 0.8;
        self.foregroundView = [[UIView alloc] init];
        self.placeholderInsets = CGPointMake(10, 5);
        self.textFieldInsets = CGPointMake(10, 0);
    }
    return self;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = [placeholderColor copy];
    [self updatePlaceholder];
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    [self updatePlaceholder];
}

- (void)setPlaceholderFontScale:(CGFloat)placeholderFontScale {
    _placeholderFontScale = placeholderFontScale;
    [self updatePlaceholder];
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
    _foregroundColor = foregroundColor;
    [self updateForegroundColor];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self drawViewsForRect:bounds];
}

#pragma mark --- PNTextFieldEffects

- (void)drawViewsForRect:(CGRect)rect {
    CGRect frame = CGRectMake(0, 0, rect.size.width, rect.size.height);

    self.foregroundView.frame = frame;
    self.foregroundView.userInteractionEnabled = false;
    self.placeholderLabel.frame = CGRectInset(frame, _placeholderInsets.x, _placeholderInsets.y);
    [self updateForegroundColor];
    [self updatePlaceholder];
    if ((self.text && self.text.length) || self.isFirstResponder) {
        [self animateViewsForTextEntry];
    }
    [self addSubview:self.foregroundView];
    [self addSubview:self.placeholderLabel];
}

- (void)animateViewsForTextEntry {
    CGFloat directionOverride = 0;
    if (@available(iOS 9.0, *)) {
        directionOverride = [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft ? - 1.0 : 1.0;
    } else {
        directionOverride = 1.0;
    }
    [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.placeholderLabel.frame = CGRectMake(self.frame.size.width * 0.65 * directionOverride, self.placeholderInsets.y, self.placeholderLabel.frame.size.width, self.placeholderLabel.frame.size.height);
    } completion:nil];
    [UIView animateWithDuration:0.45 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.foregroundView.frame = CGRectMake(self.frame.size.width * 0.6 * directionOverride, 0, self.foregroundView.frame.size.width, self.foregroundView.frame.size.height);
    } completion:^(BOOL finished) {
        if (self.animationCompletionHandler) {
            self.animationCompletionHandler(PNTextAnimationTypeEntry);
        }
    }];
}

- (void)animateViewsForTextDisplay {
    if (!self.text || self.text.length == 0) {
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.placeholderLabel.frame = CGRectMake(self.placeholderInsets.x, self.placeholderInsets.y, self.placeholderLabel.frame.size.width, self.placeholderLabel.frame.size.height);
        } completion:nil];
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:2.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.foregroundView.frame = CGRectMake(0, 0, self.foregroundView.frame.size.width, self.foregroundView.frame.size.height);
        } completion:^(BOOL finish) {
            if (self.animationCompletionHandler) {
                self.animationCompletionHandler(PNTextAnimationTypeDisplay);
            }
        }];
    }
}

#pragma mark --- private

- (void)updateForegroundColor {
    self.foregroundView.backgroundColor = self.foregroundColor;
}

- (void)updatePlaceholder {
    self.placeholderLabel.text = self.placeholder;
    self.placeholderLabel.textColor = self.placeholderColor;
}

- (UIFont *)placeholderFontFromFont:(UIFont *)font {
    return [UIFont fontWithName:font.fontName size:font.pointSize * self.placeholderFontScale];
}

#pragma mark --- overrides

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width * 0.6, bounds.size.height);
    if (@available(iOS 9.0, *)) {
        if ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft) {
            frame.origin = CGPointMake(bounds.size.width - frame.size.width, frame.origin.y);
        }
    }
    return CGRectInset(frame, _textFieldInsets.x, _textFieldInsets.y);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [self editingRectForBounds:bounds];
}
@end
