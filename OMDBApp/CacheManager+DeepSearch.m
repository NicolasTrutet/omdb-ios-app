//
//  CacheManager+DeepSearch.m
//  OMDBApp
//
//  Created by Nicolas TRUTET on 21/09/2016.
//  Copyright © 2016 Nicolas TRUTET. All rights reserved.
//

#import "CacheManager+DeepSearch.h"

@implementation CacheManager (DeepSearch)


/*
 - Returns a movie object if found in the local cache.
 */
- (Movie *)searchMovieBy:(NSString *)Id {
    
    Movie *movie;
    CacheManager *cache = [CacheManager CacheManagerInstance];
    NSMutableDictionary *lastQuery = [cache getLastQuery];
    
    //get all the data stored in cache and access it from last query key(title)
    NSMutableArray *Movies = [cache getResultForKey:[lastQuery valueForKey:@"queryStringTitle"]];
    
    //search within the given array the movie by its ID.
    for (Movie *film in Movies) {
        
        if ([film.imdbID isEqualToString:Id]) {
            movie = film;
            break;
        }
    }
    return movie;
}



    
    
    


@end
