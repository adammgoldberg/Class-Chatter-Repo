//
//  ViewController.m
//  ClassTrack Onboarding
//
//  Created by Adam Goldberg on 2015-11-16.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//


#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    CGSize scrollViewSize = CGSizeMake(self.view.bounds.size.width + 2000, self.view.bounds.size.height);
//    self.scrollView.contentSize = scrollViewSize;

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
    
    self.scrollView.scrollEnabled = YES;
    //This will create a scrollview of device screen frame
    
    NSInteger numberOfViews = 5;
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin = i * self.view.frame.size.width;
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
        aView.backgroundColor = [UIColor colorWithRed:142/255.0f green:211/255.0f blue:7/255.0f alpha:1];
        [self.scrollView addSubview:aView];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * numberOfViews, self.view.frame.size.height);
    
    self.scrollView.pagingEnabled = YES;
    self.pageControl = [[UIPageControl alloc] init]; //SET a property of UIPageControl
    self.pageControl.frame = CGRectMake(100, self.view.frame.size.height-60, self.view.frame.size.width-200, 50);
    self.pageControl.numberOfPages = 5; //as we added 3 diff views
    self.pageControl.currentPage = 0;

    self.scrollView.delegate = self;
    
    [self.view addSubview:self.scrollView];
    
    [self.view addSubview:self.pageControl];
    

    
    [self makeFirstScene];
    [self makeSecondScene];
    [self makeThirdScene];
    [self makeFourthScene];
    [self makeFifthScene];
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2 ) / pageWidth) + 1; //this provide you the page number
    self.pageControl.currentPage = page;// this displays the white dot as current page
    if (self.scrollView.contentOffset.x > (4.1 * self.scrollView.frame.size.width)) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate enterApplication];
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // Check contentOffset X to make sure that you hit end
    
    // get instance of App Delegate and create / call some method swapRootViewControllers
    // internally in swap rootview controllers get instance of tab bar assign contexts and set to window.rootViewController
}

-(void)makeFirstScene
{
    
    UILabel *appTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 100, CGRectGetMinY(self.view.bounds) + 30, 200, 30)];
//    appTitleLabel.backgroundColor = [UIColor whiteColor];
    appTitleLabel.textColor = [UIColor whiteColor];
    appTitleLabel.font = [UIFont systemFontOfSize:20.0];
    appTitleLabel.textAlignment = NSTextAlignmentCenter;
    appTitleLabel.text = @"ClassTrack";
    [self.scrollView.subviews[0] addSubview:appTitleLabel];
    
    UIImageView *appImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"desks"]];
    appImageView.frame = CGRectMake(CGRectGetMaxX(self.view.bounds) *1/6, CGRectGetMinY(self.view.bounds) + 70, CGRectGetMaxX(self.view.bounds) * 2/3, CGRectGetMaxY(self.view.bounds) * 2/3);
    [self.scrollView.subviews[0] addSubview:appImageView];
    
    UILabel *appDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 120, CGRectGetMaxY(appImageView.frame) + 10, 240, 80)];
    appDescriptionLabel.numberOfLines = 8;
//    appDescriptionLabel.backgroundColor = [UIColor whiteColor];
    appDescriptionLabel.textColor = [UIColor whiteColor];
    appDescriptionLabel.font = [UIFont systemFontOfSize:15.0];
    appDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    appDescriptionLabel.text = @"ClassTrack is a teacher-friendly email and classroom management app! It's designed to save teachers time and stress!";
    [self.scrollView.subviews[0] addSubview:appDescriptionLabel];
    
}



-(void)makeSecondScene
{
    
    UILabel *firstDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 150, 30, 300, 50)];
    firstDetailLabel.textColor = [UIColor whiteColor];
    firstDetailLabel.font = [UIFont systemFontOfSize:20.0];
    firstDetailLabel.text = @"Quickly record your students' classroom behaviour";
    firstDetailLabel.numberOfLines = 3;
    [self.scrollView.subviews[1] addSubview:firstDetailLabel];
    
    UIImageView *firstDetailImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"desks2"]];
    firstDetailImage.frame = CGRectMake(CGRectGetMinX(self.view.bounds) + 10, 90, CGRectGetMaxX(self.view.bounds) / 2 - 20, CGRectGetMaxY(self.view.bounds) / 2 - 20);
    [self.scrollView.subviews[1] addSubview:firstDetailImage];
    
    UIImageView *firstDetailImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mail"]];
    firstDetailImage2.frame = CGRectMake(CGRectGetMidX(self.view.bounds) + 10, 90, CGRectGetMaxX(self.view.bounds) / 2 - 20, CGRectGetMaxY(self.view.bounds) / 2 - 20);
    [self.scrollView.subviews[1] addSubview:firstDetailImage2];
    
    UILabel *firstDetailDescription = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 150, CGRectGetMaxY(firstDetailImage.frame) + 10, 300, 150)];
    firstDetailDescription.numberOfLines = 8;
    firstDetailDescription.textColor = [UIColor whiteColor];
   firstDetailDescription.textAlignment = NSTextAlignmentLeft;
    firstDetailDescription.text = @"Tap the desks to record good and bad behaviour, and have emails automatically prepared to be sent!\n\nClassTrack automatically fills in email templates with student and parent information so you don't have to!";
    [self.scrollView.subviews[1] addSubview:firstDetailDescription];
    
    
}


