//
//  CacheManager.m
//  OMDBApp
//
//  Created by Nicolas TRUTET on 21/09/2016.
//  Copyright © 2016 Nicolas TRUTET. All rights reserved.
//

#import "CacheManager.h"

NSUInteger const CacheSizeInMB = 50;


@implementation CacheManager
{
    NSMutableDictionary *cacheDictionnary;
    NSMutableDictionary *lastQuery;
}

    
    
    
#pragma mark - Initializer

/*
 - Create singleton object as thread safe.
 */
+ (CacheManager *)CacheManagerInstance {

        static CacheManager *CacheManagerInstance = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            CacheManagerInstance = [[CacheManager alloc] init];
        });

         return CacheManagerInstance;
}




    
#pragma mark - Cache Store Management

/*
 - Store result in cache for the seach query as key.
 */
- (void)storeResult:(NSMutableArray *)result
             forKey:(NSString *)key {
    
    if (cacheDictionnary == nil) {
        cacheDictionnary = [NSMutableDictionary new];
    }
    
    /*
     - Check size of cache and empty it if its too big.
     - Get OSMemoryNotificationCurrentLevel status first, then erase or not.
    */
    
    //Implementation ...
    
    
    //Store result.
    [cacheDictionnary setValue:result forKey:key];
}




    
    
/*
 - Returns data stored in cache as an array for
   a given query as key.
 */
- (NSMutableArray *)getResultForKey:(NSString *)key {
    
    if (cacheDictionnary != nil) {
        NSMutableArray *result = [cacheDictionnary valueForKey:key];
        return result;
    }
    
    return nil;
}





    
    
#pragma mark - Query History

/*
 - Store query and its type.
 - The option parameter is also use to store a type queyr as a boolean.
 */
- (void)saveLastQuery:(NSString *)query
                type:(BOOL)type
           withOption:(BOOL)option {

    if (lastQuery == nil) {
        lastQuery = [NSMutableDictionary new];
    }

    [lastQuery setValue:[NSNumber numberWithBool:option] forKey:@"option"];
    
    if (type) { //byTitle
        [lastQuery setValue:query forKey:@"queryStringTitle"];
        [lastQuery setValue:[NSNumber numberWithBool:type] forKey:@"queryTypeTitle"];
    
    } else { //byID
        [lastQuery setValue:query forKey:@"queryStringID"];
        [lastQuery setValue:[NSNumber numberWithBool:type] forKey:@"queryTypeID"];
    }
    
    
    
    
}




/*
 - Returns the last query dictionary.
 */
- (NSMutableDictionary *)getLastQuery {

    if (lastQuery != nil) {
        return lastQuery;
    }
    
    return nil;
}










@end
