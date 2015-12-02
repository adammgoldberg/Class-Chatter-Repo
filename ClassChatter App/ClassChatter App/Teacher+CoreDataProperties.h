//
//  Teacher+CoreDataProperties.h
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-12-02.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Teacher.h"

NS_ASSUME_NONNULL_BEGIN

@interface Teacher (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *emailTemplateBad;
@property (nullable, nonatomic, retain) NSString *emailTemplateGood;
@property (nullable, nonatomic, retain) NSString *limitForBadEmails;
@property (nullable, nonatomic, retain) NSString *limitforGoodEmails;
@property (nullable, nonatomic, retain) NSString *principalEmail;
@property (nullable, nonatomic, retain) NSString *emailTemplateHomework;
@property (nullable, nonatomic, retain) NSString *emailTemplatePhonecall;
@property (nullable, nonatomic, retain) NSSet<SchoolClass *> *schoolClasses;
@property (nullable, nonatomic, retain) NSSet<Student *> *students;

@end

@interface Teacher (CoreDataGeneratedAccessors)

- (void)addSchoolClassesObject:(SchoolClass *)value;
- (void)removeSchoolClassesObject:(SchoolClass *)value;
- (void)addSchoolClasses:(NSSet<SchoolClass *> *)values;
- (void)removeSchoolClasses:(NSSet<SchoolClass *> *)values;

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet<Student *> *)values;
- (void)removeStudents:(NSSet<Student *> *)values;

@end

NS_ASSUME_NONNULL_END
