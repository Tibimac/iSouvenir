//
//  iSouvenirMKAnnotation.h
//  iSouvenir
//
//  Created by Thibault Le Cornec on 14/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreLocation/CLLocation.h>
#import <MapKit/MapKit.h>

@interface iSouvenirMKAnnotation : NSObject <MKAnnotation> // On crée notre classe car les propriétés d'une MKAnnotation sont en read-only

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                         andTitle:(NSString *)title
                      andSubtitle:(NSString*)subtitle;

@end
