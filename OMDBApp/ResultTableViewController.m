//
//  ResultTableViewController.m
//  OMDBApp
//
//  Created by Nicolas TRUTET on 22/09/2016.
//  Copyright © 2016 Nicolas TRUTET. All rights reserved.
//

#import "ResultTableViewController.h"

static NSString *const reuseIdentifier = @"CellID";


@interface ResultTableViewController ()

@end

@implementation ResultTableViewController
{
    id _delegate;
}



#pragma mark - TableViewController Methods

- (void)setDelegateTo:(id)delegate {
    _delegate = delegate;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //Set the Nib name for the custom cell and its identifier.
    [self.tableView registerNib:[UINib nibWithNibName:@"ResultTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self data] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //Access movie from the data Array.
    Movie *movie = [[self data] objectAtIndex:[indexPath row]];
    
    /*
     - Set movie title and movie image.
       In case the movie image would be missing, then replace it by
       the local default image stored in Asset folder.
     
     */
    cell.movieTitle.text = movie.title;
    
    if (movie.poster != nil) {
        cell.moviePoster.image = movie.poster;
    } else {
        cell.moviePoster.image = [UIImage imageNamed:@"EmptyPoster"];
    }
    
    //Add Shadow to image
    cell.moviePoster.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.moviePoster.layer.shadowOffset = CGSizeMake(2, 2);
    cell.moviePoster.layer.shadowRadius = 2.0f;
    cell.moviePoster.layer.shadowOpacity = 0.5;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     - Remove highlight of the selected cell.
     - Trigger the ResultTableViewDelegate method and pass 
       the selected movie ID as parameter
     */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Movie *movie = [[self data] objectAtIndex:[indexPath row]];
    [_delegate didSelectedMovie:[movie imdbID]];
}





@end
