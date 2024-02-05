# Model-specific configuration
# Chemin vers le répertoire contenant le modèle
MODEL_PATH=.
# Nom du modèle
MODEL=conceptionGenerale
# Extension du modèle
MODEL_EXT=html
# Liste des états repliés, à définir si nécessaire en utlisant la syntaxe (attention à la casse) : objet1.EtatX.EtatAReplier,objet2.EtatAReplier
FOLDED_STATES=
# Paramètres AnimUML à passer à la génération du modèle (voir la doc d'AnimUML et les paramètres disponibles en fin de fichier .html)
PARAMS=hideOperationsAlreadyOnConnectors=true hideActorClasses=true
# Permet de générer les éventuels diagrammes d'activités associés à la machine à états d'un objet, même syntaxr que pour FOLDED_STATES
ACTIVITIES=#class.Speaker.showScreen pour afficher le diagramme d'activité de la classe Speaker pour la méthode showScreen
MANU_PUML=
