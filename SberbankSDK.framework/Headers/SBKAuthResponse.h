//
//  SBKAuthResponse.h
//  SberbankSDK
//
//  Created by Sberbank on 13.12.2019.
//  Copyright © 2019 Sberbank. All rights reserved.
//

@import Foundation;


NS_ASSUME_NONNULL_BEGIN


/**
 Модель ответа
 */
@interface SBKAuthResponse : NSObject

@property (nonatomic, copy, readonly) NSString *nonce; /**< начение, сгенерированное внешней АС для предотвращения атак повторения */
@property (nonatomic, nullable, copy, readonly) NSString *authCode; /**< Код авторизации клиента */
@property (nonatomic, nullable, copy, readonly) NSString *error; /**< Текст ошибки */
@property (nonatomic, assign, readonly, getter=isSuccess) BOOL success; /**< Статус операции */

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END
