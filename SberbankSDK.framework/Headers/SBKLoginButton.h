//
//  SBKLoginButton.h
//  SberbankSDK
//
//  Created by Sberbank on 16.12.2019.
//  Copyright © 2019 Sberbank. All rights reserved.
//

@import UIKit;


/**
 Стиль кнопки

 - SBKLoginButtonGreen: Зеленая
 - SBKLoginButtonWhite: Белая
 */
typedef NS_ENUM(NSUInteger, SBKLoginButtonStyle)
{
	SBKLoginButtonGreen = 0,
	SBKLoginButtonWhite = 1
};

NS_ASSUME_NONNULL_BEGIN


/**
 Кнопка логина через Сбербанк ID
 */
@interface SBKLoginButton : UIButton

/**
 Инициализатор кнопки

 @param style стиль кнопки
 @return объект
 */
- (instancetype)initWithType:(SBKLoginButtonStyle)style;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
