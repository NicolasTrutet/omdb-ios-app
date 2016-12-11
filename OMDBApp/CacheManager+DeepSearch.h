//
//  CacheManager+DeepSearch.h
//  OMDBApp
//
//  Created by Nicolas TRUTET on 21/09/2016.
//  Copyright © 2016 Nicolas TRUTET. All rights reserved.
//

#import "CacheManager.h"
#import "Movie.h"
#import "NetworkManager.h"

@interface CacheManager (DeepSearch)  <NSURLSessionDelegate>

- (Movie *)searchMovieBy:(NSString *)Id;

@end
