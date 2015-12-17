# Module sources

This folder was created to hold perl module sources in a standard
format suitable for CPAN. We do not plan to submit these modules but
having them in a standard format is convenient for further
development.

  * Supports easy addition of tests in the build process.
  * Automatically supports document generation.

After following the build and installation instructions below, the
finished modules will be inserted into a standard library structure
with manual pages. To run a script that uses the library, you will
need to setup the PERL5LIB environment variable to point to the new
library location.

## How to build the modules

Assuming your workspace is in a folder called `$HOME/MutopiaWeb`:

```bash
$ cd src/Mutopia_Archive
$ perl ./Build.PL
$ ./Build installdeps
$ ./Build
$ ./Build test
$ ./Build install --install_base=$HOME/MutopiaWeb
```

Before building the `Mutopia_HTMLGen` module, make sure your
environment is setup,
```bash
$ export MUTOPIA_WEB=$HOME/MutopiaWeb
$ export PERL5LIB=$MUTOPIA_WEB/lib/perl5
$ # this is not required for this build but still used in many functions
$ export MUTOPIA_BASE=$HOME/MutopiaProject
```

Now follow the same process with `Mutopia_HTMLGen` as you did with
`Mutopia_Archive`.

## [Optional reading] How the `src` structure was built

This is documented in case there is an interest in how I did this or
if we need to create new modules.

You will need the `module-starter` utility from CPAN.

```bash
$ sudo cpan install module-starter
```

This command creates the basic hierarchy on a new branch, including a
stubbed out module file.

```bash
$ git checkout -b new-modules
$ mkdir ./src && git add ./src && git commit -a
$ cd src
$ module-starter \
    --ignores=git \
    --author="Glen Larsen" \
    --module=Mutopia_Archive \
    --email=glenl.glx@gmail.com \
    --builder=Module::Build
```

You will need all of these files except the stubbed out module because
we are moving the module with its history from the project root.
Delete the stub and commit everything.

```bash
$ cd Mutopia_Archive
$ rm lib/Mutopia_Archive.pm
$ git commit -a
```

Using git, move the module into place. Commit so that we can also
track any changes made for the purpose of this change.

```bash
$ # still in <repo>/src/Mutopia_Archive
$ git mv <repo-top>/Mutopia_Archive.pm lib/
$ git commit -a
```

Now we can build and test. The first build command builds the `Build`
utility in your module folder and only needs to be done once.

```bash
$ perl ./Build.PL --install_base=<repo-top>
$ ./Build
$ ./Build test
$ ./Build install
```

Because we overlaid the stubbed module, there is a single error that
shows up in the single test --- it expects to have a global version
variable. It is easier to accomodate this in the source instead of
fixing the test; you just need to add the following line to
`lib/Mutopia_Archive.pm`:

```bash
our $VERSION = `0.02`;
```

The convention is to use a test file for each specific bit of
functionality that you want to test. The first tests I added were,

```bash
01-getdata.t
02-rdfread.t
```

The `getData()` function is used to read a datafile into an
associative list, the second test creates a temporary RDF file and
calls on the routine that creates an associative list of the music
details. After the `Build install`, you will have the following
structure at the top of your repo,

```bash
$ cd <repo-top>
$ find lib
lib
lib/perl5
lib/perl5/Mutopia_HTMLGen.pm
lib/perl5/Mutopia_Archive.pm
lib/perl5/x86_64-linux-gnu-thread-multi
lib/perl5/x86_64-linux-gnu-thread-multi/auto
lib/perl5/x86_64-linux-gnu-thread-multi/auto/Mutopia_HTMLGen
lib/perl5/x86_64-linux-gnu-thread-multi/auto/Mutopia_HTMLGen/.packlist
lib/perl5/x86_64-linux-gnu-thread-multi/auto/Mutopia_Archive
lib/perl5/x86_64-linux-gnu-thread-multi/auto/Mutopia_Archive/.packlist
```
