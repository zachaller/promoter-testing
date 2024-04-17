#!/bin/bash

git checkout main
git pull

helm template . > manifest-next.yaml
git add values.yaml
git commit -s -S  -m "hydrate script"
git push
echo "Pushed to dry branch"

DRYSHA=`git rev-parse main`
echo $DRYSHA

git checkout environment/development-next
git pull

cat << EOF >> hydrator.metadata
{
  "commands": ["hydrate.sh"],
  "drySHA": "$DRYSHA"
}
EOF

rm manifest.yaml
mv manifest-next.yaml manifest.yaml
git add manifest.yaml
git add hydrator.metadata
git commit -s -S  -m "hydration of $DRYSHA"
git push
echo "Pushed to hydrated branch"


git checkout main
