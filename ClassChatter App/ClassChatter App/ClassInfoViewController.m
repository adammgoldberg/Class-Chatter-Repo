//
//  ClassInfoViewController.m
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-10-26.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import "ClassInfoViewController.h"
#import "ClassInfoCell.h"

@interface ClassInfoViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITableView *classInfoTableView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *classInfoSeg;

@property (strong, nonatomic) IBOutlet UITextField *firstNameText;


@property (strong, nonatomic) IBOutlet UITextField *lastNameText;

@property (strong, nonatomic) IBOutlet UITextField *parentTitleText;

@property (strong, nonatomic) IBOutlet UITextField *emailAddressText;


@end

@implementation ClassInfoViewController

- (IBAction)addStudent:(id)sender {
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassInfoCell" forIndexPath:indexPath];
    return cell;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
