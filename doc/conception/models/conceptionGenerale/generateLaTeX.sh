#!/bin/bash

# Déclaration du tableau associatif des machines à états par classe
declare -A stateMachinesPerClass
# Déclaration du tableau associatif des diagrammes de séquence par cas d'utilisation
declare -A sequenceDiagramsPerUC

# Appel au fichier de config contenant les tableaux associatifs
source generateLaTeX.config

mkdir -p "../../ebauches/$outputFolder/descriptionActivity"
mkdir -p "../../ebauches/$outputFolder/descriptionArchiLogique"
mkdir -p "../../ebauches/$outputFolder/descriptionClass"
mkdir -p "../../ebauches/$outputFolder/descriptionMAE"
mkdir -p "../../ebauches/$outputFolder/descriptionSeq"
mkdir -p "../../ebauches/$outputFolder/descriptionTypes"

# Chemin d'accès aux fichiers générés du modèle du point de vue du Makefile du dossier de conception
modelName=$1
buildBase=$modelFolder/build/$modelName
objects=$2
interactions=$3
classes=$4
enumerations=$5
activities=$6

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

args='[scale=.8,max width=\textwidth,max height=.9\textheight]'

(
	echo '% WARNING: automatically generated file that may be overwritten or removed at any time'
	echo
	echo '\section{Conception générale}'
	echo
	echo '\newcommand\macroSuffix{}'
	echo "\\input{${buildBase}-macros}"
	echo
	echo
	echo '\subsection{Architecture logique}'
	echo
	figure "$buildBase-context" "Architecture logique" "archiLogique"
	echo "Le diagramme de la \\autoref{fig:$modelName-archiLogique} représente l'architecture logique du système."
	# On génère le fichier de description de l'architecture logique (s'il n'existe pas)
	touch "../../ebauches/$outputFolder/descriptionArchiLogique/description_archi_logique.tex"
	# On insère le fichier de description de l'architecture logique sous le diagramme
	echo "\input{$outputFolder/descriptionArchiLogique/description_archi_logique.tex}"
	echo
	echo '\subsection{Grands principes de fonctionnement}'
	touch "../../ebauches/$outputFolder/descriptionSeq/description_grands_princpes_fonctionnement.tex"
	# On insère le fichier de description du diagramme de séquence sous le diagramme
	echo "\input{$outputFolder/descriptionSeq/description_grands_princpes_fonctionnement.tex"}
	echo
	for uc in "${ucs[@]}" ; do
		echo "\subsubsection{CU $uc}"
		if [ "${sequenceDiagramsPerUC[$uc]}" != "" ] ; then
			for inter in ${sequenceDiagramsPerUC[$uc]} ; do
				figure "$buildBase-sequence-$inter" "Diagramme de séquence \\emph{${inter//_/ }}" "inter-$inter"
				echo "La \\autoref{fig:$modelName-inter-$inter} représente le diagramme de séquence \\emph{${inter//_/ }} 
				qui décrit le cas d'utilisation \textbf{$uc}."
				# On génère le fichier de description du diagramme de séquence (s'il n'existe pas)
				#touch "../../ebauches/$outputFolder/descriptionSeq/description_$inter.tex"
				# On insère le fichier de description du diagramme de séquence sous le diagramme
				#echo "\input{$outputFolder/descriptionSeq/description_$inter.tex}"
				inter=${inter//_/}
				inter=${inter//[/}
				inter=${inter//]/}
				inter=${inter//\'/}
				inter=$(echo -n "$inter" | iconv -t "ASCII//TRANSLIT")
				echo "\inter${inter}Description"
				echo
			done
		else
			echo "Le cas d'utilisation \textbf{$uc} sera détaillé lors du prochain incrément."
		fi
	done


	echo
	echo '\subsection{Types de données}'
	echo '\subsubsection{Types énumérés}'
	echo "\paragraph{Vue d'ensemble des littéraux d'énumération}"
	echo
	figure "$buildBase-datatypes" "Diagramme d'ensemble des littéraux d'énumération" "datatypes"
	echo "Le diagramme de la \\autoref{fig:$modelName-datatypes} représente les littéraux d'énumérations utilisés. Ils sont décrits dans les sections suivantes."
	echo
	# On insère le fichier de description de chacun des littéraux sous le diagramme principal
	for enum in $enumerations ; do
		echo "\paragraph{L'énumération \\emph{$enum}}"
		echo "L'énumération ${enum} possède les littéraux suivants :"
		echo "\\enum${enum}LiteralDescriptions"
		# On génère le fichier de description de l'énuméré (s'il n'existe pas)
		#touch "../../ebauches/$outputFolder/descriptionTypes/description_type_$enum.tex"
		# On insère le fichier de description de l'énuméré sous la description textuelle du littéral
		#echo "\input{$outputFolder/descriptionTypes/description_type_$enum.tex}"
		echo "\\enum${enum}Description"
		echo
	done
	echo '\subsubsection{Autres types de données}'
	# On insère le fichier de description de chacun des types
	for type in $types ; do
		echo "\paragraph{Le type \\emph{$type}}"
		# On génère le fichier de description du diagramme de séquence (s'il n'existe pas)
		touch "../../ebauches/$outputFolder/descriptionTypes/description_type_$type.tex"
		# On insère le fichier de description du diagramme de séquence sous le diagramme
		echo "\input{$outputFolder/descriptionTypes/description_type_$type.tex}"
		echo
	done


	echo
	echo '\subsection{Classes}'
	echo
	echo '\subsubsection{Vue générale}'
	echo
	figure "$buildBase-classes" "Diagramme de classes" "classes"
	echo "Le diagramme de la \\autoref{fig:$modelName-classes} représente les classes du système."
	touch "../../ebauches/$outputFolder/descriptionClass/description_classes.tex"
	echo "\input{$outputFolder/descriptionClass/description_classes.tex}"
	echo
	for class in $classes ; do
		# On ne génère pas de description pour les classes ignorées
		if [[ ! " ${classList[@]} " =~ " $class " ]] ; then
			echo "\\subsubsection{La classe $class}"
			echo
			figure "$buildBase-class-$class" "Diagramme de la classe $class" "class-$class"
			echo "Le diagramme de la \\autoref{fig:$modelName-class-${class}} représente la classe $class."
			# On génère le fichier de description du diagramme de classe (s'il n'existe pas)
			#touch "../../ebauches/$outputFolder/descriptionClass/description_$class.tex"
			# On insère le fichier de description du diagramme de classe sous le diagramme
			#echo "\input{$outputFolder/descriptionClass/description_$class.tex}"
			echo "\\class${class}Description"
			echo
			echo '\paragraph{Attributs}'
			echo "\\class${class}Properties"
			echo '\paragraph{Services offerts}'
			echo "\\class${class}Operations"

			if [ "${stateMachinesPerClass[$class]}" != "" ] ; then
				echo '\paragraph{Description comportementale}'
				for stateMachine in ${stateMachinesPerClass[$class]} ; do
					# On retire le nom de l'objet du nom de la machine à états
					stateName=${stateMachine#*.}
					# S'il s'agit de l'état de plus haut niveau, c'est la MAE parente
					if [ "$stateMachine" = "$stateName" ] ; then
						objectName="$stateMachine"
						figure "$buildBase-$stateMachine-SM" "Machine à états de \\emph{${class//_/ }}" "sm-$stateMachine"
						echo "Le diagramme de la \\autoref{fig:$modelName-sm-$stateMachine} représente la machine à états de \\emph{${class//_/ }}".
						# On génère le fichier de description de la MAE parente (s'il n'existe pas)
						#touch "../../ebauches/$outputFolder/descriptionMAE/description-MAE-$stateMachine.tex"
						# On insère le fichier de description de la MAE parente sous le diagramme
						#echo "\input{$outputFolder/descriptionMAE/description-MAE-$stateMachine.tex}"
						echo "\behavior${class}Description"
					# Sinon, c'est un sous-état
					else
						# On supprime les points
						subStateName=${stateName//./}

						figure "$buildBase-$objectName-$stateMachine-SM" "Sous-état \\emph{${subStateName}} de \\emph{${class//_/ }}" "sm-$stateMachine"
						echo "Le diagramme de la \\autoref{fig:$modelName-sm-$stateMachine} représente le sous-état \\emph{$subStateName} de la machine à états de \\emph{${class//_/ }}".
						# On génère le fichier de description de la MAE parente (s'il n'existe pas)
						#touch "../../ebauches/$outputFolder/descriptionMAE/description-MAE-$objectName-$subStateName.tex"
						# On insère le fichier de description de la MAE parente sous le diagramme
						#echo "\input{$outputFolder/descriptionMAE/description-MAE-$objectName-$subStateName.tex}"
						echo "\state${class}${subStateName}Description"
					fi
				done
			fi
		fi
	done
	# Décommenter si diagrammes d'activité, auquel cas il faudra les placer au bon endroit dans le fichier sous la MAE correspondante !
	# echo
	# echo "\\subsection{Diagrammes d'activité}"
	# echo
	# for activity in $activities ; do
	# 	op=${activity#*.}
	# 	op=${op//./::}
	# 	figure "{{$buildBase-activity-$activity}}" "Diagramme d'activité de l'opération \\emph{$op}" "activity-$activity"
	# 	echo "Le diagramme de la \\autoref{fig:$modelName-activity-$activity} représente le comportement de l'opération \\emph{$op}."
	#	 # On génère le fichier de description du diagramme d'activité (s'il n'existe pas)
	#	 touch "../../ebauches/$outputFolder/descriptionActivity/description_activity_$activity.tex"
	#	 # On insère le fichier de description du diagramme d'activité sous le diagramme
	#	 echo "\input{$outputFolder/descriptionActivity/description_activity_$activity.tex}"
	# 	echo
	# done
) > ../../ebauches/$outputFolder/$texFilename
