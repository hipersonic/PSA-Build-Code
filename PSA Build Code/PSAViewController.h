//
//  PSAViewController.h
//  PSA Build Code
//
//  Created by TTDani on 1/19/13.
//  Copyright (c) 2013 TTLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDFlipNumberView;

@interface PSAViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate>{
    NSArray *contentsBuildPlants;
    JDFlipNumberView *_flipDAMNumber;
    
    JDFlipNumberView *_flipDay;
    JDFlipNumberView *_flipMonth;
    JDFlipNumberView *_flipYear;
}


@property(nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, strong) IBOutlet UIView *viewDam;
@property (nonatomic, strong) IBOutlet UIView *viewDate;

@property (nonatomic, strong) IBOutlet UILabel *lblResult;
@property (nonatomic, strong) IBOutlet UILabel *lblLocation;

@property (nonatomic, strong) IBOutlet UIDatePicker *pickerDateSelect;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerDAM;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerBuildPlant;

//- (IBAction)btnPressed:(id)sender;
- (IBAction)segmentedControlChanged:(id)sender;
- (IBAction)dateChanged:(id)sender;

@end

