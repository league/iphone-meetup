//
//  DetailViewController.h
//  meetup
//
//  Created by user3368 on 7/18/13.
//  Copyright (c) 2013 Chris League. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meetup.h"

@interface DetailViewController : UIViewController<UIWebViewDelegate>
@property IBOutlet UIWebView *webView;
@property Meetup *meetup;
@property IBOutlet UIActivityIndicatorView *spinner;

@end
