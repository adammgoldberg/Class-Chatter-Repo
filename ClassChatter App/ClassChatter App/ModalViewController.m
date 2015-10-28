//
//  ModalViewController.m
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-10-26.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import "ModalViewController.h"
#import "Student.h"
#import "Parent.h"
#import "SchoolClass.h"

@interface ModalViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *firstNameText;

@property (strong, nonatomic) IBOutlet UITextField *lastNameText;

@property (strong, nonatomic) IBOutlet UITextField *parentTitleText;

@property (strong, nonatomic) IBOutlet UITextField *emailAddressText;

@property (strong, nonatomic) IBOutlet UITextField *studentClassText;



@end

@implementation ModalViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.firstNameText.delegate = self;
    self.lastNameText.delegate = self;
    self.parentTitleText.delegate = self;
    self.emailAddressText.delegate = self;
    self.studentClassText.delegate = self;
    
}

#pragma mark - buttons and text

- (IBAction)cancelAdd:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)addAStudent:(id)sender
{
    Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    student.firstName = self.firstNameText.text;
    student.lastName = self.lastNameText.text;
    
    Parent *parent = [NSEntityDescription insertNewObjectForEntityForName:@"Parent" inManagedObjectContext:self.managedObjectContext];
    parent.title = self.parentTitleText.text;
    parent.emailAddress = self.emailAddressText.text;
    
    NSInteger gradeInt = [self.studentClassText.text integerValue];
    
    NSFetchRequest *fetchForSchoolClass = [NSFetchRequest fetchRequestWithEntityName:@"SchoolClass"];
    fetchForSchoolClass.predicate = [NSPredicate predicateWithFormat:@"grade = %@", @(gradeInt)];
    
    
    NSError *error;
    NSArray *schoolClassesArray = [self.managedObjectContext executeFetchRequest:fetchForSchoolClass error:&error];
    
    if (schoolClassesArray.count > 0) {
        student.schoolClass = [schoolClassesArray firstObject];
    } else {
        SchoolClass *schoolClass = [NSEntityDescription insertNewObjectForEntityForName:@"SchoolClass" inManagedObjectContext:self.managedObjectContext];
        schoolClass.grade = @(gradeInt);
        student.schoolClass = schoolClass;
    }
    
    
    
    [student addParentsObject:parent];
    
    
    
    [self.managedObjectContext save:&error];
    
    self.firstNameText.text = @"";
    self.lastNameText.text = @"";
    self.parentTitleText.text = @"";
    self.emailAddressText.text = @"";
    self.studentClassText.text = @"";
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}






@end
