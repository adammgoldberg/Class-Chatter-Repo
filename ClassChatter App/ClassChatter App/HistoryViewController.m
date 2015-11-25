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
#import "Behaviour.h"
#import "DetailViewController.h"

@interface HistoryViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UISearchResultsUpdating, UISearchControllerDelegate>



@property (nonatomic) UISearchController *searchController;

@property (strong, nonatomic) IBOutlet UITableView *tableViewHistory;

@property (strong, nonatomic) NSMutableArray *listOfStudents;

@property (strong, nonatomic) NSMutableArray *listOfBehaviour;

@property (strong, nonatomic) NSMutableArray *filteredBehaviour;






@end

@implementation HistoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

// Ken added this code, but it wasn't necessary in the end
// self.searchDisplayController.searchResultsTableView = self.tableViewHistory;
// [self.searchDisplayController.searchResultsTableView registerClass:[HistoryCell class]forCellReuseIdentifier:@"HistoryCell"];
    
//   [self.searchDisplay.searchResultsTableView registerNib:[UINib nibWithNibName:@"CustomHistoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HistoryCell"];
    
//    [self.searchDisplay.searchResultsTableView registerClass:[HistoryCell class] forCellReuseIdentifier:@"HistoryCell"];
    
    [self.tableViewHistory registerNib:[UINib nibWithNibName:@"CustomHistoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HistoryCell"];
    
//    self.tableViewHistory.rowHeight = 82;

    
    [self makeSearchController];
    
    self.searchController.searchBar.barTintColor = [UIColor colorWithRed:96/255.0f green:174/255.0f blue:82/255.0f alpha:1];
    
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:96/255.0f green:174/255.0f blue:82/255.0f alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.searchController.searchBar setTintColor:[UIColor whiteColor]];
    
    
    
    [self fetchStudentAndBehaviour];
    
    self.filteredBehaviour = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
    

}

-(void)makeSearchController
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
    self.tableViewHistory.tableHeaderView = self.searchController.searchBar;
}





- (void)handleDataModelChange:(NSNotification *)note
{
    
    [self fetchStudentAndBehaviour];
    
    [self.tableViewHistory reloadData];
}


#pragma mark - tableview and search

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return self.filteredBehaviour.count;
    }
    else {
        return self.listOfBehaviour.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HistoryCell *cell = [self.tableViewHistory dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    
    
    if (self.searchController.active) {
        [self configureCell:cell withBehaviour:[self.filteredBehaviour objectAtIndex:indexPath.row]];
    }
    else {
        [self configureCell:cell withBehaviour:[self.listOfBehaviour objectAtIndex:indexPath.row]];
    }
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.managedObjectContext deleteObject:[self.listOfBehaviour objectAtIndex:indexPath.row]];
        [self.listOfBehaviour removeObjectAtIndex:indexPath.row];
        
        NSError *error;
        [self.managedObjectContext save:&error];
        
        [self fetchStudentAndBehaviour];
 
        [self.tableViewHistory reloadData];
    }
}



-(void)configureCell:(HistoryCell*)cell withBehaviour:(Behaviour*)behaviour
{
    Student *student = behaviour.student;
    cell.historyFirstLabel.text = student.firstName;
    cell.historyLastLabel.text = student.lastName;
    cell.colourView.layer.cornerRadius = 12;
    cell.colourView.layer.masksToBounds = YES;
    if ([behaviour.type  isEqual: @"good"]) {
        cell.colourView.backgroundColor = [UIColor colorWithRed:164/255.0f green:255/255.0f blue:127/255.0f alpha:1];
        if (behaviour.details != nil && ![behaviour.details isEqualToString:@""]) {
            cell.colourView.backgroundColor = [UIColor colorWithRed:36/255.0f green:213/255.0f blue:68/255.0f alpha:1];
        }
    } else {
        cell.colourView.backgroundColor = [UIColor colorWithRed:255/255.0f green:118/255.0f blue:103/255.0f alpha:1];
        if (behaviour.details != nil && ![behaviour.details isEqualToString:@""]) {
            cell.colourView.backgroundColor = [UIColor colorWithRed:255/255.0f green:25/255.0f blue:52/255.0f alpha:1];
        }
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm:ss"];
    
    NSString *dateString = [format stringFromDate:behaviour.time];
    
    
    cell.historyTimeLabel.text = dateString;
    cell.historyGradeLabel.text = student.schoolClass.section;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    dvc.managedObjectContext = self.managedObjectContext;
    if (self.searchController.active) {
        Behaviour *aBehaviour = self.filteredBehaviour[indexPath.row];
        dvc.behaviour = aBehaviour;
    }
    else {
        Behaviour *aBehaviour = self.listOfBehaviour[indexPath.row];
        dvc.behaviour = aBehaviour;
    }
    [self.navigationController pushViewController:dvc animated:YES];
    
}

// OLD DEPRECATED WAY - STEVE'S WAY WITH THE SEARCHCOTROLLER IS WAY BETTER
//- (void)searchTableList {
//    NSString *searchString = self.searchBar.text;
//
//    for (Behaviour *aBehaviour in self.listOfBehaviour) {
//        NSComparisonResult result = [aBehaviour.student.firstName compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
//
//        NSComparisonResult result2 = [aBehaviour.student.lastName compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
//
//        if (result == NSOrderedSame || result2 == NSOrderedSame) {
//            [self.filteredBehaviour addObject:aBehaviour];
//        }
//    }
//}


//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    self.isSearching = YES;
//}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    NSLog(@"Text change - %d",self.isSearching);

//    //Remove all objects first.
//    [self.filteredBehaviour removeAllObjects];
//
//    if([searchText length] != 0) {
//        self.isSearching = YES;
//        [self searchTableList];
//    }
//    else {
//        self.isSearching = NO;
//    }
//    [self.tableViewHistory reloadData];
//
//    // There is still an issue that one of the search results is hidden...
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    NSLog(@"Cancel clicked");
//    self.isSearching = NO;
//    [self.tableViewHistory reloadData];
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    NSLog(@"Search Clicked");
//    [self searchTableList];
//
//}
//
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//
//}




#pragma mark - UISearchResultUpdating Protocol method

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchText = searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.student.firstName contains[cd] %@ || SELF.student.lastName contains[cd] %@ || SELF.student.schoolClass.section contains[cd] %@", searchText, searchText, searchText];
    self.filteredBehaviour = [[self.listOfBehaviour filteredArrayUsingPredicate:predicate] mutableCopy];
    [self.tableViewHistory reloadData];
    

// OLD WAY TO FILTER, SEE BETTER WAY ABOVE
//  NSString *searchString = self.searchController.searchBar.text;
//
//  for (Behaviour *aBehaviour in self.listOfBehaviour) {
//  NSComparisonResult result = [aBehaviour.student.firstName compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
//
//  NSComparisonResult result2 = [aBehaviour.student.lastName compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
//
//  if (result == NSOrderedSame || result2 == NSOrderedSame) {
//      [self.filteredBehaviour addObject:aBehaviour];
//      }
//  }
    
}

#pragma mark - fetches

-(void)fetchStudentAndBehaviour
{
    self.listOfStudents = [[NSMutableArray alloc] init];
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]];
    
    NSError *error;
    
    [self.listOfStudents addObjectsFromArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    
    
    self.listOfBehaviour = [[NSMutableArray alloc] init];
    
    NSFetchRequest *behaviourFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Behaviour"];
    behaviourFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
    
    NSError *behaviourError;
    
    [self.listOfBehaviour addObjectsFromArray:[self.managedObjectContext executeFetchRequest:behaviourFetchRequest error:&behaviourError]];
}






@end
