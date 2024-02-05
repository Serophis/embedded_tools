# Lier une tâche à un commit git et y accéder depuis le graph de commit
## Principe
Lorsque vous travaillez sur une tâche, vous pouvez lier le commit Git à la tâche en ajoutant le numéro de la tâche dans le message de commit. Par exemple, si vous travaillez sur la tâche 1234, vous pouvez ajouter le numéro de la tâche dans le message de commit comme suit :
```
git commit -m "#1234 Ajout de la fonctionnalité..."
```
Cependant, chaque projet aura sa propre convention de nommage des branches et des commits. Par exemple, vous pouvez avoir une convention de nommage des branches comme suit :
```
git commit -m "[#1234] Test du module..."
```
Le but de ce document est de montrer comment paramétrer votre gestionnaire de Git préféré de sorte à, dans le graph de commit, pouvoir cliquer sur le numéro de la tâche et y accéder sur le serveur distant (GitLab, Jira, Redmine, Gitea...).

## Configuration pour VSCode (via l'extension Git Graph)
### Prérequis
Il faut installer l'extension Git Graph pour VSCode, disponible à l'adresse suivante : https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph
### Configuration
* Ouvrir Git Graph en cliquant sur l'icône Git Graph dans la barre de statut de VSCode en bas de l'écran, ou en utilisant le raccourci clavier __Ctrl+Shift+P__ et en recherchant `Git Graph: View Git Graph (git log)` ;
* Cliquer sur le bouton `Repository Settings` (roue d'option en haut à droite de la fenêtre Git Graph) ;
* Dans la section `Issue Linking`, cliquer sur __Add Issue Linking__ ;
* Dans la fenêtre qui s'ouvre, remplir le champ `Issue Regex` avec la regex qui permet de détecter le numéro de la tâche dans le message de commit. Par exemple, si vous utilisez la convention de nommage `#1234`, vous pouvez utiliser la regex suivante :
```
#(\d+)
```
Ou encore, si vous utilisez la convention de nommage `[#1234]` comme dans l'exemple ci-dessus, vous pouvez utiliser la regex suivante :
```
\[#(\d+)\]
```
* Enfin, dans le champ `Issue URL`, remplir l'URL qui permet d'accéder à la tâche sur le serveur distant. Par exemple, si vous utilisez Gitea, vous pouvez utiliser l'URL suivante (exemple du répertoire Software du club Robot de l'ESEO) :
```
https://git.robot-eseo.fr/Robot-ESEO/Software/issues/$1
```
Où $1 est le numéro de la tâche détectée par la regex.
Si vous utilisez Redmine pour ProSE, groupe 2024 B2, vous pouvez utiliser l'URL suivante :
```
https://172.24.2.6/projects/se2024-b2/issues/$1
```
* Cliquer sur le bouton `Save` pour enregistrer la configuration.

A ce stade, vous devriez voir apparaître le numéro des tâches en bleu et soulignées dans le graph des commits. Vous pouvez alors cliquer sur le numéro d'une tâche pour y accéder sur le serveur distant.

## Configuration pour SourceTree
### Prérequis
Il faut installer SourceTree, disponible à l'adresse suivante : https://www.sourcetreeapp.com/ et cloner le dépôt Git sur lequel vous souhaitez travailler.
### Configuration
* Ouvrir SourceTree ;
* Cliquer sur le bouton `Settings` (engrenage en haut à droite de la fenêtre SourceTree) ;
* Dans la section `Advanced`, sous section `Commit text links`, cliquer sur __Add__ ;
* Dans la fenêtre qui s'ouvre, si votre gestionnaire de tâches n'est ni Jira, ni Crucible, il faut sélectionner `Other` dans le menu déroulant `Replacement type` ;
* Suivre les instructions de la section `Configuration pour VSCode (via l'extension Git Graph)` pour remplir les champs `Issue Regex` et `Issue URL` ;
* Cliquer sur le bouton `OK` pour enregistrer la configuration ;
* Cliquer de nouveau sur `OK` pour fermer la fenêtre de configuration.

A ce stade, en cliquant sur un commit, vous devriez voir apparaître le numéro de la tâche en bleu et souligné dans la description du commit. Vous pouvez alors cliquer sur le numéro de la tâche pour y accéder sur le serveur distant.

## Ouverture
Des outils comme Git Graph et SourceTree permettent de simplifier la gestion des tâches et des commits Git. Cependant, il est important de bien choisir sa convention de nommage des branches et des commits afin de pouvoir utiliser ces outils de manière optimale. Par ailleurs, nous avons uniquement parlé des numéros de tâches, mais il est également possible d'automatiser le préfixe d'un commit avec le nom de la branche sur laquelle on travaille. Par exemple, si vous travaillez sur la branche `feature` de la tâche `#1234`, vous pouvez ajouter automatiquement le préfixe `feature/#1234` au message de commit en configurant votre outil !  