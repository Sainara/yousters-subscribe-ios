//
//  SBKUtils.h
//  SberbankSDK
//
//  Created by Sberbank on 13.12.2019.
//  Copyright © 2019 Sberbank. All rights reserved.
//

@import Foundation;


NS_ASSUME_NONNULL_BEGIN;

extern NSString *const SBKUtilsCodeChallengeMethod; /**< Метод хэширования */


/**
 Утилиты PKCE
 */
@interface SBKUtils : NSObject

/**
 Создает и возвращает случайно сгенерированную строку

 @return случайное сгенерированная строка
 */
+ (NSString *)createVerifier;

/**
 Создает и возвращает хэшированную строку из переданной секретной строки

 @param verifier секретная случайно сгенерированная строка
 @return хэшированная строка
 */
+ (NSString *)createChallenge:(NSString *)verifier;

@end


NS_ASSUME_NONNULL_END;
