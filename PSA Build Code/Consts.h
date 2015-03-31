//
//  Consts.h
//  PSA Build Code
//
//  Created by Dani on 12/1/13.
//  Copyright (c) 2013 TTLabs. All rights reserved.
//

#define DAM_START_DATE @"1976-11-08 00:00:00 +0000"


static NSDate* dateFromString(NSString* dateString) {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    //NSDate *myDate = [dateFormatter dateFromString: dateString];
    return [dateFormatter dateFromString: dateString];
}


static NSNumber* stringToNumber(NSString *string) {
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * resultNumber = [numberFormatter numberFromString:string];
    return resultNumber;
}

static inline NSInteger daysBetweenDates (NSDate *fromDateTime, NSDate *toDateTime)
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

static NSUInteger getDAMFromDate (NSDate *date) {
    NSDate *absoluteDate = dateFromString(DAM_START_DATE);
    return daysBetweenDates(absoluteDate, date);
}

