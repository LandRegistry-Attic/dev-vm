# dev-vm - The VM for developers

This is a basic developer VM, built by the Charges Team for the Charges Team.

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
