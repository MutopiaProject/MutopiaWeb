% Entered on Nov1, 2007
\version "2.11.34"
%#(set-global-staff-size 17) 

\paper {
%	#(set-paper-size "a4")
%	#(set-paper-size "letter")
	left-margin = 0.75 \in
	line-width = 7.0 \in
	between-system-padding = #2.0
	between-system-space = #2.0
	ragged-last-bottom = ##t 
	ragged-bottom = ##f
}

\header {
	title = "Nº. 1. March by Rossini."
	subtitle = "from Ricciardo e Zoraide."
	subsubtitle = "60 National Airs of Different Nations"
	composer = \markup{\column \right-align 
	{\line {Felix Horetzky} 1796-1870}}
	meter = ""
% MUTOPIA
 mutopiatitle = "Nº. 1. March by Rossini."
 mutopiacomposer = "HoretzkyF"
 mutopiapoet = ""
 mutopiaopus = ""
 mutopiainstrument = "Classical Guitar"
 date = "unk"
 source = "Boije collection #268"
 style = "Classical"
 copyright = "Public Domain"
 maintainer = "Stan Sanderson"
 moreInfo = "The Boije collection is found at http://www.muslib.se/ebibliotek/boije/"
 footer = "Mutopia-2007/11/17-1090"
 tagline = \markup { \override #'(box-padding . 1.0) \override #'(baseline-skip . 2.7) \box \center-align { \small \line { Sheet music from \with-url #"http://www.MutopiaProject.org" \line { \teeny www. \hspace #-1.0 MutopiaProject \hspace #-1.0 \teeny .org \hspace #0.5 } • \hspace #0.5 \italic Free to download, with the \italic freedom to distribute, modify and perform. } \line { \small \line { Typeset using \with-url #"http://www.LilyPond.org" \line { \teeny www. \hspace #-1.0 LilyPond \hspace #-1.0 \teeny .org } by \maintainer \hspace #-1.0 . \hspace #0.5 Reference: \footer } } \line { \teeny \line { This sheet music has been placed in the public domain by the typesetter, for details see: \hspace #-0.5 \with-url #"http://creativecommons.org/licenses/publicdomain" http://creativecommons.org/licenses/publicdomain } } } }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Source & comments
%%	
%%  Felix Horetzky was born in Horyszów Ruski, Poland, January 1, 1796.
%%	Little is known about he came to the guitar. He traveled to Vienna
%%	to study under master guitarrist, Mauro Giuliani. He traveled
%%  extensively in Europe as a concert performer and teacher. He wrote
%%  between 100 and 150 pieces for the guitar. He died in Edinburgh
%%  on October 6, 1870.
%%
%%	This piece is from #268, "60 National Airs of Different Nations",
%%	in the Boije collection and is in the public domain.
%%	<http://www.muslib.se/ebibliotek/boije/>
%%	Publisher: Chappell (London), no date given.
%%
%%	Carl Boije (1849-1923) was an amateur guitarist whose vast collection
%%	was donated to the State Library of Sweden after his death.
%%
%%	The dynamic markings for the most part follow the original score; obvious
%%	notation errors have been corrected.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\include "english.ly"

%%%% shortcuts

dol = \markup { \smaller\italic "dolce."}
cres = \markup{\smaller\italic"cresc:"}
cress = \markup{\tiny\smaller\italic"cresc:"}
espr = \markup{\smaller\italic"espres:"}
rit = \markup{\smaller\italic"ritart:"}
atem = \markup{\smaller\italic"a tempo:"}
smz = \markup{\smaller\italic"smorz:"} % smorzando
showTup = { \override TupletNumber #'transparent = ##f
		\override TupletBracket #'transparent = ##f }
hideTup = { \override TupletNumber #'transparent = ##t
		\override TupletBracket #'transparent = ##t }
seg = \markup {\smaller \smaller \musicglyph #"scripts.segno"}
cod = \markup {\smaller \vcenter "to" \hspace #0.7 \smaller \vcenter \musicglyph #"scripts.coda"}
toseg = \markup { \bold \vcenter "to" \hspace #0.7 \vcenter \smaller \musicglyph #"scripts.segno" }
fin = \markup {\smaller \bold \italic "Fine."}		
	
%% End shortcuts

%%%%%%%%%%
%% Reminders
%
%    \once \override DynamicText #'extra-offset = #'(-3.75 . 5.5)
%    \once \override TextScript #'extra-offset = #'( 0.8 . -2.3 )
%
%%%%%%%%%%

upper = \relative c''{
	\set Staff.instrumentName=\markup{
	\column {\smaller\bold "Nº. 1  " \smaller\smaller\italic "MAESTOSO. "}}
	\repeat volta 2 {
		fs4 e8. fs16 d4 d |
		e2 a,4 r |
		d e8. fs16 g8. a16 fs8. g16 |
		e4 e16_\< a, cs\! e_\f a4 r | \bar "||"
		
		\mark \seg
		fs4 \grace {g16[ fs]} e8. fs16 d4 d |
		e2 a,4 r |
		r8. a16 d8. e16 fs8 a16. g32 e8 g16. fs32 |
		d4 ~ d16 d fs a_\f d4 r^\fin
	}
		<e, cs>4 <cs a>8. <d b>16 <e cs>4 <fs d> |
		g2 b4 r |
		fs8. g16 fs4 ~ fs8 e d cs |
		d8. cs16 b4 bf' a8 r |
}

middle = \relative c'' {
	\override Staff.NoteCollision 
	#'merge-differently-headed = ##t
%% middle voice can interfere... use the following
	\override Stem #'length-fraction = #0.6
	\repeat volta 2 {
		a4 g8. a16 s2 |
		s1 |
		s1 |
		cs4 s cs s |

		a g8. a16 s2 |
		s1 |
		s1 |
		s2 fs'4 s |
	}
		s1 |
		e2 e4 s |
		d d ~ d8 cs b as |
		s2 <e' cs>4 s |	
}		

lower = \relative c' { 
	\override Staff.NoteCollision 
	#'merge-differently-headed = ##t
	\repeat volta 2 {
		\once \override DynamicText #'extra-offset = #'(-2.5 . 2.5)
		d2_\f <fs d>4 <fs d> |
		\once \override DynamicText #'extra-offset = #'(-2.5 . 2.5)
		<g a,>2_\sf g4 r |
		<a fs> <cs e,>8. <d d,>16 <e cs,>4 <d d,> |
		a,2 a4 s

		\once \override DynamicText #'extra-offset = #'(-2.5 . 2.5)
		d2_\p <fs d>4 <fs d> |
		<g a,>2 g4 r |
		<fs d>2 <a d,>4 <g a,> |
		<fs d> r d r |	
	}
		\once \override DynamicText #'extra-offset = #'(-2.5 . 2.5)
		a2_\p g4 fs |
		e2 g'4 r |
		\once \override TextScript #'extra-offset = #'( 2.0 . 2.0 )
		fs,_\dol fs fs fs |
		b2 a4. r8_\toseg	
}	

staffClassicalGuitar = \new Staff  {
		\time 4/4
		\key d \major
		\set Staff.connectArpeggios = ##t
		\set Staff.midiInstrument="acoustic guitar (nylon)"
		<<
			\new Voice = A { \voiceOne  \upper }
			\new Voice = B { \voiceTwo  \middle }			\new Voice = C { \voiceFour  \lower }
		>>
		\bar "||"   %%  "|."
}

\score { 
		<<
			\staffClassicalGuitar
		>>
		}
		
\layout  {\context {
   \Staff
   \consists Span_arpeggio_engraver
 } }

\score {
	\unfoldRepeats
	\staffClassicalGuitar
	\midi {
		\context {
			\Score
			tempoWholesPerMinute = #(ly:make-moment 90 4)
		}
		\context {
			\Voice
			\remove "Dynamic_performer"
	    }
    }
}
