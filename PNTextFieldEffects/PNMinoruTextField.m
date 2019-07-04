//
//  PNMinoruTextField.m
//  PNTextFieldEffects
//
//  Created by apple on 2018/9/7.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

#import "PNMinoruTextField.h"

@interface PNMinoruTextField ()

@property (nonatomic, assign) CGFloat borderThickness;
@property (nonatomic, assign) CGPoint placeholderInsets;
@property (nonatomic, assign) CGPoint textFieldInsets;
@property (nonatomic, strong) CALayer *borderLayer;
@property (nonatomic, copy) UIColor *backgroundLayerColor;
@end

@implementation PNMinoruTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)propertyInit {
    self.borderThickness = 1;
    self.placeholderInsets = CGPointMake(6, 6);
    self.textFieldInsets = CGPointMake(6, 6);
    self.borderLayer = [CALayer layer];
    self.backgroundLayerColor = [UIColor whiteColor];
}

- (void)drawViewsForRect:(CGRect)rect {
    CGRect frame = CGRectMake(0, 0, rect.size.width,  rect.size.height);
    
    self.placeholderLabel.frame = CGRectInset(frame, self.placeholderInsets.x, self.placeholderInsets.y);
    self.placeholderLabel.font = [self placeholderFontFromFont:self.font];
    
    [self updateBorder];
    [self updatePlaceholder];
    
    [self.layer insertSublayer:self.borderLayer atIndex:0];
    [self addSubview:self.placeholderLabel];
}

- (void)animateViewsForTextEntry {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.6 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.borderLayer.borderColor = self.textColor.CGColor;
        self.borderLayer.shadowOffset = CGSizeZero;
        self.borderLayer.borderWidth = self.borderThickness;
        self.borderLayer.shadowColor = self.textColor.CGColor;
        self.borderLayer.shadowOpacity = 0.5;
        self.borderLayer.shadowRadius = 1;
    } completion:^(BOOL finished) {
        if (self.animationCompletionHandler) {
            self.animationCompletionHandler(PNTextAnimationTypeEntry);
        }
    }];
}

- (void)animateViewsForTextDisplay {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.6 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.borderLayer.borderColor = nil;
        self.borderLayer.shadowOffset = CGSizeZero;
        self.borderLayer.borderWidth = 0;
        self.borderLayer.shadowColor = nil;
        self.borderLayer.shadowOpacity = 0;
        self.borderLayer.shadowRadius = 0;
    } completion:^(BOOL finished) {
        if (self.animationCompletionHandler) {
            self.animationCompletionHandler(PNTextAnimationTypeDisplay);
        }
    }];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self updatePlaceholder];
}

- (void)setPlaceholderFontScale:(CGFloat)placeholderFontScale {
    _placeholderFontScale = placeholderFontScale;
    [self updatePlaceholder];
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    [self updatePlaceholder];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self updatePlaceholder];
}

- (void)updateBorder {
    self.borderLayer.frame = [self rectForBorder:self.frame];
    self.borderLayer.backgroundColor = self.backgroundColor.CGColor;
}

- (void)updatePlaceholder {
    self.placeholderLabel.text = self.placeholder;
    self.placeholderLabel.textColor = self.placeholderColor;
    [self.placeholderLabel sizeToFit];
    [self layoutPlaceholderInTextRect];
    
    if (self.isFirstResponder) {
        [self animateViewsForTextEntry];
    }}


- (CGRect)rectForBorder:(CGRect)bounds {
    return CGRectMake(0, 0, bounds.size.width, bounds.size.height - self.font.lineHeight + self.textFieldInsets.y);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset([self rectForBorder:bounds],self.textFieldInsets.x,0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset([self rectForBorder:bounds],self.textFieldInsets.x,0);
}

- (void)layoutPlaceholderInTextRect {
    CGRect textRect = [self textRectForBounds:self.bounds];
    CGFloat originX = textRect.origin.x;
    switch(self.textAlignment) {
        case NSTextAlignmentCenter:
            originX += textRect.size.width / 2 - self.placeholderLabel.bounds.size.width;
        case NSTextAlignmentRight:
            originX += textRect.size.width - self.placeholderLabel.bounds.size.width;
            break;
        default:
            break;
    }
    self.placeholderLabel.frame = CGRectMake(originX, self.bounds.size.height - self.placeholderLabel.frame.size.height, self.placeholderLabel.frame.size.width, self.placeholderLabel.frame.size.height);
}

- (UIFont *)placeholderFontFromFont:(UIFont *)font {
    UIFont* smallFont = [UIFont fontWithName:font.fontName size:font.pointSize * self.placeholderFontScale];
    return smallFont;
}

@end
