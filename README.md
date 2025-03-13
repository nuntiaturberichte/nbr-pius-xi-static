# Digitale Edition der Nuntiatur Pius XI

* data is fetched from https://github.com/nuntiaturberichte/nbr-pius-xi-data
* build with [DSE-Static-Cookiecutter](https://github.com/acdh-oeaw/dse-static-cookiecutter)


## initial (one time) setup

* run `./shellscripts/dl_saxon.sh`
* run `./fetch_data.sh`
* run `ant`

## set up GitHub repo
* create a public, new, and empty (without README, .gitignore, license) GitHub repo https://github.com/nuntiaturberichte/nbr-pius-xi-static 
* run `git init` in the root folder of your application pixi-testi
* execute the commands described under `…or push an existing repository from the command line` in your new created GitHub repo https://github.com/nuntiaturberichte/nbr-pius-xi-static

## start dev server

* `cd html/`
* `python -m http.server`
* go to [http://0.0.0.0:8000/](http://0.0.0.0:8000/)

## publish as GitHub Page

* go to https://https://github.com/nuntiaturberichte/nbr-pius-xi-static/actions/workflows/build.yml
* click the `Run workflow` button
