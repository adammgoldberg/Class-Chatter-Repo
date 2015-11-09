//
//  DetailViewController.h
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-11-09.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Behaviour.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) Behaviour *behaviour;


@end
