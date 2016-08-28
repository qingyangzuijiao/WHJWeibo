//
//  NSDate+Extension.h
//  0307-新浪微博
//
//  Created by whj on 16/5/21.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 *  判断某天是否是在今年
 */
- (BOOL)isThisYear;


/**
 *  判断某天是否是昨天：注意比较是否是昨天时，应该把后面的时分秒忽略掉
 */
- (BOOL)isYesterday;


/**
 *  判断某天是否是今天:注意比较是否是今天时，应该把后面的时分秒忽略掉
 */
- (BOOL)isToday;


/**
 *  将日期转化成yyyy-MM-dd的格式，将后面的时分秒去掉
 *  date:2016-05-19 09:00:01 --->2016-05-19 00:00:00
 *  now:2016-05-20 23:00:45 --->2016-05-20 00:00:00
 *
 *  @param date 日期
 *
 *  @return 转化之后日期的字符串
 */
+ (NSString *)extensionStringFromDate:(NSDate *)date;


@end
