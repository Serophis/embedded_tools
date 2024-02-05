#!/bin/bash

# Configuration de l'environnement de développement sur une machine Linux vierge
# Installation de plein d'outils utiles sur une nouvelle machine Linux

echo =====Update Upgrade apt
apt update
apt upgrade -y

# Native build tools...
apt install build-essential -y
apt install git -y

# PlantUML
apt install plantuml -y
apt install graphviz -y
apt install librsvg2-bin -y

# LaTeX
apt install texlive-latex-base -y
# apt install texlive-latex-extra -y
apt install texlive-extra-utils -y
apt install texlive-font-utils -y
apt install texlive-lang-french -y
apt install texlive-lang-english -y
apt install biber -y
apt install texlive-bibtex-extra -y
apt install python3-pygments -y
apt install latexmk -y
apt install fonts-open-sans -y

# Node package for AnimUML
apt install curl -y
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --latest-npm
nvm install node
