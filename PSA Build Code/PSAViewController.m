//
//  PSAViewController.m
//  PSA Build Code
//
//  Created by TTDani on 1/19/13.
//  Copyright (c) 2013 TTLabs. All rights reserved.
//


#define segmentedIndexViewDam 0
#define segmentedIndexViewDate  1

#import "PSAViewController.h"
#import "JDFlipNumberView.h"
#import <QuartzCore/QuartzCore.h>
#import "Consts.h"

@interface PSAViewController ()

@end

@implementation PSAViewController


@synthesize viewDam, segmentedControl, lblResult;
@synthesize viewDate = _viewDate;
@synthesize pickerDateSelect = _pickerDate;
@synthesize pickerBuildPlant = _pickerBuildPlant;
@synthesize pickerDAM = _pickerDAM;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

    //Load Build Plants
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Build Codes" ofType:@"plist"];
    NSDictionary *plistContents = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    contentsBuildPlants = [[NSArray alloc] initWithArray:[plistContents objectForKey:@"Build Codes"] copyItems:YES];

    NSString * title = [self pickerView:_pickerBuildPlant titleForRow:[_pickerBuildPlant selectedRowInComponent:0] forComponent:0];
    NSDictionary *buildPlantsDescription = [[NSDictionary alloc] initWithDictionary:[plistContents objectForKey:@"All"] copyItems:YES];
    _lblLocation.text = [buildPlantsDescription objectForKey:title];
    
    _flipDAMNumber = [[JDFlipNumberView alloc] initWithDigitCount:5];
    _flipDAMNumber.value = 00000;
    _flipDAMNumber.frame = CGRectInset(self.view.bounds, 20, 20);
    _flipDAMNumber.center = CGPointMake(floor(self.view.frame.size.width/2),
                                  floor((self.view.frame.size.height/2)*0.5));
    //[self.view addSubview: _flipDAMNumber];
    
    

    /*
    
    _flipDay = [[JDFlipNumberView alloc] initWithDigitCount:2];
    _flipDay.value = 00;
    _flipDay.frame = CGRectMake(0, 0, 80, 80);
    _flipDay.center = CGPointMake(36, 0);
    //[_viewDate addSubview: _flipDay];
    
    _flipMonth = [[JDFlipNumberView alloc] initWithDigitCount:2];
    _flipMonth.value = 00;
    _flipMonth.frame = CGRectMake(0, 0, 80, 80);
    _flipMonth.center = CGPointMake(11.5, 0);
    //[_viewDate addSubview: _flipMonth];
    
    _flipYear = [[JDFlipNumberView alloc] initWithDigitCount:4];
    _flipYear.value = 0000;
    _flipYear.frame = CGRectMake(0, 0, 160, 80);
    _flipYear.center = CGPointMake(-90, 0);
    //[_viewDate addSubview: _flipYear];
    
    //Update Flipviews for the selection of DAM picker
    
     */
    NSInteger DAMNumber = [self getDAMPickerSelection];
    [self handleDAMinput:DAMNumber animated:NO];
}

-(IBAction)segmentedControlChanged:(id)sender {
    lblResult.text = @"";
    
    if (segmentedControl.selectedSegmentIndex == segmentedIndexViewDam) {
        //toggle the correct view to be visible
        
        //Update Flipviews for the selection of DAM picker
        NSInteger DAMNumber = [self getDAMPickerSelection];
        [self handleDAMinput:DAMNumber animated:NO];
        
        _viewDate.hidden = NO;
        
        _pickerDate.hidden = YES;
        _flipDAMNumber.hidden = YES;
        
        _pickerDAM.hidden = NO;
        lblResult.hidden = NO;
    } else {
        //toggle the correct view to be visible
        [_flipDAMNumber setValue:getDAMFromDate(_pickerDate.date) animated:NO];
        _pickerDate.hidden = NO;
        _flipDAMNumber.hidden = NO;
        _viewDate.hidden = YES;
        
        _pickerDAM.hidden = YES;
        lblResult.hidden = YES;
    }
     
}

