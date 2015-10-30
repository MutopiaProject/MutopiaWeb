% Entered on Nov 11, 2007
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
	title = "Nº. 49. March by Rossini."
	subtitle = ""
	subsubtitle = "60 National Airs of Different Nations"
	composer = \markup{\column \right-align 
	{\line {Felix Horetzky} 1796-1870}}
	meter = ""
% MUTOPIA
 mutopiatitle = "Nº. 49. March by Rossini."
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
 footer = "Mutopia-2007/11/17-1146"
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
rit = \markup{\smaller\italic"ritard:"}
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
	{\smaller\bold "Nº. 49.  " \smaller\smaller\italic "MAESTOSO.  " 
	}}
	\partial 16*5 <e cs>16[ <ds bs>8. <d b>16] |
	cs4 cs8. cs16 cs4 b |
	<b d,>8. <a cs,>16 a8. a16 a8.[ e16 a8. cs16] |
	<e cs>4 a, <a' fs>4.\trill <gs e>16 <fs d>16 |
	<e cs>2 ~ <e cs>8[ <ds bs> <d b> <cs a>] |
	b4 b8.^\dol b16 b4 <cs as> |
	<d b> f2-> e8. d16 |
	<cs a>8.[ <a' cs,>16 <gs b,>8. <fs a,>16] <e gs,>4 <ds fs,> |
	e <e' gs, e> r8. \bar "||"
	
	e,16[ e8. e16] |
	e8.[ fs16 gs8. a16] <<{b4. cs8}\\
		{\override Voice.NoteColumn  #'force-hshift = #0.4 d,2}>> |
	a'4 ~ \times 4/5 {\slurDown a16[ gs_. b( a)_. fs]}\slurUp 
		<e cs>4 cs'8. b16 ( |
	a8.[) gs16 fs8. es16(] fs8.)[ gs16 a8. b16] |
	cs4 cs, r8. e16[ ds8. d16] |
	cs4 cs8. cs16 <b gs>4 cs |
	d <fs d> ~ <fs d>8.[ <fs d>16 <e cs>8. <d b>16] |
	<cs a>8.[ <e cs>16 <d b>8. <cs a>16] <b a>4 <e gs,> |
	cs4 a8 r8. r16 <e' gs,>8 <ds a>8. <d b>16 |
	cs4 cs8. cs16 <b gs>4 cs |
	d <fs d> ~ <fs d>8.[ <fs d>16 <e cs>8. <d b>16] |
	<cs a>8.[ <e cs>16 <d b>8. <cs a>16] b4 e |
	a, <a' e cs a> r r8.
	
}


lower = \relative c' { 
	\override Staff.NoteCollision 
	#'merge-differently-headed = ##t
	\set fingeringOrientations = #'(left)
	\partial 16*5 e16[ fs8. gs16] |
	a4 <e a,> <e a,>  r |
	a, <cs a> <cs a> r |
	a' \once \override DynamicText #'extra-offset = #'(-3.0 . 2.5) 
		<cs, a> d4. r8 |
	a8.[ gs16 a8. gs16] a4 r |
	gs' <gs e> <gs d> cs, |
	b <c' a,> <b gs,> <b gs e,> |
	a,2 b4 b |
	<gs' e> \once \override DynamicText #'extra-offset = #'(-3.0 . 2.5)
		e,_\f r8. 
		
	r16 r4 |
	\once \override DynamicText #'extra-offset = #'(-2.5 . 0.0)
	<d'' gs,>4_\p <d e,,> gs, e, |
	<cs'' a> a, a'
	\once \override DynamicText #'extra-offset = #'(-2.5 . 0.5)
		cs8._\f b16( |
	a8.)[ gs16 fs8. es16]( fs8.)[ gs16 a8. b16] |
	cs4 cs, r8. <gs'e>16[ <a fs>8. <b gs>16] |
	a4 <a e a,>_\< <d, a> <g e a,>\! |
	\once \override DynamicText #'extra-offset = #'(-3.0 . 2.5)
	<a fs d>_\f d,8. cs16 b4 cs8. d16 |
	e8.[ a,16 b8. cs16] d4 e |
	a <cs, a>8 r8. r16 e,8 fs8. gs16 |
	<a' a,>4 <a e a,> <gs d a> <g e a,> |
	<fs d> d8. cs16 b4 cs8. d16 |
	e8.[ a,16 b8. cs16] <a' d,>4 <gs e>8 e, |
	<cs' a>4 \once \override DynamicText #'extra-offset = #'(-3.0 . 2.5)
		a_\ff r4 r8
	
	
}

staffClassicalGuitar = \new Staff  {
		\time 4/4
		\key a \major
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
	\unfoldRepeats
	\staffClassicalGuitar
	\midi {
		\context {
			\Score
			tempoWholesPerMinute = #(ly:make-moment 72 4)
		}
		\context {
			\Voice
			\remove "Dynamic_performer"
	    }
    }
}
