//
//  PNHoshiTextField.h
//  PNTextFieldEffects
//
//  Created by apple on 2018/2/8.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

#import "PNEffectsTextField.h"

@interface PNHoshiTextField : PNEffectsTextField

@property (nonatomic, copy) IBInspectable UIColor *borderInactiveColor;
@property (nonatomic, copy) IBInspectable UIColor *borderActiveColor;
@property (nonatomic, copy) IBInspectable UIColor *placeholderColor;
@property (nonatomic, assign) IBInspectable CGFloat placeholderFontScale;

@end
