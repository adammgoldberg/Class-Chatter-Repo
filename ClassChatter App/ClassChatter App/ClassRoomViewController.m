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
#import "Behaviour.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ClassRoomViewController () <UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate> 

@property (strong, nonatomic) IBOutlet UIButton *resetButton;

@property (strong, nonatomic) IBOutlet UISegmentedControl *classSeg;

@property (strong, nonatomic) IBOutlet UICollectionView *studentCollectionView;

@property (strong, nonatomic) NSMutableArray *listOfStudents;

@property (strong, nonatomic) NSMutableArray *listOfParents;

@property (strong, nonatomic) NSMutableArray *listOfBehaviour;

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
        
        aTeacher.emailTemplateBad = @"Dear <Title> <Parent>,\n\nI wanted to inform you that <Student> disrupted class <Selected Number> times today. It would be greatly appreciated if you could please remind <Student> the importance of participating positively in class and being respectful to the teacher and other students. Thank you for your time and help.\n\nSincerely,\nYOUR NAME HERE\n\n\nSent via ClassChatter\nClassChatter - The Teacher Friendly Email Service";
        
        aTeacher.emailTemplateGood = @"Dear <Title> <Parent>,\n\nI wanted to inform you that <Student> did  extremely well in class today. <Student> was engaged, respectful, and contributed positively to the classroom environment. It is a pleasure to teach when students are so participatory! I hope all is well with you and the rest of your family. Have a great day!\n\nSincerely,\nYOUR NAME HERE\n\n\nSent via ClassChatter\nClassChatter - The Teacher Friendly Email Service";
        
        aTeacher.limitForBadEmails = [NSString stringWithFormat:@"%@", @"3"];
        aTeacher.limitforGoodEmails = [NSString stringWithFormat:@"%@", @"5"];
        


        NSError *error;
        [self.managedObjectContext save:&error];
        
        NSFetchRequest *teacherFetch = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
        [self.listOfTeachers addObjectsFromArray:[self.managedObjectContext executeFetchRequest:teacherFetch error:&error]];
    }

    self.resetButton.layer.cornerRadius = 12;
    self.resetButton.layer.masksToBounds = YES;
    

    
    
    [self fetchStudentAndParentsAndBehaviourAndSchoolClasses];
    
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
    self.currentClass = [[NSMutableArray alloc] init];
    for (Student *student in self.listOfStudents) {
        if (student.schoolClass.section == titleString) {
            [self.currentClass addObject:student];
        }
    }
    [self.studentCollectionView reloadData];
}




- (void)handleDataModelChange:(NSNotification *)note
{
        
    [self fetchStudentAndParentsAndBehaviourAndSchoolClasses];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"numberOfDisruptions" ascending:NO];
    self.sortClass = @[sort];
    
    [self.currentClass sortUsingDescriptors:self.sortClass];
    
    [self.studentCollectionView reloadData];
    
    [self rebuildSegControl];
}

#pragma mark - buttons and segs

- (IBAction)resetNumbers:(UIButton *)sender
{
    for (Student *aStudent in self.currentClass) {
        aStudent.numberOfDisruptions = 0;
        aStudent.numberOfPositives = 0;
    }
    [self.studentCollectionView reloadData];
    
    NSError *error;
    [self.managedObjectContext save:&error];
    
}


- (IBAction)classSelected:(UISegmentedControl *)sender {

    NSString *gradeTitle = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    self.currentClass = [[NSMutableArray alloc] init];
    for (Student *student in self.listOfStudents) {
        if (student.schoolClass.section == gradeTitle) {
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
            [self.classSeg insertSegmentWithTitle:schoolClass.section atIndex:0 animated:NO];
        }
    } else {
        [self.classSeg insertSegmentWithTitle:@"Class" atIndex:0 animated:true];
    }
}




#pragma mark - collectionview




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
    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:recognizer];
    }
    
    Student *student = self.currentClass[indexPath.row];
    Teacher *theTeacher = [self.listOfTeachers firstObject];
    cell.studentNameLabel.text = student.firstName;
    cell.numberOfDisruptionsLabel.text = [NSString stringWithFormat:@"%ld / %ld", [student.numberOfDisruptions integerValue], [theTeacher.limitForBadEmails integerValue]];
    cell.numberOfGoodsLabel.text = [NSString stringWithFormat:@"%ld / %ld", [student.numberOfPositives integerValue], [theTeacher.limitforGoodEmails integerValue]];
    CGFloat numberOfSwipes = [student.numberOfDisruptions integerValue];
    cell.tag = indexPath.row;
    cell.layer.cornerRadius = 15;
    cell.layer.masksToBounds = YES;
        
    if ((numberOfSwipes > 0) && (numberOfSwipes <= (1.0/3.0 * [theTeacher.limitForBadEmails integerValue]))) {
        cell.backgroundColor = [UIColor colorWithRed:214/255.0f green:214/255.0f blue:0/255.0f alpha:1];
    } else if ((numberOfSwipes > (1.0/3.0 * [theTeacher.limitForBadEmails integerValue])) && (numberOfSwipes <= (2.0/3.0 * [theTeacher.limitForBadEmails integerValue]))) {
        cell.backgroundColor = [UIColor orangeColor];
    } else if (numberOfSwipes > (2.0/3.0 * [theTeacher.limitForBadEmails integerValue])) {
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor colorWithRed:47/255.0f green:187/255.0f blue:48/255.0f alpha:1];
    }

    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(badSwipe:)];
    [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [cell addGestureRecognizer:downSwipe];
    
    UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goodSwipe:)];
    [upSwipe setDirection:UISwipeGestureRecognizerDirectionUp];
    [cell addGestureRecognizer:upSwipe];
    
    
}


