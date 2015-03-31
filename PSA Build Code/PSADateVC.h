//
//  PSADateVC.h
//  PSA Build Code
//
//  Created by Dani on 12/1/13.
//  Copyright (c) 2013 TTLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSADateVC : UIViewController <UIPickerViewDelegate> {
    NSArray *contentsBuildPlants;
}


@property (nonatomic, strong) IBOutlet UILabel *lblResult;
@property (nonatomic, strong) IBOutlet UILabel *lblLocation;

@property (nonatomic, strong) IBOutlet UIDatePicker *pickerDateSelect;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerBuildPlant;

- (IBAction)dismissViewController;

- (IBAction)dateChanged:(id)sender;
- (void)handleDateInput:(NSDate *)date;

@end
