//
//  Teacher+CoreDataProperties.h
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-10-26.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Teacher.h"

NS_ASSUME_NONNULL_BEGIN

@interface Teacher (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *emailAddress;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *students;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *schoolClasses;

@end

@interface Teacher (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(NSManagedObject *)value;
- (void)removeStudentsObject:(NSManagedObject *)value;
- (void)addStudents:(NSSet<NSManagedObject *> *)values;
- (void)removeStudents:(NSSet<NSManagedObject *> *)values;

- (void)addSchoolClassesObject:(NSManagedObject *)value;
- (void)removeSchoolClassesObject:(NSManagedObject *)value;
- (void)addSchoolClasses:(NSSet<NSManagedObject *> *)values;
- (void)removeSchoolClasses:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
