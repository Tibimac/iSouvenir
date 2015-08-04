//
//  iSouvenirViewController.m
//  iSouvenir
//
//  Created by Thibault Le Cornec on 11/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "iSouvenirViewController.h"
#import "iSouvenirView.h"

@implementation iSouvenirViewController

/* ************************************************** */
/* ----------------- Initialisations ---------------- */
/* ************************************************** */
#pragma mark - Initialisations

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialisation de la vue principale et des delegate
    _mainView = [[iSouvenirView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_mainView setViewController:self];
    [[_mainView map] setDelegate:self];
    // On relie la vue créé a la vue dirigée par ce controlleur.
    // (Le controleur connait ainsi la vue qu'il gère)
    [[self view] addSubview:_mainView];
    
    
    /* -------------------- Appui Long ------------------ */
    //  Ne peut être créé dans iSouvenirView si la target est le controlleur,
    //      car au moment de la création le controlleur = nil
    longTouch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongTouch:)];
    [[_mainView map] addGestureRecognizer:longTouch];
    [longTouch release];
    
    
    // Initialisation des variables d'instance
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    { isiPhone = YES; }
    else
    { isiPhone = NO; }
    // L'image par défaut est créée et sera réutilisé à chaque fois que nécessaire
    defaultImageViewForLeftAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoContactGrey"]];

    
    // Vérif de l'activation ou non des services de localisation
    if ([CLLocationManager locationServicesEnabled])
    {        
        firstUpdate = YES;
        // On désactive le bouton tant qu'une épingle n'est pas sélectionnée
        [[_mainView deletePinButton] setEnabled:NO];
        // Localisation de l'utilisateur pour affichage sur la carte
        [[_mainView map] setShowsUserLocation:YES];
    }
    else // Si les services de localisation sont désactivés -> Alerte Erreur
    {
        UIAlertView *alertViewLocationServicesNotEnabled;
        alertViewLocationServicesNotEnabled = [[UIAlertView alloc]
                                               initWithTitle:@"Services de localisation désactivés"
                                               message:@"Les services de localisation sont désactivés.\nPour les activer rendez-vous dans Réglages > Confidentialité > Services de localisation."
                                               delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alertViewLocationServicesNotEnabled show];
        [alertViewLocationServicesNotEnabled release];
    }
}





/* ************************************************** */
/* ------------ Localisation Utilisateur ------------ */
/* ************************************************** */
#pragma mark - Localisation Utilisateur

#pragma mark |--> Changement localisation (MKMapViewDelegate)
//  Méthode appellée lorsque la localisation de l'utilisateur a changée
//  Cette méthode permet de zoomer sur la localisation de l'utilisateur
//      mais seulement lors du la 1ère mise à jour (théoriquement au lancement de l'app)
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //  On zoom sur la localisation de l'utilisateur uniquement lors de la 1ère mise à jour.
    //  Après on le laisse déplacer la carte comme il souhaite.
    if (firstUpdate)
    {
        // On récupère les coordonnées de la localisation de l'utilisateur
        CLLocationCoordinate2D userLocationCoordinate = [[[[_mainView map] userLocation] location] coordinate];
        
        // On centre la carte sur la position de l'utilisateur
        [[_mainView map] setCenterCoordinate:userLocationCoordinate animated:YES];
        
        // On défini de "zoom"
        MKCoordinateSpan span = {.latitudeDelta = 0.005, .longitudeDelta = 0.005};
        
        // On défini la région a afficher avec les coordonnées et la valeur de "zoom"
        [[_mainView map] setRegion:MKCoordinateRegionMake(userLocationCoordinate, span) animated:YES];
        
        firstUpdate = NO;
    }
}


#pragma mark |--> Erreur de localisation (MKMapViewDelegate)
//  Si la carte n'a pas pu localiser l'utilisateur -> Alerte Erreur
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    UIAlertView *alertViewMKLocationError;
    alertViewMKLocationError = [[UIAlertView alloc] initWithTitle:@"Localisation Impossible"
                                                          message:@"Pour vous localiser, vous devez autoriser iSouvenir à utiliser votre localisation.\nRendez-vous dans Réglages > Confidentialité > Services de localisation et activez la localisation pour iSouvenir."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    [alertViewMKLocationError show];
    [alertViewMKLocationError release];
}





