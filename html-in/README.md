# The Template library

## Synopsis

The .html-in files are like "HTML with macros".  They are processed by
the update script to generate static HTML files.

Sections enclosed in double square-brackets `[[ ... ]]` are executed as
perl code.  The value returned is inserted into the output HTML.  For
example, `[[ scalar localtime() ]]` inserts the current date and time.

The code is actually executed by the `Archive_HTMLGen.pm` module, so any
subroutines in that module will be available.  For example, `[[ HEAD() ]]`
calls the `HEAD` subroutine in that module, which returns the HTML for a
menu at the top of a page.

Note that this is a pale imitation of the HTML::Embperl module, which
can be used to make dynamic web pages.  It would be nicer to use that
module, but it is a complex module and would be tricky to install on
the Mutopia Project server.

## Changes for HTML5 Effort

A mechanism for including other template files has been added,
`INCLUDE()`, and, consequently, .html-include files have emerged as a
moniker for template code that might be included by other template
code. If it gets any more complicated than this we need to get some
template code off the shelf.
