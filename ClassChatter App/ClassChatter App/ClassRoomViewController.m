//
//  ClassRoomViewController.m
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-10-26.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import "ClassRoomViewController.h"
#import "StudentDeskCell.h"
#import "ClassInfoViewController.h"
#import "TemplateViewController.h"
#import "Student.h"
#import "Parent.h"
#import "Teacher.h"
#import "SchoolClass.h"
#import "Misbehaviour.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ClassRoomViewController () <UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate> 

@property (strong, nonatomic) IBOutlet UISegmentedControl *classSeg;

@property (strong, nonatomic) IBOutlet UICollectionView *studentCollectionView;

@property (strong, nonatomic) NSMutableArray *listOfStudents;

@property (strong, nonatomic) NSMutableArray *listOfParents;

@property (strong, nonatomic) NSMutableArray *listOfMisbehaviour;

@property (strong, nonatomic) NSMutableArray *listOfSchoolClasses;

@property (strong, nonatomic) NSMutableArray *currentClass;

@property (strong, nonatomic) NSArray *sortClass;

@property (strong, nonatomic) NSMutableArray *listOfTeachers;

@property (strong, nonatomic) TemplateViewController *templateViewController;

@property (strong, nonatomic) NSString *teacherEmailString;


@end

@implementation ClassRoomViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listOfTeachers = [[NSMutableArray alloc] init];
    NSFetchRequest *teacherFetch = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    NSError *error;
    [self.listOfTeachers addObjectsFromArray:[self.managedObjectContext executeFetchRequest:teacherFetch error:&error]];
    
    if (self.listOfTeachers.count == 0) {
        Teacher *aTeacher = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:self.managedObjectContext];
        
        aTeacher.emailAddress = @"Dear <Title> <Parent>,\n\nI wanted to inform you that <Student> disrupted class 3 times today. It would be greatly appreciated if you could please remind <Student> the importance of participating positively in class and being respectful to the teacher and other students. Thank you for your time and help.\n\nSincerely,\nYOUR NAME HERE\n\n\nSent via ClassChatter\nClassChatter - The Teacher Friendly Email Service";
        


        NSError *error;
        [self.managedObjectContext save:&error];
        
        NSFetchRequest *teacherFetch = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
        [self.listOfTeachers addObjectsFromArray:[self.managedObjectContext executeFetchRequest:teacherFetch error:&error]];
    }

    
    
    
    
    [self fetchStudentAndParentsAndMisbehaviourAndSchoolClasses];
    
    [self rebuildSegControl];
    
    [self.classSeg setSelectedSegmentIndex:0];
    [self classSelected:self.classSeg];
    

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSInteger selectedIndex = [self.classSeg selectedSegmentIndex];
    if (selectedIndex == -1) {
        [self.classSeg setSelectedSegmentIndex:0];
        selectedIndex = 0;
    }
    NSString *titleString = [self.classSeg titleForSegmentAtIndex:selectedIndex];
    NSInteger titleAsInt = [titleString integerValue];
    self.currentClass = [[NSMutableArray alloc] init];
    for (Student *student in self.listOfStudents) {
        if (student.schoolClass.grade.integerValue == titleAsInt) {
            [self.currentClass addObject:student];
        }
    }
    [self.studentCollectionView reloadData];
}




- (void)handleDataModelChange:(NSNotification *)note
{
        
    [self fetchStudentAndParentsAndMisbehaviourAndSchoolClasses];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"numberOfDisruptions" ascending:NO];
    self.sortClass = @[sort];
    
    [self.currentClass sortUsingDescriptors:self.sortClass];
    
    [self.studentCollectionView reloadData];
    
    [self rebuildSegControl];
}

#pragma mark - buttons and segs

- (IBAction)resetNumbers:(id)sender
{
    for (Student *aStudent in self.currentClass) {
        aStudent.numberOfDisruptions = 0;
    }
    [self.studentCollectionView reloadData];
    
    NSError *error;
    [self.managedObjectContext save:&error];
    
}


- (IBAction)classSelected:(UISegmentedControl *)sender {

    NSInteger grade = [[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] integerValue];
    self.currentClass = [[NSMutableArray alloc] init];
    for (Student *student in self.listOfStudents) {
        if (student.schoolClass.grade.integerValue == grade) {
            [self.currentClass addObject:student];
        }
    }
    [self.studentCollectionView reloadData];
}

