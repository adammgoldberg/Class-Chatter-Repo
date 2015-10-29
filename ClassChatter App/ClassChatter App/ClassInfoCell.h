//
//  ClassInfoCell.h
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-10-26.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *studentFirstNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *studentLastNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *parentTitleLabel;


@property (strong, nonatomic) IBOutlet UILabel *parentEmailLabel;

@property (strong, nonatomic) IBOutlet UILabel *studentClassLabel;

@property (strong, nonatomic) IBOutlet UILabel *parentLastLabel;


@end
