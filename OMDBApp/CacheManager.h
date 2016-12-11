//
//  CacheManager.h
//  OMDBApp
//
//  Created by Nicolas TRUTET on 21/09/2016.
//  Copyright © 2016 Nicolas TRUTET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

@interface CacheManager : NSObject


+ (CacheManager *)CacheManagerInstance;

- (void)storeResult:(NSMutableArray *)result
             forKey:(NSString *)key;
    

- (NSMutableArray *)getResultForKey:(NSString *)key;

- (void)saveLastQuery:(NSString *)query
                type:(BOOL)type
           withOption:(BOOL)option;
    
- (NSMutableDictionary *)getLastQuery;



@end
