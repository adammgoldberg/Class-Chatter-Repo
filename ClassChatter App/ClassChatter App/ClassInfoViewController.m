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
#import "ModalViewController.h"

@interface ClassInfoViewController () <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *classInfoTableView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *classInfoSeg;



@property (strong, nonatomic) NSMutableArray *listOfStudents;

@property (strong, nonatomic) NSMutableArray *listOfParents;


@end

@implementation ClassInfoViewController



    


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showModal"]) {
        ModalViewController *modalvc = (ModalViewController*)[segue destinationViewController];
        modalvc.managedObjectContext = self.managedObjectContext;
    }
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listOfStudents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassInfoCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureCell:(ClassInfoCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    Student *student = self.listOfStudents[indexPath.row];
    Parent *parent = [student.parents anyObject];
    cell.studentFirstNameLabel.text = student.firstName;
    cell.studentLastNameLabel.text = student.lastName;
    cell.parentTitleLabel.text = parent.title;
    cell.parentEmailLabel.text = parent.emailAddress;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fetchStudentAndParents];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
    
    
}


- (void)handleDataModelChange:(NSNotification *)note
{

    [self fetchStudentAndParents];
    
    [self.classInfoTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchStudentAndParents
{
    self.listOfStudents = [[NSMutableArray alloc] init];
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]];
    
    NSError *error;
    
    [self.listOfStudents addObjectsFromArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    
    
    self.listOfParents = [[NSMutableArray alloc] init];
    
    NSFetchRequest *parentFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Parent"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"emailAddress" ascending:YES]];
    
    NSError *parentError;
    
    [self.listOfParents addObjectsFromArray:[self.managedObjectContext executeFetchRequest:parentFetchRequest error:&parentError]];
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
