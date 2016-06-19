//
//  Programme+CoreDataProperties.h
//  SizeClassesApp
//
//  Created by Melany Gulianovych on 6/16/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Programme.h"

NS_ASSUME_NONNULL_BEGIN

@interface Programme (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *descriptor;
@property (nullable, nonatomic, retain) NSData *image;

@end

NS_ASSUME_NONNULL_END
