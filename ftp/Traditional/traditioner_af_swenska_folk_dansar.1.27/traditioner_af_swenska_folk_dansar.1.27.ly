

\header {
    title = "Traditioner af Swenska Folk-Dansar"
    opus = \markup {
         \column  {
          \right-align  "1st part, nr 27"
   \right-align "polska from Uppland, Sweden" 
}
 } 
  source = "Traditioner af Swenska Folk-Dansar, 1st part, 1814"



    enteredby = "Erik Sjölund"
				% mutopia headers.

    mutopiatitle = "Traditioner af Swenska Folk-Dansar, 1st part, nr 27"

    mutopiacomposer = "Traditional"
    mutopiainstrument = "Piano"
    style = "Folk"
    copyright = "Creative Commons Attribution 2.5"
    maintainer = "Erik Sjölund"
    maintainerEmail = "erik.sjolund@gmail.com"




    lastupdated = "2006/November/25"
 footer = "Mutopia-2006/12/01-863"
 tagline = \markup { \override #'(box-padding . 1.0) \override #'(baseline-skip . 2.7) \box \center-align { \small \line { Sheet music from \with-url #"http://www.MutopiaProject.org" \line { \teeny www. \hspace #-1.0 MutopiaProject \hspace #-1.0 \teeny .org \hspace #0.5 } • \hspace #0.5 \italic Free to download, with the \italic freedom to distribute, modify and perform. } \line { \small \line { Typeset using \with-url #"http://www.LilyPond.org" \line { \teeny www. \hspace #-1.0 LilyPond \hspace #-1.0 \teeny .org } by \maintainer \hspace #-1.0 . \hspace #0.5 Copyright © 2006. \hspace #0.5 Reference: \footer } } \line { \teeny \line { Licensed under the Creative Commons Attribution 2.5 License, for details see: \hspace #-0.5 \with-url #"http://creativecommons.org/licenses/by/2.5" http://creativecommons.org/licenses/by/2.5 } } } }
  }




     \version "2.8.5"









global={
  \key d \minor
  \time 3/4
}
    
upper = {
  \global
\partial 4 a'4
  \repeat volta 2 
{
	d''8( e'') f''( e'') g''( f'') |
	e''( d'') f''( e'' d'' cis'') |

  }
\alternative { {
	cis''8( d'') d'4 a' |
} {
	cis''8( d'') d'4 e'' |
} }
  \repeat volta 2 
{

	f''8. g''16 a''4 f''8( a'') |
%5
	g''4 \staccatissimo \repeat "tremolo" 4 e''8 |
	a''4 f'' e''8 d'' |
	cis''4 \repeat "tremolo" 4 a'8  |
	d''8( e'') f''( e'') g''( f'') |
	e''( cis'') g''( e'' d'' cis'') |
%10


  }
\alternative { {

	cis''8( d'') d'4 e''4

} {
	cis''8( d'') d'4 s4
} }


}

lower = {
  \global \clef bass
\partial 4 << { f4 } \\ { d4 } >> 
  \repeat volta 2 
{

<< {	f8( g) a( g) bes( a) |
	g( f) a( g f e) } \\ { d2. d2 a,4  } >> 
  }
\alternative { {
	<< { f2 } \\ { d2 } >> << { f4 } \\ { d4 } >>  
} {
	<< { f2 } \\ { d2 } >>   bes4 
} }
  \repeat volta 2 
{

	a8 c' f c' a c' |
%5
	e c' c c' cis bes |
<< {	r gis( a \staccatissimo) a( gis f) |
	e4. } \\ { d2 d4 a,4 } >> e16 f g8 e |
<<	{ f( g) a( g) bes( a) bes2 } \\ { d2. g2 } >> 
	 a4 |
%10


  }
\alternative { {
	<d f>2 bes4 
} {
	<d f>2 s4
} }
}
    
dynamics = { 
\partial 4 s4
  \repeat volta 2 { s2.*2 }
\alternative { {
s2.
} {
s2.
} }
  \repeat volta 2 { s2.*6 }
\alternative { {
s2.
} {
s2.
} }

}
  



\score {
  \new PianoStaff \with{systemStartDelimiter = #'SystemStartBracket } <<
    \new Staff = "upper" \upper
    \new Dynamics = "dynamics" \dynamics
    \new Staff = "lower" <<
      \clef bass
      \lower
    >>
  >>

  \layout {
    \context {
      \type "Engraver_group"
      \name Dynamics
      \alias Voice % So that \cresc works, for example.
      \consists "Output_property_engraver"
%      \override VerticalAxisGroup #'minimum-Y-extent = #'(-1 . 1)
      \consists "Piano_pedal_engraver"
      \consists "Script_engraver"
      \consists "Dynamic_engraver"
      \consists "Text_engraver"
      \override TextScript #'font-size = #2
      \override TextScript #'font-shape = #'italic

      \override DynamicText #'extra-offset = #'(0 . 2.5)
      \override Hairpin #'extra-offset = #'(0 . 2.5)


      \consists "Skip_event_swallow_translator"
      \consists "Axis_group_engraver"
    }
    \context {\Score \remove "Bar_number_engraver"}
    \context {
      \PianoStaff
      \accepts Dynamics
   \override VerticalAlignment #'forced-distance = #7
  \override SpanBar #'transparent = ##t

    }
  }
}

          


mididynamics = { \dynamics } 
midiupper = { \upper }
midilower = { \lower }

          




\score {
  \unfoldRepeats
  \new PianoStaff <<
    \new Staff = "upper" <<  \midiupper  \mididynamics >>
    \new Staff = "lower" <<  \midilower  \mididynamics >>
  >>
  \midi {
    \context {
      \type "Performer_group"
      \name Dynamics
      \consists "Piano_pedal_performer"
    }
    \context {
      \PianoStaff
      \accepts Dynamics
    }
 \tempo 4=100    
  }
}






  



