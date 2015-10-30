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
#import "SchoolClass.h"
#import "Misbehaviour.h"

@interface HistoryViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>




@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplay;

@property (strong, nonatomic) IBOutlet UITableView *tableViewHistory;

@property (strong, nonatomic) NSMutableArray *listOfStudents;

@property (strong, nonatomic) NSMutableArray *listOfMisbehaviour;


@property (strong, nonatomic) NSMutableArray *filteredMisbehaviour;

@property (assign, nonatomic) BOOL isSearching;




@end

@implementation HistoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

// Ken added this code, but it wasn't necessary in the end
// self.searchDisplayController.searchResultsTableView = self.tableViewHistory;
// [self.searchDisplayController.searchResultsTableView registerClass:[HistoryCell class]forCellReuseIdentifier:@"HistoryCell"];
    
    [self fetchStudentAndMisbehaviour];
    
    self.filteredMisbehaviour = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
    

}


- (void)handleDataModelChange:(NSNotification *)note
{
    
    [self fetchStudentAndMisbehaviour];
    
    [self.tableViewHistory reloadData];
}


#pragma mark - tableview and search

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearching) {
        return self.filteredMisbehaviour.count;
    }
    else {
        return self.listOfMisbehaviour.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HistoryCell *cell = [self.tableViewHistory dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    
    if (self.isSearching) {
        [self configureCell:cell withMisbehaviour:[self.filteredMisbehaviour objectAtIndex:indexPath.row]];
    }
    else {
        [self configureCell:cell withMisbehaviour:[self.listOfMisbehaviour objectAtIndex:indexPath.row]];
    }
    
    return cell;
    
}

- (void)searchTableList {
    NSString *searchString = self.searchBar.text;
    
    for (Misbehaviour *aMisbehaviour in self.listOfMisbehaviour) {
        NSComparisonResult result = [aMisbehaviour.student.firstName compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        
        NSComparisonResult result2 = [aMisbehaviour.student.lastName compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        
        if (result == NSOrderedSame || result2 == NSOrderedSame) {
            [self.filteredMisbehaviour addObject:aMisbehaviour];
        }
    }
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Text change - %d",self.isSearching);
    
    //Remove all objects first.
    [self.filteredMisbehaviour removeAllObjects];
    
    if([searchText length] != 0) {
        self.isSearching = YES;
        [self searchTableList];
    }
    else {
        self.isSearching = NO;
    }
    [self.tableViewHistory reloadData];
    
    // There is still an issue that one of the search results is hidden...
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
    self.isSearching = NO;
    [self.tableViewHistory reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self searchTableList];
}




-(void)configureCell:(HistoryCell*)cell withMisbehaviour:(Misbehaviour*)misbehaviour
{
    Student *student = misbehaviour.student;
    cell.historyFirstLabel.text = student.firstName;
    cell.historyLastLabel.text = student.lastName;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm:ss"];
    
    NSString *dateString = [format stringFromDate:misbehaviour.time];
    
    
    cell.historyTimeLabel.text = dateString;
    cell.historyGradeLabel.text = [NSString stringWithFormat:@"%@", student.schoolClass.grade];
    
}


#pragma mark - fetches

-(void)fetchStudentAndMisbehaviour
{
    self.listOfStudents = [[NSMutableArray alloc] init];
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]];
    
    NSError *error;
    
    [self.listOfStudents addObjectsFromArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    
    
    self.listOfMisbehaviour = [[NSMutableArray alloc] init];
    
    NSFetchRequest *misbehaviourFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Misbehaviour"];
    misbehaviourFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
    
    NSError *misbehaviourError;
    
    [self.listOfMisbehaviour addObjectsFromArray:[self.managedObjectContext executeFetchRequest:misbehaviourFetchRequest error:&misbehaviourError]];
}






@end
