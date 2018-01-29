//
//  PNAkiraTextField.h
//  PNTextFieldEffects
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

#import "PNEffectsTextField.h"


@interface PNAkiraTextField : PNEffectsTextField

@property (nonatomic, copy) IBInspectable UIColor *borderColor;
@property (nonatomic, copy) IBInspectable UIColor *placeholderColor;
@property (nonatomic, assign) IBInspectable CGFloat placeholderFontScale;
@end
