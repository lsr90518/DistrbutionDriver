//
//  MDUtil.m
//  Distribution
//
//  Created by Lsr on 4/7/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDUtil.h"
#import <Security/Security.h>

@implementation MDUtil

+(MDUtil *)getInstance {
    static MDUtil *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[MDUtil alloc] init];
    });
    return sharedInstance;
}

-(NSString *)internationalPhoneNumber:(NSString *)phoneNumber {
    if ( ![[phoneNumber substringToIndex:3] isEqualToString:@"+81"] ) {
        NSString *tmpNumber = [NSString stringWithFormat:@"+81%@",[phoneNumber substringFromIndex:1]];
        phoneNumber = tmpNumber;
    }
    
    return phoneNumber;
}

-(NSString *)japanesePhoneNumber:(NSString *)phoneNumber {
    if ( [[phoneNumber substringToIndex:3] isEqualToString:@"+81"] ) {
        NSString *tmpNumber = [NSString stringWithFormat:@"0%@",[phoneNumber substringFromIndex:3]];
        phoneNumber = tmpNumber;
    }
    
    return phoneNumber;
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+(float)getOSVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+(void)makeAlertWithTitle:(NSString *)title
                  message:(NSString *)message
                     done:(NSString *)done
           viewController:(UIViewController *)viewController{
    if([self getOSVersion] < 8.0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:viewController
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:done, nil];
        [alertView show];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:done style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // ボタンが押された時の処理
            if([viewController respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]){
                [(UIViewController <UIAlertViewDelegate> *)viewController alertView:nil clickedButtonAtIndex:0];
            }
        }]];
        [viewController presentViewController:alertController animated:YES completion:nil];
    }
}

+(NSDate *)getLocalDateTimeFromString:(NSString *)datetime utc:(BOOL)utc{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 文字列からNSDateオブジェクトを生成
    NSDate *fromFormatDate = [dateFormatter dateFromString: datetime];
    if(utc)return [fromFormatDate initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:fromFormatDate];
    else return fromFormatDate;
}
+(NSString *)getLocalDateTimeStrFromString:(NSString *)datetime format:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: format];
    return [dateFormatter stringFromDate:[self getLocalDateTimeFromString:datetime utc:YES]];
}

@end
