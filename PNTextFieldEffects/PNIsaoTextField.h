//
//  PNIsaoTextField.h
//  PNTextFieldEffects
//
//  Created by apple on 2018/9/7.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

#import "PNEffectsTextField.h"

@interface PNIsaoTextField : PNEffectsTextField

@property (nonatomic, strong) IBInspectable UIColor *inactiveColor;
@property (nonatomic, strong) IBInspectable UIColor *activeColor;
@property (nonatomic, strong) CALayer *seperatorLayer;
@end
