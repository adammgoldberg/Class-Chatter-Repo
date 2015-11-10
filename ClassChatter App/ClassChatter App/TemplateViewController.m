//
//  TemplateViewController.m
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-10-29.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import "TemplateViewController.h"


@interface TemplateViewController () <UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) UITextView *activeView;


@end

@implementation TemplateViewController

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.activeView = textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.emailTemplateText.delegate = self;
    
    NSFetchRequest *teacherFetch = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    NSError *error;
    self.teacher = [[self.managedObjectContext executeFetchRequest:teacherFetch error:&error] firstObject];
    
    self.emailTemplateText.text = self.teacher.emailTemplateBad;
    self.saveButton.layer.cornerRadius = 12;
    self.saveButton.layer.masksToBounds = YES;
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getRidOfKeyboard:)];
    
    [self registerForKeyboardNotifications];
    
    [self.view addGestureRecognizer:tapGesture];
}

-(void)viewDidLayoutSubviews
{
    [self.emailTemplateText setContentOffset:CGPointZero animated:YES];

}

-(void)getRidOfKeyboard:(UITapGestureRecognizer*)tap
{
    [self.emailTemplateText resignFirstResponder];
}



- (IBAction)saveTemplate:(UIButton *)sender
{
    self.teacher.emailTemplateBad = self.emailTemplateText.text;
    NSError *error;
    [self.managedObjectContext save:&error];
}

#pragma mark - scrollview


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    CGSize size = CGSizeMake(self.view.frame.size.width, 650);
    self.scrollView.contentSize = size;
    
//     If active text field is hidden by keyboard, scroll it so it's visible
//     Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
//    self.view.transform = CGAffineTransformMakeTranslation(0, -kbSize.height);
    
    if (!CGRectContainsPoint(aRect, self.activeView.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeView.frame.origin.y-kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}




@end
