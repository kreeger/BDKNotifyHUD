//
//  BDKAppDelegate.h
//  BDKNotifyHUD
//
//  Created by Benjamin Kreeger on 11/2/12.
//  Copyright (c) 2012 Benjamin Kreeger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BDKViewController;

@interface BDKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BDKViewController *viewController;

@end