/* ************************************************** */
/* ---------------- Methodes d'Action --------------- */
/* ************************************************** */
#pragma mark - Methodes d'Action

#pragma mark |--> Changement Type Carte
//  Méthode appellée lorsque l'on selectionne un nouveau segment sur le UISegmentedControl
//  Cette méthode change le type de carte en fonction da la valeur du segment sélectionné
-(void)changeMapType
{
    [[_mainView map] setMapType:[[_mainView mapType] selectedSegmentIndex]];
}





/* ************************************************** */
/* ----------------- Ajout Épingle ----------------- */
/* ************************************************** */
#pragma mark - Ajout Épingle

#pragma mark |--> Création annotation iSouveniMKAnnotation
//  Méthode appellée pour la création d'une épingle
//  Cette méthode crée une épingle aux coordonnées
//      qui lui sont passées en paramètre
//  Fait appel à mapView:viewForAnnotation:
- (void)addPinOnMap:(CLLocationCoordinate2D)coordinate
{
    // On construit l'annotation avec ses attributs
    iSouvenirMKAnnotation *newAnnotation = [[iSouvenirMKAnnotation alloc]
                                            initWithCoordinate:coordinate
                                            andTitle:@"Aucun contact associé"
                                            andSubtitle:nil];
   
    // Ajout à la map (qui va nous demander de créer la vue)
    [[_mainView map] addAnnotation:newAnnotation];

    [newAnnotation release];
}


#pragma mark |--> Création de la vue pour les annotations (MKMapViewDelegate)
//  Méthode appellée lors de l'ajout d'une annotation pour configurer sa vue (MKPinAnnotationView)
//  Cette méthode crée une vue personnalisée s'il s'agit d'une MKAnnotation de type iSouvenirMKAnnotation
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        ((MKUserLocation *)annotation).title = @"Vous êtes ici";
        return nil;  //return nil to use default blue dot view
    }
    
    if ([annotation isKindOfClass:[iSouvenirMKAnnotation class]])
    {
        // S'il existe déja une vue avec un ID "pinViewID" on la récupère pour la réutiliser
        MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier: @"pinViewID"];
        
        if (pin == nil) // Si nil = pas de vue existante avec cet ID = on crée la vue
        {
            pin = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinViewID"] autorelease];
        }
        else // Si non nil = une vue existe déja = on lui donne la nouvelle annotation
        {
            [pin setAnnotation:annotation];
        }
        
        [pin setAnimatesDrop:YES];
        [pin setDraggable:YES];
        [pin setCanShowCallout:YES];
        [pin setTintColor:[UIColor orangeColor]];
        
        // Nouvelle pin = aucun contact sélectionné = image par défaut
        [pin setLeftCalloutAccessoryView:defaultImageViewForLeftAccessoryView];
        [pin setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeContactAdd]];
        
        return pin;
    }
    else
    {
        return nil;
    }
    
}


#pragma mark |--> Reconnaissance touché long sur la carte
//  Méthode appellée lorsqu'on fait un appui long sur la carte
//  Cette méthode récupère les coordonnées sur la map où l'appui
//      a été fait et appelle la méthode addOrDeletePinOnMap pour ajouter
//      une épingle sur la carte à ces coordonnées
- (void)didLongTouch:(UILongPressGestureRecognizer*)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        MKMapView *theMap = [_mainView map];
        CGPoint touchPoint = [gestureRecognizer locationInView:theMap];
        CLLocationCoordinate2D touchCoordinateOnMap = [theMap convertPoint:touchPoint toCoordinateFromView:theMap];
        [self addPinOnMap:touchCoordinateOnMap];
    }
}





/* ************************************************** */
/* --------------- Suppression Épingle -------------- */
/* ************************************************** */
#pragma mark - Suppression Épingle

