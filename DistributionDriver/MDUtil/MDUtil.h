//
//  MDUtil.h
//  Distribution
//
//  Created by Lsr on 4/7/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDUtil : NSObject

+(MDUtil *)getInstance;

-(NSString *)internationalPhoneNumber:(NSString *)phoneNumber;
-(NSString *)japanesePhoneNumber:(NSString *)phoneNumber;
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+(void)makeAlertWithTitle:(NSString *)title message:(NSString *)message done:(NSString *)done viewController:(UIViewController *)viewController;

+(NSDate *)getLocalDateTimeFromString:(NSString *)datetime utc:(BOOL)utc;
+(NSString *)getLocalDateTimeStrFromString:(NSString *)datetime format:(NSString *)format;

@end
