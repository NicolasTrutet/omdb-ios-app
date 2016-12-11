//
//  DetailsViewController.m
//  OMDBApp
//
//  Created by Nicolas TRUTET on 22/09/2016.
//  Copyright © 2016 Nicolas TRUTET. All rights reserved.
//

#import "DetailsViewController.h"

static NSString *const reuseIdentifier = @"DetailCell";


@interface DetailsViewController ()

@end

@implementation DetailsViewController
{
    NetworkManager *_networkManager;
    NSMutableArray *_moviesArray;
    BOOL _isTableViewTransparent;
}




#pragma mark - Networking

/*
 - In this implementation this method create a instance of a NetwokManager object
   and make a HTTP request to query a movie details by its ID.
 */
- (void)searchDataWithQuery:(NSString *)query {
    
    if (_networkManager == nil) {
        _networkManager = [NetworkManager new];
        _networkManager.delegate = self;
    }
    [_networkManager fetchDataWithQuery:query searchByTitle:NO];
}






/*
 - This is the NetworkManagerDelegate method which is called once the data has been fetched.
 - In this implementation the parameter 'data' contains a Movie object.
   Each movie attribute is stored in a NSDictionary along with the type of attribute it corresponds to.
   Each NSDictionary is then stored in a NSMutableArray that will be used for further display on tableView.
 - This method receives a status which is an integer that indicates if the network request was a success or not.
   Status 0 = success
   Status 1 = failure
   Status 2 = unreachable network
 - In case of a status of 1 or 2, an AlertView is displayed.
 - In case of a success, the tableView is reloaded and a image is assign to the background UIImageView.
 */
- (void)requestDidFinishWithStatus:(NSUInteger)status data:(NSMutableArray *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([data count] != 0 && data != nil) {
            Movie *movie = [data objectAtIndex:0];
            
            if (movie.poster != nil) {
                self.imageView.image = movie.poster;
            }
            [_moviesArray removeAllObjects];
            
            [_moviesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:movie.title, @"value", @"Title", @"header",  nil]];
            [_moviesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:movie.year, @"value",@"Year", @"header", nil]];
            [_moviesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:movie.genre, @"value",@"Genre", @"header", nil]];
            [_moviesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:movie.plot, @"value",@"Story", @"header", nil]];
            [_moviesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:movie.rated, @"value",@"Rated", @"header", nil]];
            [_moviesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:movie.released, @"value",@"Released", @"header", nil]];
            [_moviesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:movie.runtime, @"value",@"Runtime", @"header", nil]];
            [_moviesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:movie.director, @"value",@"Director", @"header", nil]];
            [_moviesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:movie.writer, @"value",@"Writer", @"header", nil]];
            [_moviesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:movie.actors, @"value",@"Actors", @"header", nil]];
            [_moviesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:movie.languages, @"value",@"Languages", @"header", nil]];
            [_moviesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:movie.country, @"value",@"Country", @"header", nil]];
            [_moviesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:movie.awards, @"value",@"Awards", @"header", nil]];
            [_moviesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:movie.metascore, @"value",@"Metascore", @"header", nil]];
            [_moviesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:movie.imdbRating, @"value",@"Rating", @"header", nil]];
            [_moviesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:movie.imdbVotes, @"value",@"Votes", @"header", nil]];
            
            [self.tableView reloadData];
            
            if (movie.poster != nil) {
                self.imageView.image = movie.poster;
            } else {
                self.imageView.image = [UIImage imageNamed:@"EmptyPoster"];
            }
        }
        
        switch (status) {
            case 1:
                [self displayAlertViewWithMessage:@"Sorry there were a networking problem."];
                break;
            case 2:
                [self displayAlertViewWithMessage:@"Sorry the network is unreachable."];
            default:
                break;
        }
    });
}







#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_moviesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //Access movie atttribute and the title of which it corresponds to.
    NSDictionary *movieDict = [_moviesArray objectAtIndex:[indexPath row]];
    NSString *header = [movieDict valueForKey:@"header"];
    NSString *value = [movieDict valueForKey:@"value"];
    
    cell.title.text = header;
    cell.details.text = value;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     - Count the number of characters the movie attribute contains in order
       to calculate the size of the cell.
     - This is mainly made to display the movie plot which contains a lot of informations.
     */
    NSDictionary *movieDict = [_moviesArray objectAtIndex:[indexPath row]];
    NSString *value = [movieDict valueForKey:@"value"];
    CGFloat height = 85;
    
    if (value != nil) {
        CGFloat characters = [value length];
        CGFloat space = (characters/60) * 15;
        height = 85 + space;
    }
    return height;
}




/*
 - Initialize UITableView and disable user cell selection.
 - Initialize the movieArray use to contain movie details informations.
 - Add tap gesture recognizer which is use to display/remove tableView in order 
   to show the whole picture in the background or show movie details infos.
 */
- (void)initTableView {
    
    if (_moviesArray == nil) {
        _moviesArray = [NSMutableArray new];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    
    //Add Tap gesture recognizer to tableView.
    UITapGestureRecognizer *singleTapGestureForTableView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    self.tableView.tag = 1;
    [self.tableView addGestureRecognizer:singleTapGestureForTableView];
    
    //Add Tap gesture recognizer to background imageView.
    UITapGestureRecognizer *singleTapGestureForImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    self.imageView.tag = 2;
    [self.imageView addGestureRecognizer:singleTapGestureForImage];
    [self.imageView setUserInteractionEnabled:YES];
}





#pragma mark - AlertView Management

/*
 - Display alertView in case of error.
 */
- (void)displayAlertViewWithMessage:(NSString *)message {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Sorry"
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* OKButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                               }];
    
    [alert addAction:OKButton];
    [self presentViewController:alert animated:YES completion:nil];
}







#pragma  mark - Tap Gesture

/*
 - Make tableView transparent or visible by setting its alpha to 1 or 0;
 */
-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer{
    
    if (tapGestureRecognizer.view.tag == 1) { //tableview
        [UITableView animateWithDuration:0.3 animations:^{
            self.tableView.alpha = 0;
        }];
    } else if (tapGestureRecognizer.view.tag == 2) { //imageview
        [UITableView animateWithDuration:0.3 animations:^{
            self.tableView.alpha = 1;
        }];
    }
}



#pragma  mark - View Controller Methods


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set nav bar title
    self.navigationItem.title = @"Details";
    
    //Hide back button text.
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [self searchDataWithQuery:[self imdbID]];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
