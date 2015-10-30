\header{
	composer = "Musicalisch Handbuch, Hamburg, 1690"
	date = "1690"
	enteredby = "Peter Chubb"
	metre = "88 . 88"
	meter = \metre
	title = "Winchester New"

	arranger = "W. H. Monk (1823--1889)"
	mutopiaarranger=\arranger
	mutopiacomposer="Anonymous"
	maintainer = \enteredby
	mutopiaEmail= "mutopia@chubb.wattle.id.au"
	style = "Hymn"
	copyright="Public Domain"
	lastupdated="2005/Jan/9"

	footer = "Mutopia-2005/01/18-197"
	tagline = "\\raisebox{10mm}{\\parbox{188mm}{\\quad\\small\\noindent " + \footer + " \\hspace{\\stretch{1}} This music is part of the Mutopia project: \\hspace{\\stretch{1}} \\texttt{http://www.MutopiaProject.org/}\\\\ \\makebox[188mm][c]{It has been typeset and placed in the public domain by " + \maintainer + ".} \\makebox[188mm][c]{Unrestricted modification and redistribution is permitted and encouraged---copy this music and share it!}}}"
}

% $Log: WinchesterNew.ly,v $
% Revision 1.4  2005/01/11 08:33:37  peterc
% Discard obsolete american-style chords.
%
% Revision 1.3  2005/01/09 02:19:54  peterc
% Updated to current Lily
%
% Revision 1.2  2002/02/27 03:11:52  peterc
% Added mutopia headers.
%
\version "2.4.0"

global={
	\key bes \major
	\time 4/4
	\partial 4
	\skip 4
	\skip 4*4
	\skip 4*3
	\bar "||"
	\skip 4
	\skip 4*4
	\skip 4*3
	\bar "||"\break
	\skip 4
	\skip 4*4
	\skip 4*3
	\bar "||"
	\skip 4
	\skip 4*4
	\skip 4*3
	\bar "|."
}

sop=\relative c'{
	\partial 4 f4 |
	bes f g g |
	f es d

	d es d c f |
	f e f

	f |
	bes c d bes |
	es d c

	d |
	bes g f bes |
	bes a bes
}
alt=\relative c' {
	d4 |
	f d es es8( d) |
	c4 a bes 

	bes |
	bes bes c d |
	d c c

	f |
	f es d g8 ( f) |
	es4 f f 
	f |
	f es f d |
	g f f
}

tenor=\relative c' {
	bes4 |
	bes bes bes es, |
	f f f

	f |
	g f8 ( g) a4 a |
	bes8 ( a) g4  a 

	a |
	bes g8( a) bes4 bes |
	bes8( a) bes4 a 
	
	bes|
	bes bes bes bes |
	c c d
}

bass=\relative c {
	bes4 |
	d bes es c8( bes) |
	a4 f bes 

	bes |
	g bes f d' |
	bes c f,

	f'8(  es) |
	d4 c bes es8( d) |
	c4 d8( es) f4 

	bes, |
	d es d g |
	es f bes,
}


upper=\context Staff = "upper" <<
	\global
	\context Voice=sop{\voiceOne\sop}
	\context Voice = "alt" {\voiceTwo\alt}
>>
lower =\context Staff = "lower" <<
      {\clef "bass" \global}
	\context Voice = "tenor" {\voiceOne\tenor}
	\context Voice = "bass" {\voiceTwo\bass}
>>




harm=\chordmode {
	bes4 |
	bes/+d bes  es c:m |
	f/a f bes 

	bes |
	es/+g bes f d:m |
	bes c f

	f |
	bes c:m bes es |
	c:m bes/+d f 

	bes  |
	bes/+d es  bes/+d g:m |
	c:m7/+es f bes
}
music= <<
	\context ChordNames\harm
	\upper
	\lower
>>

\score{
	 \music
	\layout{
		indent = 0.0	
		\context {
			\ChordNames
		 \override ChordName #'style = #'american
%		 \override ChordName #'word-space = #1
		}
	}
	\midi {
		\tempo 4=100
	}
}

