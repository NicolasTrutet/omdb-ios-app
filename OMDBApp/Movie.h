//
//  Movie.h
//  OMDBApp
//
//  Created by Nicolas TRUTET on 21/09/2016.
//  Copyright © 2016 Nicolas TRUTET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Movie : NSObject

@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSString *year;
@property (nonatomic, strong, readwrite) NSString *rated;
@property (nonatomic, strong, readwrite) NSString *released;
@property (nonatomic, strong, readwrite) NSString *runtime;
@property (nonatomic, strong, readwrite) NSString *director;
@property (nonatomic, strong, readwrite) NSString *writer;
@property (nonatomic, strong, readwrite) NSString *actors;
@property (nonatomic, strong, readwrite) NSString *plot;
@property (nonatomic, strong, readwrite) NSString *languages;
@property (nonatomic, strong, readwrite) NSString *country;
@property (nonatomic, strong, readwrite) NSString *awards;
@property (nonatomic, strong, readwrite) NSString *metascore;
@property (nonatomic, strong, readwrite) NSString *imdbRating;
@property (nonatomic, strong, readwrite) NSString *imdbVotes;
@property (nonatomic, strong, readwrite) NSString *imdbID;
@property (nonatomic, strong, readwrite) NSString *type;
@property (nonatomic, strong, readwrite) NSString *genre;
@property (nonatomic, strong, readwrite) UIImage *poster;


@end
