//
//  SettingsViewController.m
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-11-10.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *badEmailNumbers;

@property (strong, nonatomic) IBOutlet UIPickerView *goodEmailNumbers;

@property (strong, nonatomic) IBOutlet UITextField *principalEmailTextField;

@property (strong, nonatomic) NSArray *pickerData;

@property (strong, nonatomic) UITextField *activeField;

@property (strong, nonatomic) IBOutlet UILabel *ccLabel;



@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSFetchRequest *teacherFetch = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    NSError *error;
    self.teacher = [[self.managedObjectContext executeFetchRequest:teacherFetch error:&error] firstObject];

    self.pickerData = @[@"Off", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
    
    self.badEmailNumbers.delegate = self;
    self.goodEmailNumbers.delegate = self;
    self.principalEmailTextField.delegate = self;
    
//    [self.badEmailNumbers selectRow:2 inComponent:0 animated:NO];
//    [self.goodEmailNumbers selectRow:4 inComponent:0 animated:NO];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getRidOfKeyboard:)];
    
    [self.view addGestureRecognizer:tapGesture];
}


-(void)getRidOfKeyboard:(UITapGestureRecognizer*)tap
{
    [self.activeField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}


- (IBAction)savePrincipalEmail:(UIButton *)sender
{
    self.teacher.principalEmail = self.principalEmailTextField.text;
    NSError *error;
    [self.managedObjectContext save:&error];
    self.principalEmailTextField.text = @"";
    self.ccLabel.text = [NSString stringWithFormat:@"Currently CC'd to: %@", self.teacher.principalEmail];
}



-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerData.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.badEmailNumbers) {
        return self.pickerData[row];
    } else
    return self.pickerData[row];
  

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView == self.badEmailNumbers) {
        NSInteger numberForBadEmail = [self.badEmailNumbers selectedRowInComponent:component];
        NSLog(@"number for bad emails is %@", [self.pickerData objectAtIndex:numberForBadEmail]);
        self.teacher.limitForBadEmails = self.pickerData[numberForBadEmail];
        NSError *error;
        [self.managedObjectContext save:&error];
    } else if (pickerView == self.goodEmailNumbers) {
        NSInteger numberForGoodEmail = [self.goodEmailNumbers selectedRowInComponent:component];
        NSLog(@"number for good emails is %@", [self.pickerData objectAtIndex:numberForGoodEmail]);
        self.teacher.limitforGoodEmails = self.pickerData[numberForGoodEmail];
        NSError *error;
        [self.managedObjectContext save:&error];
    }

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
