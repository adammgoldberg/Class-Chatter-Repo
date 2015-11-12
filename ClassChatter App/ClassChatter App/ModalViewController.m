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


@property (strong, nonatomic) IBOutlet UITextField *parentLastNameText;

@property (strong, nonatomic) IBOutlet UITextField *emailAddressText;

@property (strong, nonatomic) IBOutlet UITextField *studentClassText;

@property (strong, nonatomic) UITextField *activeField;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIButton *addStudentButton;



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
    self.parentLastNameText.delegate = self;
    
    self.addStudentButton.layer.cornerRadius = 12;
    self.addStudentButton.layer.masksToBounds = YES;
    
    [self.firstNameText becomeFirstResponder];
    
    [self registerForKeyboardNotifications];
    
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

#pragma mark - scrollview


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    CGSize size = CGSizeMake(self.view.frame.size.width, 500);
    self.scrollView.contentSize = size;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;

    
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y-kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
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
    parent.lastName = self.parentLastNameText.text;
    
//    NSInteger gradeInt = [self.studentClassText.text integerValue];
    NSString *gradeString = self.studentClassText.text;
    
    NSFetchRequest *fetchForSchoolClass = [NSFetchRequest fetchRequestWithEntityName:@"SchoolClass"];
    fetchForSchoolClass.predicate = [NSPredicate predicateWithFormat:@"section = %@", gradeString];
//    fetchForSchoolClass.predicate = [NSPredicate predicateWithFormat:@"grade = %@", gradeString];
    
    
    NSError *error;
    NSArray *schoolClassesArray = [self.managedObjectContext executeFetchRequest:fetchForSchoolClass error:&error];
    
    if (schoolClassesArray.count > 0) {
        student.schoolClass = [schoolClassesArray firstObject];
    } else {
        SchoolClass *schoolClass = [NSEntityDescription insertNewObjectForEntityForName:@"SchoolClass" inManagedObjectContext:self.managedObjectContext];
        schoolClass.section = gradeString;
        student.schoolClass = schoolClass;
    }
    
    student.parent = parent;

// BELOW IS PREVIOUS TEXT WHEN STUDENT PARENT RELATIONSHIP WAS ONE TO MANY
//    [student addParentsObject:parent];
    
    
    
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
    if ([textField isEqual:self.firstNameText]) {
        [self.lastNameText becomeFirstResponder];
    } else if ([textField isEqual:self.lastNameText]) {
        [self.studentClassText becomeFirstResponder];
    } else if ([textField isEqual:self.studentClassText]) {
        [self.parentTitleText becomeFirstResponder];
    } else if ([textField isEqual:self.parentTitleText]) {
        [self.parentLastNameText becomeFirstResponder];
    } else if ([textField isEqual:self.parentLastNameText]) {
        [self.emailAddressText becomeFirstResponder];
    }
    return YES;
}






@end
