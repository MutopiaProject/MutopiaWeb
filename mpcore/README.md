# mp-core
This is a temporary repository to show the proposed layout of the
library and one of its java tools.

 * Core library defines the package `mutopia.core`
 * `mutopia.core` has no external dependencies
 * Uses [Gradle](http://gradle.org/) as a build tool

If you are playing you need to install [Gradle](http://gradle.org/).
As a quick start I have installed the gradle wrapper in mpcore which
will look for an existing gradle and install one if it doesn't find
it,

```bash
$ cd mpcore
$ gradlew install
```

What to do with gradle?

 * `gradle help tasks` will show what can be done with the build file
 * `gradle build` will build the library and the Mutopia tool
 * `gradle :Mutopia:installApp` will build and install the Mutopia
    tool as an executable script in the build folder

Install the Mutopia application so I can use it,

```bash
$ cd mpcore
$ gradle install
$ (cd Mutopia/build/install/Mutopia; tar cf - bin lib) | (cd ..; tar xf -)
$ ../bin/Mutopia
Arguments must be: -d, -c, -f or -r followed by .ly file(s)
```

If you are not familiar with unix shell commands, that line just packs
up the `bin` and `lib` folders under `Mutopia/build/install/Mutopia`,
puts them onto a pipe, and unloads them in the folder above you
(`mpcore/..`).
