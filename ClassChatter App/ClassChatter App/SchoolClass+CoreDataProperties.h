//
//  SchoolClass+CoreDataProperties.h
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-11-11.
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
@property (nullable, nonatomic, retain) NSSet<Behaviour *> *behaviour;
@property (nullable, nonatomic, retain) NSSet<Student *> *students;
@property (nullable, nonatomic, retain) Teacher *teacher;

@end

@interface SchoolClass (CoreDataGeneratedAccessors)

- (void)addBehaviourObject:(Behaviour *)value;
- (void)removeBehaviourObject:(Behaviour *)value;
- (void)addBehaviour:(NSSet<Behaviour *> *)values;
- (void)removeBehaviour:(NSSet<Behaviour *> *)values;

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet<Student *> *)values;
- (void)removeStudents:(NSSet<Student *> *)values;

@end

NS_ASSUME_NONNULL_END
