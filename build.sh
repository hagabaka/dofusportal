#!/bin/sh

set -e

jade --out public --pretty index.jade
sass style.sass public/style.css
coffee --compile --output public main.coffee

