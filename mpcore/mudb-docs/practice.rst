.. _in-practice:

===========
In Practice
===========

Managing an update task
-----------------------

The database was put together so I could perform *ad hoc* queries on
the database. One of the greater challenges of the Mutopia Project is
that the LilyPond application continues to improve and many assets in
the catalogue can be improved if they can be updated. LilyPond
provides an application for this --- ``convert-ly`` --- but a number of
factors may prevent an update from being automatic. Updates must
always be reviewed.

This section walks through the process of using the database to help
manage an update task.

Step 1: Cleaning things up
~~~~~~~~~~~~~~~~~~~~~~~~~~

As Mutopia pieces are updated or added the database is updated as
well. This is simple database maintenance that can be automated fairly
well and is described in another section. We have run some update
tasks in the past and as this progresses we have started to accomplish
our goal of reducing the overall versions in use in our catalogue.

We can quickly find out how many LilyPond versions are represented in our
library with a simple query:

.. literalinclude:: sql/version-count.sql
    :language: sql

This returns 97. [#f1]_ This represents the total of distinct versions and I
will posit that there isn't much difference between small revisions
within a release. That is, a piece built with either 2.2.0 and 2.2.5
is not going to be substantially different. Let's take a
look at another query to get a more realistic count:

.. literalinclude:: sql/version-count-real.sql
    :language: sql

This is a rather odd query but all it does is concatenate the major
and minor columns of the version (ignoring the third ``edit`` value)
and count the distinct instances. This gives us 17 versions.

We have gone through some version update tasks and one thing that
happens is that there is no mechanism to remove rows from the
:ref:`version-table-label` table when a version becomes obsolete. Here
is a query that finds these dangling rows.

.. literalinclude:: sql/unused-versions.sql
    :language: sql

This will give us a list of rows in the :ref:`version-table-label`
table that have no reference in the :ref:`piece-table-label` table::

    1.7.21
    2.1.34
    2.1.7
    2.2.0
    2.2.5

An improvement! It is a goal to obsolete versions but we need to
clean these up to get accurate counts. By carefully editing the
previous ``SELECT`` statement we can quickly get some SQL that will do
exactly what we need

.. literalinclude:: sql/remove-obsolete-versions.sql
    :language: sql

Not surprisingly, that reduces the overall number of versions in use
to 92, just 16 distinct versions if the query ignores the ``edit``
value. Now that the :ref:`version-table-label` table is correct, we
can continue to the next step.

Step 2: Narrowing our view
~~~~~~~~~~~~~~~~~~~~~~~~~~

The :ref:`piece-table-label` table represents all pieces in the
catalogue. What we would like to do is select a subset of those pieces
that we can target for an update. SQL provides a very nice feature for
this called a view which allows you to use a select statement to
define a virtual table. We focused on pieces built with LilyPond 2.2
in the 4th set of updates and the table definition looked like this.


.. literalinclude:: sql/view4.sql
    :language: sql

If you were to select all pieces in this view, it would show only
pieces built with version 2.2. The advantage of this kind of mechanism
is that whenever you use it, the ``select`` statement is applied. As
pieces are updated in the database and the view will get smaller and
smaller. So how to pick the pieces to go into a view? First we need a
histogram.

.. literalinclude:: sql/version-histogram.sql
    :language: sql

I've put a little formatting sugar at the top to make this more
readable but what it does provide counts of pieces in the catalogue
for each major and minor revision. The output looks like this::

    version    count
    ---------  ------
    2.1        1
    2.2        5
    2.4        44
    2.6        97
    2.7        2
    2.8        147
    2.9        16
    2.10       454
    2.11       308
    2.12       186
    2.13       27
    2.14       76
    2.16       315
    2.17       1
    2.18       199
    2.19       55

Since versions 2.1.* and 2.2.* were included in earlier update tasks
the counts here are already accounted for in another milestone. The
plan is to take on 2.4, but it is still a little large to manage so
we'll try to whittle it down in a ``SELECT`` statement. What we would
like to have is about 20 pieces to present to volunteers.

.. note:: You do not want to use an SQL ``LIMIT`` statement to refine
          the size of these views. You *want* the view to get smaller
          as pieces are updated.

To look closer into the pieces represented within all 2.4 versions, we
can use this,

.. literalinclude:: sql/version-pare.sql
    :language: sql

Giving us these counts::

    version  count
    -------  -----
    2.4.1    6
    2.4.2    34
    2.4.5    4

For the sake of closing this section, let's take the easy way out and
choose the 10 pieces represented by pieces built with either 2.4.1 or
2.4.5. Here is the SQL for that view,

.. literalinclude:: sql/view5a.sql
    :language: sql

This is exactly what I used for "Update milestone #5". Once created
this view can be used to help create the issue descriptions in GITHUB
and it can help track progress.


Step 3: Solicit volunteers
~~~~~~~~~~~~~~~~~~~~~~~~~~

We have identified a subset of the Mutopia Project catalog to define a
set of pieces to use as a basis for issues in a GITHUB milestone. To
get this into GITHUB is a matter of hand manipulation with some
software aids. The process for doing this is,

  1. Create a milestone in the GITHUB project account.
  2. Create an issue for each piece in the view we just defined.
  3. Add each issue to the milestone.
  4. Mark the issue with a ``content-update`` tag.
  5. Request help on the mutopia-discuss group.
  6. You've done a lot of work so far but it would be nice if you
     would assign one of the tasks to yourself.

There is plenty of careful writing that truly is required to make an
update project successful. The majority of time will be spent on the
second step because for each issue you have to provide all the
information for the volunteer to adequately do the task. Getting it
wrong has serious consequences.

You have a database and several options. You could write some software
to pull the necessary data from the database and use some templating
library to write the issues. But if you aren't feeling fancy there are
ways to do this with the ``sqlite`` command line. For our small view
called ``piece_5a`` (which is currently update #5), you could use this
for the title of each issue.

.. literalinclude:: sql/issue-title.sql
    :language: sql

This uses the concatenation operator (``||``) to display the result
set in a formatted fashion. Like any language, you get used to the
syntax after a while and it is easy enough to play on the command line
since these are read-only calls into the database. The results look
like this::

    Update "SUONATA PRIMA, FVGA PLAGALE From Primo Registro of the Organo Suonarino" by BanchieriA
    Update "SUONATA SECONDA, FVGA TRIPLICATA From Primo Registro of the Organo Suonarino" by BanchieriA
    Update "SUONATA TERZA, FVGA GRAVE From Primo Registro of the Organo Suonarino" by BanchieriA
    Update "SUONATA QUARTA, FVGA CROMATICA From Primo Registro of the Organo Suonarino" by BanchieriA
    Update "SUONATA QUINTA, FVGA HARMONICA From Primo Registro of the Organo Suonarino" by BanchieriA
    Update "SUONATA SESTA, FVGA TRIPLICATA From Primo Registro of the Organo Suonarino" by BanchieriA
    Update "Sonata in G minor" by EcclesH
    Update "Overture to Egmont - Opus 84" by BeethovenLv
    Update "Brandenburg Concerto No. 5 (3rd Movement: Allegro)" by BachJS
    Update "Ein Musikalischer Spass (A Musical Joke) Mv 1" by MozartWA

You will also want to give a link to the piece on the MutopiaProject
website so that volunteers can take a look at what they are getting
into. This link can be created like so,

.. literalinclude:: sql/mutopia-link.sql
    :language: sql

giving::

    http://www.mutopiaproject.org/cgibin/piece-info.cgi?id=31
    http://www.mutopiaproject.org/cgibin/piece-info.cgi?id=32

(I've limited this arbitrarily to 2 so as not to bore you.) To create
that same link in the markup language used in GITHUB (called `md`),
you would modify the above like so,

.. literalinclude:: sql/mutopia-link-md.sql
    :language: sql

which will create a nicely formatted link in the issue description::

    [Mutopia piece 31](http://www.mutopiaproject.org/cgibin/piece-info.cgi?id=31)
    [Mutopia piece 32](http://www.mutopiaproject.org/cgibin/piece-info.cgi?id=32)

Note here how ``sqlite`` didn't really care that you used ``_id``
twice in the same ``SELECT`` query.


Full Text Search
----------------

Full text search, for want of a better explanation, is how most web
search engines work: you enter a string of keywords and a search
returns pages matching your request. This is supported in ``sqlite``
with an enhancement called `fts3 <http://www.sqlite.org/fts3.html>`_.
The best way to explain how this works is to walk through an example.

In ``mudb``, the instruments are parsed so that a separate table can
be built to allow queries to follow the 1:M relationship between
pieces and instruments. In the process of creating that table the
raw instrument list is process --- instruments are translated, plural
instruments are made singular, nicknames are dereferenced. If we
wanted to try to act on the original raw instrument string instead of
using this processed data, we could use the fts enhancement against a
virtual table containing the content we wish to mine.

.. literalinclude:: sql/fts-raw.sql
    :language: sql

This creates a virtual table, ``muVRawInstrument``, and populates it
from the desired columns of the ``muPiece`` table. We can now use the
fts ``MATCH`` directives to query this table. Here is a relatively
simple query that finds pieces containing both of the keywords
organ and piano (an implicit AND operation),

.. literalinclude:: sql/fts-q1.sql
    :language: sql

The ``MATCH`` directive engages the fts algorithms for the search and
returns this output, ::

    Harpsichord, Organ, Piano|Duetto II (from the Clavierübung Part III)
    Voice (SATB) and Organ or Piano|All My Heart This Night Rejoices
    Trumpet, Organ/Piano|La Réjouissance des Feux d'Artifice Royaux (Royal Fireworks)
    Trumpet and organ, or flute and piano|Wedding Music

The output is not pretty but I wanted the ``raw_instrument`` string
displayed so you could see how the match is made. Note that the search
finds the instruments in question regardless of order. You can further
refine the search to narrow results even more.

.. literalinclude:: sql/fts-q2.sql
    :language: sql

Gives a similar set but skips pieces with a trumpet part::

    Harpsichord, Organ, Piano|Duetto II (from the Clavierübung Part III)
    Voice (SATB) and Organ or Piano|All My Heart This Night Rejoices

These aren't very complicated queries for ``fts`` and, in fact, they
can be accomplished with the :ref:`piece-instrument-table-label` table
as well. Here is one that is made very simple with the ``MATCH``
operator,

.. literalinclude:: sql/fts-q3.sql
    :language: sql

It finds pieces that have both violin and cello parts (there are currently 4
in the MutopiaProject archive) but do not contain a viola part. There is only one
piece that meets that criteria. ::

    1454|BachJS|Violin and Cello|14 Canons - 4

These queries are somewhat contrived but it is an interesting search
that can be accomplished with relatively literal effort. The biggest
problem? Accuracy all depends on the consistency of the input.


Popularity Counts
-----------------

We have already seen how the built-in function ``count()`` can be used
as columnar data and sorted in the report output. This is convenient
for answering questions like "who composed the most pieces in the archive?"

Top ten composers in the archive
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The following is an example that provides a "top ten" list of most
popular composer in the archive,

.. literalinclude:: sql/top-ten-composer.sql
    :language: sql

The results are, ::

    composer              c_count
    --------------------  --------
    BachJS                415
    Traditional           125
    MozartWA              89
    GiulianiM             80
    BeethovenLv           74
    HoretzkyF             60
    HandelGF              57
    SchubertF             55
    SorF                  55
    DiabelliA             36


Top ten instruments
~~~~~~~~~~~~~~~~~~~
Composers are relatively simple since, for this kind of list, we can
simply output our internal tag without a join. This is similar with
instruments, differing in that multiple instruments may be specified
for a single piece (e.g., duets, symphonies). Since there is a
many-to-many relationship between instruments and pieces, we can get
count information for instruments directly from the mapping table,
:ref:`piece-instrument-table-label`,

.. literalinclude:: sql/top-ten-instruments.sql
    :language: sql

The results are no big surprise, ::

    instrument        t_count
    ----------------  --------
    Piano             740
    Voice             426
    Guitar            338
    Organ             182
    Harpsichord       177
    Violin            177
    Cello             118
    Continuo          93
    Viola             84
    Horn              67


.. rubric:: Footnotes
.. [#f1] Though not entirely accurate, I found an old list of versions
         and pieces that I used to cobble up a count of LilyPond
         versions in use a few years ago --- 127. The update tasks
         have done some good.
