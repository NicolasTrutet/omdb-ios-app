//
//  DetailsTableViewCell.h
//  OMDBApp
//
//  Created by Nicolas TRUTET on 22/09/2016.
//  Copyright © 2016 Nicolas TRUTET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *details;

@end
