//
//  DetailViewController.m
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-11-09.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UITextView *behaviourDescriptionText;

@property (strong, nonatomic) IBOutlet UIButton *saveDescriptionButton;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.behaviourDescriptionText.delegate = self;
    
    self.behaviourDescriptionText.text = self.behaviour.details;
    

    
    self.saveDescriptionButton.layer.cornerRadius = 12;
    self.saveDescriptionButton.layer.masksToBounds = YES;
    
    self.behaviourDescriptionText.layoutManager.allowsNonContiguousLayout = NO;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getRidOfKeyboard:)];
    
    [self.view addGestureRecognizer:tapGesture];
    
}





-(void)getRidOfKeyboard:(UITapGestureRecognizer*)tap
{
//    [self.behaviourDescriptionText resignFirstResponder];
}


- (IBAction)saveBehaviourDescription:(UIButton *)sender {
    self.behaviour.details = self.behaviourDescriptionText.text;
    NSError *error;
    [self.managedObjectContext save:&error];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
