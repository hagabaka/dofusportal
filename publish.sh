#!/bin/sh

set -e

npm run build

git checkout gh-pages
for file in public/*.{html,css,js}; do
  cp -L $file .
  git add $(basename $file)
done
git commit -am 'Update files'
git push origin gh-pages:gh-pages

git checkout master
./clean.sh
git push

