//
//  Customer+CoreDataProperties.h
//  
//
//  Created by apple on 16/9/5.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Customer.h"

NS_ASSUME_NONNULL_BEGIN

@interface Customer (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *create_time;
@property (nullable, nonatomic, retain) NSString *grade;
@property (nullable, nonatomic, retain) NSString *register_status;
@property (nullable, nonatomic, retain) NSString *academy_id;
@property (nullable, nonatomic, retain) NSString *school_id;
@property (nullable, nonatomic, retain) NSString *academy_name;
@property (nullable, nonatomic, retain) NSString *school_name;
@property (nullable, nonatomic, retain) NSString *face_img;
@property (nullable, nonatomic, retain) NSString *signature;
@property (nullable, nonatomic, retain) NSString *sex;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *mobile;
@property (nullable, nonatomic, retain) NSString *userId;

@end

NS_ASSUME_NONNULL_END
