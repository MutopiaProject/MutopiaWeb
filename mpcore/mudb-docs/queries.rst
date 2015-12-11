.. _db_queries: Sample Queries

Sample Queries
==============

This section contains a few useful queries to provide a sample of what the
database can provide for data mining.

Introduction to Joins
---------------------
The first is a simple example of using a join to display a complete
query. Given the Mutopia id, a piece might be retrieved with this
sql::

  sqlite> .mode line
  sqlite> select composer, title, license_id
     ...> from muPiece
     ...> where _id=1720;
    composer = LullyJB
       title = Salve Regina
  license_id = 2

.. note:: ``.mode line`` is a command to the sqlite3 command
   interpreter to provide the result in a vertical format. The default
   mode is ``list`` and is more suited for a large result set.

There is a human-readable problem here: we now know the license --- 2
--- but it would be good to know what that meant. The 2 in this case
references a row in the ``license_id`` table and that is where we need
to go to get this information. This is done using a join.

.. literalinclude:: sql/copyright_join.sql
    :language: sql

And the results are::

  composer = LullyJB
     title = Salve Regina
      name = Creative Commons Attribution 3.0

In addition, the composer could use the descriptor field instead of
the Mutopia-oriented composer tag,

.. literalinclude:: sql/composer_join.sql
   :language: sql

Giving the results::

  description = J. B. Lully (1632–1687)
        title = Salve Regina
         name = Creative Commons Attribution 3.0

.. _compound-queries:

Compound Queries
----------------

Database queries are really all about sets and that notion is very
apparent in compound queries, where a selection is made on one table
based on a result set from another table. The example here is from the
1:many relationship of ``pieces`` to ``instruments`` (as in, "a piece
may be written for 1 or more instruments"). The table that defines
this relationship is ``muPieceInstrument``.

.. literalinclude:: sql/compound-select-1.sql
   :language: sql

This will give you a list of identifiers that represent pieces that
specify that a Violin score is included. If you wanted to also know
the composer and title of each piece, you could use the result set
from that query to find that information in the ``muPiece`` table.

.. literalinclude:: sql/compound-select-2.sql
   :language: sql

This works because the original result set, in parentheses, returns
only a set of identifiers that we can then use as a set. Note the use
of the sql keyword ``AS`` to give a name to our select references.
This is not strictly necessary in this relatively simple query but is
a convenience to help organize the select clause.

The results of these queries aren't being shown here because this
particular list has over 2000 lines. Out of curiousity and for the
purpose of this tutorial, let's filter this list down so that we can
figure out which composer wrote the most pieces for violins in our
database.

.. literalinclude:: sql/compound-select-3.sql
   :language: sql

This has introduced a number of interesting SQL bits and you can
start to see how an SQL query can expand. We have added a count of the
composer field on the select line and we have given it a column name
of ``ccount``. Skipping over the select statement that forms are inner
result set you can see how this is later used to order the list ---
descending so we see the largest at the top. To shorten this we
specify a limit of 6 lines of information. The other new element, the
``GROUP BY`` clause is so the count represents the composers has a
group. Without grouping the select, the result would be single row
with a confusing count.

The results of our top 6 are::

    composer      ccount
    ------------  ------
    BachJS        46    
    MozartWA      31    
    BeethovenLv   20    
    BlakeB        6     
    HandelGF      6     
    PaganiniN     6     


Aggregate Functions
-------------------

If we wanted to count how many pieces there are in the database that
are written for violin, we could use a simple query using the
``muPieceInstrument`` table as a base.

.. literalinclude:: sql/instrument_count.sql
   :language: sql

The aggregate function, ``count()``, is one of several functions
available on the command line that can act on the result set.

Intersection
------------
Now suppose you wanted to find pieces written specifically for
multiple instruments. Think of it as a compound query with some set
theory thrown in --- you want to use the results from 2 instrument
queries and perform a set operation to get a single result. Because
you want just the set of pieces that satisfy both queries, what you
want is the intersection of the two sets. Instead of listing specific
pieces, here is a query that provides totals by composer, ordered by
frequency.

.. literalinclude:: sql/instrument_intersect.sql
   :language: sql

The result of this query (at this time of database development)
is::

    MozartWA: 29
    BachJS: 19
    BeethovenLv: 11
    GriegE: 2
    HandelGF: 2
    Mendelssohn-BartholdyF: 2

Picking a specific composer you can use a similar query to get a list
of titles:

.. literalinclude:: sql/mozart_intersect.sql
   :language: sql

With a result of::

    Canzonetta "Deh vieni alla finestra" from Don Giovanni
    String Quartet KV. 387 (nr. 14)
    Die Zauberflöte (The Magic Flute) - Ouverture
    Die Zauberflöte (The Magic Flute) - No. 4 Arie
    Die Zauberflöte (The Magic Flute) - No. 13 Arie
    Die Zauberflöte (The Magic Flute) - No. 17 Arie

.. note:: Currently, there is no way to find duets using the same
	  instrument (2 guitars, 2 pianos, etc.).
