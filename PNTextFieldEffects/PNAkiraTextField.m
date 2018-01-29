//
//  PNAkiraTextField.m
//  PNTextFieldEffects
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

#import "PNAkiraTextField.h"

@interface PNAkiraTextField()

@property (nonatomic, assign) CGFloat activeBorderSize;
@property (nonatomic, assign) CGFloat inactiveBorderSize;
@property (nonatomic, strong) CALayer *borderLayer;
@property (nonatomic, assign) CGPoint textFieldInsets;
@property (nonatomic, assign) CGPoint placeholderInsets;

@property (nonatomic, readonly) CGFloat placeholderHeight;

@end


IB_DESIGNABLE
@implementation PNAkiraTextField

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
    self.activeBorderSize = 1;
    self.inactiveBorderSize = 2;
    self.borderLayer = [CALayer layer];
    self.textFieldInsets = CGPointMake(6, 0);
    self.placeholderInsets = CGPointMake(6, 0);
    self.placeholderFontScale = 0.7;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
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

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    [self updatePlaceholder];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self updateBorder];
}

#pragma mark --- PNEffectsTextField

- (void)drawViewsForRect:(CGRect)rect {
    [self updateBorder];
    [self updatePlaceholder];
    
    [self addSubview:self.placeHolderLabel];
    [self.layer addSublayer:self.borderLayer];
}

#pragma mark --- Privates

- (void)updatePlaceholder {
    self.placeHolderLabel.frame = [self placeholderRectForBounds:self.bounds];
    self.placeHolderLabel.text = self.placeholder;
    self.placeHolderLabel.font = [self placeholderFontFromFont:self.font];
    self.placeHolderLabel.textAlignment = self.textAlignment;
}


- (void)updateBorder {
    self.borderLayer.frame = [self rectForbounds:self.bounds];
    self.borderLayer.borderWidth = (self.isFirstResponder || self.text.length != 0) ? self.activeBorderSize : self.inactiveBorderSize;
    self.borderLayer.borderColor = self.borderColor.CGColor;
}

- (UIFont *)placeholderFontFromFont:(UIFont *)font {
    return [UIFont fontWithName:font.fontName size:font.pointSize * _placeholderFontScale];
}

- (CGRect)rectForbounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x, bounds.origin.y + self.placeholderHeight, bounds.size.width, bounds.size.height - self.placeholderHeight);
}

#pragma mark --- overrides

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    if (self.isFirstResponder || (self.text && self.text.length == 0)) {
        return CGRectMake(self.placeholderInsets.x, self.placeholderInsets.y, self.bounds.size.width, self.placeholderHeight);
    } else {
        return [self textRectForBounds:bounds];
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectOffset(bounds, self.textFieldInsets.x, self.placeholderHeight / 2);
}

@end
