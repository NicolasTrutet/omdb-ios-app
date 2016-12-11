//
//  ResultTableViewCell.h
//  OMDBApp
//
//  Created by Nicolas TRUTET on 23/09/2016.
//  Copyright © 2016 Nicolas TRUTET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *movieTitle;
@property (nonatomic, weak) IBOutlet UILabel *year;
@property (nonatomic, weak) IBOutlet UIImageView *moviePoster;

@end
