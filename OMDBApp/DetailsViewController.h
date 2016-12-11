//
//  DetailsViewController.h
//  OMDBApp
//
//  Created by Nicolas TRUTET on 22/09/2016.
//  Copyright © 2016 Nicolas TRUTET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "Movie.h"
#import "DetailsTableViewCell.h"

@interface DetailsViewController : UIViewController <NetworkManagerDelegate, UITableViewDelegate, UITableViewDataSource>

//Hold the movie ID.
@property (nonatomic, strong) NSString *imdbID;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
