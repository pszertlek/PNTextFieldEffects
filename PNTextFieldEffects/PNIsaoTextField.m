//
//  PNIsaoTextField.m
//  PNTextFieldEffects
//
//  Created by apple on 2018/9/7.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

#import "PNIsaoTextField.h"

@interface PNIsaoTextField ()

@property (nonatomic, assign) CGPoint textFieldInsets;
@property (nonatomic, assign) CGPoint placeholderInsets;
@property (nonatomic, assign) CGFloat placeholderFontScale;
@end


@implementation PNIsaoTextField

- (void)updateBorder {
    
}

- (void)updatePlaceholder {
    self.placeholderLabel.text = self.placeholder;
    self.placeholderLabel.textColor = self.inactiveColor;
    [self.placeholderLabel sizeToFit];
    
}

- (UIFont *)placeholderFontFromFont:(UIFont *)font {
    UIFont *smallerFont = [UIFont fontWithName:font.fontName size:font.pointSize * self.placeholderFontScale];
    return smallerFont;
}

#pragma mark --- Overrides

- (void)drawRect:(CGRect)rect {
    CGRect frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    self.placeholderLabel.frame = CGRectInset(frame, self.placeholderInsets.x, self.placeholderInsets.y);
    [self updateBorder];
    [self updatePlaceholder];
    [self.layer addSublayer:self.seperatorLayer];
    [self addSubview:self.placeholderLabel];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect newBounds = CGRectMake(0, 0, bounds.size.width, bounds.size.height - self.font.lineHeight + self.textFieldInsets.y);
    return CGRectInset(newBounds, self.textFieldInsets.x, 0);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect newBounds = CGRectMake(0, 0, bounds.size.width, bounds.size.height - self.font.lineHeight + self.textFieldInsets.y);
    return CGRectInset(newBounds, self.textFieldInsets.x, 0);
}

@end
