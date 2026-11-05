#!/usr/bin/env bash

# 1. Détection automatique de la branche active
CURRENT_BRANCH=$(git branch --show-current)

if [ -z "$CURRENT_BRANCH" ] || [ "$CURRENT_BRANCH" = "temp-branch" ]; then
    echo "Erreur: Branche invalide détectée ($CURRENT_BRANCH)."
    exit 1
fi

echo "Squeezing history on branch: $CURRENT_BRANCH..."

# 2. Processus de nettoyage de l'historique
git checkout --orphan temp-branch && \
git add -A && \
git commit -m 'Initial commit' --no-gpg-sign && \
git branch -D "$CURRENT_BRANCH" && \
git branch -m "$CURRENT_BRANCH" && \
git push origin "$CURRENT_BRANCH" --force && \
\
# 3. Libération immédiate de l'espace disque local (très important pour vos grosses photos !)
echo "Purge des anciens fichiers lourds du disque local..." && \
git reflog expire --expire=now --all && \
git gc --prune=now --aggressive
