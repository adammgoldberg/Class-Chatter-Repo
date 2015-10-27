//
//  HistoryViewController.m
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-10-27.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryCell.h"
#import "Student.h"
#import "Misbehaviour.h"

@interface HistoryViewController () <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableViewHistory;

@property (strong, nonatomic) NSMutableArray *listOfStudents;

@property (strong, nonatomic) NSMutableArray *listOfMisbehaviour;


@end

@implementation HistoryViewController




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listOfMisbehaviour.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureCell:(HistoryCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    Misbehaviour *misbehaviour = self.listOfMisbehaviour[indexPath.row];
    Student *student = misbehaviour.student;
    cell.historyFirstLabel.text = student.firstName;
    cell.historyLastLabel.text = student.lastName;
    cell.historyDisruptionLabel.text = [NSString stringWithFormat:@"%@",student.numberOfDisruptions];
    cell.historyTimeLabel.text = [NSString stringWithFormat:@"%@",misbehaviour.time];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fetchStudentAndMisbehaviour];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
}


- (void)handleDataModelChange:(NSNotification *)note
{
    
    [self fetchStudentAndMisbehaviour];
    
    [self.tableViewHistory reloadData];
}


-(void)fetchStudentAndMisbehaviour
{
    self.listOfStudents = [[NSMutableArray alloc] init];
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]];
    
    NSError *error;
    
    [self.listOfStudents addObjectsFromArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    
    
    self.listOfMisbehaviour = [[NSMutableArray alloc] init];
    
    NSFetchRequest *misbehaviourFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Misbehaviour"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
    
    NSError *misbehaviourError;
    
    [self.listOfMisbehaviour addObjectsFromArray:[self.managedObjectContext executeFetchRequest:misbehaviourFetchRequest error:&misbehaviourError]];
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
