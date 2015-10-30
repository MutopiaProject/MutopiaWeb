% Entered on Nov 5, 2007
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
	title = "Nº. 14. Tyrolian Air."
	subtitle = ""
	subsubtitle = "60 National Airs of Different Nations"
	composer = \markup{\column \right-align 
	{\line {Felix Horetzky} 1796-1870}}
	meter = ""
% MUTOPIA
 mutopiatitle = "Nº. 14. Tyrolian Air."
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
 footer = "Mutopia-2007/11/10-1104"
 tagline = \markup { \override #'(box-padding . 1.0) \override #'(baseline-skip . 2.7) \box \center-align { \small \line { Sheet music from \with-url #"http://www.MutopiaProject.org" \line { \teeny www. \hspace #-1.0 MutopiaProject \hspace #-1.0 \teeny .org \hspace #0.5 } • \hspace #0.5 \italic Free to download, with the \italic freedom to distribute, modify and perform. } \line { \small \line { Typeset using \with-url #"http://www.LilyPond.org" \line { \teeny www. \hspace #-1.0 LilyPond \hspace #-1.0 \teeny .org } by \maintainer \hspace #-1.0 . \hspace #0.5 Reference: \footer } } \line { \teeny \line { This sheet music has been placed in the public domain by the typesetter, for details see: \hspace #-0.5 \with-url #"http://creativecommons.org/licenses/publicdomain" http://creativecommons.org/licenses/publicdomain } } } }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Source & comments
%%	
%%  	Felix Horetzky was born in Horyszów Ruski, Poland, January 1, 1796.
%%	Little is known about he came to the guitar. He traveled to Vienna
%%	to study under master guitarrist, Mauro Giuliani. He traveled
%%  	extensively in Europe as a concert performer and teacher. He wrote
%%  	between 100 and 150 pieces for the guitar. He died in Edinburgh
%%  	on October 6, 1870.
%%
%%	This piece is from #268, "60 National Airs of Different Nations",
%%	in the Boije collection and is in the public domain.
%%	
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
fin = \markup {\smaller \smaller \bold \italic "Fine."}		
I = \once \override NoteColumn #'ignore-collision = ##t	

%% End shortcuts


%%%%%%%%%%
%% Reminders
%
%    \once \override DynamicText #'extra-offset = #'(-3.75 . 5.5)
%    \once \override TextScript #'extra-offset = #'( 0.8 . -2.3 )
%    \once \override Stem #'length-fraction = #0.8
%
%%%%%%%%%%

upper = \relative c''{
	\set Staff.instrumentName=\markup{ \center-align 
	{\smaller\bold "Nº. 14  " \smaller\smaller\italic "TEMPO di. " 
	\tiny\smaller\italic "MENUETTO."}}
	\repeat volta 2 {
		\partial 4*1 b,4 |
		e8. e16 gs8. gs16 b8. b16 |
		<b gs>8 gs' e4^> \times 2/3 {gs,8 b e} |
		fs4 a \times 2/3{fs,8 a ds} |
		<e gs,>4 <gs b,> \times 2/3{b,8 a ds,} | \bar "||"
		
		e8. e16 gs8. gs16 b8. b16 |
		b8 gs' e4^> \times 2/3{gs,8 cs <es ds>} |
		<fs cs>4 <a cs,> \times 2/3{fs,8 a ds} |
		<e gs,>2 
	}
	
		\partial 4*1 \times 2/3 {gs,8 b e} |
		\times 2/3 {a,8 b ds} <fs ds a>4 \times 2/3 {a,8 b ds} |
		\times 2/3 {gs,8 b e} <gs b,>4 \times 2/3 {gs,8 b e} |
		\times 2/3 {a,8 b ds} <fs ds a>4 \times 2/3 {a,8 b ds} |
		\times 2/3 {gs,8 b e} <gs b,>4 b,4 |
	e,8. e16 gs8. gs16 b8. b16 |
	b8 gs' e4^> \times 2/3{gs,8 cs <es ds>} |
	<fs cs>4 <a cs,> \times 2/3{fs,8 a ds} |
	<e gs,>2 
}
		

lower = \relative c' { 
	\override Staff.NoteCollision 
	#'merge-differently-headed = ##t
	\repeat volta 2{
		\partial 4*1 r4 |
		e,4 gs b |
		e2 e,4 |
		a2 b4 |
		e e, b' |
		
		e, <e' gs,> <gs b,> |
		<gs e>2 \times 2/3{cs,8 ~ cs b} |
		a4 fs8 a b4 |
		e e, 
	}
	
		\partial 4*1 e'4 
		fs \once \override DynamicText #'extra-offset = #'(-3.25 . 2.8)
			b,_\sf fs' |
		e \once \override DynamicText #'extra-offset = #'(-3.25 . 3.8)
			e,_\sf e' |
		fs \once \override DynamicText #'extra-offset = #'(-3.25 . 2.8)
			b,_\sf fs'
		e e, \times 2/3{b'8 a' ds,} 
	
		e,4 <e' gs,> <gs b,> |
		<gs e>2 \times 2/3{cs,8 ~ cs b} |
		a4 fs8 a b4 |
		e e,	
	
}

staffClassicalGuitar = \new Staff  {
		\time 3/4
		\key e \major
		\set Staff.connectArpeggios = ##t
		\set Staff.midiInstrument="acoustic guitar (nylon)"
		<<
			\new Voice = A { \voiceOne  \upper }			
			\new Voice = C { \voiceFour  \lower }
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
%%	\unfoldRepeats
	\staffClassicalGuitar
	\midi {
		\context {
			\Score
			tempoWholesPerMinute = #(ly:make-moment 110 4)
		}
		\context {
			\Voice
			\remove "Dynamic_performer"
	    }
    }
}
