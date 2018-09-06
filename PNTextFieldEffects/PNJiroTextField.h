//
//  PNJiroTextField.h
//  PNTextFieldEffects
//
//  Created by apple on 2018/9/6.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

#import "PNEffectsTextField.h"

@interface PNJiroTextField : PNEffectsTextField

@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

@property (nonatomic, assign) IBInspectable CGFloat placeholderFontScale;

@end
