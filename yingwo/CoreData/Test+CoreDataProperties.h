//
//  Test+CoreDataProperties.h
//  
//
//  Created by apple on 16/9/5.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Test.h"

NS_ASSUME_NONNULL_BEGIN

@interface Test (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *password;

@end

NS_ASSUME_NONNULL_END
