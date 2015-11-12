//
//  Student+CoreDataProperties.h
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-11-11.
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
@property (nullable, nonatomic, retain) NSNumber *numberOfPositives;
@property (nullable, nonatomic, retain) NSSet<Behaviour *> *behaviour;
@property (nullable, nonatomic, retain) Parent *parent;
@property (nullable, nonatomic, retain) SchoolClass *schoolClass;
@property (nullable, nonatomic, retain) Teacher *teacher;

@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addBehaviourObject:(Behaviour *)value;
- (void)removeBehaviourObject:(Behaviour *)value;
- (void)addBehaviour:(NSSet<Behaviour *> *)values;
- (void)removeBehaviour:(NSSet<Behaviour *> *)values;

@end

NS_ASSUME_NONNULL_END
