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
#import "Student.h"
#import "Parent.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ClassRoomViewController () <UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate> 

@property (strong, nonatomic) IBOutlet UISegmentedControl *classSeg;

@property (strong, nonatomic) IBOutlet UICollectionView *studentCollectionView;

@property (strong, nonatomic) NSMutableArray *listOfStudents;

@property (strong, nonatomic) NSMutableArray *listOfParents;


@end

@implementation ClassRoomViewController



- (IBAction)actionEmailComposer
{
    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Student *theStudent = self.listOfStudents[indexPath.row];
    Parent *theParent = [theStudent.parents anyObject];
    NSInteger numberOfTaps = [theStudent.numberOfDisruptions integerValue];
    numberOfTaps = numberOfTaps + 1;
    NSNumber *newNumber = [NSNumber numberWithInteger:numberOfTaps];
    theStudent.numberOfDisruptions = newNumber;
    
    
    [self fetchStudentAndParents];
    
    if (numberOfTaps == 7) {
        if ([MFMailComposeViewController canSendMail]) {
            
            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
            mailViewController.mailComposeDelegate = self;
            [mailViewController setSubject:@"Misbehaviour in class."];
            [mailViewController setMessageBody:[NSString stringWithFormat:@"Dear %@ %@,\n\nI wanted to inform you that %@ disrupted class 3 times today. It would be greatly appreciated if you could please remind %@ the importance of participating positively in class and being respectful to the teacher and other students. Thank you for your time and help.\n\nSincerely, Mr. Goldberg\n\n\nSent via ClassChatter\nClassChatter - The Teacher Friendly Email Service", theParent.title, theStudent.lastName, theStudent.firstName, theStudent.firstName] isHTML:NO];
            [mailViewController setToRecipients:@[[NSString stringWithFormat:@"%@", theParent.emailAddress]]];
            
            [self presentViewController:mailViewController animated:YES completion:nil];
    
        }
        
        else {
            
            NSLog(@"Device can't send emails");
    }
    
    [self.managedObjectContext save:NULL];
    
    }
}
    

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error:(NSError*)error
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
        
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listOfStudents.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StudentDeskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StudentDeskCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


-(void)configureCell:(StudentDeskCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    Student *student = self.listOfStudents[indexPath.row];
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




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fetchStudentAndParents];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
    
    
}
     

- (void)handleDataModelChange:(NSNotification *)note
{
        
    [self fetchStudentAndParents];
        
    [self.studentCollectionView reloadData];
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