-(void)badSwipe:(UISwipeGestureRecognizer*)swipe
{

//INSTEAD OF USING TAGS, I COULD USE THE LOCATION OF THE SWIPE
//    CGPoint location = [swipe locationInView:self.studentCollectionView];
//    NSIndexPath *swipedIndexPath = [self.studentCollectionView indexPathForItemAtPoint:location];
//    StudentDeskCell
//    CGPoint location = [gesture locationInView:tableView];
//    NSIndexPath *swipedIndexPath = [tableView indexPathForRowAtPoint:location];
//    UITableViewCell *swipedCell  = [tableView cellForRowAtIndexPath:swipedIndexPath];
    
    
    NSLog(@"bad swipe");
    Behaviour *misbehaviour = [NSEntityDescription insertNewObjectForEntityForName:@"Behaviour" inManagedObjectContext:self.managedObjectContext];
    misbehaviour.time = [NSDate date];
    Student *theStudent = self.currentClass[swipe.view.tag];
    Parent *theParent = [theStudent.parents anyObject];
    [theStudent addBehaviourObject:misbehaviour];
    NSError *error;
    [self.managedObjectContext save:&error];
    
    NSInteger numberOfBadSwipes = [theStudent.numberOfDisruptions integerValue];
    numberOfBadSwipes = numberOfBadSwipes + 1;
    NSNumber *newNumber = [NSNumber numberWithInteger:numberOfBadSwipes];
    theStudent.numberOfDisruptions = newNumber;
    
    
    [self fetchStudentAndParentsAndBehaviourAndSchoolClasses];
    

    Teacher *theTeacher = [self.listOfTeachers firstObject];
    
    if (![theTeacher.limitForBadEmails isEqualToString:@"Off"]) {
        
        if (numberOfBadSwipes == [theTeacher.limitForBadEmails integerValue]) {
            if ([MFMailComposeViewController canSendMail]) {
                
                MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
                mailViewController.mailComposeDelegate = self;
                [mailViewController setSubject:@"Misbehaviour in class."];
                NSString *theResultString = theTeacher.emailTemplateBad;
                theResultString = [theResultString stringByReplacingOccurrencesOfString:@"<Title>" withString:theParent.title];
                theResultString = [theResultString stringByReplacingOccurrencesOfString:@"<Parent>" withString:theParent.lastName];
                theResultString = [theResultString stringByReplacingOccurrencesOfString:@"<Student>" withString:theStudent.firstName];
                theResultString = [theResultString stringByReplacingOccurrencesOfString:@"<Selected Number>" withString:theTeacher.limitForBadEmails];
                
                
                
                [mailViewController setMessageBody:[NSString stringWithFormat:@"%@", theResultString] isHTML:NO];
                
                if (theTeacher.principalEmail != nil) {
                [mailViewController setToRecipients:@[[NSString stringWithFormat:@"%@", theParent.emailAddress], [NSString stringWithFormat:@"%@", theTeacher.principalEmail]]];
                } else
                [mailViewController setToRecipients:@[[NSString stringWithFormat:@"%@", theParent.emailAddress]]];
                
                [self presentViewController:mailViewController animated:YES completion:nil];
                
            }
            
        }
        
        else {
            NSLog(@"Device can't send emails");
        }
        
        [self.managedObjectContext save:&error];
    }
    
    else {
        NSLog(@"Emails have been turned off by you");
    }

}

