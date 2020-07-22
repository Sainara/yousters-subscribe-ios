//
//  SBKAuthRequest.h
//  SberbankSDK
//
//  Created by Sberbank on 13.12.2019.
//  Copyright © 2019 Sberbank. All rights reserved.
//

@import Foundation;


/**
 Модель запроса
 */
@interface SBKAuthRequest : NSObject

@property (nonatomic, nonnull, copy) NSString *clientId; /**< Идентификатор клиента */
@property (nonatomic, nonnull, copy) NSString *scope; /**< Наименование групп данных, на которые подписана система */
@property (nonatomic, nonnull, copy) NSString *state; /**< Значение для предотвращения подделки межсайтовых запросов, случайно сгенерированное */
@property (nonatomic, nonnull, copy) NSString *redirectUri; /**< Адрес на который будет перенаправлен клиент после успешной аутентификации (deeplink) */
@property (nonatomic, nonnull, copy) NSString *nonce; /**< Значение, сгенерированное внешней АС для предотвращения атак повторения */
@property (nonatomic, nullable, copy) NSString *codeChallenge; /**< Хэшированное значение секретного кода */
@property (nonatomic, nullable, copy) NSString *codeChallengeMethod; /**< Метод преобразования секретного кода */

@end

