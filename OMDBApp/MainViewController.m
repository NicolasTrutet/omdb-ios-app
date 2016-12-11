//
//  MainViewController.m
//  OMDBApp
//
//  Created by Nicolas TRUTET on 22/09/2016.
//  Copyright © 2016 Nicolas TRUTET. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
{
    ResultTableViewController *_ResultViewCtrl;
    NetworkManager *_networkManager;
}






/*
 - Set shadow of the UILabel which is use as logo background.
 */
- (void)customBackgroundWallpaper {
    self.BackgroundWallpaper.layer.shadowColor = [UIColor blackColor].CGColor;
    self.BackgroundWallpaper.layer.shadowOffset = CGSizeMake(2, 2);
    self.BackgroundWallpaper.layer.shadowRadius = 2.0f;
    self.BackgroundWallpaper.layer.shadowOpacity = 0.5;
}






#pragma mark - Search Bar Management

/*
 - Initialize search bar.
 - Change its text color and placeholder.
 */
- (void)customSearchBar {
    self.SearchBar.delegate = self;
    self.SearchBar.showsCancelButton = NO;
    
    //Custom search field appearance
    UITextField *searchField = [self.SearchBar valueForKey:@"searchField"];
    searchField.textColor = [UIColor blackColor];
    searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search movies"];
}


/*
 - Once the search button is triggered, the UIKeyboard is dissmissed and
   a request is fired to get movies data from the given query.
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self searchDataWithQuery:[searchBar text]];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.SearchBar setShowsCancelButton:YES animated:YES];
}

/*
 - This method is called if the user hit the searchBar cancel button.
 - Once hit, the cancel button is hidden, the UIkeyboard is dissmised
   the tableView that holds the movie list is removed and the
   UILabel that serves as background logo is reset to its default value in case
   error message would have been displayed in it.
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.SearchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self removeTableView];
    [self resetBackgroundLabelAppearence];
}








#pragma mark - TableView Management

/*
 - Initialize _ResultViewCtrl tableView that holds the movie list 
   and displays the data passed as parameter.
 */
- (void)displayTableViewWithData:(NSMutableArray *)data {
    
    if (_ResultViewCtrl == nil) {
        _ResultViewCtrl = [ResultTableViewController new];
        [_ResultViewCtrl setDelegateTo:self];
        _ResultViewCtrl.view.frame = self.viewContainer.bounds;
        [self.viewContainer addSubview:_ResultViewCtrl.view];
    }
    
    //Pass data to display on tableView.
    if (_ResultViewCtrl != nil) {
        _ResultViewCtrl.data = data;
        [_ResultViewCtrl.tableView reloadData];
    }
}


/*
 - Remove the _ResultViewCtrl tableView that holds the movie list
   from the view.
 */
- (void)removeTableView {
    
    if (_ResultViewCtrl != nil) {
        [_ResultViewCtrl.view removeFromSuperview];
        _ResultViewCtrl = nil;
    }
}









#pragma mark - Networking

/*
 - In this implementation this method create a instance of a NetwokManager object
   and make a HTTP request to query a movie list from the given query parameter.
 */
- (void)searchDataWithQuery:(NSString *)query {
    
    if (_networkManager == nil) {
        _networkManager = [NetworkManager new];
        _networkManager.delegate = self;
    }
    
    [_networkManager fetchDataWithQuery:query searchByTitle:YES];
    self.activityIndicatorView.alpha = 1;
    [self.activityIndicatorView startAnimating];
}



/*
 - This is the NetworkManagerDelegate method which is called once the data has been fetched.
 - In this implementation the parameter 'data' contains an array of movie object.
 - This method receives a status which is an integer that indicates if the network request was a success or not.
   Status 0 = success
   Status 1 = failure
   Status 2 = unreachable network
 - In case of a status of 1 or 2, an AlertView is displayed.
 - In case of a success, a method that displays the movie list in a tableView is called and
   the UILabel that serves as background logo is reset to its default value in case error message would have been displayed in it.
 */
- (void)requestDidFinishWithStatus:(NSUInteger)status data:(NSMutableArray *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.alpha = 0;
        
        if ([data count] != 0 && data != nil) {
            [self displayTableViewWithData:data];
            [self resetBackgroundLabelAppearence];
        } else {
            [self changeBackgroundLabelWithMessage:@"Sorry there is no movie for that search."];
            
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


/*
 - This is the ResultTableViewDelegate method that is called when
   the user has hit a cell from the tableView.
 - A DetailsViewController is instanciated and the value of the selected movie ID is passed to the ViewController.
   Then the navigation controller displays the DetailsViewController view.
 */
- (void)didSelectedMovie:(NSString *)ID {
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsVC"];
    detailsVC.imdbID = ID;
    [self.navigationController pushViewController:detailsVC animated:YES];
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


/*
 - The following two methods are use to display informations in the UILabel
   set in the background view with different fonts,  font size and FX.
 - changeBackgroundLabelWithMessage() is use to display error information
 - resetBackgroundLabelAppearence() display the logo, name of the app with shadow.
 */
- (void)changeBackgroundLabelWithMessage:(NSString *)message {
    self.BackgroundWallpaper.font = [UIFont fontWithName:@"System-Bold" size:19];
    self.BackgroundWallpaper.text = message;
    self.BackgroundWallpaper.layer.shadowColor = [UIColor clearColor].CGColor;
}

- (void)resetBackgroundLabelAppearence {
    self.BackgroundWallpaper.font = [UIFont fontWithName:@"Lemon-Regular" size:34];
    self.BackgroundWallpaper.text = @"OMDB";
    [self customBackgroundWallpaper];
    
}




#pragma  mark - View Controller Methods

/*
 - Triggered when the user hit the background view.
 - This remove the search bar cancel button and
   dissmiss the UIKeyboard.
 */
- (IBAction)removeKeyboard:(id)sender {
    [self.SearchBar setShowsCancelButton:NO animated:YES];
    [self.SearchBar resignFirstResponder];
}



- (void)viewDidLoad {
    [super viewDidLoad];

    [self customBackgroundWallpaper];
    [self customSearchBar];
    self.activityIndicatorView.alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"Search";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
