//
//  Student+CoreDataProperties.h
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-10-26.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSNumber *numberOfDisruptions;
@property (nullable, nonatomic, retain) NSNumber *numberOfEmails;
@property (nullable, nonatomic, retain) NSSet<Parent *> *parents;
@property (nullable, nonatomic, retain) SchoolClass *schoolClass;
@property (nullable, nonatomic, retain) Teacher *teacher;

@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addParentsObject:(Parent *)value;
- (void)removeParentsObject:(Parent *)value;
- (void)addParents:(NSSet<Parent *> *)values;
- (void)removeParents:(NSSet<Parent *> *)values;

@end

NS_ASSUME_NONNULL_END
