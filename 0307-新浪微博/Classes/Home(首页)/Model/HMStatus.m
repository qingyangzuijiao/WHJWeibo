//
//  HMStatus.m
//  0307-新浪微博
//
//  Created by whj on 16/4/24.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//  微博模型

#import "HMStatus.h"
#import <MJExtension.h>
#import "HMPhoto.h"
//#import "HMUser.h"
@implementation HMStatus
//+ (instancetype)statusWithDict:(NSDictionary *)dict
//{
//    HMStatus *status = [[HMStatus alloc] init];
//    status.idstr = dict[@"idstr"];
//    status.text = dict[@"text"];
//    
//    status.user = [HMUser userWithDict:dict[@"user"]];
//    return status;
//    
//}

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"pic_urls" : [HMPhoto class]};
}

/**
 1.今年
 1> 今天
 * 1分内： 刚刚
 * 1分~59分内：xx分钟前
 * 大于60分钟：xx小时前
 
 2> 昨天
 * 昨天 xx:xx
 
 3> 其他
 * xx-xx xx:xx
 
 2.非今年
 1> xxxx-xx-xx xx:xx
 */
- (NSString *)created_at
{
//     _created_at = @"Thu May 19 17:06:25 +0800 2016";
    
    /**时间转换器：字符串和日期之间的转换*/
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //真机调试时需要指出本地化信息
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年

    //声明日期的格式，让转换器能够读懂
    formatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
    /** 微博创建时间*/
    NSDate *createdDate = [formatter dateFromString:_created_at];
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSString *createDateString = [formatter stringFromDate:createdDate];
//    DLog(@"%@ ",createdDate);
    
    /** 当前时间*/
    NSDate *now = [NSDate date];
//        DLog(@"%@ ",now);

    /** 日历对象（方便比较两个日期之间的差距）*/
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    /** NSCalendarUnit枚举代表想获得哪些差值*/
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    /** 计算两个日期之间的差值*/
    NSDateComponents *comps = [calendar components:unit fromDate:createdDate toDate:now options:0];
    
//    NSDateComponents *nowComps = [calendar components:unit fromDate:now];
//    NSDateComponents *createdComps = [calendar components:unit fromDate:createdDate];
//    nowComps.year == createdComps.year;
    
//    DLog(@"%@ %@ %@",createdDate, now, comps);
    
    if ([createdDate isThisYear]) { //今年
        
        if ([createdDate isYesterday]) {//昨天
            formatter.dateFormat = @"昨天 HH:mm";
            return [formatter stringFromDate:createdDate];

        }
        else if ([createdDate isToday]) {//今天
            if (comps.hour >= 1) { // 大于一小时
                return [NSString stringWithFormat:@"%ld小时前",comps.hour];
            }
            else if (comps.minute >= 1) {//大于一分钟小于一小时
                return [NSString stringWithFormat:@"%ld分钟前",comps.minute];
            }
            else {
                return @"刚刚";
            }
            
        }

        else {//今年的其他日子
            formatter.dateFormat = @"MM-dd HH:mm";
            return [formatter stringFromDate:createdDate];
        }
    
    }
    else { // 非今年
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *createdDateString = [formatter stringFromDate:createdDate];
        return createdDateString;
    }

}
/**
 *  判断某天是否是在今年
 */
- (BOOL)isThisYear:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear;
    //微博的发布时间
    NSDateComponents *dateComps = [calendar components:unit fromDate:date];
    
    //当前时间
    NSDateComponents *nowComps = [calendar components:unit fromDate:[NSDate date]];
    
    return nowComps.year == dateComps.year;
    
}
/**
 *  判断某天是否是昨天：注意比较是否是昨天时，应该把后面的时分秒忽略掉
 */
- (BOOL)isYesterday:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    //先将日期转化成自己想要的格式，也就是将后面的时分秒清零，这样比较才准确
    NSString *dateString = [formatter stringFromDate:date];
    NSString *nowString = [formatter stringFromDate:[NSDate date]];
    //date:2016-05-19 09:00:01 --->2016-05-19 00:00:00
    //now:2016-05-20 23:00:45 --->2016-05-20 00:00:00
    
    //得到想要的日期，在进行比较
    date = [formatter dateFromString:dateString];
    NSDate *now = [formatter dateFromString:nowString];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date toDate:now options:0];
    
    return comps.year == 0 & comps.month == 0 & comps.day == 1;
}
/**
 *  判断某天是否是今天:注意比较是否是今天时，应该把后面的时分秒忽略掉
 */
- (BOOL)isToday:(NSDate *)date
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    //先将日期转化成自己想要的格式
    NSString *dateString = [formatter stringFromDate:date];
    NSString *nowString = [formatter stringFromDate:now];
    //date:2016-05-19 09:00:01 --->2016-05-19 00:00:00
    //now:2016-05-20 23:00:45 --->2016-05-20 00:00:00
    
    
    return [dateString isEqualToString:nowString];
}
/**
 *  截取source的有用的字符
 * source == <a href="http://app.weibo.com/t/feed/2llosp" rel="nofollow">OPPO_N1mini</a>
 */
- (void)setSource:(NSString *)source
{
    //是怕source中没有值
    if ([source isEqualToString:@""])
        return;

    // 正则表达式 NSRegularExpression
    // 截串 NSString
    NSRange range;
    range.location = [source rangeOfString:@">"].location + 1;
    range.length = [source rangeOfString:@"</"].location - range.location;
//    range.length = [source rangeOfString:@"<" options:NSBackwardsSearch].location - range.location;//反序
    
    _source = [NSString stringWithFormat:@"来自%@",[source substringWithRange:range]];
    
}
@end
