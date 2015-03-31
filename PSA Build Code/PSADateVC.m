//
//  PSADateVC.m
//  PSA Build Code
//
//  Created by Dani on 12/1/13.
//  Copyright (c) 2013 TTLabs. All rights reserved.
//

#import "PSADateVC.h"
#import "Consts.h"

@interface PSADateVC ()

@end

@implementation PSADateVC

@synthesize lblResult = _lblResult;
@synthesize pickerDateSelect = _pickerDateSelect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Load Build Plants
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Build Codes" ofType:@"plist"];
    NSDictionary *plistContents = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    contentsBuildPlants = [[NSArray alloc] initWithArray:[plistContents objectForKey:@"Build Codes"] copyItems:YES];
    
    _pickerBuildPlant.delegate = self;
    
    
    
    NSInteger damNumber = getDAMFromDate([NSDate date]);
    _lblResult.text = [NSString stringWithFormat:@"%d", damNumber];
    _pickerDateSelect.date = [NSDate date];
   
    
    NSString * title = [self pickerView:_pickerBuildPlant titleForRow:[_pickerBuildPlant selectedRowInComponent:0] forComponent:0];
    NSDictionary *buildPlantsDescription = [[NSDictionary alloc] initWithDictionary:[plistContents objectForKey:@"All"] copyItems:YES];
    _lblLocation.text = [buildPlantsDescription objectForKey:title];
}


- (IBAction)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)dateChanged:(id)sender {
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    [self handleDateInput:datePicker.date];
}

- (void)handleDateInput:(NSDate *)date {
    if (date != nil) {
        NSInteger damNumber = getDAMFromDate(date);
        _lblResult.text = [NSString stringWithFormat:@"%d", damNumber];
        //[_flipDAMNumber animateToValue:damNumber duration:1.50 completion:^(BOOL finished) { }];
    } else {
        _lblResult.text = @"0000";
        //[_flipDAMNumber animateToValue:0000 duration:1.50 completion:^(BOOL finished) { }];
    }
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger rowsNumber = 10;
    
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
    

    if (pickerView == _pickerBuildPlant) {
        NSString * title = [self pickerView:pickerView titleForRow:row forComponent:1];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Build Codes" ofType:@"plist"];
        NSDictionary *plistContents = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        NSDictionary *buildPlantsDescription = [[NSDictionary alloc] initWithDictionary:[plistContents objectForKey:@"All"] copyItems:YES];
        
        _lblLocation.text = [buildPlantsDescription objectForKey:title];
        
    }
}


@end
