//
//  ClassInfoViewController.m
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-10-26.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import "ClassInfoViewController.h"
#import "ClassInfoCell.h"
#import "Student.h"
#import "Parent.h"
#import "SchoolClass.h"
#import "ModalViewController.h"


@interface ClassInfoViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UIButton *addStudent;


@property (strong, nonatomic) IBOutlet UITableView *classInfoTableView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *classInfoSeg;

@property (strong, nonatomic) NSMutableArray *listOfStudents;

@property (strong, nonatomic) NSMutableArray *listOfParents;

@property (strong, nonatomic) NSMutableArray *listOfSchoolClasses;

@property (strong, nonatomic) NSMutableArray *currentInfoClass;

@property (strong, nonatomic) UIView *editView;

@property (strong, nonatomic) Student *student;

//@property (strong, nonatomic) Parent *parent;

@property (strong, nonatomic) UITextField *firstNameTextField;

@property (strong, nonatomic) UITextField *lastNameTextField;

//@property (strong, nonatomic) UITextField *classNameTextField;

@property (strong, nonatomic) UITextField *parentTitleTextField;

@property (strong, nonatomic) UITextField *parentLastNameTextField;

@property (strong, nonatomic) UITextField *parentEmailTextField;

@property (strong, nonatomic) UITextField *activeField;


@property (strong, nonatomic) IBOutlet UIButton *editClassButton;


@property (strong, nonatomic) IBOutlet UIButton *deleteClassButton;





@end

@implementation ClassInfoViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.classInfoTableView.delegate = self;
    self.deleteClassButton.hidden = YES;
    
    [self fetchStudentAndParentsAndClasses];
    
    [self rebuildInfoSegControl];
    
    [self.classInfoSeg setSelectedSegmentIndex:0];
    [self classInfoSelected:self.classInfoSeg];
    
    self.addStudent.layer.cornerRadius = 12;
    self.addStudent.layer.masksToBounds = YES;
    
//    self.classInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.classInfoTableView.separatorColor = [UIColor colorWithRed:96/255.0f green:174/255.0f blue:82/255.0f alpha:1];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
    
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSInteger selectedIndex = [self.classInfoSeg selectedSegmentIndex];
    if (selectedIndex == -1) {
        [self.classInfoSeg setSelectedSegmentIndex:0];
        selectedIndex = 0;
    }
    NSString *titleString = [self.classInfoSeg titleForSegmentAtIndex:selectedIndex];
    self.currentInfoClass = [[NSMutableArray alloc] init];
    for (Student *student in self.listOfStudents) {
        if (student.schoolClass.section == titleString) { [self.currentInfoClass addObject:student]; }
    }
    [self.classInfoTableView reloadData];
}



- (void)handleDataModelChange:(NSNotification *)note
{

    [self fetchStudentAndParentsAndClasses];
    
    [self.classInfoTableView reloadData];
    
    [self rebuildInfoSegControl];
}





#pragma mark - buttons


- (IBAction)classInfoSelected:(UISegmentedControl *)sender
{
//    NSInteger grade = [[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] integerValue];
    NSString *gradeTitle = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    self.currentInfoClass = [[NSMutableArray alloc] init];
    for (Student *student in self.listOfStudents) {
        if (student.schoolClass.section == gradeTitle) {
            [self.currentInfoClass addObject:student];
        }
    }
    [self.classInfoTableView reloadData];
}



- (void) rebuildInfoSegControl;
{
    [self.classInfoSeg removeAllSegments];
    if (self.listOfSchoolClasses.count > 0) {
        for (SchoolClass *schoolClass in self.listOfSchoolClasses) {
            [self.classInfoSeg insertSegmentWithTitle:schoolClass.section atIndex:0 animated:NO];
        }
    } else {
        [self.classInfoSeg insertSegmentWithTitle:@"Class" atIndex:0 animated:true];
    }
}



#pragma mark editview, buttons, and textfields


-(void)longTapGesture
{
    [self buildEditViewButtonsAndTextFields];
}


