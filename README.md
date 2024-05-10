# Team 04: PitchWize - An all-in-one football management app

PitchWize is an all-in-one football management app, designed to make tracking and organising daily management activities a more comfortable experience. Players likewise benefit having easily accessible information about all the core information happening in their team(s).

This file contains information on how to get started with the app both on your local device and from a deployed version on the web. The deployed version is available at https://team04.demo1.genesys.shefcompsci.org.uk/. Accessing this site will require log in from a registered University account.

## Version Requirements

This project was developed in Ruby on Rails. Rails version 7.1.3.2 and Ruby version 3.1.2p20 were used during development. For the best experience using this app, it is recommended to install these specific versions.

## Getting Started

To run this project from your local device, you will first be required to connect to The University of Sheffield's VPN. This project was developed in an Ubuntu environment - it is recommended that you use Ubuntu 22.04 or later to ensure compatibility.

To clone this project to your Ubuntu environment, enter in the terminal:

```
# with HTTPS
git clone https://git.shefcompsci.org.uk/com4525-2023-24/team04/project.git
# with SSH
git clone git@git.shefcompsci.org.uk:com4525-2023-24/team04/project.git
```

Then, navigate to the project's directory using:

```
cd project
```

You can then enter the following to set up the project:

```
bin/setup
```

To run the project, open another terminal and use the following two lines, separately in each terminal:

```
bundle exec rails s

bin/shakapacker-dev-server
```

You can then open the project using http://localhost:3000/ in your web browser.

## Using PitchWize

### 1. Account Details

To enter the application as an admin, use the following credentials:
```
E-mail: site-admin@grr.la
Password: password
```

While you can freely create accounts to be used as a player/manager in our app, we provide account details for a user managing a team, and a user playing for that same team.

Manager credentials:
```
E-mail: test@manager.com
Password: password
```

Player credentials:
```
E-mail: test@player.com
Password: password
```

### 2. League Scraping

In our app, we provide the ability to load content from a football league website into your team. 

When logged in as a manager, you can use the following website address as a league web page:
```
```

By navigating to this team website, you will see there are a number of team's to select from. For example, when specifying the team name from this website, you can use:
```
```
(Note: this team name does not have to be the same as the team name inside our app)




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