-(void)goodSwipe:(UISwipeGestureRecognizer*)swipe
{
    NSLog(@"goodswipe");
    Behaviour *goodBehaviour = [NSEntityDescription insertNewObjectForEntityForName:@"Behaviour" inManagedObjectContext:self.managedObjectContext];
    goodBehaviour.time = [NSDate date];
    goodBehaviour.type = @"good";
    Student *theStudent = self.currentClass[swipe.view.tag];
    Parent *theParent = [theStudent.parents anyObject];
    [theStudent addBehaviourObject:goodBehaviour];
    NSError *error;
    [self.managedObjectContext save:&error];
    
    NSInteger numberOfGoodSwipes = [theStudent.numberOfPositives integerValue];
    numberOfGoodSwipes = numberOfGoodSwipes + 1;
    NSNumber *goodNumber = [NSNumber numberWithInteger:numberOfGoodSwipes];
    theStudent.numberOfPositives = goodNumber;
    
    
    [self fetchStudentAndParentsAndBehaviourAndSchoolClasses];
    
    Teacher *theTeacher = [self.listOfTeachers firstObject];
    if (![theTeacher.limitforGoodEmails isEqualToString:@"Off"]) {

        if (numberOfGoodSwipes == [theTeacher.limitforGoodEmails integerValue]) {
            if ([MFMailComposeViewController canSendMail]) {
                
                MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
                mailViewController.mailComposeDelegate = self;
                [mailViewController setSubject:@"Good behaviour in class."];
                
                
                NSString *theResultString = theTeacher.emailTemplateGood;
                theResultString = [theResultString stringByReplacingOccurrencesOfString:@"<Title>" withString:theParent.title];
                theResultString = [theResultString stringByReplacingOccurrencesOfString:@"<Parent>" withString:theParent.lastName];
                theResultString = [theResultString stringByReplacingOccurrencesOfString:@"<Student>" withString:theStudent.firstName];
                
                [mailViewController setMessageBody:[NSString stringWithFormat:@"%@", theResultString] isHTML:NO];
                
                [mailViewController setToRecipients:@[[NSString stringWithFormat:@"%@", theParent.emailAddress], theTeacher.principalEmail]];
                
                [self presentViewController:mailViewController animated:YES completion:nil];
                
            }
            
        }
        
        else {
            NSLog(@"Device can't send emails");
        }
        
        [self.managedObjectContext save:&error];
    }
    
    else {
        NSLog(@"Emails have been turned off by you");
    }
    
}






#pragma mark - fetches

-(void)fetchStudentAndParentsAndBehaviourAndSchoolClasses
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
    
    
    
    self.listOfBehaviour = [[NSMutableArray alloc] init];
    
    NSFetchRequest *behaviourFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Behaviour"];
//    misbehaviourFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
    
    NSError *behaviourError;
    
    [self.listOfBehaviour addObjectsFromArray:[self.managedObjectContext executeFetchRequest:behaviourFetchRequest error:&behaviourError]];
    
    
    self.listOfSchoolClasses = [[NSMutableArray alloc] init];
    
    NSFetchRequest *schoolClassFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SchoolClass"];
//    schoolClassFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"grade" ascending:YES]];
    
    NSError *schoolClassError;
    
    [self.listOfSchoolClasses addObjectsFromArray:[self.managedObjectContext executeFetchRequest:schoolClassFetchRequest error:&schoolClassError]];
    
}


//CHANGE ORIGINAL VERSION FROM TAPPING THE BOXES TO HAVING SWIPE GESTURES
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    Misbehaviour *misbehaviour = [NSEntityDescription insertNewObjectForEntityForName:@"Misbehaviour" inManagedObjectContext:self.managedObjectContext];
//    misbehaviour.time = [NSDate date];
//    Student *theStudent = self.currentClass[indexPath.row];
//    Parent *theParent = [theStudent.parents anyObject];
//    [theStudent addMisbehaviourObject:misbehaviour];
//    NSError *error;
//    [self.managedObjectContext save:&error];
//
//    NSInteger numberOfTaps = [theStudent.numberOfDisruptions integerValue];
//    numberOfTaps = numberOfTaps + 1;
//    NSNumber *newNumber = [NSNumber numberWithInteger:numberOfTaps];
//    theStudent.numberOfDisruptions = newNumber;
//
//
//    [self fetchStudentAndParentsAndMisbehaviourAndSchoolClasses];
//
//    if (numberOfTaps == 3) {
//        if ([MFMailComposeViewController canSendMail]) {
//
//            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
//            mailViewController.mailComposeDelegate = self;
//            [mailViewController setSubject:@"Misbehaviour in class."];
//
//            Teacher *theTeacher = [self.listOfTeachers firstObject];
//            NSString *theResultString = theTeacher.emailAddress;
//            theResultString = [theResultString stringByReplacingOccurrencesOfString:@"<Title>" withString:theParent.title];
//            theResultString = [theResultString stringByReplacingOccurrencesOfString:@"<Parent>" withString:theParent.lastName];
//            theResultString = [theResultString stringByReplacingOccurrencesOfString:@"<Student>" withString:theStudent.firstName];
//
//            [mailViewController setMessageBody:[NSString stringWithFormat:@"%@", theResultString] isHTML:NO];
//
//            [mailViewController setToRecipients:@[[NSString stringWithFormat:@"%@", theParent.emailAddress]]];
//
//            [self presentViewController:mailViewController animated:YES completion:nil];
//
//        }
//
//        else {
//            NSLog(@"Device can't send emails");
//        }
//
//        [self.managedObjectContext save:&error];
//
//    }
//}

@end
