//
//  AppDelegate.m
//  iSouvenir
//
//  Created by Thibault Le Cornec on 11/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "AppDelegate.h"
#import "iSouvenirView.h"
#import "iSouvenirViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Alloc + Init du iSouvenirViewController qui sera le rootViewController de la window de l'application.
    rootViewController = [[iSouvenirViewController alloc] init];
    [self.window setRootViewController:rootViewController];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // On stoppe la localisation de l'utilisateur
    [[[rootViewController mainView] map] setShowsUserLocation:NO];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    // On stoppe la localisation de l'utilisateur
    [[[rootViewController mainView] map] setShowsUserLocation:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    // On active la localisation de l'utilisateur
    [[[rootViewController mainView] map] setShowsUserLocation:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // On active la localisation de l'utilisateur
    [[[rootViewController mainView] map] setShowsUserLocation:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


// Permet de redimensionner la vue lorsque la frame de la statusBar change
- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
//  Lorsque cette méthode est appellée elle donne les nouvelles dimensions de la statusBar
//      mais si on passe en paramètre d'orientation l'orientation actuelle de l'application
//      celle-ci ayant pas encore fait sa rotation on passe alors l' "ANCIENNE" orientation.
//  On ne peut pas non plus passer directement la valeur de l'orientation du iDevice car
//      car ça ne correspond pas exactement aux valeurs d'orientation de l'interface.
//      On passe donc une valeur 1 pour l'orientation portrait et 3 pour le paysage en fonction
//      de l'orientation du iDevice (0 ou 1 pour le portrait, 3 ou 4 pour le paysage).
//  On peut se baser sur l'orientation du iDevice car l'appel de cette méthode se fait justement
//      parce-que le iDevice a déjà changé d'orientation ou que la frame de la statusBar change
//      donc l'orientation du iDevice au moment où la demande (ci-dessus) est bien la "nouvelle"
//      orientation.
    if (([[UIDevice currentDevice] orientation] == 0) || ([[UIDevice currentDevice] orientation] == 1))
    {
        [[rootViewController mainView] setViewForOrientation:1
                                          withStatusBarFrame:newStatusBarFrame];
    }
    else if (([[UIDevice currentDevice] orientation] == 3) || ([[UIDevice currentDevice] orientation] == 4))
    {
        [[rootViewController mainView] setViewForOrientation:3
                                          withStatusBarFrame:newStatusBarFrame];
    }
}
@end