- (void)handleDAMinput:(NSInteger)damNumber animated:(BOOL)animated{
    
    if (damNumber < 24856) {
        NSDate *absoluteDate = dateFromString(DAM_START_DATE);
        NSDate *resultDate = [absoluteDate dateByAddingTimeInterval:60*60*24*damNumber];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"dd MM yyyy"];
        //[formatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        NSString *stringFromDate = [dateFormatter stringFromDate:resultDate];
        
        [self setDateFlipViewsToDate:resultDate animated:animated];
        
        lblResult.text = stringFromDate;
    } else {
        //Number is not appropriate
        NSDate *dateNow = [NSDate new];
        [self setDateFlipViewsToDate:dateNow animated:animated];
    }
}

- (void)handleDateInput:(NSDate *)date {
    if (date != nil) {
        //NSInteger damNumber = [PSAViewController getDAMFromDate:date];
        NSInteger damNumber = getDAMFromDate(date);
        [_flipDAMNumber animateToValue:damNumber duration:1.50 completion:^(BOOL finished) { }];
    } else {
        [_flipDAMNumber animateToValue:0000 duration:1.50 completion:^(BOOL finished) { }];
    }
}

#pragma mark - Convertors
/*
+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    //NSDate *myDate = [dateFormatter dateFromString: dateString];
    return [dateFormatter dateFromString: dateString];
}

+ (NSNumber *)stringToNumber:(NSString *)string {
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * resultNumber = [numberFormatter numberFromString:string];
    return resultNumber;
}

+ (NSUInteger)getDAMFromDate:(NSDate *)date {
    NSDate *absoluteDate = [PSAViewController dateFromString:DAM_START_DATE];
    return [PSAViewController daysBetweenDate:absoluteDate andDate:date];
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
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


*/

#pragma mark - PICKERVIEW methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger numberOfComponents = 1;
    
    if (pickerView == _pickerDAM) {
        numberOfComponents = 5;
    }
    
    return numberOfComponents;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger rowsNumber = 10;
    
    if (pickerView == _pickerDAM && component == 0) {
        rowsNumber = 2;
    }
    
    if (pickerView == _pickerBuildPlant) {
        rowsNumber = [contentsBuildPlants count];
    }
    
    return rowsNumber;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *result = [NSString stringWithFormat:@"%d", row];
    
    if (contentsBuildPlants == nil || [contentsBuildPlants count] == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Build Codes" ofType:@"plist"];
        NSDictionary *plistContents = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        contentsBuildPlants = [[NSArray alloc] initWithArray:[plistContents objectForKey:@"Build Codes"] copyItems:YES];
    }
    
    if (pickerView == _pickerBuildPlant) {
        result = [contentsBuildPlants objectAtIndex:row];
    }
    return result;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView == _pickerDAM) {
        NSInteger DAMNumber = [self getDAMPickerSelection];
        [self handleDAMinput:DAMNumber animated:YES];
    }
    
    if (pickerView == _pickerBuildPlant) {
        NSString * title = [self pickerView:pickerView titleForRow:row forComponent:1];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Build Codes" ofType:@"plist"];
        NSDictionary *plistContents = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        NSDictionary *buildPlantsDescription = [[NSDictionary alloc] initWithDictionary:[plistContents objectForKey:@"All"] copyItems:YES];

        _lblLocation.text = [buildPlantsDescription objectForKey:title];
    }
}

- (IBAction)dateChanged:(id)sender {
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    [self handleDateInput:datePicker.date];
}

- (NSUInteger)getDAMPickerSelection {
    NSInteger DAMNumber = 0;
    
    //Get picker value
    for(NSUInteger i = 0; i < 5; ++i) {
        NSUInteger selectedRow = [_pickerDAM selectedRowInComponent:i];
        //NSString * title = [[pickerView delegate] pickerView:myPickerView titleForRow:selectedRow inComponent:i];
        //[text appendFormat:@"Selected item \"%@\" in component %lu\n", title, i];
        
        NSUInteger degree = 4-i;
        NSInteger multiplier = pow(10, degree);
        DAMNumber += selectedRow * multiplier;
    }
    return DAMNumber;
}

