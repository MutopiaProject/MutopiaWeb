#!/usr/bin/perl -T
package HTMLcommon;
use strict;
use utf8;

#
# Routines common to the Mutopia site CGI scripts.
# More info at perldoc HTMLcommon
# 

our $VERSION = '0.01';

our $FTPBASE = 'http://www.mutopiaproject.org/ftp/';

# Maximum page length for pagination
our $PAGE_MAX = 10;

# This code was in-line and identical in both modules, so moved here
# as a function. Returns the QUERY_STRING as an associative array.
sub queryArgs {
    my @pairs = split(/\&/, $ENV{'QUERY_STRING'}, 0);
    my %FORM;
    foreach my $pair (@pairs) {
        my ($name, $value) = split(/=/, $pair, 3);
        $value =~ tr/+/ /;
        $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack 'C', hex $1;/eg;
        $FORM{$name} = $value;
    }
    return %FORM;
}


sub startPage {
    my ($headTitle, $titleTitle) = @_;
    # fallback if only one argument given
    $titleTitle = $headTitle if !defined($titleTitle);

    binmode(STDOUT, ":utf8");
    # Output the content header. Done separately because the empty
    # line after the statement is important.
    print "Content-type: text/html; charset: utf8\n\n";

    print <<__HEAD;
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="Free, open, sheet music for the world.">
  <meta name="author" content="Mutopia Project contributors">
  <link rel="icon" href="../favicon.ico">
  <link rel="alternate" title="Mutopia RSS" href="http://www.mutopiaproject.org/latestadditions.rss" type="application/rss+xml" />

  <title>$headTitle</title>

  <link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="../css/mutopia.css" rel="stylesheet">
  <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
  <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->
</head>

<body>
  <nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
      <div class="navbar-header">
        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
          <span class="sr-only">Toggle navigation</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="../index.html"><img src="../images/mutopia-ico-24x24.png" /></a>
      </div>
      <div id="navbar" class="navbar-collapse collapse">
        <ul class="nav navbar-nav">
          <li><a href="../index.html">Home</a></li>
          <li><a href="../browse.html">Browse</a></li>
          <li><a href="../advsearch.html">Search</a></li>
          <li><a href="../legal.html">Licensing</a></li>
          <li><a href="../contribute.html">Contribute</a></li>
          <li><a href="../projects.html">In-Progress</a></li>
          <li><a href="../contact.html">Contact</a></li>
        </ul>
      </div> <!-- .navbar-collapse -->
    </div>
  </nav>

  <div class="jumbotron">
    <div class="container">
      <div class="row">
        <div class="col-sm-3">
          <img src="../images/mutopia-logo.svg" alt="Mutopia Project Logo" width="260" height="68" />
        </div>
        <div class="col-sm-4 col-sm-offset-1 text-center">
          <b>All music in the Mutopia Project is free to download, print out, perform and distribute.<br />
            25 pieces of music are now available.</b>
        </div>
        <div class="col-sm-4 text-center">
          Save our bandwidth - use a mirror!<br />
          <a href="http://www.mutopiaproject.org/" title="Main site in Canada"><b>Canada</b></a> |
          <a href="http://eremita.di.uminho.pt/mutopia/" title="Mirror in Portugal">Portugal</a>
        </div>
      </div>
    </div>
  </div>

  <div class="container">
    <div class="row">
      <!-- main body -->
      <div class="col-sm-12">
        <h2>$titleTitle</h2>
__HEAD
}


sub finishPage {
    print <<__FINISH;
    </div>
   </div>
  </div>
  <footer class="footer">
    <div class="container">
      <p class="text-center"><u>Disclaimer:</u><br/>
      <small>The Mutopia Project is run by volunteers, and the material within it is provided
      "as-is". NO WARRANTY of any kind is made, including fitness
      for any particular purpose.<br />No claim is made as to the accuracy or the
      factual, editorial or musical correctness of any of the material
      provided here.</small></p>
    </div>
  </footer>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  <script src="../bootstrap/js/bootstrap.min.js"></script>
</body>
</html>
__FINISH
}


sub startPiece {
    my ($title, $composer) = @_;
    my $byline;
    my $headTitle;
    if ($composer eq 'Anonymous' or $composer eq 'Traditional') {
        $headTitle = qq[$title ($composer)];
        $byline = "($composer)";
    }
    else {
        $headTitle = qq[$title, by $composer];
        $byline = "by $composer";
    }
    startPage($headTitle, $title);
    print qq(        <h4>$byline</h4>\n);
}

sub finishPiece {
    finishPage();
}

__END__

=head1 NAME

HTMLCommon - common routines for MutopiaProject web site

=head1 SYNOPSIS

This package provides routines for presenting search results. The goal
is to provide common HTML code here without cluttering the search
code.

It is not intended for use outside of Mutopia's cgibin.


=head2 queryArgs - get arguments from the QUERY_STRING

Parse the query string into an associative list.

    my %FORM = queryArgs();
    foreach my $k (keys %FORM) {
        print "$k = $FORM{$k}\n";
    }

This code was migrated from the CGI scripts and made into a common
library routine call.


=head2 startPage - Start HTML5 document

Write the html, head and body tags. This is very specific to the
MutopiaProject site and must be closed with finishPage.

=head2 finishPage - Finish document started with startPage

Closes the div directives started in HStart, adds a footer, and closes
the HTML document.
