//
//  TemplateViewController.h
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-10-29.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Teacher.h"

@interface TemplateViewController : UIViewController <UITextViewDelegate>


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (strong, nonatomic) IBOutlet UITextView *emailTemplateText;

@property (strong, nonatomic) NSString *emailString;

@property (strong, nonatomic) Teacher *teacher;




@end
