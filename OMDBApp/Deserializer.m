//
//  Deserializer.m
//  OMDBApp
//
//  Created by Nicolas TRUTET on 21/09/2016.
//  Copyright © 2016 Nicolas TRUTET. All rights reserved.
//

#import "Deserializer.h"

@implementation Deserializer


/*
 - This method deserialized the JSON data and store the values in
   a Movie object.
 
 - When extracting the basic information for the movie list, it return the data stored in a array.
   This array is passed as parameter of the DeserializerDelegate method.
   If a poster image http link exist, it will be fetch and then assign to the movie object.
   Once done, the DeserializerDelegate method is trigged.
 
 - When extracting data for movie details informations, values of the movie attributes are assigned
   by reference. Once complete, the DeserializerDelegate method is triggerd.
 
 */
- (void)deserializeData:(NSData *)data
                        andAssignValuesToObject:(id)object {
    
    NSError *error = nil;
    NSMutableArray *store = [NSMutableArray new];
    
    // Get JSON data into a Foundation object
    id JsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    
    
    //Extract all movie basic informations
    if ([JsonObject isKindOfClass:[NSDictionary class]] && error == nil)
    {
        NSArray *array;
        if ([[JsonObject objectForKey:@"Search"] isKindOfClass:[NSArray class]])
        {
            array = [JsonObject objectForKey:@"Search"];
            if ([JsonObject objectForKey:@"Response"]) {
                
                for (int i=0; i < array.count; i++) {
                    
                    Movie *movie = [Movie new];
                    
                    movie.title = [array[i] objectForKey:@"Title"];
                    movie.year = [array[i] objectForKey:@"Year"];
                    movie.imdbID = [array[i] objectForKey:@"imdbID"];
                    movie.type = [array[i] objectForKey:@"Type"];
                    
                    //assign image if exist.
                    if (![[array[i] objectForKey:@"Poster"] isEqual:@"N/A"]) {
                        
                        //Perform HTTP request to get poster image for the given link.
                        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                        NSURLSession *networkSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
                        NSURL *url = [NSURL URLWithString:[array[i] objectForKey:@"Poster"]];
                        NSURLRequest *request = [NSURLRequest requestWithURL:url];
                        
                        UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
                        [[networkSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                            
                            if (error != nil) {
                                UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
                            } else {
                                UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
                                //Create image from the received data then assign it to movie attribute.
                                UIImage *img = [UIImage imageWithData:data];
                                movie.poster = img;
                                
                                //Call the DeserializerDelegate methods when done.
                                [self.delegate dataHasBeenDeserialized:store];
                            }
                        }] resume];
                    }

                    //store object in array
                    [store addObject:movie];
                }
            }
        }
        
        
        
        //Extract movie details informations.
        if ([[JsonObject objectForKey:@"Title"] isKindOfClass:[NSString class]])
        {
                //Assign value to movie object which was passed as parameter.
                Movie *movie = object;
            
                movie.title = [JsonObject objectForKey:@"Title"];
                movie.year = [JsonObject objectForKey:@"Year"];
                movie.imdbID = [JsonObject objectForKey:@"imdbID"];
                movie.type = [JsonObject objectForKey:@"Type"];
                movie.rated = [JsonObject objectForKey:@"Rated"];
                movie.released = [JsonObject objectForKey:@"Released"];
                movie.plot = [JsonObject objectForKey:@"Plot"];
                movie.actors = [JsonObject objectForKey:@"Actors"];
                movie.runtime = [JsonObject objectForKey:@"Runtime"];
                movie.director = [JsonObject objectForKey:@"Director"];
                movie.writer = [JsonObject objectForKey:@"Writer"];
                movie.languages = [JsonObject objectForKey:@"Language"];
                movie.awards = [JsonObject objectForKey:@"Awards"];
                movie.metascore = [JsonObject objectForKey:@"Metascore"];
                movie.country = [JsonObject objectForKey:@"Country"];
                movie.imdbRating = [JsonObject objectForKey:@"imdbRating"];
                movie.imdbVotes = [JsonObject objectForKey:@"imdbVotes"];
                movie.genre = [JsonObject objectForKey:@"Genre"];
        }
        [self.delegate dataHasBeenDeserialized:store];
    }
}


    
    
    
    
    

    
    
    
    
@end


