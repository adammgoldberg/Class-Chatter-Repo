//
//  ClassRoomViewController.h
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-10-26.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ClassRoomViewController : UIViewController


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