- (void) rebuildSegControl;
{
    [self.classSeg removeAllSegments];
    
    if (self.listOfSchoolClasses.count > 0) {
        for (SchoolClass *schoolClass in self.listOfSchoolClasses) {
            [self.classSeg insertSegmentWithTitle:[NSString stringWithFormat:@"%@", schoolClass.grade] atIndex:0 animated:NO];
        }
    } else {
        [self.classSeg insertSegmentWithTitle:@"Class" atIndex:0 animated:true];
    }
}




#pragma mark - collectionview

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Misbehaviour *misbehaviour = [NSEntityDescription insertNewObjectForEntityForName:@"Misbehaviour" inManagedObjectContext:self.managedObjectContext];
    misbehaviour.time = [NSDate date];
    Student *theStudent = self.currentClass[indexPath.row];
    Parent *theParent = [theStudent.parents anyObject];
    [theStudent addMisbehaviourObject:misbehaviour];
    NSError *error;
    [self.managedObjectContext save:&error];
    
    NSInteger numberOfTaps = [theStudent.numberOfDisruptions integerValue];
    numberOfTaps = numberOfTaps + 1;
    NSNumber *newNumber = [NSNumber numberWithInteger:numberOfTaps];
    theStudent.numberOfDisruptions = newNumber;
    
    
    [self fetchStudentAndParentsAndMisbehaviourAndSchoolClasses];
    
    if (numberOfTaps == 3) {
        if ([MFMailComposeViewController canSendMail]) {
            
            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
            mailViewController.mailComposeDelegate = self;
            [mailViewController setSubject:@"Misbehaviour in class."];
            
            Teacher *theTeacher = [self.listOfTeachers firstObject];
            NSString *theResultString = theTeacher.emailAddress;
            theResultString = [theResultString stringByReplacingOccurrencesOfString:@"<Title>" withString:theParent.title];
            theResultString = [theResultString stringByReplacingOccurrencesOfString:@"<Parent>" withString:theParent.lastName];
            theResultString = [theResultString stringByReplacingOccurrencesOfString:@"<Student>" withString:theStudent.firstName];
            
            [mailViewController setMessageBody:[NSString stringWithFormat:@"%@", theResultString] isHTML:NO];
            
            [mailViewController setToRecipients:@[[NSString stringWithFormat:@"%@", theParent.emailAddress]]];
            
            [self presentViewController:mailViewController animated:YES completion:nil];
            
        }
        
        else {
            NSLog(@"Device can't send emails");
        }
        
        [self.managedObjectContext save:&error];
        
    }
}


-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error:(NSError*)error
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.currentClass.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StudentDeskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StudentDeskCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


-(void)configureCell:(StudentDeskCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    Student *student = self.currentClass[indexPath.row];
    cell.studentNameLabel.text = student.firstName;
    cell.numberOfDisruptionsLabel.text = [NSString stringWithFormat:@"%d", [student.numberOfDisruptions integerValue]];
    NSInteger numberOfTaps = [student.numberOfDisruptions integerValue];
    
    if (numberOfTaps == 1) {
        cell.backgroundColor = [UIColor yellowColor];
    } else if (numberOfTaps == 2) {
        cell.backgroundColor = [UIColor orangeColor];
    } else if (numberOfTaps >= 3) {
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor greenColor];
    }
    
    
    
}





#pragma mark - fetches

-(void)fetchStudentAndParentsAndMisbehaviourAndSchoolClasses
{
    self.listOfStudents = [[NSMutableArray alloc] init];
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"numberOfDisruptions" ascending:NO]];
    
    NSError *error;
    
    [self.listOfStudents addObjectsFromArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    
    
    self.listOfParents = [[NSMutableArray alloc] init];
    
    NSFetchRequest *parentFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Parent"];
//    parentFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"emailAddress" ascending:YES]];
    
    NSError *parentError;
    
    [self.listOfParents addObjectsFromArray:[self.managedObjectContext executeFetchRequest:parentFetchRequest error:&parentError]];
    
    
    
    self.listOfMisbehaviour = [[NSMutableArray alloc] init];
    
    NSFetchRequest *misbehaviourFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Misbehaviour"];
//    misbehaviourFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
    
    NSError *misbehaviourError;
    
    [self.listOfMisbehaviour addObjectsFromArray:[self.managedObjectContext executeFetchRequest:misbehaviourFetchRequest error:&misbehaviourError]];
    
    
    self.listOfSchoolClasses = [[NSMutableArray alloc] init];
    
    NSFetchRequest *schoolClassFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SchoolClass"];
//    schoolClassFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"grade" ascending:YES]];
    
    NSError *schoolClassError;
    
    [self.listOfSchoolClasses addObjectsFromArray:[self.managedObjectContext executeFetchRequest:schoolClassFetchRequest error:&schoolClassError]];
    
}

@end
