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

@property (strong, nonatomic) UIView *informationView;

@property (strong, nonatomic) IBOutlet UIButton *saveEmailButton;

@property (strong, nonatomic) IBOutlet UIButton *showMoreButton;



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
    
    self.saveEmailButton.layer.cornerRadius = 10;
    self.saveEmailButton.layer.masksToBounds = YES;
    
    self.showMoreButton.layer.cornerRadius = 10;
    self.showMoreButton.layer.masksToBounds = YES;
    
    [self.badEmailNumbers selectRow:3 inComponent:0 animated:NO];
    [self.goodEmailNumbers selectRow:5 inComponent:0 animated:NO];
    
    if (self.teacher.principalEmail != nil) {
        self.ccLabel.text = [NSString stringWithFormat:@"Currently CC'd to: %@", self.teacher.principalEmail];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getRidOfKeyboard:)];
    
    [self.view addGestureRecognizer:tapGesture];
}


- (IBAction)showInformation:(UIButton *)sender {
    self.informationView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.informationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.informationView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.informationView.bounds.origin.x, self.informationView.bounds.origin.y, self.informationView.bounds.size.width, self.informationView.bounds.size.height)];
    CGSize size = CGSizeMake(self.informationView.frame.size.width, 1500);
    scrollView.contentSize = size;
    
    [self.informationView addSubview:scrollView];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.informationView.bounds.origin.x + 20, self.informationView.bounds.origin.y + 35, 20, 20)];
    closeButton.backgroundColor = [UIColor colorWithRed:96/255.0f green:174/255.0f blue:82/255.0f alpha:1];
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:24.0];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(removeInformation:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.informationView addSubview:closeButton];
    
    float multiplier;
    if (self.informationView.bounds.size.height < 575) {
        multiplier = 2.3;
    } else if (self.informationView.bounds.size.height > 575 && self.informationView.bounds.size.height < 680) {
        multiplier = 1.8;
    }
    else {
        multiplier = 1.4;
    }
    
    
//    iPhone 6: 1334h * 750w @2x (in points: 667h * 375w)
//    iPhone 6+: 1920 * 1080 @3x (in points: 640h * 360w)
//    nstead of 568.f like it should be on a 4-inch device.
    
    
    UILabel *informationLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.informationView.bounds.origin.x + 20, CGRectGetMaxY(closeButton.frame) + 10, self.informationView.bounds.size.width - 40, self.informationView.bounds.size.height * multiplier)];
    informationLabel.numberOfLines = 250;
    informationLabel.backgroundColor = [UIColor whiteColor];
    informationLabel.textColor = [UIColor colorWithRed:96/255.0f green:174/255.0f blue:82/255.0f alpha:1];
    informationLabel.text = @"Welcome to ClassTrack! Our aim is to help save you time as a teacher!\n\nBelow is information to help you use the app.\n\n1. Sending emails:\nIf you want to send an email to a parent, simply tap on the 📝 (for Homework related issues), 😇 (represents positive behaviour in class), 📞 (for arranging phone calss), 😡 (represents poor behaviour in class) on a 'student desk' found in the Classroom page.\n\n2. Adding Students and Classes:\nIf you want to add a student or a class, simply press the 'Add Student' button and type in student, class, and parent information. When you want to add a new class, just type in the new class name and the app will create a new class for you. The app uses this information to automatically fill in emails and save you time! This information is kept secure and private on the app and stored on your phone.\n\n3. History:\nAnytime you tap 📝, 😇, 📞, or 😡, the event is recorded and stored on the history page. You can click on the events and add notes to it for future reference.\n\n4. Templates:\nIn the Templates section, you can customize the email templates that you send to parents. The placeholders will be automatically populated with the information you provided for each student and parent.\n\n5. Settings:\nHere you can customize the amount of 'good taps' and 'bad taps' before an email is automatically populated and prepared to send. You can select a number, or turn off the ability to send emails and simply use the app to record behaviour in class. You can also put in your Principal's email address if you would like him or her to be CC'd on the emails that are sent out.\n\n6. Your Email Account:\nThe app works in conjunction with your phone's Mail App. If you have multiple email accounts in your mail app, you can select which account is sending the emails. Simply go to 'Settings' -> 'Mail, Contacts, Calendars' -> 'Default Account' and select which email account you want the app to use.";
    // There are numbers that indicate the amount of swipes up or swipes down that you've done so far and the background colour of the student desk changes as well to help you keep track of student behaviour
    
    [scrollView addSubview:informationLabel];
    

    
    self.informationView.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.informationView.alpha = 1;
    }];
    
}


-(void)removeInformation:(UIButton*)button
{
    [self.informationView removeFromSuperview];
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