#pragma mark |--> Gestion suppression épingle(s)
//  Méthode appellée pour supprimer une épingle de la carte
//  Cette méthode compte le nombre d'épingle sur la carte, hormis éventuellement
//      celle représentant la localisation actuelle de l'utilisateur
-(void)deletePinOnMap
{
    NSUInteger nbPinOnMap = 0;
    
    // Si la localisation de l'utilisateur est activé et fonctione (donc visible)
    //  on déduit du total des épingles l'épingle qui représente sa position
    if ([[_mainView map] showsUserLocation] == YES && [[_mainView map] isUserLocationVisible] == YES)
    {
        nbPinOnMap = [[[_mainView map] annotations] count]-1; // Il y a nb-(userLocation) épingles
    }
    else
    {
        nbPinOnMap = [[[_mainView map] annotations] count]; // Il y a nb épingles
    }
    
    
    // S'il n'y a qu'une seule épingle
    //  (hormis éventuellement celle représentant la localisation de l'utilisateur)
    //  sur la carte, on supprime direct
    if (nbPinOnMap == 1)
    {
        [[_mainView map] removeAnnotation:[currentSelectedAnnotationView annotation]];
    }
    
    // Si plusieurs, on affiche l'ActionSheet pour demander à l'utilisateur
    //  s'il souhaite supprimer celle sélectionnée ou toutes les épingles de la carte
    if ([[[_mainView map] annotations] count] > 1)
    {
        UIActionSheet *deleteOneOrAllPin;
        deleteOneOrAllPin = [[UIActionSheet alloc] initWithTitle:@"Que voulez-vous supprimer ?"
                                                        delegate:self
                                               cancelButtonTitle:@"Rien"
                                          destructiveButtonTitle:@"L'épingle sélectionnée"
                                               otherButtonTitles:@"Toutes les épingles", nil];
        if (isiPhone)
        {
            [deleteOneOrAllPin showInView:_mainView];
        }
        else
        {
            [deleteOneOrAllPin showFromRect:CGRectMake([_mainView bounds].size.width-(10+35), [_mainView bounds].size.height-35, 0.1, 100) inView:_mainView animated:YES];
        }
        [deleteOneOrAllPin release];
    }
}


#pragma mark |--> Gestion de l'ActionSheet (UIActionSheetDelegate)
//  Méthode appellée lorsque l'utilisateur touche un un des boutons de l'ActionSheet
//  Cette méthode supprime l'épingle sélectionnée ou affiche l'AlertView pour demander
//      une confirmation à l'utilisateur avant de supprimer toutes les épingles
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet destructiveButtonIndex]) // Bouton pour supprimer l'épingle sélectionnée
    {
        [[_mainView map] removeAnnotation:[currentSelectedAnnotationView annotation]];
    }
    else if (buttonIndex == [actionSheet firstOtherButtonIndex]) // Bouton pour supprimer toute les épingles -> confirmation
    {
        UIAlertView *alertViewDeleteAllPin;
        alertViewDeleteAllPin = [[UIAlertView alloc]
                                 initWithTitle:@"Tout supprimer ?"
                                 message:@"Êtes-vous sur de vouloir supprimer toutes les épingles de la carte ?"
                                 delegate:self
                                 cancelButtonTitle:@"Annuler"
                                 otherButtonTitles:@"Oui",nil];
        [alertViewDeleteAllPin show];
        [alertViewDeleteAllPin release];
    }
    
}


#pragma mark |--> Gestion de l'AlertView (UIAlertViewDelegate)
//  Méthode appellée lorsque l'utilisateur touche sur un des boutons de l'AlertView
//  Cette méthode supprime toutes les annotation de la cartes si c'est le choix
//      de l'utilisateur
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    else if (buttonIndex == [alertView firstOtherButtonIndex]) // L'utilisateur a confirmé qu'il voulait tout supprimer
    {
        [[_mainView map] removeAnnotations:[[_mainView map] annotations]];
    }
}





/* ************************************************** */
/* ------------------ Ajout Contact ----------------- */
/* ************************************************** */
#pragma mark - Ajout Contact

