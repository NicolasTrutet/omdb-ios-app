//
//  MainViewController.h
//  OMDBApp
//
//  Created by Nicolas TRUTET on 22/09/2016.
//  Copyright © 2016 Nicolas TRUTET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultTableViewController.h"
#import "NetworkManager.h"
#import "DetailsViewController.h"

@interface MainViewController : UIViewController <UISearchBarDelegate, ResultTableViewDelegate, NetworkManagerDelegate>

@property (nonatomic, weak) IBOutlet UIControl *viewContainer;
@property (nonatomic, weak) IBOutlet UILabel *BackgroundWallpaper;
@property (nonatomic, weak) IBOutlet UISearchBar *SearchBar;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end
