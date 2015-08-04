//
//  iSouvenirMKAnnotation.m
//  iSouvenir
//
//  Created by Thibault Le Cornec on 14/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "iSouvenirMKAnnotation.h"

@implementation iSouvenirMKAnnotation

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *)title andSubtitle:(NSString *)subtitle
{
    self = [super init];
    
    if (self)
    {
        _coordinate = coordinate;
        _title = title;
        _subtitle = subtitle;
        return self;
    }
    else
    {
        return nil;
    }
}

- (void)dealloc
{
    [_title release];
    _title = nil;
    [super dealloc];
}

@end
