//
//  Deserializer.h
//  OMDBApp
//
//  Created by Nicolas TRUTET on 21/09/2016.
//  Copyright © 2016 Nicolas TRUTET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Movie.h"
#import "CacheManager.h"

@protocol DeserializerDelegate <NSObject>
- (void)dataHasBeenDeserialized:(NSMutableArray *)data;
@end



@interface Deserializer : NSObject <NSURLSessionDelegate>    
@property (nonatomic,strong) id delegate;

- (void)deserializeData:(NSData *)data
                        andAssignValuesToObject:(id)object;
@end
