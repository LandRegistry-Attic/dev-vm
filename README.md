# dev-vm - The VM for developers

This is a basic developer VM, built by the Charges Team for the Charges Team.

## Pre-requisites

We use a few plugins in the Dev VM you should install first:

```
> vagrant plugin install vagrant-dns
> vagrant plugin install vagrant-librarian-puppet
> vagrant plugin install vagrant-cachier
```

You also should have Vagrant and Virtualbox. Easiest way is through
`homebrew-cask`:

Install `homebrew-cask`:

```
> brew install caskroom/cask/brew-cask
```

Then install the Vagrant and Virtualbox:

```
> brew cask install vagrant
> brew cask install virtualbox
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

## Accessing apps from your browser

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

## Pulling in another app

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

## Using for your development

This VM was mostly built for the Charges Team but we would like to support anyone else making use of it. When using it please keep project specific code out of the master branch. Take a new branch and make the changes: pull in your apps, install postgres, etc.

If you make changes that seem good for anyone to use please commit these separately and cherry-pick them into a new feature branch. That way you can open a pull request and get it peer reviewed.
