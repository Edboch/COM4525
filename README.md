# PitchWize - Team 4

## Demo site deployment

### 1. Commit any changes
Before deploying to your demo site, ensure you have committed any changes to your `main` branch.

```
# Add any untracked files to the next commit
git add -A

# Commit to your repository, replacing {message} with a relevant commit message
git commit . -m "{message}"

# Push your changes to your team repository
git push -u origin main
```

### 2. Deploying your project

Your project uses the epiDeploy gem to tag the release and then invoke Capistrano to deploy your project to your team demo site.

epiDeploy will warn you if you have uncommitted changes, so make sure to follow the steps above before deploying to the demo site.

```
# Tag a release and deploy to the demo site
bundle exec epi_deploy release -d demo
```

### 3. Seed the database

Aside from any migrations that create tables, the database for your deployed application will initially be empty. This is unlikely to be desired, as you might want an initial administrative user to be created so that you can log in and create further users.

If you have populated your `db/seeds.rb` file with initial database data, you can run the following command to seed your database on the demo server.

```
bundle exec cap demo deploy:seed
```

## Developers

Upon freshly cloning the repository, run `.hooks/link_hooks.sh`. This script
sets up symbolic links between the hook scripts in the .hooks directory (the
ones that don't have a file extension) and the hooks in the .git/hooks directory.


## TODO: The rest of this


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
