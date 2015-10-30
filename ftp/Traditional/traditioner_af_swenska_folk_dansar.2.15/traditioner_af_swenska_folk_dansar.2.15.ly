

\header {
    title = "Traditioner af Swenska Folk-Dansar"
    opus = \markup {
         \column  {
          \right-align  "2nd part, nr 15"
   \right-align "polska from Västergötland, Sweden" 
}
 } 
  source = "Traditioner af Swenska Folk-Dansar, 2nd part, 1814"



    enteredby = "Erik Sjölund"
				% mutopia headers.

    mutopiatitle = "Traditioner af Swenska Folk-Dansar, 2nd part, nr 15"

    mutopiacomposer = "Traditional"
    mutopiainstrument = "Piano"
    style = "Folk"
    copyright = "Creative Commons Attribution 2.5"
    maintainer = "Erik Sjölund"
    maintainerEmail = "erik.sjolund@gmail.com"




    lastupdated = "2006/November/25"
 footer = "Mutopia-2006/12/01-832"
 tagline = \markup { \override #'(box-padding . 1.0) \override #'(baseline-skip . 2.7) \box \center-align { \small \line { Sheet music from \with-url #"http://www.MutopiaProject.org" \line { \teeny www. \hspace #-1.0 MutopiaProject \hspace #-1.0 \teeny .org \hspace #0.5 } • \hspace #0.5 \italic Free to download, with the \italic freedom to distribute, modify and perform. } \line { \small \line { Typeset using \with-url #"http://www.LilyPond.org" \line { \teeny www. \hspace #-1.0 LilyPond \hspace #-1.0 \teeny .org } by \maintainer \hspace #-1.0 . \hspace #0.5 Copyright © 2006. \hspace #0.5 Reference: \footer } } \line { \teeny \line { Licensed under the Creative Commons Attribution 2.5 License, for details see: \hspace #-0.5 \with-url #"http://creativecommons.org/licenses/by/2.5" http://creativecommons.org/licenses/by/2.5 } } } }
  }




     \version "2.8.5"









global={
  \key d \minor
  \time 3/4
}
    
upper = {
  \global
  \repeat volta 2 
{	d'8.( f'16) a'4 cis'' |
	e''8.( f''16) d''8 d'' c'' a' |
	a' a' f'4 a'8 g' |
	e'8. f'16 d'2 |

  }
  \repeat volta 2 {
	f'8 f' a' a' c''8. a'16 |
	<< { g'8 g'     \grace  a'16  g'8 f'16 g' a'4 } \\ { e'8 e'8 e'4 f'4 } >>  |
	f'8 f' a' a' c''8. a'16 |
	<< { g'8 g'     \grace  a'16  g'8 f'16 g' a'4 } \\ { e'8 e'8 e'4 f'4 } >>  |




	f'8. a'16 g'4 a'8. g'16 |
	e'8.( f'16) d'4.  << { d''8 } \\ {  a'8 } >> |

<< { 	cis''([ d'')] a'([ f')] a'([ g')] } \\ { g'8[ a'8] e'8[ f'8] d'8[ e'8] } >> |
<< { 	e' \staccatissimo  e'16( f') d'4 } \\ {  cis'4 d'4 } >> r8 << { d''8 } \\  { a'8 } >>  
<< { 	cis''([ d'')] a'([ f')] a'([ g')] } \\ { g'8[ a'8] e'8[ f'8] d'8[ e'8] } >> |

<< { 	e' \staccatissimo  e'16( f') d'2 } \\ {  cis'4 d'2 } >> 
  
  }
}

lower = {
  \global \clef bass
  \repeat volta 2 
{	f8 a f a <e g> a |
	<cis g> a <d f> a <a, e> a |
	f a d a cis e |
	a a, d4 d, |

  }
  \repeat volta 2 {


	<f a>8 c' <f a> c' <f a> c' |
	c g e c f f, |

	<f a>8 c' <f a> c' <f a> c' |
	c g e c f f, |


	a f e d cis e |
	a a, d4 d,8\noBeam f' |


	e'( f') cis'( d') f( g)    |
	a a, d4 d,8\noBeam f |
      e8([ f8)] cis([ d)] f,([ g,)] 
 a,8 a,8 d4 d,4

  }
}
    
dynamics = { 
  \repeat volta 2 { s2.*4 }
  \repeat volta 2 { s2. s2 _\markup { \small \transparent "c"  \null  }    s4  s2.*3 s2 s8 s8 \p s2. s2  s8    s8 \f s2.*2 }
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
 \tempo 4=70    
  }
}






  



