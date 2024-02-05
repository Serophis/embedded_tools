#!/bin/bash

# This script should be run from "doc" folder, otherwise change the relative path
MODELS_FOLDER_RELATIVE_PATH="conception/animUML/conceptionGenerale/models"

if [ ! -d "$MODELS_FOLDER_RELATIVE_PATH" ]; then
    echo Création du dossier $MODELS_FOLDER_RELATIVE_PATH
    mkdir -p "$MODELS_FOLDER_RELATIVE_PATH"
fi
cd "$MODELS_FOLDER_RELATIVE_PATH"
echo Setup npm folder for AnimUML
cd conception/animUML/conceptionGenerale
npm install