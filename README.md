# dev-vm - The VM for developers

This is a full featured Developer VM, built by the Charges Team for the Charges Team.

**Table of contents**
- [Philosophy](#philosophy)
  - [In theory](#in-theory)
  - [In practice](#in-practice)
- [README conventions](#readme-conventions)
- [Pre-requisites](#pre-requisites)
- [Usage](#usage)
- [Apps installed](#apps-installed)
    - [Borrower Frontend](#borrower-frontend)
    - [Conveyancer Frontend](#conveyancer-frontend)
    - [Deed API](#deed-api)
    - [Case API](#case-api)
    - [Scribe](#scribe)
    - [Verifudge](#verifudge)
    - [Catalogue](#catalogue)
- [Development usage](#development-usage)
    - [Development path](#development-path)
    - [Controlling apps](#controlling-apps)
        - [Starting / Stopping / Restarting an app](#starting--stopping--restarting-an-app)
        - [Accessing an apps logs](#accessing-an-apps-logs)
        - [Replacing an app with your development version](#replacing-an-app-with-your-development-version)
    - [Accessing apps from your browser](#accessing-apps-from-your-browser)
    - [Pulling in another app](#pulling-in-another-app)
    - [Accessing the databases](#accessing-the-databases)
    - [Dropping and Creating databases](#dropping-and-creating-databases)
    - [Deploying a specific version or branch](#deploying-a-specific-version-or-branch)
        - [Deploying a different version of an apps Puppet module](#deploying-a-different-version-of-an-apps-puppet-module)
        - [Deploy a different version of an app](#deploy-a-different-version-of-an-app)
- [Anatomy of this repo](#anatomy-of-this-repo)
    - [The Puppetfile](#the-puppetfile)
    - [Hiera](#hiera)
        - [The hiera.yaml file](#the-hierayaml-file)
        - [The `/hiera` folder](#the-hiera-folder)
        - [The `hiera/vagrant.yaml` file](#the-hieravagrantyaml-file)
- [Using for your own development](#using-for-your-own-development)

## Philosophy

### In theory

This Dev VM is built around the idea that developers should be running the
entire stack at all times. To perform this the Dev VM has all the apps installed
out of the box.

This Dev VM is also built around the concept that "it isn't done unless it's
deployed". To speed up the time to deploy the Dev VM uses the exact same code
used to deploy to Preview to provision the Dev VM.

Finally the Dev VM is built on the idea that any change that might break the
deploy will first break the Dev VM. Thus before we merge anything, we expect it
to have deployed to the Dev VM. If it doesn't the infrastructure change needed
is added to that change. This has forced us to co-locate the app code and the
infrastructure code.

### In practice

- Every app has it's own repo
    - example: [charges-borrower-frontend](https://github.com/LandRegistry/charges-borrower-frontend)
- Infrastructure code to deploy an app exists in it's repo in `/puppet/<app_name>`
    - example: [charges-borrower-frontend/puppet/borrower_frontend](https://github.com/LandRegistry/charges-borrower-frontend/tree/master/puppet/borrower_frontend)
- Infrastructure code for each app is pulled in to the Dev VM through Librarian-Puppet
    - example: [the Dev VM Puppetfile](https://github.com/LandRegistry/dev-vm/blob/master/Puppetfile)

## README conventions

This readme uses a few conventions to make understanding where to execute
commands.

To indicate a command that should be *executed in your shell*, probably in the
root of this repo:

```bash
> [some command]
```

To indicate a command that should be *run inside the dev vm*, i.e. by executing
`> vagrant ssh` to access the vm first:

```bash
vagrant@dev-vm > [some command]
```

To indicate a command that should be *run as a specific user* in the dev vm:

```bash
[user]@dev-vm > [some command]
```

For example if you should run a command as the `postgres` user you should:

```bash
> vagrant ssh
vagrant@dev-vm > sudo su - postgres
postgres@dev-vm > [some command]
```

## Pre-requisites

You should have Vagrant and Virtualbox. Easiest way is through `homebrew-cask`:

Install `homebrew-cask`:

```
> brew install caskroom/cask/brew-cask
```

Then install the Vagrant and Virtualbox:

```
> brew cask install vagrant
> brew cask install virtualbox
```

You'll also need a few ruby gems installed:

```
> gem install puppet
> gem install librarian-puppet
```

We use a few plugins in the Dev VM you should install first:

```
> vagrant plugin install vagrant-dns
> vagrant plugin install vagrant-cachier
```

Then start the vagrant dns plugin:

```
> vagrant dns --install
```

## Usage

First clone the repo:

```
> git clone git@github.com:LandRegistry/dev-vm.git
```

Then install the dependencies:

```
> librarian-puppet install
```

Add an environment variable that points at your development folder (e.g. mine is
in `~/Projects/land-registry/charges`) to your `~/.bashrc` or `~/.zshrc`:

```
> echo "export development=/path/to/your/code" >> ~/.zshrc
```

And finally you can start the VM:

```
> vagrant up
```

And wait, and wait, and wait.

## Apps installed

Every app is installed through Puppet code that is co-located with it's app
code. They all install to `/opt` and expose a host so you can access them from
your browser directly. If you need to control the app, e.g. starting, stopping,
reading logs, you can through [systemd and journalctl](#controlling-apps).

### Borrower Frontend

 Piece               | Location
---------------------|------------------------------------------------------------------------------------
 App name            | borrower_frontend
 Code                | [charges-borrower-frontend](https://github.com/LandRegistry/charges-borrower-frontend)
 Infrastructure code | [charges-borrower-frontend/puppet/borrower_frontend](https://github.com/LandRegistry/charges-borrower-frontend/tree/master/puppet/borrower_frontend)
 Development Host    | http://borrower-frontend.dev.service.gov.uk
 Code on VM          | /opt/borrower_frontend
 Default port        | 0.0.0.0:9000

### Conveyancer Frontend

 Piece               | Location
---------------------|------------------------------------------------------------------------------------
 App name            | conveyancer_frontend
 Code                | [charges-conveyancer-frontend](https://github.com/LandRegistry/charges-conveyancer-frontend)
 Infrastructure code | [charges-conveyancer-frontend/puppet/borrower_frontend](https://github.com/LandRegistry/charges-conveyancer-frontend/tree/master/puppet/conveyancer_frontend)
 Development Host    | http://conveyancer-frontend.dev.service.gov.uk
 Code on VM          | /opt/conveyancer_frontend
 Default port        | 0.0.0.0:9040

### Deed API

 Piece               | Location
---------------------|------------------------------------------------------------------------------------
 App name            | deed_api
 Code                | [charges-deed-api](https://github.com/LandRegistry/charges-deed-api)
 Infrastructure code | [charges-deed-api/puppet/deed_api](https://github.com/LandRegistry/charges-deed-api/tree/master/puppet/deed_api)
 Development Host    | http://deedapi.dev.service.gov.uk
 Code on VM          | /opt/deed_api
 Default port        | 0.0.0.0:9012

### Case API

 Piece               | Location
---------------------|------------------------------------------------------------------------------------
 App name            | case_api
 Code                | [charges-case-api](https://github.com/LandRegistry/charges-case-api)
 Infrastructure code | [charges-case-api/puppet/case_api](https://github.com/LandRegistry/charges-case-api/tree/master/puppet/case_api)
 Development Host    | http://case-api.dev.service.gov.uk
 Code on VM          | /opt/case_api
 Default port        | 0.0.0.0:9070

### Scribe

 Piece               | Location
---------------------|------------------------------------------------------------------------------------
 App name            | scribe
 Code                | [charges-scribe](https://github.com/LandRegistry/charges-scribe)
 Infrastructure code | [charges-scribe/puppet/scribe](https://github.com/LandRegistry/charges-scribe/tree/master/puppet/scribe)
 Development Host    | http://scribeapi.dev.service.gov.uk
 Code on VM          | /opt/scribe
 Default port        | 0.0.0.0:9010

### Verifudge

 Piece               | Location
---------------------|------------------------------------------------------------------------------------
 App name            | verifudge
 Code                | [charges-verifudge](https://github.com/LandRegistry/charges-verifudge)
 Infrastructure code | [charges-verifudge/puppet/verifudge](https://github.com/LandRegistry/charges-verifudge/tree/master/puppet/verifudge)
 Development Host    | http://verifudge.dev.service.gov.uk
 Code on VM          | /opt/verifudge
 Default port        | 0.0.0.0:9080

### Catalogue

  Piece               | Location
 ---------------------|------------------------------------------------------------------------------------
  App name            | catalogue
  Code                | [charges-catalogue](https://github.com/LandRegistry/charges-catalogue)
  Infrastructure code | [charges-catalogue/puppet/catalogue](https://github.com/LandRegistry/charges-catalogue/tree/master/puppet/catalogue)
  Development Host    | http://catalogue.dev.service.gov.uk
  Code on VM          | /opt/catalogue
  Default port        | 0.0.0.0:9100

### Matching Service

  Piece               | Location
 ---------------------|------------------------------------------------------------------------------------
  App name            | catalogue
  Code                | [charges-matching-service](https://github.com/LandRegistry/charges-matching-service)
  Infrastructure code | [charges-matching-service/puppet/matching_service](https://github.com/LandRegistry/charges-matching-service/tree/master/puppet/matching_service)
  Development Host    | http://matching-service.dev.service.gov.uk
  Code on VM          | /opt/matching_service
  Default port        | 0.0.0.0:9090

##Development usage

### Development path

The VM uses rsync to mirror the path you set when installing:
```bash
> export development=/path/to/your/code
```

This folder will exist in `~/development`. In this way you can keep using your
IDE or editor of choice while benefitting from the Dev VM.

### Controlling apps

Every app is controlled through systemd. They each expose a service that can be
used to do a variety of tasks. They also expose an nginx config that can be used
in development to speed up the connecting of services together.

The following instructions assume you have sshed in to a vm built using a clean
copy of this repo.

#### Starting / Stopping / Restarting an app

To start / stop / restart any app use:

```
vagrant@dev-vm > sudo systemctl <action> -u <app_name>
```

Where <app_name> is the name listed in the [Apps installed](#apps-installed)
tables above and action is any of `start`, `stop`, `restart`.

**Examples**

To start the Borrower Frontend use: `sudo systemctl start -u borrower_frontend`

To stop the Verifudge use: `sudo systemctl stop -u verifudge`

To restart the Case API use: `sudo systemctl restart -u case_api`

*note:* you can also use the old initd syntax since initd passes through to systemd
on centos, e.g. `sudo service borrower_frontend start`

#### Accessing an apps logs

Services run by SystemD output log to the same location, a utility called
JournalD. All of our app deployed via Puppet will log to here as well. You can
easily access the logs by using the `journalctl` command:

```
vagrant@dev-vm > sudo journalctl -u <app_name>
```
where <app_name> is the name of an app listed in the [Apps installed](#apps-installed)
tables above.

To follow the logs as they are output, e.g. to see the behavior of an app during
an acceptance test run you can use:

```
vagrant@dev-vm > sudo journalctl -f -u <app_name>
```
where `-f` is equivalent to tails `--follow`.

#### Replacing an app with your development version

A useful part of having all the apps installed and configured through nginx
before developing is that you can easily make your changes to any app and then
piggy back on the nginx config to quickly integrate your changes into the full
system.

**Example**

Lets say I'm working on a change for the Borrower Frontend. First I'll provision
the Dev VM. The Borrower Frontend that is on master will be installed and exposed
on http://borrower_frontend.dev.service.gov.uk and all other apps will be
configured to connect to it, including the acceptance tests.

Next I cd into `~/development/borrower_frontend` where I have the Borrower
Frontend checked out. This is a different copy to the version running currently,
which is located in `/opt/borrower_frontend`.

I make my changes and ensure my unit tests are passing:

```
vagrant@dev-vm > cd ~/development/borrower_frontend
vagrant@dev-vm > mkvirtualenv borrower_frontend
vagrant@dev-vm > pip install -r requirements.txt
vagrant@dev-vm > pip install -r requirements_test.txt
vagrant@dev-vm >
vagrant@dev-vm > #Do some work
vagrant@dev-vm > python tests.py
...........................
ok
vagrant@dev-vm >
```

Now I stop the Borrower Frontend that puppet installed:
```
vagrant@dev-vm > sudo service borrower_frontend stop
```

Since the Borrower Frontend has an nginx config that expects it to be running on
port `9000`, I can now start my version bound to the same port:

```
vagrant@dev-vm > cd ~/development/borrower_frontend
vagrant@dev-vm > workon borrower_frontend
vagrant@dev-vm > python run.py runserver --host 0.0.0.0 --port 9000
```

Now my changes are available on http://borrower_frontend.dev.service.gov.uk and
I can run the full acceptance tests easily:

```
vagrant@dev-vm > cd ~/development/borrower_frontend/acceptance_tests
vagrant@dev-vm > ./run_tests.sh
```

### Accessing apps from your browser

The Dev VM is available on IP `10.10.10.10`. If you have a flask app running on
port `9000` then you can access it by typing `http://10.10.10.10:9000` in to your
browser. (Note the `http` is important as Chrome and Safari will think you want
to search without it).

The VM is set up to create a DNS entry automatically for you. To activate DNS
just run:

```
> vagrant dns --install
```

Now you can type `vm.dev.service.gov.uk:9000` in to your browser. Any subdomain
on `*dev.service.gov.uk` will resolve to the VM so this can be useful for
having multiple apps running e.g. `frontend-dev.service.gov.uk`,
`api.dev.service.gov.uk`, `my.super.long.domain.dev.service.gov.uk` will all
resolve to the VM.

### Pulling in another app

To pull in the "real" version of an app (i.e. what is currently deployed on
master) you can use the same deployment code the environment uses.

For example to pull in the Charges Borrower Frontend:

1. Add the following to the Puppetfile in this repo

```
mod 'charges/borrower_frontend',
  :git  => 'git://github.com:LandRegistry/charges-borrower-frontend',
  :path => 'puppet/borrower_frontend'
```

2. Update librarian-puppet to pull in the new module

```
> librarian-puppet update
```

3. Include the module in `manifests/site.pp`

```
node default {
  require ::standard_env

  include ::borrower_frontend

  ...
}
```

4. Reprovision the VM

```
> vagrant provision
```

The Borrower Frontend will now be deployed in your VM and available on it's
default port (8000) at `dev.service.gov.uk:8000`.

### Accessing the databases

Any apps that need a database install a PostgreSQL database called the same as
their [App name](#apps-installed) owned by the vagrant user. Thus you can connect
directly from any ssh connection:

```
> vagrant ssh
vagrant@dev-vm > psql verifudge
psql (9.4.4)
Type "help" for help.

verifudge=>
verifudge=> \dt
             List of relations
 Schema |      Name       | Type  |  Owner  
--------+-----------------+-------+---------
 public | alembic_version | table | vagrant
 public | identity        | table | vagrant
(2 rows)

verifudge=> \q
vagrant@dev-vm > exit
>
```

See this handy [PostgreSQL cheatsheet](http://blog.jasonmeridth.com/posts/postgresql-command-line-cheat-sheet/)
for examples of using the PostgreSQL prompt.

### Dropping and Creating databases

On the rare occasion when you need to drop or create databases you'll need to
log in as the `postgres` user, who has root access to PostgreSQL, and ensure the
DB you create is owned by the `vagrant` user, as they are the user that runs our
apps.

This can be done through Puppet or commandline:

**Command line**

SSH in and become the `postgres` user:
```
> vagrant ssh
vagrant@dev-vm > sudo su - postgres
postgres@dev-vm >
```

Drop or create your DB:
```
postgres@dev-vm > dropdb verifudge
postgres@dev-vm > createdb -O vagrant verifudge
```
(note: the `-O vagrant` is important as that's what lets our apps own their DB)

**Puppet**

In [manifests/site.pp](https://github.com/LandRegistry/dev-vm/blob/master/manifests/site.pp)
add a postgres declaration:
```puppet
standard_env::db::postgres { 'my-awesome-db':
  user     => 'vagrant',
  password => 'vagrant',
}
```

The connection string in this example would then be: `postgres:///my-awesome-db`.

Note: You can only create databases in Puppet. This is useful when adding a DB to
an new app but not when something goes wrong and you need to wipe a DB.

### Deploying a specific version or branch

Often we need to deploy a new feature to the Dev VM to test it before we merge
it.

The Dev VM is set up to fetch the Puppet module that deploys an app based on the
listings in [the Puppetfile](#the-puppetfile).
This Puppet module then understands how to fetch and deploy the app.

Each app is configured based on the defaults set in the module and the values
set for it in [hiera](#hiera).

Thus to change which version we deploy we need to make two changes, one to change
the Puppet module we pull in and one to change the version of the app that the
module fetches.

#### Deploying a different version of an apps Puppet module

When testing a change made to a Puppet module it's a importan to deploy it to
the Dev VM first to see that it works. There are two ways to do this:

**Deploy a local version**

If currently working on a change you can tell Librarian Puppet to pull in the
code as it is on disk on your machine. Simply change the declaration in the
[Puppetfile](#the-puppetfile) to point to the location of the modified module
on disk:

```ruby
mod 'LandRegistry/borrower_frontend',
    path: '../borrower-frontend/puppet/borrower_frontend'
```

This will tell Librarian-Puppet to look in `../borrower-frontend/puppet/borrower_frontend`
for the puppet module.

**Deploy a branch**

If you are wanting to deploy a change that has been pushed to github, for example
to test out someones pull request before merging it, you can modify the
[Puppetfile](#the-puppetfile) to point to the specific branch:

```ruby
mod 'LandRegistry/borrower_frontend',
    git: 'git://github.com/LandRegistry/charges-borrower-frontend.git',
    ref: 'my-awesome-feature',
    path: 'puppet/borrower_frontend'
```

This will tell Librarian-Puppet to pull the module from the `my-awesome-feature`
branch. It's important to remember that Librarian-Puppet needs to know the exact
folder of the Puppet module, so we need to provide the path parameter. This will
be used relative to the root of the git repo.

### Deploy a different version of an app

To deploy a specific version of an app, say to deploy someones branch so that you
can test it works before merging, you need to configure the apps Puppet module
using [Hiera](#hiera).

In [the `hiera/vagrant.yaml` file](#the-hieravagrantyaml-file) you can override
the default value of any class parameters. Each app provides a `branch_or_revision`
parameter, which tells it which branch to checkout when deploying. By default
this is set to `master`. For example the [branch_or_revision parameter of the
Case Api](https://github.com/LandRegistry/charges-case-api/blob/master/puppet/case_api/manifests/init.pp#L6)

**Examples:**

```ruby
::borrower_frontend::branch_or_revision: 'my-awesome-feature'
```
Deploy the version of the Borrower Frontend found on the `my-awesome-feature`
branch.

```ruby
::case_api::branch_or_revision: '36989ac'
```
Deploy the version of the Case Api found at git commit [`36989ac`](https://github.com/LandRegistry/charges-case-api/commit/37294e036989ac25e491b31479e225939b0aaae6).

To properly understand the different parameters you can change have a look at
an apps `manifests/init.pp`, for example the [Borrower Frontends `init.pp`](https://github.com/LandRegistry/charges-borrower-frontend/blob/master/puppet/borrower_frontend/manifests/init.pp)

## Anatomy of this repo

### The Puppetfile

Location: [`/Puppetfile`](https://github.com/LandRegistry/dev-vm/blob/master/Puppetfile)

The Puppetfile tells Librarian-Puppet which modules to pull in. An example
declaration is:

```ruby
mod 'LandRegistry/borrower_frontend',
    git: 'git://github.com/LandRegistry/charges-borrower-frontend',
    ref: 'master',
    path: 'puppet/borrower_frontend'
```

**Line by line explanation:**

```ruby
mod 'LandRegistry/borrower_frontend',
```

Declare the modules name. This needs to be the same as the enclosing folder that
the puppet code exists in, e.g. if my puppet module is in `/foo` then I need to
name the module `mod MyCompany/foo`.

```ruby
    git: 'git://github.com/LandRegistry/charges-borrower-frontend',
```

Tell Librarian-Puppet where to find the repo that contains the module. This is
only needed when you haven't published your modules to a [forge](https://forge.puppetlabs.com/).

```ruby
    ref: 'master',
```

Tell Librarian-Puppet which branch or commit to fetch the puppet code from. You
can change this to any commit sha or branch name that is pushed to the git url
above. This is useful when testing puppet changes. **Note:** This only changes
where you fetch the *puppet* code from, not the app code. You configure the
module in [hiera](#hiera) for that.

```ruby
    path: 'puppet/borrower_frontend'
```

Tell Librarian-Puppet where to find the module inside the git repo above. You
can omit the git repo declaration and use only a path parameter to reference a
location on disk.

The Puppetfile can be used to [deploy a different version of an apps Puppet module](#deploying-a-different-version-of-an-apps-puppet-module).

### Hiera

Hiera is a tool for storing configuration parameters and it's fully integrated
in to Puppet. When creating a resource Puppet will look for a config value in
hiera and use that, falling back to any defaults defined in the class if it can't
find one.

Using Hiera we can set config values that are specific to certain environments,
even to certain VMs, in this way the same Puppet code can be used to deploy the
app to multiple locations.

Hiera is often used in the Dev VM to [deploy a different version of an app](#deploy-a-different-version-of-an-app)

#### The hiera.yaml file

The hiera.yaml file configues hiera and tells it where to look for files that
contain the config values. It's likely you'll not need to change this much. Ours
is set up to point to the vagrant.yaml file in [`hiera/vagrant.yaml`](https://github.com/LandRegistry/dev-vm/blob/master/hiera/vagrant.yaml).

#### The `/hiera` folder

The `/hiera` folder stores yaml files that contain config values used by Puppet
to configure the different Puppet modules. Files in this folder can be selected
based on any property of the VM, but often it is the "Fully Qualified Domain Name"
that's used (or `fqdn`). In the Dev VM we have only one VM and so we have only
one data file, [`hiera/vagrant.yaml`](https://github.com/LandRegistry/dev-vm/blob/master/hiera/vagrant.yaml)
which is used to configure our Dev VM.

#### The `hiera/vagrant.yaml` file

Example file: [`hiera/vagrant.yaml`](https://github.com/LandRegistry/dev-vm/blob/master/hiera/vagrant.yaml).

This file is filled with `key: value` pairs, where the key indicates which class
parameter to override and the value is used as the new value.

The key is namespaced to indicate which class and which parameter of that class
to override. Say we had a class named `foo` and it had a parameter `bar`:

```ruby
class foo ($bar = 'bar') {
}
```

If I want to override that bar parameter I need to use the key: `::foo::bar` to
indicate that all instances of `foo` should set `bar` to the new value.

**Examples:**

```
::borrower_frontend::port: 9001
```
Set the Borrower Frontends port to `9001`.
```
::case_api::branch_or_revision: 'my-awesome-new-feature'
```
Tell the Case API to [deploy the code on `my-awesome-new-feature` branch](#deploy-a-different-version-of-an-app).

## Using for your own development

This VM was mostly built for the Charges Team but we would like to support
anyone else making use of it. When using it please keep app specific code
out of the master branch. Instead make those changes in that apps puppet module.

If you make changes that seem good for anyone to use please commit these
separately and cherry-pick them into a new feature branch. That way you can open
a pull request and get it peer reviewed.
