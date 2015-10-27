//
//  HistoryCell.h
//  ClassChatter App
//
//  Created by Adam Goldberg on 2015-10-27.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *historyFirstLabel;

@property (strong, nonatomic) IBOutlet UILabel *historyLastLabel;

@property (strong, nonatomic) IBOutlet UILabel *historyTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *historyGradeLabel;

@property (strong, nonatomic) IBOutlet UILabel *historyDisruptionLabel;

@end