-(void)buildEditViewButtonsAndTextFields
{
    self.editView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMinY(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    self.editView.backgroundColor = [UIColor colorWithRed:96/255.0f green:174/255.0f blue:82/255.0f alpha:1];
    [self.view addSubview:self.editView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getRidOfKeyboard:)];
    
    [self.editView addGestureRecognizer:tapGesture];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.editView.bounds.origin.x + 20, self.editView.bounds.origin.y + 20, 60, 30)];
    closeButton.backgroundColor = [UIColor colorWithRed:96/255.0f green:174/255.0f blue:82/255.0f alpha:1];
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:28.0];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(removeTheView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.editView addSubview:closeButton];
    
    self.firstNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.editView.bounds) - 60, self.editView.bounds.origin.y + 80, 120, 30)];
    self.firstNameTextField.backgroundColor = [UIColor whiteColor];
    self.firstNameTextField.textAlignment = NSTextAlignmentCenter;
    self.firstNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.firstNameTextField.text = self.student.firstName;
    [self.editView addSubview:self.firstNameTextField];
    
    [self.firstNameTextField becomeFirstResponder];
    
    self.lastNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.editView.bounds) - 60, self.editView.bounds.origin.y + 120, 120, 30)];
    self.lastNameTextField.backgroundColor = [UIColor whiteColor];
    self.lastNameTextField.textAlignment = NSTextAlignmentCenter;
    self.lastNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.lastNameTextField.text = self.student.lastName;
    [self.editView addSubview:self.lastNameTextField];
    
    // THERE ARE ISSUES WHEN TRYING TO CHANGE THE CLASS... IT SCREWS UP THE OTHER STUDENTS CLASSES AND THE SEG CONTROL... DOESN'T SORT THEM... CAN PROBABLY BE FIXED BY LOOKING AT THE METHOD FOR SORTING KIDS INTO CLASSES BUT NOT NECESSARY FOR NOW
    //    self.classNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.editView.bounds.origin.x + 50, self.editView.bounds.origin.y + 160, 70, 30)];
    //    self.classNameTextField.backgroundColor = [UIColor whiteColor];
    //    self.classNameTextField.text = self.student.schoolClass.section;
    //    [self.editView addSubview:self.classNameTextField];
    
    self.parentTitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.editView.bounds) - 60, self.editView.bounds.origin.y + 160, 120, 30)];
    self.parentTitleTextField.backgroundColor = [UIColor whiteColor];
    self.parentTitleTextField.textAlignment = NSTextAlignmentCenter;
    self.parentTitleTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.parentTitleTextField.text = self.student.parent.title;
    [self.editView addSubview:self.parentTitleTextField];
    
    self.parentLastNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.editView.bounds) - 60, self.editView.bounds.origin.y + 200, 120, 30)];
    self.parentLastNameTextField.backgroundColor = [UIColor whiteColor];
    self.parentLastNameTextField.textAlignment = NSTextAlignmentCenter;
    self.parentLastNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.parentLastNameTextField.text = self.student.parent.lastName;
    [self.editView addSubview:self.parentLastNameTextField];
    
    
    self.parentEmailTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.editView.bounds) - 60, self.editView.bounds.origin.y + 240, 120, 30)];
    self.parentEmailTextField.backgroundColor = [UIColor whiteColor];
    self.parentEmailTextField.textAlignment = NSTextAlignmentCenter;
    self.parentEmailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.parentEmailTextField.text = self.student.parent.emailAddress;
    [self.editView addSubview:self.parentEmailTextField];
    
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.parentTitleTextField.delegate = self;
    self.parentLastNameTextField.delegate = self;
    self.parentEmailTextField.delegate = self;
    
    
    UIButton *saveChangesButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.editView.bounds) - 70, self.editView.bounds.origin.y + 320, 140, 30)];
    saveChangesButton.backgroundColor = [UIColor whiteColor];
    [saveChangesButton setTitle:@"Save Changes" forState:UIControlStateNormal];
    [saveChangesButton setTitleColor:[UIColor colorWithRed:96/255.0f green:174/255.0f blue:82/255.0f alpha:1] forState:UIControlStateNormal];
    [saveChangesButton addTarget:self action:@selector(saveChanges:) forControlEvents:UIControlEventTouchUpInside];
    saveChangesButton.layer.cornerRadius = 12;
    saveChangesButton.layer.masksToBounds = YES;
    
    [self.editView addSubview:saveChangesButton];
    
    self.editView.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.editView.alpha = 1;
    }];
    

    
    
}


-(void)getRidOfKeyboard:(UITapGestureRecognizer*)tap
{
    [self.activeField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.firstNameTextField]) {
        [self.lastNameTextField becomeFirstResponder];
    } else if ([textField isEqual:self.lastNameTextField]) {
        [self.parentTitleTextField becomeFirstResponder];
    } else if ([textField isEqual:self.parentTitleTextField]) {
        [self.parentLastNameTextField becomeFirstResponder];
    } else if ([textField isEqual:self.parentLastNameTextField]) {
        [self.parentEmailTextField becomeFirstResponder];

    }
    return YES;
}

-(void)removeTheView:(UIButton*)button
{
    [self.editView removeFromSuperview];

}

-(void)saveChanges:(UIButton*)button
{
    self.student.firstName = self.firstNameTextField.text;
    self.student.lastName = self.lastNameTextField.text;
//    self.student.schoolClass.section = self.classNameTextField.text;
    self.student.parent.title = self.parentTitleTextField.text;
    self.student.parent.lastName = self.parentLastNameTextField.text;
    self.student.parent.emailAddress = self.parentEmailTextField.text;
    
    NSError *error;
    [self.managedObjectContext save:&error];
    [self.classInfoTableView reloadData];
    
    [self.editView removeFromSuperview];
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showModal"]) {
        ModalViewController *modalvc = (ModalViewController*)[segue destinationViewController];
        modalvc.managedObjectContext = self.managedObjectContext;
    }
}




