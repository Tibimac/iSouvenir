//
//  iSouvenirView.h
//  iSouvenir
//
//  Created by Thibault Le Cornec on 11/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class iSouvenirViewController;

@interface iSouvenirView : UIView
{
    UIView *statusBarOverlay;
}

@property (strong, readwrite, retain)iSouvenirViewController <MKMapViewDelegate, UIActionSheetDelegate> *viewController;
@property (readwrite, copy) MKMapView *map;
@property (readwrite, copy) UIButton *deletePinButton;
@property (readwrite, copy) UISegmentedControl *mapType;


- (void)setViewForOrientation:(UIInterfaceOrientation)orientation
            withStatusBarFrame:(CGRect)statusBarFrame;

@end