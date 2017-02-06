//
//  User+CURD.m
//  yingwo
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "User+CURD.h"
#import "Test.h"
@implementation User (CURD)

+ (void)saveCustomerByUser:(User *)user {
    
    Customer *customer = [Customer MR_findFirst];
    
    if (customer == nil) {
        customer = [Customer MR_createEntity];
    }
    if (user.userId != nil) {
        customer.userId          = user.userId;
    }
    if (user.mobile != nil) {
        customer.mobile          = user.mobile;
    }
    if (user.name != nil) {
        customer.name            = user.name;
    }
    if (user.signature != nil) {
        customer.signature       = user.signature;
    }
    if (user.sex != nil) {
        customer.sex             = user.sex;
    }
    if (user.face_img != nil) {
        customer.face_img        = user.face_img;
    }
    if (user.academy_id != nil) {
        customer.academy_id      = user.academy_id;
    }
    if (user.academy_name != nil) {
        customer.academy_name    = user.academy_name;
    }
    if (user.school_id != nil) {
        customer.school_id       = user.school_id;
    }
    if (user.school_name != nil) {
        customer.school_name     = user.school_name;
    }
    if (user.register_status != nil) {
        customer.register_status = user.register_status;
    }
    if (user.grade != nil) {
        customer.grade           = user.grade;
    }
    if (user.create_time != nil) {
        customer.create_time     = user.create_time;
    }

    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

+ (void)deleteCustoer {
    Customer *customer = [Customer MR_findFirst];
    [customer MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

+ (Customer *)findCustomer {

    Customer *customer = [Customer MR_findFirst];

    return customer;
}

+ (void)modifyCustomerByKey:(NSString *)key value:(NSString *)value {
   
    Customer *customer = [Customer MR_findFirst];
    [customer setValue:value forKey:key];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

}

/***********************************login cookie**************************************************/

+ (BOOL)saveLoginInformationWithUsernmae:(NSString *)phone password:(NSString *)password {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:phone forKey:USERNAME];
    [userDefaults setObject:password forKey:PASSWORD];
    
    return YES;
}

+ (BOOL)haveExistedLoginInformation {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username           = [userDefaults objectForKey:USERNAME];
    if (username.length != 0) {
        return YES;
    }
    return NO;
}

+ (NSString *)getUsername {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username           = [userDefaults objectForKey:USERNAME];

    return username;
}

+ (NSString *)getPasswoord {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *password           = [userDefaults objectForKey:PASSWORD];
    
    return password;
}

+ (void)deleteLoginInformation {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:USERNAME];
    [userDefaults setObject:nil forKey:PASSWORD];
    
}

+ (void)getUserInfoForChatWithUserId:(NSString *)userId
                             success:(SuccessBlock)successValue
                             failure:(FailureValue)failure{
    
    NSDictionary *parameter = @{@"user_id":userId};
    
    [YWRequestTool YWRequestPOSTWithURL:TA_INFO_URL
                              parameter:parameter
                           successBlock:^(id success) {
                               

                               User *user = [User mj_objectWithKeyValues:success[@"info"]];
                               
                               successValue(user);
    } errorBlock:^(id error) {
        failure(error);
    }];
    
}

@end
