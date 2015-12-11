.. _db-design: MP Database Design

Database Details
================

.. _background-label:

Background
----------
The `Mutopia Project <http://mutopiaproject.org>`_ offers sheet music
editions of classical music for free download. All sheet music is
written in `LilyPond <http://lilypond.org>`_ and contributed by volunteers.

Historically, the Mutopia Project hasn't used a formal database. The
web interface uses dataset that is generated each time a piece is
added or updated. The interface that presents and interacts with that
dataset is written in perl and it allows useful searching capabilities
for finding specific pieces of music. ``MuDB`` is a side project that
defines an SQL-style database based on the physical dataset. It's only
purpose at this point is to provide ad hoc queries.

The core archive of Mutopia is structured as a file hierarchy that
roughly follows this layout::

 Mutopia
 |-- datafiles
 |-- ftp
 |   |-- composer-1
 |   |   |-- work-1
 |   |   |   |-- piece-1
 |   |   |   |-- piece-2
 |   |   |-- work-2
 |   |   |   |-- piece-1
 |   |-- composer-2
 |   |   .
 |   |   .

 Physical file structure


This is the physical structure that provides a path to an individual
piece of sheet music, representing a specific work by a composer. The
sheet music itself, written in `LilyPond <http://lilypond.org>`_,
contains a header structure describing elements that form the
description of the piece.


Design
------
The design is presented with a UML diagram to show entities and
their relationships. Each entity in the diagram is represented in the
database by a table.

.. image:: /images/mudb-design.svg
	   :alt: UML Diagram for MUDB
	   :width: 90%
	   :align: center

An entry in the Mutopia archive might represent a single work of music
or an entire opus.

.. _piece-table-label:

The muPiece Table
~~~~~~~~~~~~~~~~~
The attributes of the ``muPiece`` table are precisely what you will find on
the Mutopia web site with regards to contributing a piece. With the
exception of the primary key, they are all fields that Mutopia will
use to enter a contributed work into the system.

.. literalinclude:: sql/muPiece-table.sql
   :language: sql

_id, unique primary key
    This is used to reference a specific entry into the Mutopia
    archive. For pieces existing before the database, the value is the
    existing mutopia id, typically found formatted in the ``footer``
    header variable that is added by Mutopia when pieces are entered
    into the system.

title
   The title of the piece.

composer
    A composer name `tag`, pre-formulated by the Mutopia Project,
    which references a single row of the ``muComposer`` table.

style
    The style tag, which must match to a specific row of the
    ``muStyle`` table.

raw_instrument
    The full instrument specification taken from header. This is later
    processed into a map of relationships between instruments and
    pieces.

license_id
    A reference to a specific copyright.

maintainer_id
    A reference to a specific contributor who contributed this
    piece. The attribute name is somewhat inaccurate since volunteers
    may perform updates without modifying this variable. In reality
    this contributor entered the piece and released it according to
    the license.

version_id
    The LilyPond software version that was used to create the
    deliverables for this piece.

opus
    Opus of which this piece is a part. Optional.

lyricist (was `poet`)
    Used for vocal pieces, the author of the lyrics. Optional.

date_composed (was `date`)
    Date the piece was originally written in no particular searchable
    format. Sometimes its hard to get any more exact than '19th
    century'.

date_published
    ISO8601 date of publication of this transcription. This is parsed
    from the ``footer`` field in the header.

source
    Typically the publisher of the sheet music that was used to
    engrave the sheet music.

moreinfo
    Additional information relevant to the piece.



The muInstrument Table
~~~~~~~~~~~~~~~~~~~~~~
The list of valid instruments is a simple hash table to improve
searches for sheet music that targets a specific instrument. This
table is seeded with instruments from *instruments.dat* then
additional instruments are added as they are found in headers.

.. literalinclude:: sql/muInstrument-table.sql
   :language: sql


The muStyle Table
~~~~~~~~~~~~~~~~~
A simple hash table for controlling style names within Mutopia
pieces. This is loaded from the *styles.dat* file, any additional
styles that are found in headers but not mentioned in *styles.dat* are
dealt with using the ``in_mutopia`` boolean.

.. literalinclude:: sql/muStyle-table.sql
   :language: sql


The muLicense Table
~~~~~~~~~~~~~~~~~~~
Contributions to Mutopia, ideally, will use the small set of
licenses with which this table is seeded.


.. literalinclude:: sql/muLicense-table.sql
   :language: sql


The muContributor Table
~~~~~~~~~~~~~~~~~~~~~~~
The creation of this table is a direct result of normalizing the
information used by Mutopia from the header structure. There is no
naming convention in place so this is very loose (contributed pieces
are allowed to skip author identification.)

.. note:: Several Mutopia pieces claim to have more than one
	  maintainer. This is not currently supported in the model but
	  could be in the future.

.. literalinclude:: sql/muContributor-table.sql
   :language: sql

name
    The name of the contributor.

email
    The contributor's email, if given.

url
    The contributor's web address, if given.


The muComposer Table
~~~~~~~~~~~~~~~~~~~~
.. literalinclude:: sql/muComposer-table.sql
   :language: sql

The attributes of this table are a mirror of the existing
*composers.dat* data file.

composer
    A unique but descriptive tag to identify the composer. This
    provides a mechanism for one contributor to ascribe a work to
    'Bach' and another contributor to use 'Johann Sebastion Bach';
    within Mutopia this is **BachJS**.

description
    Because the ``composer`` is a tag, this field allows some
    free-form text that is typically used to give the full name with
    the composer's lifespan information.


The muRDFMap Table
~~~~~~~~~~~~~~~~~~
The muRDFMap table is used to map the physical structure (see
:ref:`background-label`) to the database tables by helping to locate
the headers for each piece. Once fully populated, the number of
entries in ``myRDFMap`` should be equal to the number of entries in
``muPiece``. This table is mainly used as an aid for loading tables
from RDF files.

.. literalinclude:: sql/muRDFMap-table.sql
   :language: sql

rdfspec
    A path, relative to top of the ftp folder in the physical
    hierarchy, that contains the source files for the sheet music.

piece_id
    A reference to a row within the ``muPiece`` table


The muPieceInstrument Table
~~~~~~~~~~~~~~~~~~~~~~~~~~~
This table is used to implement the mapping from a single piece to 1
or more instruments. The instrument names are parsed from the
``raw_instruments`` column of ``muPiece`` (see :ref:`piece-table-label`).

.. literalinclude:: sql/muPieceInstrument-table.sql
   :language: sql

Each row in the table maps a piece to a single instrument. If 2
instruments are listed for the piece they will account for 2 rows in
the table. This allows a very fast method for finding pieces written
for specific instruments.
