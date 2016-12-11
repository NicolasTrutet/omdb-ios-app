//
//  NetworkManager.h
//  OMDBApp
//
//  Created by Nicolas TRUTET on 21/09/2016.
//  Copyright © 2016 Nicolas TRUTET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheManager+DeepSearch.h"
#import "Deserializer.h"

@protocol NetworkManagerDelegate <NSObject>
- (void)requestDidFinishWithStatus:(NSUInteger)status
                              data:(NSMutableArray*)data;
@end



typedef enum ResponseStatus : NSUInteger {
    Success = 0,
    Failure = 1,
    NetworkUnreachable = 2,
} ResponseStatus;





@interface NetworkManager : NSObject <NSURLSessionDelegate, DeserializerDelegate>

@property (nonatomic,strong) id delegate;

- (void)fetchDataWithQuery:(NSString *)query
             searchByTitle:(BOOL)byTitle;

    
    
@end
