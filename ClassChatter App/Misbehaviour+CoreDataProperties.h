//
//  Misbehaviour+CoreDataProperties.h
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-10-27.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Misbehaviour.h"

NS_ASSUME_NONNULL_BEGIN

@interface Misbehaviour (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *time;
@property (nullable, nonatomic, retain) Student *student;
@property (nullable, nonatomic, retain) SchoolClass *schoolClass;

@end

NS_ASSUME_NONNULL_END
