\version "2.4.0"

\include "k477-header.ly"
\include "k477-defs.ly"
\include "k477-horn1-part.ly"

\score {
    \new Staff {
	\set Score.skipBars = ##t

	\set Staff.instrument = \markup {
	    \column < "Corno I"
		      { "in E" \smaller \flat } >
	}
	\set Staff.midiInstrument = #"french horn"

	\new Voice { << { \hornI } { \markings } >> }
    }

    \layout { }
    \include "k477-midi.ly"
}