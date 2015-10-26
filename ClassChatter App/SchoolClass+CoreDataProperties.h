//
//  SchoolClass+CoreDataProperties.h
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-10-26.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SchoolClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface SchoolClass (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *grade;
@property (nullable, nonatomic, retain) NSString *section;
@property (nullable, nonatomic, retain) NSString *subject;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *students;
@property (nullable, nonatomic, retain) Teacher *teacher;

@end

@interface SchoolClass (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(NSManagedObject *)value;
- (void)removeStudentsObject:(NSManagedObject *)value;
- (void)addStudents:(NSSet<NSManagedObject *> *)values;
- (void)removeStudents:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
