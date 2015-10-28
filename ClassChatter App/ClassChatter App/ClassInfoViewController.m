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


@interface ClassInfoViewController () <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *classInfoTableView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *classInfoSeg;

@property (strong, nonatomic) NSMutableArray *listOfStudents;

@property (strong, nonatomic) NSMutableArray *listOfParents;

@property (strong, nonatomic) NSMutableArray *listOfSchoolClasses;

@property (strong, nonatomic) NSMutableArray *currentInfoClass;


@end

@implementation ClassInfoViewController



//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self.managedObjectContext deleteObject:[self.currentInfoClass objectAtIndex:indexPath.row]];
//    [self.currentInfoClass removeObjectAtIndex:indexPath.row];
//    [self.classInfoTableView reloadData];
//    NSError *error;
//    [self.managedObjectContext save:&error];
//}




- (void) rebuildInfoSegControl;
{
    [self.classInfoSeg removeAllSegments];
    if (self.listOfSchoolClasses.count > 0) {
        for (SchoolClass *schoolClass in self.listOfSchoolClasses) {
            [self.classInfoSeg insertSegmentWithTitle:[NSString stringWithFormat:@"%@", schoolClass.grade] atIndex:0 animated:NO];
        }
    } else {
        [self.classInfoSeg insertSegmentWithTitle:@"Class" atIndex:0 animated:true];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showModal"]) {
        ModalViewController *modalvc = (ModalViewController*)[segue destinationViewController];
        modalvc.managedObjectContext = self.managedObjectContext;
    }
}




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
    Parent *parent = [student.parents anyObject];
    cell.studentFirstNameLabel.text = student.firstName;
    cell.studentLastNameLabel.text = student.lastName;
    cell.parentTitleLabel.text = parent.title;
    cell.parentEmailLabel.text = parent.emailAddress;
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    
    [cell addGestureRecognizer:swipeGesture];
}

-(void)swiped:(UISwipeGestureRecognizer*)swipe
{
    CGPoint point = [swipe locationInView:self.classInfoTableView];
    NSIndexPath *indexPath = [self.classInfoTableView indexPathForRowAtPoint:point];
    
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



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.classInfoTableView.delegate = self;
    
    [self fetchStudentAndParentsAndClasses];
    
    [self rebuildInfoSegControl];
    
    [self.classInfoSeg setSelectedSegmentIndex:0];
    [self classInfoSelected:self.classInfoSeg];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.classInfoTableView reloadData];
}

- (IBAction)classInfoSelected:(UISegmentedControl *)sender
{
    NSInteger grade = [[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] integerValue];
    self.currentInfoClass = [[NSMutableArray alloc] init];
    for (Student *student in self.listOfStudents) {
        if (student.schoolClass.grade.integerValue == grade) {
            [self.currentInfoClass addObject:student];
        }
    }
    [self.classInfoTableView reloadData];
}





- (void)handleDataModelChange:(NSNotification *)note
{

    [self fetchStudentAndParentsAndClasses];
    
    [self.classInfoTableView reloadData];
    
    [self rebuildInfoSegControl];
}


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
