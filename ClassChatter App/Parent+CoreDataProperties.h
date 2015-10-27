//
//  Parent+CoreDataProperties.h
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-10-26.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Parent.h"

NS_ASSUME_NONNULL_BEGIN

@interface Parent (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *emailAddress;
@property (nullable, nonatomic, retain) NSManagedObject *student;

@end

NS_ASSUME_NONNULL_END