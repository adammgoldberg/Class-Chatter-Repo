//
//  TemplateViewController.m
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-10-29.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import "TemplateViewController.h"


@interface TemplateViewController ()

@end

@implementation TemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.emailTemplateText.delegate = self;
    
    NSFetchRequest *teacherFetch = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    NSError *error;
    self.teacher = [[self.managedObjectContext executeFetchRequest:teacherFetch error:&error] firstObject];
    
    self.emailTemplateText.text = self.teacher.emailAddress;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getRidOfKeyboard:)];
    
    [self.view addGestureRecognizer:tapGesture];
}


-(void)getRidOfKeyboard:(UITapGestureRecognizer*)tap
{
    [self.emailTemplateText resignFirstResponder];
}



- (IBAction)saveTemplate:(UIButton *)sender
{
    self.teacher.emailAddress = self.emailTemplateText.text;
    NSError *error;
    [self.managedObjectContext save:&error];
}



@end
