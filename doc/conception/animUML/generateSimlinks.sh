# !/bin/bash
# Author : Eliot Coulon, 2023
# Brief : Fichier de création des liens symboliques pour les scripts de génération de la conception détaillée des logiciels (C, Android)
# Precondition : generateConceptionDetailleeSoftGenerique.sh doit être présent dans le même dossier que ce script

# Liste des logiciels pour lesquels on souhaite générer les fichiers LaTeX (seulement les logiciels dont on souhaite générer la conception détaillée, pas l'architecture vide ou la conception générale)
modelSoftwareList=(SmartHouseApp SmartHouseSoft)

scriptDirectory="$(dirname "$(readlink -f "$0")")"
cd $scriptDirectory
# Création des liens symboliques
for model in ${modelSoftwareList[@]}
do
    ln -nsf $scriptDirectory/generateConceptionDetailleeSoftGenerique.sh conceptionDetaillee$model/generateLaTeX.sh
done