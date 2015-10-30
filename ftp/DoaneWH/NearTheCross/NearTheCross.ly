\version "2.4.1"

#(set-global-staff-size 22)

global = 
{
	\key f \major
	\time 6/4
	\set Staff.autoBeaming = ##f
}

\paper
{
	%topmargin = 0.7\cm
	%bottommargin = 1.2\cm
	%leftmargin = 1.5\cm
	%linewidth = 18.0\cm
}

\header
{
	title = "Near the Cross"
	poet = "Frances Jane (Fanny) Crosby, 1869"
	composer = "William Howard Doane"
	meter = "76.76. and Refrain"
	mutopiatitle = "Near the Cross"
	mutopiacomposer = "DoaneWH"
	mutopiapoet = "France Jane (Fanny) Crosby"
	mutopiainstrument = "Voice and Piano"
	date = "1869"
	source = "CyberHymnal"
	style = "Hymn"
	copyright = "Public Domain"
	maintainer = "Jefferson dos Santos Felix"
	maintainerEmail = "jsfelix@gmail.com"
	lastupdated = "2004/Nov/11"

	footer = "Mutopia-2004/11/11-495"
	tagline = "\\raisebox{10mm}{\\parbox{188mm}{\\quad\\small\\noindent " + \footer + " \\hspace{\\stretch{1}} This music is part of the Mutopia project: \\hspace{\\stretch{1}} \\texttt{http://www.MutopiaProject.org/}\\\\ \\makebox[188mm][c]{It has been typeset and placed in the public domain by " + \maintainer + ".} \\makebox[188mm][c]{Unrestricted modification and redistribution is permitted and encouraged---copy this music and share it!}}}"
}

setLyricsExtent =     \set Lyrics.minimumVerticalExtent        = #'(-1.0 . 1.2)
setLyricsExtentRef =  \override Lyrics #'minimumVerticalExtent = #'(-1.3 . 1.4)
setStaffExtentA =     \set Staff.minimumVerticalExtent         = #'(-6 . 1)
setStaffExtentB =     \set Staff.minimumVerticalExtent         = #'(-1 . 5)


refText = \markup { \bold \italic { "" \raise #1.2 "Refrain" } }

soprano = \relative c''
{
	%% SOPRANO NOTES %%
	a2 bes4 a2 g4 f2 d4 d2. c2 f4 f2 a4 a2. g \break
	a2 bes4 a2 g4 f2 d4 d2. c2 f4 f2 e4 g2. f \bar "||" \break
	a2^\refText c4 c2. bes2 d4 d2. c2 d4 c2 a4 a2. g \break
	a2 bes4 a2 g4 f2 d4 d2. c2 f4 f2 e4 g2. f \bar "|."
}

alto = \relative c'
{
	%% ALTO NOTES %%
	f2 f4 f2 e4 d2 <<{s4 s2.}\\{d4 d2.}>> a2 c4 c2 f4 f2. e
	f2 f4 f2 e4 d2 <<s4\\d>> bes2. a2 c4 c2 c4 e2. <<s\\f>>
	f2 f4 f2. f2 f4 f2. f2 f4 f2 f4 f2. e
	c2 d4 c2 cis4 d2 <<s4\\d>> bes2. a2 c4 c2 c4 e2. <<s\\f>>
}

tenor = \relative c'
{
	%% TENOR NOTES %%
	c2 d4 c2 bes4 a2 bes4 bes2. a2 a4 a2 c4 c2. c
	c2 d4 c2 bes4 a2 bes4 f2. f2 a4 a2 g4 bes2. a
	c2 a4 a2. d2 s4 s2. a2 bes4 a2 c4 c2. c
	a2 s4 a2 a4 a2 bes4 f2. f2 a4 a2 g4 bes2. a
}

bass = \relative c
{
	%% BASS NOTES %%
	f2 f4 f2 c4 d2 bes4 bes2. f'2 f4 f2 f4 c2. c
	f2 f4 f2 c4 d2 bes4 bes2. c2 c4 c2 c4 c2. f
	f2 f4 f2. bes2 <<{bes4 bes2.}\\{bes4 bes2.}>> f2 f4 f2 f4 c2. c
	f2 <<g4\\f>> f2 e4 d2 bes4 bes2. c2 c4 c2 c4 c2. f
}

verseOne = \lyrics
{
	\setLyricsExtent
	\set stanza = "1. "
	Je -- sus, keep me near the cross,
	There a pre -- cious fon -- tain
	Free to all, a heal -- ing stream
	Flows from Cal -- vary's moun -- tain.

		\setLyricsExtentRef
		% Refrain
		In the cross, in the cross,
		Be my glo -- ry e -- ver;
		Till my rap -- tured soul shall find
		Rest be -- yond the ri -- ver.
}

verseTwo = \lyrics
{
	\setLyricsExtent
	\set stanza = "2. "
	Near the cross, a trem -- bling soul,
	Love and mer -- cy found me;
	There the bright and morn -- ing star
	Sheds its beams a -- round me.
}

verseThree = \lyrics
{
	\setLyricsExtent
	\set stanza = "3. "
	Near the cross! O Lamb of God,
	Bring its scenes be -- fore me;
	Help me walk from day to day,
	With its sha -- dows o'er me.
}

verseFour = \lyrics
{
	\setLyricsExtent
	\set stanza = "4. "
	Near the cross I'll watch and wait
	Hop -- ing, trus -- ting e -- ver,
	Till I reach the gold -- en strand,
	Just be -- yond the ri -- ver.
}

\score
{
	<<
		\context Voice = SA 
		<<
			\override Score.BarNumber #'break-visibility = #all-invisible
			\setStaffExtentA
			\stemUp
			\global
			\soprano
			\alto
		>>
		\context Lyrics = sopranoLyrics { s1 }
		\lyricsto "SA" \context Lyrics = sopranoLyrics 
		<<
			\verseOne
			\verseTwo
			\verseThree
			\verseFour
		>>
		\context Voice = TB 
		<<
			\setStaffExtentB
			\clef bass
			\stemDown
			\global
			\tenor
			\bass
		>>
	>>
	
	\layout { indent = 0.0\cm }
	\midi { \tempo 4=112 }
} 
