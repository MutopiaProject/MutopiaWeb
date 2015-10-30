# MutopiaWeb

This repository contains a development area for updating the
MutopiaProject website.

## Project Goal

The goal of the MutopiaWeb project is to replicate the existing site
functionality in the more modern language of HTML5 and, in so doing,
improve the support for smartphone and tablet devices.

The process will leverage the existing design while taking advantage
of newer features.

   * Use bootstrap for the web framework to provide a jump-start to the new CSS and JavaScript features available.

   * Provide a reviewable site before deployment and get design feedback from the discussion list.

   * Implement accepted design requests.

   * Test on small format devices as well as desktop browsers.

   * Repeat the previous three steps until done.

## Implementation notes

The basic deployment strategy of the site will not change for this
project. The core web site, not including search results, will remain
a set of static pages built from perl scripts. This will allow the
existing publication process to remain stable.

   * Update and extend the existing perl scripts to support the new features.

   * Sources for existing and new artwork will be checked into the repository.

   * All templates in the `html-in` folder will be modified to accomodate the new HTML code.

   * The few dynamic pages (from browsing and advanced search) will be modified to contain HTML5 header and navigation.
