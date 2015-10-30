\header{
    title = "Leoni"
    meter = "6 6 8 4 D"
    %composer = "Transcribed by M. Lyon (1751--1797)\\\\ and adapted by T.Olivers (1725--1799)\\ from a synagogue melody for the Yigdal"
    subtitle = "Transcribed by M. Lyon (1751--1797) and adapted by T.Olivers (1725--1799)"
    subsubtitle = "from a synagogue melody for the Yigdal"
    
    mutopiatitle = \title
    mutopiacomposer = "Anonymous"
    mutopiaarranger = "M. Lyon (1751--1797) and T. Olivers (1725--1799)"
    date = "C18"

    style = "Hymn"
    source = "Australian Hymn Book number 53"
    copyright = "Public Domain"
    maintainer = "Peter Chubb"
    maintainerEmail = "mutopia@chubb.wattle.id.au"
    lastupdated =	 "2005/Jan/10"

    footer = "Mutopia-2005/01/18-525"
    tagline = "\\raisebox{10mm}{\\parbox{188mm}{\\quad\\small\\noindent " + \footer + " \\hspace{\\stretch{1}} This music is part of the Mutopia project: \\hspace{\\stretch{1}} \\texttt{http://www.MutopiaProject.org/}\\\\ \\makebox[188mm][c]{It has been typeset and placed in the public domain by " + \maintainer + ".} \\makebox[188mm][c]{Unrestricted modification and redistribution is permitted and encouraged---copy this music and share it!}}}"
}
\version "2.4.0"

global =  {
    \key f \minor
    \time 4/4
    \partial 4 s4 |
    s1 |
    s2. \bar "||" 
    s4 |
    s1 |
    s2. \bar "||" 
    s4 |
    s1 |
    s2. \bar "||" 
    s4 |
    s1 |
    s2. \bar "||" 
    s4 |
    s1 |
    s2. \bar "||" 
    s4 |
    s1 |
    s2. \bar "||" 
    s4 |
    s1 |
    s2. \bar "||" 
    s4 |
    s1 |
    s2. \bar "||" 
}

sop =  \relative c' {
    c4 |
    f g as bes |
    c2. 

    as4 |
    bes c des es |
    c2. 

    g4 |
    as bes c des |
    es g, as 

    des |
    c2 bes |
    as2.

    as8( bes) |
    c4 c c c |
    bes2. 

    as8( g) |
    f( g) as( bes) c4 f, |
    f( e!2)

    c4 |
    f g as bes |
    c bes8( c) des4

    c8( bes) |
    as2 g |
    f2.
}

alto =  \relative c' {
    c4 |
    c e! f f |
    e!2.

    es4 |
    es es as g |
    es2.

    es4 |
    es es es as |
    g es es 

    des |
    es2 es4( des) |
    c2.

    f4 |
    es es es es |
    es2.

    e!4|
    f f f des |
    c2.

    c4 |
    c c c f |
    f f f

    f f2 f4( e!) |
    c2.
}


tenor = \relative c' {
    c4 |
    as c c bes |
    g2.

    c4 |
    bes as as bes |
    c2.

    bes4 |
    as g as as |
    bes bes as

    as |
    as2 g |
    as2.

    as4 |
    as as as as|
    g2.

    c8( bes) |
    as4 f f bes |
    g2. 

    e!4 |
    f e f f  |
    as  bes8( as) bes4 

    c8( des) |
    c4( des) g,2 |
    as2.
}

bass=\relative c {
    c4 |
    f c f des |
    c2.

    as'4 |
    g as f es |
    as2. 

    es4 |
    c es as f |
    es des c

    f |
    es4( des) es2 |
    as,2.

    des4|
    as' es c as |
    es'2. 

    c4 |
    f des as bes |
    c2.

    c4 |
    as c f des |
    as des8( c) bes4 

    as8( bes) |
    c4( bes) c2 |
    f2.
}

guitar=\chordmode {
    c4 |
    f:m c f:m bes:m/+des |
    c c c 

    as |
    es/+g as des es |
    as as as

    es |
    as/+c es as f:m |
    es es:7/+des as/+c

    des |
    as/+es as/+des es es:7 |
    as as as 

    des |
    as as as as |
    es es es 

    c |
    f:m des f:m bes:m |
    c:sus4 c c 

    c |
    f:m/+as c f:m des |
    f:m/+as des bes

    f:m |
    f:m bes c:sus4 c |
    f:m f:m f:m
}

\score {
    \transpose f e <<
      \context ChordNames \guitar
      \context Staff = "top" << 
	{ \clef "G" \global  }
	\context Voice = "sop" { \voiceOne \sop }
	\context Voice = "alto" { \voiceTwo \alto} 
      >>

      \context Staff = "bottom" << 
	{ \clef "F" \global }
	\context Voice = "tenor" { \voiceOne \tenor }
	\context Voice = "bass" { \voiceTwo \bass }
      >>
    >>

\layout {
    indent = 0.0\mm
    \context { 
      \ChordNames
 %     \override ChordName #'word-space = #1 
      \override ChordName  #'style = #'american
			chordChanges = ##t
    }
}
\midi {
    \tempo 4 = 120
}
}
