//
//  PNHoshiTextField.m
//  PNTextFieldEffects
//
//  Created by apple on 2018/2/8.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

#import "PNHoshiTextField.h"

@interface PNHoshiTextField ()

@property (nonatomic, assign) CGPoint placeholderInsets;
@property (nonatomic, assign) CGPoint textFieldInsets;
@property (nonatomic, strong) CALayer *inactiveBorderLayer;
@property (nonatomic, strong) CALayer *activeBorderLayer;
@property (nonatomic, assign) CGPoint activePlaceholderPoint;
@property (nonatomic, assign) CGFloat borderThicknessActive;
@property (nonatomic, assign) CGFloat borderThicknessInactive;

@end

IB_DESIGNABLE
@implementation PNHoshiTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self propertyInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self propertyInit];
    }
    return self;
}

- (void)propertyInit {
    self.placeholderInsets = CGPointMake(0, 6);
    self.textFieldInsets = CGPointMake(0, 12);
    self.inactiveBorderLayer = [CALayer layer];
    self.activeBorderLayer = [CALayer layer];
    self.activePlaceholderPoint = CGPointZero;
    self.borderThicknessActive = 2;
    self.borderThicknessInactive = 0.5;
    if (!_placeholderColor) {
        _placeholderColor = [UIColor blackColor];
        self.placeholderFontScale = 0.65;
    }
}

- (void)setBorderInactiveColor:(UIColor *)borderInactiveColor {
    _borderInactiveColor = borderInactiveColor;
    [self updateBorder];
}

- (void)setBorderActiveColor:(UIColor *)borderActiveColor {
    _borderActiveColor = borderActiveColor;
    [self updateBorder];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self updatePlaceholder];
}

- (void)setPlaceholderFontScale:(CGFloat)placeholderFontScale {
    _placeholderFontScale = placeholderFontScale;
    [self updatePlaceholder];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self updateBorder];
    [self updatePlaceholder];
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    [self updatePlaceholder];
}

#pragma mark --- TextFieldEffects

- (void)drawViewsForRect:(CGRect)rect {
    CGRect frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    self.placeholderLabel.frame = CGRectInset(frame, self.placeholderInsets.x, self.placeholderInsets.y);
    self.placeholderLabel.font = [self placeholderFontFromFont:self.font];
    
    [self updateBorder];
    [self updatePlaceholder];
    
    [self.layer addSublayer:self.inactiveBorderLayer];
    [self.layer addSublayer:self.activeBorderLayer];
    [self addSubview:self.placeholderLabel];
}

- (void)animateViewsForTextEntry {
    if (!self.text || self.text.length == 0) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.placeholderLabel.frame = CGRectMake(10, self.placeholderLabel.frame.origin.y, self.placeholderLabel.frame.size.width, self.placeholderLabel.frame.size.height);
            self.placeholderLabel.alpha = 0;
        } completion:^(BOOL finished) {
            if (self.animationCompletionHandler) {
                self.animationCompletionHandler(PNTextAnimationTypeEntry);
            }
        }];
    }
    [self layoutPlaceholderInTextRect];
    self.placeholderLabel.frame = CGRectMake(self.activePlaceholderPoint.x, self.activePlaceholderPoint.y, self.placeholderLabel.frame.size.width, self.placeholderLabel.frame.size.height);
    [UIView animateWithDuration:0.4 animations:^{
        self.placeholderLabel.alpha = 1.0;
    }];
    self.activeBorderLayer.frame = [self rectForBorder:self.borderThicknessActive isFilled:YES];
}

- (void)animateViewsForTextDisplay {
    if (!self.text || self.text.length == 0) {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self layoutPlaceholderInTextRect];
            self.placeholderLabel.alpha = 1;
        } completion:^(BOOL finished) {
            if (self.animationCompletionHandler) {
                self.animationCompletionHandler(PNTextAnimationTypeDisplay);
            }
        }];
        self.activeBorderLayer.frame = [self rectForBorder:self.borderThicknessActive isFilled:false];
    }
}

#pragma mark --- Privates

- (void)updateBorder {
    self.inactiveBorderLayer.frame = [self rectForBorder:self.borderThicknessInactive isFilled:true];
    self.inactiveBorderLayer.backgroundColor = self.borderInactiveColor.CGColor;
    self.activeBorderLayer.frame = [self rectForBorder:self.borderThicknessInactive isFilled:true];
    self.activeBorderLayer.backgroundColor = self.borderActiveColor.CGColor;
}

- (void)updatePlaceholder {
    self.placeholderLabel.text = self.placeholder;
    self.placeholderLabel.textColor = self.placeholderColor;
    [self.placeholderLabel sizeToFit];
    [self layoutPlaceholderInTextRect];
    if (self.isFirstResponder || (self.text && self.text.length != 0)) {
        [self animateViewsForTextEntry];
    }
}

- (UIFont *)placeholderFontFromFont:(UIFont *)font {
    return [UIFont fontWithName:font.fontName size:font.pointSize * self.placeholderFontScale];
}

- (CGRect)rectForBorder:(CGFloat)thickness isFilled:(BOOL)isFilled {
    if (isFilled) {
        return CGRectMake(0, self.frame.size.height - thickness, self.frame.size.width, thickness);
    } else {
        return CGRectMake(0, self.frame.size.height - thickness, 0, thickness);
    }
}

- (void)layoutPlaceholderInTextRect {
    CGRect textRect = [self textRectForBounds:self.bounds];
    CGFloat originX = textRect.origin.x;
    switch (self.textAlignment) {
        case NSTextAlignmentCenter:{
            originX += textRect.size.width/2 - self.placeholderLabel.bounds.size.width / 2;
        }
            break;
        case NSTextAlignmentRight: {
            originX += textRect.size.width - self.placeholderLabel.bounds.size.width ;
        }
            break;
        default:
            break;
    }
    self.placeholderLabel.frame = CGRectMake(originX, textRect.size.height / 2, self.placeholderLabel.bounds.size.width, self.placeholderLabel.bounds.size.height);
    self.activePlaceholderPoint = CGPointMake(self.frame.origin.x, self.placeholderLabel.frame.origin.y - self.placeholderLabel.frame.size.height - self.placeholderInsets.y);
}

#pragma mark --- Overrides

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectOffset(bounds, self.textFieldInsets.x, self.textFieldInsets.y);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectOffset(bounds, self.textFieldInsets.x, self.textFieldInsets.y);
}

@end
