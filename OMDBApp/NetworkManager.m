//
//  NetworkManager.m
//  OMDBApp
//
//  Created by Nicolas TRUTET on 21/09/2016.
//  Copyright © 2016 Nicolas TRUTET. All rights reserved.
//

#import "NetworkManager.h"
#import "CacheManager.h"


@implementation NetworkManager
{
    NSURLSession *_networkSession;
    CacheManager *_cache;
}

    
    
    
    
    
/* 
 - Initialize NSURLSession.
 - Initialize cache manager singleton object.
*/
- (instancetype)init {
    self = [super init];
    
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _networkSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        _cache = [CacheManager CacheManagerInstance];
    }
    return self;
}

    
  
    
    
    
    
/*
  - Check if network and service are reachable.
  - Return Yes if successfull, NO otherwise.
*/
- (BOOL)isNetworkReachable {
    /*
    CFNetDiagnosticRef dReference;
    dReference = CFNetDiagnosticCreateWithURL (NULL, (__bridge CFURLRef)[NSURL URLWithString:@"www.omdbapi.com"]);
    
    CFNetDiagnosticStatus status;
    status = CFNetDiagnosticCopyNetworkStatusPassively (dReference, NULL);
    CFRelease (dReference);
    
    if ( status == kCFNetDiagnosticConnectionUp ) {
        return YES;
    }
    else {
        return NO;
    }
     */
    return YES;
}
    
    
    
    
    
    
    
   
/*
 - This public method fetches data for a given query. 
   Once done it triggers the NetworkManagerDelegate method and pass the response as parameter along with the response status.
 - It first check if the network is reachable.
 - If it is, then if search in the local cache before firering any HTTP request.
 - In case where the data would be present in the local cache it would trigger the NetworkManagerDelegate method with the response passed as parameter.
 - Otherwise no data will be sent and the NetworkManagerDelegate method will send a status of "failure" or "NetworkUnreachable".
 */
- (void)fetchDataWithQuery:(NSString *)query
             searchByTitle:(BOOL)byTitle {
    
    if ([self isNetworkReachable]) {
        
        //store the query for further reload purposes.
        [_cache saveLastQuery:query type:byTitle withOption:byTitle];
        
        if (byTitle) {
            
            /* 
             - Search in cache and return an NSMutableArray.
             - Otherwise perfom an HTTP request for the given query.
             */
            NSMutableArray *CacheResult = [_cache getResultForKey:query];
            if (CacheResult != NULL || CacheResult != nil) {
                ResponseStatus status = 0;
                [_delegate requestDidFinishWithStatus:status data:CacheResult];
                
            } else {
                //Perform HTTP request to search by title
                NSString *formatQuery = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.omdbapi.com/?s=%@&r=json", formatQuery]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [self performHTTPRequest:request withOption:nil] ;
            }
        
        } else {
            
            //Search in cache and return the movie in an NSMutableArray.
            Movie *movie = [_cache searchMovieBy:query];
            
            //Does the Movie has missing values that needs to be fetch online ?
            if (movie.plot == nil || movie.actors == nil || movie.rated == nil) {
                
                //Perform HTTP request to search by title
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.omdbapi.com/?i=%@&plot=full&r=json", query]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [self performHTTPRequest:request withOption:movie];
            }
            
            //Send the movie in an Array
            ResponseStatus status = 0;
            [_delegate requestDidFinishWithStatus:status data:[NSMutableArray arrayWithObject:movie]];
            
            
        }
        
    } else {
        //Respond with status network unreachable.
        ResponseStatus status = 2;
        [_delegate requestDidFinishWithStatus:status data:nil];
    }
}
    
    
    
    
    
    
    
    
    
    
    
    
/*
 - Perform an asynchronous HTTP request and in case of:
    - 'Error' it will trigger the NetworkManagerDelegate method and send a status of failure with no data.
    - 'Success' it will deserialize the received data.
      Once the data deserialized and stored in cache, it will trigger its DeserializerDelegate method which will trigger
      the same request and then return the data from the local cache.
 
*/
- (void)performHTTPRequest:(NSURLRequest *)request withOption:(id)option {
    
    UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;

    [[_networkSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            ResponseStatus status = 1;
            [_delegate requestDidFinishWithStatus:status data:nil];
            UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
        } else {
            UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
            Deserializer *desarializer = [Deserializer new];
            desarializer.delegate = self;
            [desarializer deserializeData:data andAssignValuesToObject:option];
        }
    }] resume];
}
    
    
    
    
    
    
    
    
/*
 - This is the DeserializerDelegate method implemetation that store data in cache, 
   then reload the request so that it will return the data from memory.
*/
- (void)dataHasBeenDeserialized:(NSMutableArray *)data {
    
    //Get the last type of query that was performed.
    BOOL lastRequestType = [[[_cache getLastQuery] valueForKey:@"option"] boolValue];
    
    if (lastRequestType) { //byTitle
        
        //Access last query parameters
        NSString *query = [[_cache getLastQuery] valueForKey:@"queryStringTitle"];
        BOOL type = [[[_cache getLastQuery] valueForKey:@"queryTypeTitle"] boolValue];
        
        //Store result in cache.
        [_cache storeResult:data forKey:query];
        
        //Reload the request with the previous parameters.
        [self fetchDataWithQuery:query searchByTitle:type];
    
    } else { //byID
        
        //Access last query parameters
        NSString *query = [[_cache getLastQuery] valueForKey:@"queryStringID"];
        BOOL type = [[[_cache getLastQuery] valueForKey:@"queryTypeID"] boolValue];
        
        //Reload the request with the previous parameters.
        [self fetchDataWithQuery:query searchByTitle:type];
    }
}
    
    
    

    
    

    
    
    
    
    
@end
