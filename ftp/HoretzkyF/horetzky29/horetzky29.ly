% Entered on Nov 8, 2007
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
	title = "Nº. 29. Scotch Air. “Donald.”"
	subtitle = ""
	subsubtitle = "60 National Airs of Different Nations"
	composer = \markup{\column \right-align 
	{\line {Felix Horetzky} 1796-1870}}
	meter = ""
% MUTOPIA
 mutopiatitle = "Nº. 29. Scotch Air. “Donald.”"
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
 footer = "Mutopia-2007/11/17-1119"
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
sdu = \once \override Stem #'direction = #UP
sdd = \once \override Stem #'direction = #DOWN

%% End shortcuts


%%%%%%%%%%
%% Reminders
%
%    \once \override DynamicText #'extra-offset = #'(-3.75 . 5.5)
%    \once \override TextScript #'extra-offset = #'( 0.8 . -2.3 )
%    \once \override Stem #'length-fraction = #0.8
%    \once \override Beam #'positions = #'(-2.2 . -3.0)
%
%%%%%%%%%%

upper = \relative c''{
	\set Staff.instrumentName=\markup{ \center-align 
	{\smaller\bold "Nº. 29  " \smaller\smaller\italic "ANDANTE. " 
	\tiny\smaller\italic "con molta esp: "}}
	\partial 4*1 g'8. a16 |
%% segno
	b4. \times 2/3 {a16 g fs} \grace a16 g4. d8 |
	fs[ e] d[ c] c16 b8. r8 d |
	b16[ d8.] g8[ a] b4 a8. g16 |
	<g d>4 <a fs d> r g8 a |
	b4. \times 2/3 {a16 g fs}\I g4 r8 <d g,>16 g |
	fs8[ e] d[ c] \grace d16 c b8. r8 d |
	b16 d8. g8 b d16 b8. a8. b16 |
	g4\fermata \grace{\slurDown a16[( g fs])}
		\times 2/3{g8 a b} <a c,>8 <g b,>  \bar "||"
		
	d'4 |
	<d b> <c a>8 <b g> <b g >16 <a fs>8. 
		<<{\times 2/3{a8 b c}}\\{fs,4}>> |
	<b g>8[ <g e>] e[ c'] b8. c32 b  <a fs d>8 b \noBeam |
	c4 g8 <b gs> b16 a c b a8 <g e bf> |
	<g d b>2\fermata \grace{fs32[ g a]} <fs d>4\fermata g8. a16 |
	
	b4. \times 2/3 {a16 g fs} \grace a16 g4. d8 |
	fs[ e] d[ c] c16 b8. r8 d |
	b16[ d8.] g8[ a] b4 a8. g16 |
	<g d>4 <a fs d> r g8 a |
	b4. \times 2/3 {a16 g fs}\I g4 r8 <d g,>16 g |
	fs8[ e] d[ c] \grace d16 c b8. r8 d |
	b16 d8. g8 b d16 b8. a8. b16 |
	g4\fermata \grace{\slurDown a16[( g fs])}
		\times 2/3{g8 a b} <a c,>8 <g b,>

}
 



lower = \relative c' { 
	\override Staff.NoteCollision 
	#'merge-differently-headed = ##t
	\set fingeringOrientations = #'(left)
	\partial 4*1 r4 |
%% segno
	<b' g>4 <c a> <d b> <b g> |
	<g c,> <fs d> g4. g,8 |
	g'4. <d' fs,>8 <d g,>4 <cs e,> |
	r d, <fs' d>8 <e c> <d b> <c a> |
	<b g>4 <c d,> <<{
		\once \override Beam #'positions = #'(1.6 . 1.0)b8[ g]}
		\\{e4}>> <g b,>4 |
	<g c,> <fs d> <g e> <fs d> |
	g <b g> <b d,> <c d,> |
	<b g>_\fermata r d,8 g
	
	r4 |
	\once \override DynamicText #'extra-offset = #'(-2.2 . 1.0)
	d2 d4 ds |
	e <c'c,>8 <e a,,>  <g d d,>4 d,8 r |
	r e'[ ef d] <e c a,>4. 
	\once \override DynamicText #'extra-offset = #'(-2.75 . 1.5) cs,8_\sf |
	d2 <a' d,>4 r |
	
	<b g>4 <c a> <d b> <b g> |
	<g c,> <fs d> g4. g,8 |
	g'4. <d' fs,>8 <d g,>4 <cs e,> |
	r d, <fs' d>8 <e c> <d b> <c a> |
	<b g>4 <c d,> <<{
		\once \override Beam #'positions = #'(1.6 . 1.0)b8[ g]}
		\\{e4}>> <g b,>4 |
	<g c,> <fs d> <g e> <fs d> |
	g <b g> <b d,> <c d,> |
	<b g>_\fermata r d,8 g
}

staffClassicalGuitar = \new Staff  {
		\time 4/4
		\key g \major
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
			tempoWholesPerMinute = #(ly:make-moment 90 4)
		}
		\context {
			\Voice
			\remove "Dynamic_performer"
	    }
    }
}
