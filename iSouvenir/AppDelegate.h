//
//  AppDelegate.h
//  iSouvenir
//
//  Created by Thibault Le Cornec on 11/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iSouvenirViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    iSouvenirViewController *rootViewController;
}
@property (strong, nonatomic) UIWindow *window;

@end
