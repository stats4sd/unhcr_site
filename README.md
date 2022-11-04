# UNHCR Site
A website to present the early results of exploring the availability of micro-data and published statistics about 12 priority SDG indicators for Refugees and IDPs, developed for the United Nations High Commissioner for Refugees (UNHCR).

# Development
This platform is built using Laravel/PHP. The front-end uses an R shiny dashboard and the admin panel uses Backpack for Laravel.

## Setup Local Environment
1.	Clone repo: `git clone git@github.com:stats4sd/unhcr_site.git`
2.	Copy `.env.example` as a new file and call it `.env`
3.	Update variables in `.env` file to match your local environment:
    1. Check APP_URL is correct
    2.	Update DB_DATABASE (name of the local MySQL database to use), DB_USERNAME (local MySQL username) and DB_PASSWORD (local MySQL password)
4.	Create a local MySQL database with the same name used in the `.env` file
5.	Run the following setup commands in the root project folder:
```
composer install
php artisan key:generate
php artisan backpack:install
npm install
npm run dev
```
7.	Migrate the database: `php aritsan migrate:fresh --seed` (or copy from the staging site)

## Setup R

Requirements:
 - R Studio
 - Packrat

Process:

1. Open the `unhcr.Rproj` in R Studio.
2. It will probably give a warning: "Packrat is not installed in the local library -- attempting to bootstrap an installation...". It may take a minute or so to load fully, but once you see the Files, Packages sidebar etc, you're ready to go.
3. run `packrat::restore()`. This will read the `packrat/packrat.lock` file and attempt to install the required packages locally.
 - NOTE: I had to run `packrat::restore()` twice for this project. The first run fails when installing gtable. But the second run successfully installs gtable and then finishes the process.
4. You should then be able to run the app through RStudio!

Note - The R Shiny app now requires the .env file, and will fail on database connection without it. (Copy the .env.example file to .env, and update the DB_ details if needed).
