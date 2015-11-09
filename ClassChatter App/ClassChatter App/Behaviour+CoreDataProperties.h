//
//  Behaviour+CoreDataProperties.h
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-11-09.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Behaviour.h"

NS_ASSUME_NONNULL_BEGIN

@interface Behaviour (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *time;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) SchoolClass *schoolClass;
@property (nullable, nonatomic, retain) Student *student;

@end

NS_ASSUME_NONNULL_END
