# mp-core
This folder holds the java routines previously in `../UsefulScripts`.
The java code was moved, relatively unchanged, from that location into
java hierarchies that will promote reuse.

 * Core library (`core`) defines the package `mutopia.core`
 * `Mutopia` contains the Mutopia application that uses the core libraries.
 * Uses [Gradle](http://gradle.org/) as a build tool

If you are playing you need to install [Gradle](http://gradle.org/).
As a quick start I have installed the gradle wrapper (`gradlew`) in
mpcore which will look for an existing gradle and install one if it
doesn't find it,

```bash
$ cd mpcore
$ gradlew installDist
```

What to do with gradle?

 * `gradle help tasks` will show what can be done with the build file
 * `gradle build` will build the library and the Mutopia tool
 * `gradle installApp` will build and install the Mutopia
    tool as an executable script in the build folder

Install the Mutopia application so it can be used conveniently,

```bash
$ cd mpcore
$ gradle installDist
$ (cd Mutopia/build/install/Mutopia; tar cf - .) | (cd ..; tar xf -)
$ ../bin/Mutopia
Arguments must be: -d, -c, -f or -r followed by .ly file(s)
```

If you are not familiar with unix shell commands, that line just packs
up all folders from the installDist command (`bin` and `lib` from under
`Mutopia/build/install/Mutopia`) and unloads them into the folder
above `mpcore`. The `../lib` folder may be created in this process.

Note that the `bin/Mutopia` that gradle builds is a script, that will
do the right thing with respect to finding the required libraries in
the sibling `lib` folder. Either run the command directly or, more
conveniently, add the bin folder to your PATH,

```bash
$ export PATH=$PATH:$HOME/MutopiaWeb/bin
```