#pragma mark |--> Gestion de l'affichage du picker de contact (MKMapViewDelegate)
//  Méthode appellée lorsque l'on touche le bouton d'ajout d'un contact dans une MKAnnotationView
//  Cette méthode vérifie si l'application est autorisée à accéder aux contacts.
//      Si oui elle affiche le ABPeoplePickerNavigationController pour choisir un contact
//      Si non elle affiche une erreur
//      Si l'autorisation est indéterminée (non demandée), elle demande l'autorisation d'accès
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied || ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted)
    {
        // Non autorisé ou Restreint par le Controle parental
        UIAlertView *alertViewABNotAllow;
        alertViewABNotAllow = [[UIAlertView alloc] initWithTitle:@"Impossible"
                                                         message:@"Pour associer un contact à une épingle, vous devez autoriser iSouvenir à accéder à vos contacts.\nRendez-vous dans Réglages > Confidentialité > Contacts et activez l'accès pour iSouvenir."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alertViewABNotAllow show];
        [alertViewABNotAllow release];
        
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) // Authorisé
    {
        // On crée le ABPeoplePickerNavigationController
        addressbookPicker = [[ABPeoplePickerNavigationController alloc] init];
        [addressbookPicker setPeoplePickerDelegate:self];
        
        if (isiPhone)
        {
            // Si iPhone on affiche le picker de contact sur tout l'écran
            [self presentViewController:addressbookPicker animated:YES completion:nil];
        }
        else
        {
            // Si iPad, on crée le popoverController pour y afficher le picker de contact
            popOverController = [[UIPopoverController alloc] initWithContentViewController:addressbookPicker];
            [popOverController setDelegate:self];
            [popOverController presentPopoverFromRect:CGRectMake(0, ([_mainView frame].size.height)/2, 1, 1) inView:[_mainView map]
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
        }
    }
    else // ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
    {    // Indéterminé
         // On demande l'autorisation à l'utilisateur
        ABAddressBookRequestAccessWithCompletion
        (
            ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error)
            {
                if (!granted)
                {   // Non autorisé
                    return;
                }
                // Autorisé
            }
         );
    }
}


#pragma mark |--> Récupération du contact choisi (ABPeoplePickerNavigationControllerDelegate)
//  Méthode appellée lorsqu'un contact est sélectionné
//  Cette méthode récupère le contact choisi et indique que l'on n'affiche pas sa fiche (return NO)
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    // L'utilisateur a sélectionné un contact, on le récupère, on retire le picker, et on ne va pas plus loin
    [self updateAnnotationViewWithPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (!isiPhone)
    {
        [popOverController dismissPopoverAnimated:YES];
    }
    
    return NO;
}


#pragma mark |--> Mise à jour des infos de l'épingle avec le contact choisi
//  Méthode appellée pour mettre à jour une épingle une fois un contact choisi récupéré
//  Cette méthode récupère les infos du contact en fonction de son type et met à jour l'épingle
- (void)updateAnnotationViewWithPerson:(ABRecordRef)person
{
    
    // Récupération de notre iSouvenirMKAnnotation qui est dans la MKAnnotationView
    iSouvenirMKAnnotation *annotationToUpdate = [currentSelectedAnnotationView annotation];
    
    
    // On vide l'annotation
    [annotationToUpdate setTitle:@""];
    [annotationToUpdate setSubtitle:@""];
    [currentSelectedAnnotationView setLeftCalloutAccessoryView:nil];
    
    
    // Contruction du titre et du sous-titre selon s'il s'agit d'une fiche de type Personnel ou Entreprise
    NSString *title = nil;
    NSString *subtitle = nil;
    
    CFNumberRef contactKind = ABRecordCopyValue(person, kABPersonKindProperty);
    
    if (contactKind == kABPersonKindOrganization)
    {
        NSString *organizationName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
        title = [NSString stringWithString:organizationName];
        
        [organizationName release];
    }
    else if (contactKind == kABPersonKindPerson)
    {
        NSString *firstName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
        NSString *job = (__bridge NSString*)ABRecordCopyValue(person, kABPersonJobTitleProperty);
        title    = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        if (job != nil)
        {
            subtitle = [NSString stringWithString:job];
        }
        
        [firstName release];
        [lastName release];
        [job release];
    }
    
    CFRelease(contactKind);
    
    
    // Mise à jour des infos de l'annotation iSouvenirMKAnnotation
    [annotationToUpdate setTitle:title];
    
    if (subtitle != nil)
    {
        [annotationToUpdate setSubtitle:subtitle];
    }
    
    
    // Mise à jour de l'image de la MKAnnotationView
    if (ABPersonHasImageData(person)) // Si le contact a une image
    {
        // On récupère l'image
        NSData *personImageData = (NSData*)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
        UIImage *contactImage = [[UIImage alloc] initWithData:personImageData];
        UIImageView *contactImageView = [[UIImageView alloc] initWithImage:contactImage];
        [contactImageView setFrame:CGRectMake(0, 0, 35, 35)];
        [currentSelectedAnnotationView setLeftCalloutAccessoryView:contactImageView];
        
        [personImageData release];
        [contactImage release];
        [contactImageView release];
    }
    else // Sinon on remet l'image par défaut
    {
        [currentSelectedAnnotationView setLeftCalloutAccessoryView:defaultImageViewForLeftAccessoryView];
    }
}





