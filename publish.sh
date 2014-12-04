#!/bin/sh

set -e

npm run build

git checkout gh-pages
for file in public/*; do
  cp -Lr $file .
  git add $(basename $file)
done
git commit -am 'Update files'
git push origin gh-pages:gh-pages

git checkout master