#pragma mark - tableview and swipe

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentInfoClass.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassInfoCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureCell:(ClassInfoCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    Student *student = self.currentInfoClass[indexPath.row];
    Parent *parent = student.parent;
    cell.studentFirstNameLabel.text = student.firstName;
    cell.studentLastNameLabel.text = student.lastName;
    cell.parentTitleLabel.text = parent.title;
    cell.parentEmailLabel.text = parent.emailAddress;
    cell.studentClassLabel.text = student.schoolClass.section;
    cell.parentLastLabel.text = parent.lastName;
//    cell.selectedBackgroundView = [[UIView alloc] init];
//    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];

    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Student *student = [self.currentInfoClass objectAtIndex:indexPath.row];
            SchoolClass *schoolClass = student.schoolClass;
            NSInteger amountOfStudents = schoolClass.students.count;
        
            [self.managedObjectContext deleteObject:[self.currentInfoClass objectAtIndex:indexPath.row]];
            [self.currentInfoClass removeObjectAtIndex:indexPath.row];
        
            if (amountOfStudents == 1) {
                [self.managedObjectContext deleteObject:schoolClass];
            }
        
        
        
            NSError *error;
            [self.managedObjectContext save:&error];
        
            [self fetchStudentAndParentsAndClasses];
            [self rebuildInfoSegControl];
            
            [self.classInfoTableView reloadData];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSLog(@"Tapped");
    
    if (!tableView.editing) {
            self.student = self.currentInfoClass[indexPath.row];
            [self buildEditViewButtonsAndTextFields];
            [self.classInfoTableView deselectRowAtIndexPath:indexPath animated:YES];
      
    }
}


- (IBAction)deleteClass:(UIButton *)sender {
 
    
    NSArray *studentToBeDeleted = [self.classInfoTableView.indexPathsForSelectedRows mutableCopy];
    
    SchoolClass *aSchoolClass = ((Student*)self.currentInfoClass[0]).schoolClass;
    NSMutableIndexSet *indicesToDelete = [NSMutableIndexSet indexSet];
    for (NSIndexPath *studentIndex in studentToBeDeleted) {
        Student *aStudent = self.currentInfoClass[studentIndex.row];
        [indicesToDelete addIndex:studentIndex.row];
        [self.managedObjectContext deleteObject:aStudent];
    }
    if (studentToBeDeleted.count == self.currentInfoClass.count) {
        [self.managedObjectContext deleteObject:aSchoolClass];
    }
    [self.currentInfoClass removeObjectsAtIndexes:indicesToDelete];
    
    [self.classInfoTableView deleteRowsAtIndexPaths:studentToBeDeleted withRowAnimation:UITableViewRowAnimationLeft];
    
    NSError *error;
    [self.managedObjectContext save:&error];
    
    [self.classInfoTableView reloadData];

    
}


- (IBAction)editClass:(UIButton *)sender {
    
    if (!self.classInfoTableView.editing) {
        [self.classInfoTableView setEditing:YES animated:YES];
        [self.editClassButton setTitle:@"Cancel" forState:UIControlStateNormal];
        self.deleteClassButton.hidden = NO;
    } else {
        [self.classInfoTableView setEditing:NO animated:YES];
        [self.editClassButton setTitle:@"Edit Class" forState:UIControlStateNormal];
        self.deleteClassButton.hidden = YES;
    }
    

    
    

    
}



//-(void)swiped:(UISwipeGestureRecognizer*)swipe
//{
//    CGPoint point = [swipe locationInView:self.classInfoTableView];
//    NSIndexPath *indexPath = [self.classInfoTableView indexPathForRowAtPoint:point];
//    
//    Student *student = [self.currentInfoClass objectAtIndex:indexPath.row];
//    SchoolClass *schoolClass = student.schoolClass;
//    NSInteger amountOfStudents = schoolClass.students.count;
//    
//    [self.managedObjectContext deleteObject:[self.currentInfoClass objectAtIndex:indexPath.row]];
//    [self.currentInfoClass removeObjectAtIndex:indexPath.row];
//    
//    if (amountOfStudents == 1) {
//        [self.managedObjectContext deleteObject:schoolClass];
//    }
//    
//    
//    
//    NSError *error;
//    [self.managedObjectContext save:&error];
//    
//    [self fetchStudentAndParentsAndClasses];
//    [self rebuildInfoSegControl];
//    
//    [self.classInfoTableView reloadData];
//}





#pragma mark - fetches

-(void)fetchStudentAndParentsAndClasses
{
    self.listOfStudents = [[NSMutableArray alloc] init];
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]];
    
    NSError *error;
    
    [self.listOfStudents addObjectsFromArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    
    
    self.listOfParents = [[NSMutableArray alloc] init];
    
    NSFetchRequest *parentFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Parent"];
//    parentFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"emailAddress" ascending:YES]];
    
    NSError *parentError;
    
    [self.listOfParents addObjectsFromArray:[self.managedObjectContext executeFetchRequest:parentFetchRequest error:&parentError]];
    
    
    self.listOfSchoolClasses = [[NSMutableArray alloc] init];
    
    NSFetchRequest *schoolClassFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SchoolClass"];
    //    schoolClassFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"grade" ascending:YES]];
    
    NSError *schoolClassError;
    
    [self.listOfSchoolClasses addObjectsFromArray:[self.managedObjectContext executeFetchRequest:schoolClassFetchRequest error:&schoolClassError]];
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
