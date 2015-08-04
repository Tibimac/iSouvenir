//
//  iSouvenirView.m
//  iSouvenir
//
//  Created by Thibault Le Cornec on 11/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "iSouvenirView.h"
#import "iSouvenirViewController.h"

@implementation iSouvenirView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        /* ************************************************** */
        /* ---------------------- Carte --------------------- */
        _map = [[MKMapView alloc] init];
        [_map setScrollEnabled:YES];    // Valeur par défaut
        [_map setZoomEnabled:YES];      // Valeur par défaut
        [self addSubview:_map];
        [_map release];
        
        
        /* ************************************************** */
        /* ---------- Bouton Supprimer une épingle ---------- */
        _deletePinButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_deletePinButton setTitle:@"Supprimer" forState:UIControlStateNormal];
        [_deletePinButton addTarget:_viewController action:@selector(deletePinOnMap) forControlEvents:UIControlEventTouchUpInside];
        [_deletePinButton setTintColor:[UIColor orangeColor]];
        [self addSubview:_deletePinButton];
        [_deletePinButton release];
        
        
        /* ************************************************** */
        /* -------------- Segments Type de Carte ------------ */
        _mapType = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Plan", @"Satellite", @"Mixte", nil]];
        [_mapType addTarget:_viewController action:@selector(changeMapType) forControlEvents:UIControlEventValueChanged];
        [_mapType setSelectedSegmentIndex:[_map mapType]]; // Segment sélectionné par défaut = type par défaut de la carte.
        [_mapType setTintColor:[UIColor orangeColor]];
        [self addSubview:_mapType];
        [_mapType release];
        
        
        /* ************************************************** */
        /* ---------------- StatusBar Overlay --------------- */
        statusBarOverlay = [[UIView alloc] init];
        [statusBarOverlay setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1  alpha:0.7]];
        [self addSubview:statusBarOverlay];
        
        
        /* ************************************************** */
        /* ------------ Positionnement des objets ----------- */
        [self setViewForOrientation:[[UIApplication sharedApplication] statusBarOrientation]
                  withStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
        
        return self;
    }
    else
    {
        return nil;
    }
}


#pragma mark -
#pragma mark Draw Methods

- (void)setViewForOrientation:(UIInterfaceOrientation)orientation withStatusBarFrame:(CGRect)statusBarFrame
{
    #pragma mark Debug UI Position
    /* ======================= DEBUG ======================= */
//    [addPin setBackgroundColor:[UIColor yellowColor]];
//    [addContactToPin setBackgroundColor:[UIColor yellowColor]];
//    [_map setBackgroundColor:[UIColor yellowColor]];
//    [_mapType setBackgroundColor:[UIColor yellowColor]];
    /* ===================================================== */
    
    #pragma mark Positioning Objects
    
    #define MARGE_X 10
    CGFloat MARGE_Y = 0.0;
    CGFloat STATUSBAR_EXTRA = 0.0;
    
    if(UIInterfaceOrientationIsPortrait(orientation))
    {
        if (statusBarFrame.size.height > 20)
        {
            STATUSBAR_EXTRA = statusBarFrame.size.height-20;
        }
        
        [self setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-(STATUSBAR_EXTRA))];
    }
    else if (UIInterfaceOrientationIsLandscape(orientation))
    {
        if (statusBarFrame.size.width > 20)
        {
            STATUSBAR_EXTRA = statusBarFrame.size.width-20;
        }
        
        [self setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width-(STATUSBAR_EXTRA))];
    }
    
    CGFloat viewWidth   = [self bounds].size.width;
    CGFloat viewHeight  = [self bounds].size.height;
    
    [statusBarOverlay setFrame:CGRectMake(0, 0, viewWidth, 20)];
    
    // Carte prend :
    //      - la largueur de la vue mois les marges de 5 de chaque côté
    //      - la hauteur de la vue moins l'espace pris en haut moins les marges moins l'espace pris en bas
    //      ||  35 = espace pris au dessus  ||  10 = marge Bottom   ||  25+10 = espace pris en dessous  ||
    [_map       setFrame:CGRectMake(0, MARGE_Y, viewWidth, viewHeight-(MARGE_Y+10+25+10))];
    
    
    // Positionnement en hauteur = hauteur de la vue moins l'espace pris par la hauteur de l'objet et ses marges (5+25+5)
    // Largeur de l'objet = largeur de la vue moins les marges de 10 sur chaque côté moins la largeur du bouton de gauche moins espace de 20 entre les 2 élements
    [_mapType  setFrame:CGRectMake(MARGE_X, viewHeight-(25+10), viewWidth-(10+10+75+10), 25)];
    
    [_deletePinButton setFrame:CGRectMake(viewWidth-(75+10), viewHeight-(25+10), 75, 25)];
}

@end
