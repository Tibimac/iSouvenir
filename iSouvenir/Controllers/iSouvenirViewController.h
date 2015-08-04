//
//  iSouvenirViewController.h
//  iSouvenir
//
//  Created by Thibault Le Cornec on 11/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "iSouvenirMKAnnotation.h"
@class iSouvenirView;

@interface iSouvenirViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, ABPeoplePickerNavigationControllerDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
    UILongPressGestureRecognizer *longTouch;
    ABPeoplePickerNavigationController *addressbookPicker;
    UIPopoverController *popOverController;
    
    //  Stocke la pin actuellement sélectionnée lors de l'appel a son callOut
    //      (lors de l'affichage de la MKAnnotationView)
    MKAnnotationView *currentSelectedAnnotationView;
    
    //  L'image quand aucun contact n'est sélectionnée est mise dans une variable et réutilisée
    //      pour éviter une consommation mémoire inutile.
    UIImageView *defaultImageViewForLeftAccessoryView;
    
    //  Cette variable permet de savoir s'il s'agit de la première mise à jour
    //      de la localisation de l'utilisateur ou non.
    //  Permet de ne faire le zoom de la carte sur la localisation de l'utilisateur
    //      que la 1ère fois.
    BOOL firstUpdate;
    
    BOOL isiPhone;
}

//  Accès nécessaire pour le AppDelegate
//      (voir application:willChangeStatusBarFrame:)
@property (readonly, retain) iSouvenirView *mainView;

//  Appelée par le bouton "Ajouter".
//  Cette méthode ajoute une épongle au centre de la carte.
- (void)deletePinOnMap;

//  Appelée par le segmented control
//  Cette méthode permet de changer le type de carte affichée
-(void)changeMapType;

//  Appellée lorsqu'un appui long est détecté sur la carte
//  Cette méthode permet indirectement l'ajout d'une épingle
- (void)didLongTouch:(UILongPressGestureRecognizer*)gestureRecognizer;

@end