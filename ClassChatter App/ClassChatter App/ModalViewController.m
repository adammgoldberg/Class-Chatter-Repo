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

@interface ModalViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *firstNameText;

@property (strong, nonatomic) IBOutlet UITextField *lastNameText;

@property (strong, nonatomic) IBOutlet UITextField *parentTitleText;

@property (strong, nonatomic) IBOutlet UITextField *emailAddressText;


@property (strong, nonatomic) IBOutlet UITextField *studentClassText;



@end

@implementation ModalViewController


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
    
    [student addParentsObject:parent];
    
    NSError *error;
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



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.firstNameText.delegate = self;
    self.lastNameText.delegate = self;
    self.parentTitleText.delegate = self;
    self.emailAddressText.delegate = self;
    self.studentClassText.delegate = self;
    
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
