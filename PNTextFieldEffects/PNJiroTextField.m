//
//  PNJiroTextField.m
//  PNTextFieldEffects
//
//  Created by apple on 2018/9/6.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

#import "PNJiroTextField.h"

@interface PNJiroTextField () {
    @private
    CGFloat borderThickness;
    CGPoint placeholderInsets;
    CGPoint textFieldInsets;
    CALayer *borderLayer;
}

@end

@implementation PNJiroTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        borderThickness = 2;
        placeholderInsets = CGPointMake(8, 8);
        textFieldInsets = CGPointMake(8, 12);
        borderLayer = [[CALayer alloc] init];
        _placeholderColor = [UIColor blackColor];
        _placeholderFontScale = 0.65;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect frame = self.bounds;
    self.placeholderLabel.frame = CGRectInset(frame, placeholderInsets.x, placeholderInsets.y);
    self.placeholderLabel.font = [self placeholderFontFromFont:self.font];
    [self updateBounds];
    [self updatePlaceholder];
    [self.layer insertSublayer:borderLayer atIndex:0];
    [self addSubview:self.placeholderLabel];
}

- (void)updatePlaceholder {
    self.placeholderLabel.text = self.placeholder;
    self.placeholderLabel.textColor = self.placeholderColor;
    [self.placeholderLabel sizeToFit];
    [self layoutPlaceholderInTextRect];
    
    if (self.isFirstResponder || !self.text || self.text.length == 0) {
        [self animateViewsForTextEntry];
    }
}

- (void)updateBounds{
    borderLayer.frame = [self rectForBorder:borderThickness isFilled:false];
    borderLayer.backgroundColor = self.borderColor.CGColor;
}

- (void)animateViewsForTextEntry {
    borderLayer.frame = CGRectMake(0, self.font.lineHeight,borderLayer.frame.size.width,borderLayer.frame.size.height);
    [UIView animateWithDuration:0.2 delay:0.3 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        CGRect placeholderFrame = self.placeholderLabel.frame;
        placeholderFrame.origin = CGPointMake(placeholderInsets.x, borderLayer.frame.origin.y - self.placeholderLabel.bounds.size.height);
        self.placeholderLabel.frame = placeholderFrame;
        borderLayer.frame = [self rectForBorder:borderThickness isFilled:true];
    } completion:^(BOOL finished) {
        if (self.animationCompletionHandler) {
            self.animationCompletionHandler(PNTextAnimationTypeEntry);
        }
    }];
}

- (void)animateViewsForTextDisplay {
    if (!self.text || self.text.length == 0) {
        [UIView animateWithDuration:0.2 delay:0.3 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self layoutPlaceholderInTextRect];
            self.placeholderLabel.alpha = 1;
        } completion:^(BOOL finished) {
            if (self.animationCompletionHandler) {
                self.animationCompletionHandler(PNTextAnimationTypeDisplay);
            }
        }];
        borderLayer.frame = [self rectForBorder:borderThickness isFilled:false];

    }
}

- (UIFont *)placeholderFontFromFont:(UIFont *)font {
    return [UIFont fontWithName:font.fontName size:font.pointSize * self.placeholderFontScale];
}

- (CGRect)rectForBorder:(CGFloat)thickness isFilled:(BOOL)isFilled {
    if (isFilled) {
        return CGRectMake(0, self.placeholderLabel.frame.origin.y + self.placeholderLabel.font.lineHeight, self.frame.size.width, self.frame.size.height);
    } else {
        return CGRectMake(0,self.frame.size.height-thickness,self.frame.size.width, thickness);

    }
}

- (void)layoutPlaceholderInTextRect {
    if (!self.text || self.text.length == 0) {
        return;
    }
    CGRect textRect = [self textRectForBounds:self.bounds];
    CGFloat originX = textRect.origin.x;
    switch (self.textAlignment) {
        case NSTextAlignmentCenter:
            originX += textRect.size.width - self.placeholderLabel.bounds.size.width / 2;
            break;
        case NSTextAlignmentRight:
            originX += textRect.size.width - self.placeholderLabel.bounds.size.width;
            break;
        default:
            break;
    }
    self.placeholderLabel.frame = CGRectMake(originX, textRect.size.height / 2, self.placeholderLabel.frame.size.width, self.placeholderLabel.frame.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y);
}

@end
