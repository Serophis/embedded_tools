#!/usr/bin/bash
# Author : Eliot Coulon, 2023
# Warning : ce fichier peut être un lien symbolique vers le fichier generateConceptionDetailleeSoftGenerique.sh 
# afin de pouvoir être appelé depuis chaque dossier de conception détaillée de logiciel (mais pas la conception
# générale ou l'architecture vide qui ont leur propre script de génération de fichier LaTeX)
# EN CAS DE MODIFICATION DE CE FICHIER, EXÉCUTER generateSimlinks.sh POUR QUE LES LIENS SYMBOLIQUES SOIENT MIS À JOUR

# Chargement du fichier de configuration (contient diverses variables)
source generateLaTeX.config

# Chemin d'accès aux fichiers générés du modèle du point de vue du Makefile du dossier de conception
modelName=$1
model=$modelFolder/$modelName
objects=$2
interactions=$3
classes=$4
enumerations=$5
activities=$6

# Création des dossiers contenant les descriptions des différentes sections générées par le script
mkdir -p "../../ebauches/$outputFolder/descriptionArchiPhysique$softwareName"
mkdir -p "../../ebauches/$outputFolder/descriptionSeq"
mkdir -p "../../ebauches/$outputFolder/descriptionClass"
mkdir -p "../../ebauches/$outputFolder/descriptionGestionMultitache$softwareName"

# Arguments à passer à la commande \includegraphics{} pour afficher les images avec la taille souhaitée
args='[scale=.8,max width=\textwidth,max height=.9\textheight]'
# Fonction permettant de générer un bloc LaTeX d'affichage d'une figure
figure() {
	local file="$1"
	local caption="$2"
	local label="$3"
	echo '\begin{figure}[H]'
	echo '	\centering'
	echo "	\\includegraphics$args{$file}"
	echo "	\\caption{$caption}"
	echo "	\\label{fig:$modelName-$label}"
	echo '\end{figure}'
}

# On génère le fichier LaTeX
(
	echo '% WARNING: automatically generated file that may be overwritten or removed at any time'
	echo
	echo "\\input{${model}-macros}"
    echo "\subsection{Conception détaillée de $softwareName}"
	echo
	echo "\subsubsection{Architecture physique de $softwareName}"
	echo
	figure "$model-classes" "Architecture physique $softwareName" "archiPhysique$softwareName"
	echo "Le diagramme de la \\autoref{fig:$modelName-archiPhysique$softwareName} représente l'architecture physique du logiciel $softwareName."
    # On génère le fichier de description de l'architecture physique (s'il n'existe pas)
    touch "../../ebauches/$outputFolder/descriptionArchiPhysique$softwareName/descriptionArchiPhysique.tex"
    # On insère le fichier de description de l'architecture physique sous le diagramme
    echo "\input{$outputFolder/descriptionArchiPhysique$softwareName/descriptionArchiPhysique.tex}"
	echo
	echo

    echo "\subsubsection{Séquence de démarrage et d'arrêt de $softwareName}"
        # $interactions[0] peut être utilisé si on n'a qu'un diagramme, la boucle permet éventuellement d'évoluer vers plusieurs diagrammes, il faudra alors aussi adapter la façon dont on génère les descriptions
        for inter in $interactions ; do
            figure "$model-sequence-$inter" "Diagramme de séquence \\emph{${inter//_/ }}" "inter-$inter"
            echo "La \\autoref{fig:$modelName-inter-$inter} représente le diagramme de séquence \\emph{${inter//_/ }} 
            qui décrit la séquence de démarrage et d'arrêt de $softwareName."
            # On génère le fichier de description du diagramme de séquence (s'il n'existe pas)
            touch "../../ebauches/$outputFolder/descriptionSeq/description_$inter.tex"
            # On insère le fichier de description du diagramme de séquence sous le diagramme
            echo "\input{$outputFolder/descriptionSeq/description_$inter.tex}"
            echo
        done
	echo

	echo
	echo "\subsubsection{Classes de la conception détaillée de $softwareName}"
	echo
    echo "Cette section présente les classes de la conception détaillée de $softwareName, à savoir celles qui n'apparaissaient pas dans la conception générale ou bien qui proposent de nouveaux services."
	echo
	for class in $classes ; do
        # On détermine si l'on doit ou non générer la description de la classe en fonction de la liste des classes à générer et du flag
        if [ "$excludeListedClasses" = false ] ; then
            # On génère la description des classes listées (pas de descriptions pour les autres)
            if [[ " ${classList[@]} " =~ " $class " ]] ; then
                flagGenerateClass=true
            else
                flagGenerateClass=false
            fi
        else
            # On génère la description des classes qui ne sont pas listées (pas de description pour les classes ignorées)
            if [[! " ${classList[@]} " =~ " $class " ]] ; then
                flagGenerateClass=true
            else
                flagGenerateClass=false
            fi
        fi

        # On génère la description de la classe si le flag est vrai
        if $flagGenerateClass ; then
            echo "\paragraph{La classe $class}"
            echo
            figure "$model-class-$class" "Diagramme de la classe $class" "class-$class"
            echo "Le diagramme de la \\autoref{fig:$modelName-class-${class}} représente la classe $class."
            # On génère le fichier de description du diagramme de classe (s'il n'existe pas)
            touch "../../ebauches/$outputFolder/descriptionClass/description_$class.tex"
            # On insère le fichier de description du diagramme de classe sous le diagramme
            echo "\input{$outputFolder/descriptionClass/description_$class.tex}"
            echo
            # On génère la description des attributs et des services offerts par la classe à partir des commentaires du modèle
            echo '\subparagraph{Attributs}'
            echo "\\class${class}Properties"
            echo '\subparagraph{Services offerts}'
            echo "\\class${class}Operations"
        fi
	done
    echo '\subsubsection{Gestion du multitâche}'
    echo "Cette section présente la gestion du multitâche de $softwareName. \\\ "
    touch "../../ebauches/$outputFolder/descriptionGestionMultitache$softwareName/descriptionGestionMultitache.tex"
    echo "\input{$outputFolder/descriptionGestionMultitache$softwareName/descriptionGestionMultitache.tex}"
) > ../../ebauches/$outputFolder/$texFilename