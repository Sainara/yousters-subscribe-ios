//
//  SBKAuthManager.h
//  SberbankSDK
//
//  Created by Sberbank on 13.12.2019.
//  Copyright © 2019 Sberbank. All rights reserved.
//

@import Foundation;

@class SBKAuthRequest;
@class SBKAuthResponse;


NS_ASSUME_NONNULL_BEGIN


/**
 Менеджер авторизации
 */
@interface SBKAuthManager : NSObject

/**
 Авторизоваться с помощью Сбербанк Онлайн

 @param request Модель запроса
 */
+ (void)authWithSberId:(SBKAuthRequest *)request;

/**
 Получить объект ответа

 @param url url с которого был переход
 @param completion блок, возвращающий объект ответа
 */
+ (void)getResponseFromURL:(NSURL *)url completion:(void(^)(SBKAuthResponse *response))completion;

@end


NS_ASSUME_NONNULL_END
