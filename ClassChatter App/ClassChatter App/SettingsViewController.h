//
//  SettingsViewController.h
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-11-10.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Teacher.h"

@interface SettingsViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) Teacher *teacher;

@end
