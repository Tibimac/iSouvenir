# iSouvenir
Exercice "iSouvenir" de la semaine 6 du MOOC "Programmation iPhone et iPad". Réalisation : 11 juin 2014

[![iSouvenir](http://www.tibimac.com/uploads_forums/github/iSouvenir1.png)](https://youtu.be/SpBXERSZPzQ "iSouvenir")
[![iSouvenir](http://www.tibimac.com/uploads_forums/github/iSouvenir2.png)](https://youtu.be/SpBXERSZPzQ "iSouvenir")

Vidéo de démo : https://youtu.be/SpBXERSZPzQ

- ARC désactivé.
- Structure MVC.
- Pas de storyboard.
- Gestion iPhone / iPad (iOS 7).
- Gestion Orientation Portrait / Paysage.
- Gestion changement hauteur statusBar.
- Possibilité de changement du type de carte.
- Ajout des épingles par appui long sur la carte.
- Suppression d'épingle (direct si une seule sur la carte (hormis celle de la localiation de l'utilisateur, si la localisation de celui-ci est activé et fonctionne), sinon une UIActionSheet demande à l'utilisateur s'il souhaite supprimer la pin sélectionnée ou toutes celles présentes sur la carte, si il choisi toutes, une UIAlertView demande confirmation). Le bouton de suppression n'est activé que lorsqu'une épingle est sélectionnée.
- Ajout d'un contact (dans un UIPopoverController si iPad).
- Si la fiche est de type "Personnel" récupération et affichage nom et prénom et, si renseigném le métier (mis en sous-titre).
- Si la fiche et de type "Société" récupération et affichage du nom de la société.
- Récupération de la miniature de l'image du contact s'il y en a une, sinon image par défaut que mise lors de la création de l'épingle.
- Personnalisation de l'annotation de la position actuelle de l'utilisateur.
- Code organisé par fonctionnalité (plus simple que d'organiser par "mécanisme").
