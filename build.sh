#!/bin/sh
coffee -o dist -c src/injector.coffee
uglifyjs dist/injector.js > dist/injector.min.js