-(void)makeThirdScene
{
    UILabel *secondDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 150, 30, 300, 50)];
    secondDetailLabel.textColor = [UIColor whiteColor];
    secondDetailLabel.font = [UIFont systemFontOfSize:20.0];
    secondDetailLabel.text = @"Easily add and edit students and classes";
    secondDetailLabel.numberOfLines = 3;
    [self.scrollView.subviews[2] addSubview:secondDetailLabel];
    
    UIImageView *secondDetailImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list"]];
    secondDetailImage.frame = CGRectMake(CGRectGetMinX(self.view.bounds) + 10, 90, CGRectGetMaxX(self.view.bounds) / 2 - 20, CGRectGetMaxY(self.view.bounds) / 2 - 20);
    [self.scrollView.subviews[2] addSubview:secondDetailImage];
    
    UIImageView *secondDetailImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add"]];
    secondDetailImage2.frame = CGRectMake(CGRectGetMidX(self.view.bounds) + 10, 90, CGRectGetMaxX(self.view.bounds) / 2 - 20, CGRectGetMaxY(self.view.bounds) / 2 - 20);
    [self.scrollView.subviews[2] addSubview:secondDetailImage2];
    
    UILabel *secondDetailDescription = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 150, CGRectGetMaxY(secondDetailImage.frame) + 10, 300, 150)];
    secondDetailDescription.numberOfLines = 8;
    secondDetailDescription.textColor = [UIColor whiteColor];
    secondDetailDescription.textAlignment = NSTextAlignmentLeft;
    secondDetailDescription.text = @"Type in student specific information once and you won't have to again.\n\nEasy to edit students (click on the student) and classes if need be.";
    [self.scrollView.subviews[2] addSubview:secondDetailDescription];
    
}

-(void)makeFourthScene
{
    UILabel *thirdDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 150, 30, 300, 50)];
    thirdDetailLabel.textColor = [UIColor whiteColor];
    thirdDetailLabel.font = [UIFont systemFontOfSize:20.0];
    thirdDetailLabel.text = @"View and search student behaviour history";
    thirdDetailLabel.numberOfLines = 3;
    [self.scrollView.subviews[3] addSubview:thirdDetailLabel];
    
    UIImageView *thirdDetailImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hist"]];
    thirdDetailImage.frame = CGRectMake(CGRectGetMinX(self.view.bounds) + 10, 90, CGRectGetMaxX(self.view.bounds) / 2 - 20, CGRectGetMaxY(self.view.bounds) / 2 - 20);
    [self.scrollView.subviews[3] addSubview:thirdDetailImage];
    
    UIImageView *thirdDetailImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dets"]];
    thirdDetailImage2.frame = CGRectMake(CGRectGetMidX(self.view.bounds) + 10, 90, CGRectGetMaxX(self.view.bounds) / 2 - 20, CGRectGetMaxY(self.view.bounds) / 2 - 20);
    [self.scrollView.subviews[3] addSubview:thirdDetailImage2];
    
    UILabel *thirdDetailDescription = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 150, CGRectGetMaxY(thirdDetailImage.frame) + 10, 300, 150)];
    thirdDetailDescription.numberOfLines = 8;
    thirdDetailDescription.textColor = [UIColor whiteColor];
    thirdDetailDescription.text = @"Anytime you press a student's desk, an event is recorded on the History page.\n\nClick on a specific event to add more details for future reference.";
    [self.scrollView.subviews[3] addSubview:thirdDetailDescription];
    
}

-(void)makeFifthScene
{
    UILabel *fourthDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 150, 30, 300, 50)];
    fourthDetailLabel.textColor = [UIColor whiteColor];
    fourthDetailLabel.font = [UIFont systemFontOfSize:20.0];
    fourthDetailLabel.text = @"Customize your templates and settings";
    fourthDetailLabel.numberOfLines = 3;
    [self.scrollView.subviews[4] addSubview:fourthDetailLabel];
    
    UIImageView *fourthDetailImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"temp"]];
    fourthDetailImage.frame = CGRectMake(CGRectGetMinX(self.view.bounds) + 10, 90, CGRectGetMaxX(self.view.bounds) / 2 - 20, CGRectGetMaxY(self.view.bounds) / 2 - 20);
    [self.scrollView.subviews[4] addSubview:fourthDetailImage];
    
    UIImageView *fourthDetailImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more"]];
    fourthDetailImage2.frame = CGRectMake(CGRectGetMidX(self.view.bounds) + 10, 90, CGRectGetMaxX(self.view.bounds) / 2 - 20, CGRectGetMaxY(self.view.bounds) / 2 - 20);
    [self.scrollView.subviews[4] addSubview:fourthDetailImage2];
    
    UILabel *fourthDetailDescription = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 150, CGRectGetMaxY(fourthDetailImage.frame) + 10, 300, 150)];
    fourthDetailDescription.numberOfLines = 8;
    fourthDetailDescription.textColor = [UIColor whiteColor];
    fourthDetailDescription.text = @"You can create and save a unique positive and negative email template.\n\nTeachers can customize the amount of behaviours before an email is sent.\n\nSwipe right to continue!";
    [self.scrollView.subviews[4] addSubview:fourthDetailDescription];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
