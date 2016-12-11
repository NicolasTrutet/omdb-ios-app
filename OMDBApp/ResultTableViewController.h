//
//  ResultTableViewController.h
//  OMDBApp
//
//  Created by Nicolas TRUTET on 22/09/2016.
//  Copyright © 2016 Nicolas TRUTET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "ResultTableViewCell.h"

@protocol ResultTableViewDelegate
- (void)didSelectedMovie:(NSString *)ID;
@end




@interface ResultTableViewController : UITableViewController 

@property (nonatomic, strong) NSMutableArray *data;

- (void)setDelegateTo:(id)delegate;
@end
