//
//  NSDate+Extension.m
//  0307-新浪微博
//
//  Created by whj on 16/5/21.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

/**
 *  判断某天是否是在今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear;
    //微博的发布时间
    NSDateComponents *dateComps = [calendar components:unit fromDate:self];//
    
    //当前时间
    NSDateComponents *nowComps = [calendar components:unit fromDate:[NSDate date]];
    
    return nowComps.year == dateComps.year;
    
}
/**
 *  判断某天是否是昨天：注意比较是否是昨天时，应该把后面的时分秒忽略掉
 */
- (BOOL)isYesterday
{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd";
//    //先将日期转化成自己想要的格式
//    NSString *dateString = [formatter stringFromDate:self];
//    NSString *nowString = [formatter stringFromDate:[NSDate date]];
//    //date:2016-05-19 09:00:01 --->2016-05-19 00:00:00
//    //now:2016-05-20 23:00:45 --->2016-05-20 00:00:00
    
    NSString *dateString = [NSDate extensionStringFromDate:self];
    NSString *nowString = [NSDate extensionStringFromDate:[NSDate date]];

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    //得到想要的日期，在进行比较
    NSDate *date = [formatter dateFromString:dateString];
    NSDate *now = [formatter dateFromString:nowString];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date toDate:now options:0];
    
    return comps.year == 0 & comps.month == 0 & comps.day == 1;
}
/**
 *  判断某天是否是今天:注意比较是否是今天时，应该把后面的时分秒忽略掉
 */
- (BOOL)isToday
{
    NSDate *now = [NSDate date];
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd";
//    //先将日期转化成自己想要的格式
//    NSString *dateString = [formatter stringFromDate:self];
//    NSString *nowString = [formatter stringFromDate:now];
    
    NSString *dateString = [NSDate extensionStringFromDate:self];
    NSString *nowString = [NSDate extensionStringFromDate:now];

    
    return [dateString isEqualToString:nowString];
}

/**
 *  将日期转化成yyyy-MM-dd的格式，将后面的时分秒去掉
 *  date:2016-05-19 09:00:01 --->2016-05-19 00:00:00
 *  now:2016-05-20 23:00:45 --->2016-05-20 00:00:00
 *
 *  @param date 日期
 *
 *  @return 转化之后日期的字符串
 */
+ (NSString *)extensionStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    return [formatter stringFromDate:date];
}

@end