/* ************************************************** */
/* --- ABPeoplePickerNavigationControllerDelegate --- */
/* ************************************************** */
#pragma mark - Autres méthodes de ABPeoplePickerNavigationControllerDelegate

//  Méthode appellée lorsque l'utilisateur annule la sélection
//  d'un contact à partir du picker de contact
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    //  L'utilisateur a appuyé sur Cancel, on retire le picker
    [self dismissViewControllerAnimated:YES completion:nil];
}


//  Méthode appellée pour savoir si le picker doit effectuer une
//      action lors de la sélection d'une propriété d'un contact
//  Utile si on autorise l'affichage des details d'un contact lors
//      de la selection.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}





/* ************************************************** */
/* -------- Autres Méthodes MKMapViewDelegate ------- */
/* ************************************************** */
#pragma mark - Autres méthodes de MKMapViewDelegate

#pragma mark |--> Annotation sélectionnée
//  Méthode appellée lorsqu'une épingle est sélectionnée
//  Cette méthode change le nom du bouton, si on est sur une épingle
//      on peut pas en ajouter d'autre, mais on peut supprimer celle
//      sur laquelle on est
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //  Si on est sur l'annotation de la localisation de l'utilisateur
    //      on laisse le bouton en "Ajouter" car on ne peut de toute façon
    //      pas supprimer l'annotation de la localisation de l'utilisateur
    if (! [[view annotation] isKindOfClass:[MKUserLocation class]])
    {
        //  On récupèrre l'objet MKAnnotationView de l'épingle pour le conserver
        //  Nécessaire pour toutes les actions possible dessus par la suite
        //      - Mise à jour des infos après sélection d'un contact
        //      - Suppression
        currentSelectedAnnotationView = view;
        
        [[_mainView deletePinButton] setEnabled:YES];
    }
}


#pragma mark |--> Annotation désélectionnée
//  Méthode appellée lorsqu'une épingle est désélectionnée
//  Cette méthode change le nom du bouton, si nous ne sommes plus sur une épingle
//      on peut en ajouter d'autre, mais on peut plus supprimer
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    currentSelectedAnnotationView = nil;
    [[_mainView deletePinButton] setEnabled:NO];
}





/* ************************************************** */
/* ---------------- Gestion affichage --------------- */
/* ************************************************** */
#pragma mark - Gestion orientation

- (BOOL)shouldAutorotate
{
    return YES;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_mainView setViewForOrientation:toInterfaceOrientation
                  withStatusBarFrame:CGRectMake(0, 0, 0, 0)];
}


#pragma mark |--> Replacement ActionSheet après rotation (UIPopoverControllerDelegate)
//  Méthode appellée lorsque la vue contenant la UIPopoverController change (notamment lors d'un changement d'orientation (sur iPad)
//  Cette méthode permet de modifier les coordonnées de placement de la UIPopoverController en fonction de la nouvelle orientation
- (void)popoverController:(UIPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView **)view
{
    rect->origin.x = 0;
    rect->origin.y = ([_mainView frame].size.height)/2;
    rect->size.width = 1;
    rect->size.height = 1;
}





/* ************************************************** */
/* ----------------- Gestion Mémoire ---------------- */
/* ************************************************** */
#pragma mark - Gestion Mémoire

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (!([self isViewLoaded]) &&  [self.view window] == nil)
    {
        _mainView.deletePinButton = nil;
        _mainView.mapType = nil;
        _mainView.map = nil;
        _mainView = nil;
        self.view = nil;
    }
    
    if (! [addressbookPicker isViewLoaded])
    {
        [addressbookPicker release];
        addressbookPicker = nil;
    }
    
    if (! [popOverController isPopoverVisible])
    {
        [popOverController release];
        popOverController = nil;
    }
    
    [currentSelectedAnnotationView release];
    
    if (currentSelectedAnnotationView == nil)
    {
        defaultImageViewForLeftAccessoryView = nil;
    }
}
@end