- (void)setDateFlipViewsToDate:(NSDate *)targetDate animated:(BOOL)animated {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:targetDate]; // Get necessary date components
    
    NSInteger month = [components month]; //gives you month
    NSInteger day   = [components day]; //gives you day
    NSInteger year  = [components year]; // gives you year
    
    if (animated) {
        [_flipDay animateToValue:day duration:1.5];
        [_flipMonth animateToValue:month duration:1.5];
        [_flipYear animateToValue:year duration:1.5];
    } else {
        [_flipDay setValue:day animated:NO];
        [_flipMonth setValue:month animated:NO];
        [_flipYear setValue:year animated:NO];
    }
    
}


#pragma mark - Validators
/*
 - (void)handleTextFieldValidation:(UITextField *)textfield forValidationState:(BOOL)isValid {
 if (isValid) {
 // The input is valid
 textfield.backgroundColor = [UIColor greenColor];
 textfield.textColor = [UIColor whiteColor];
 } else {
 // The input is invalid so alert the user in some way
 textfield.backgroundColor = [UIColor whiteColor];
 textfield.textColor = [UIColor blackColor];
 }
 }
 
 - (BOOL)validateInputYear:(id)sender {
 BOOL isValid = YES;
 
 if (!([tfYear.text hasPrefix:@"1"] || [tfYear.text hasPrefix:@"2"])) {
 isValid = NO;
 }
 
 if (tfYear.text.length != 4) {
 isValid = NO;
 }
 
 [self handleTextFieldValidation:tfYear forValidationState:isValid];
 
 return isValid;
 }
 
 - (BOOL)validateInputMonth:(id)sender {
 BOOL isValid = YES;
 
 NSNumber * monthNumber = [PSAViewController stringToNumber:tfMonth.text];
 if ([monthNumber integerValue] < 1 || [monthNumber integerValue] > 12) {
 isValid = NO;
 }
 
 [self validateAndCorrectInputDayForMonth];
 [self handleTextFieldValidation:tfMonth forValidationState:isValid];
 
 return isValid;
 }
 
 - (BOOL)validateInputDay:(id)sender {
 BOOL isValid = YES;
 
 NSNumber * dayNumber = [PSAViewController stringToNumber:tfDay.text];
 if ([dayNumber integerValue] < 1 || [dayNumber integerValue] > 31) {
 isValid = NO;
 }
 
 [self validateAndCorrectInputDayForMonth];
 [self handleTextFieldValidation:tfDay forValidationState:isValid];
 
 
 
 return isValid;
 }
 
 - (void)validateAndCorrectInputDayForMonth {
 
 if (tfDay.text == nil || tfMonth == nil) {
 return;
 }
 
 NSInteger dayNumber = [[PSAViewController stringToNumber:tfDay.text] integerValue];
 NSInteger monthNumber = [[PSAViewController stringToNumber:tfMonth.text] integerValue];
 
 NSInteger maxPossibleDays = [PSAViewController daysInMonth:monthNumber];
 
 if (monthNumber == 2 && dayNumber > 28) {
 NSLog(@"AHAAA CHEATING?");
 }
 
 if (dayNumber > maxPossibleDays) {
 tfDay.text = [NSString stringWithFormat:@"%d", maxPossibleDays];
 }
 }
 
 //jan 31   feb 28   mar 31   apr 30   may 31   jun 30 jul 31   aug 31   sep 30   oct 31   nov 30   dec 31
 + (NSInteger)daysInMonth:(NSInteger)monthIndex {
 switch (monthIndex) {
 case 1:
 return 31;
 case 2:
 return 28;
 case 3:
 return 31;
 case 4:
 return 30;
 case 5:
 return 31;
 case 6:
 return 30;
 case 7:
 return 31;
 case 8:
 return 31;
 case 9:
 return 30;
 case 10:
 return 31;
 case 11:
 return 30;
 case 12:
 return 31;
 default:
 return 28;
 }
 }
 */
@end
