//
//  DBManager.h
//  SizeClassesApp
//
//  Created by Melany Gulianovych on 6/16/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Programme.h"

@interface DBManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (instancetype)sharedManager;
- (NSURL *)applicationDocumentsDirectory;
- (NSManagedObjectContext *)managedObjectContext;
- (void)saveContext;
- (Programme *)createProgramme;
- (BOOL)coreDataHasEntriesForEntityName;
- (BOOL)hasEntityWithTitle:(NSString *)name;
@end
