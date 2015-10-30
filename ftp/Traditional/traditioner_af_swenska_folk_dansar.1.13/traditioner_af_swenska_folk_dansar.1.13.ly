

\header {
    title = "Traditioner af Swenska Folk-Dansar"
    opus = \markup {
         \column  {
          \right-align  "1st part, nr 13"
   \right-align "polska from Södermanland, Sweden" 
}
 } 
  source = "Traditioner af Swenska Folk-Dansar, 1st part, 1814"



    enteredby = "Erik Sjölund"
				% mutopia headers.

    mutopiatitle = "Traditioner af Swenska Folk-Dansar, 1st part, nr 13"

    mutopiacomposer = "Traditional"
    mutopiainstrument = "Piano"
    style = "Folk"
    copyright = "Creative Commons Attribution 2.5"
    maintainer = "Erik Sjölund"
    maintainerEmail = "erik.sjolund@gmail.com"




    lastupdated = "2006/November/25"
 footer = "Mutopia-2006/12/01-819"
 tagline = \markup { \override #'(box-padding . 1.0) \override #'(baseline-skip . 2.7) \box \center-align { \small \line { Sheet music from \with-url #"http://www.MutopiaProject.org" \line { \teeny www. \hspace #-1.0 MutopiaProject \hspace #-1.0 \teeny .org \hspace #0.5 } • \hspace #0.5 \italic Free to download, with the \italic freedom to distribute, modify and perform. } \line { \small \line { Typeset using \with-url #"http://www.LilyPond.org" \line { \teeny www. \hspace #-1.0 LilyPond \hspace #-1.0 \teeny .org } by \maintainer \hspace #-1.0 . \hspace #0.5 Copyright © 2006. \hspace #0.5 Reference: \footer } } \line { \teeny \line { Licensed under the Creative Commons Attribution 2.5 License, for details see: \hspace #-0.5 \with-url #"http://creativecommons.org/licenses/by/2.5" http://creativecommons.org/licenses/by/2.5 } } } }
  }




     \version "2.8.5"









global={
  \key g \major
  \time 3/4
}
    
upper =  {
  \global
  \repeat volta 2 {
    << { g'8 a'16 b' c''4 b' } \\ { d'2 d'4 } >> |
    << { a'8. g'16 fis'8 e' fis' d' } \\ { e'4 d'2 } >> |
    << { d''8 d''  e''4 d'' } \\ { g'8 g' g'4 g' }  >> |
    << {  c''8 c'' b'4 } \\ { g'8 fis'  g'4   } >> r4 |
  }
  \repeat volta 2 {
    << { d''8 (  e''16 d'' ) c''8  c''  b'4 } \\ { b'8 c''16 b'  a'8 a' g'4 } >>
    << { c''8 (  d''16  c'' )  b'8  b' a'4 } \\ { a'8 b'16 a'  g'8 g' fis'4 } >>  |
    << { g'8. ( fis'16 ) g'8 a' b' c''  } \\ { d'4. d'8 d'8 e'8  } >> |
    << { a'8. (  fis'16 )  g'4  r  } \\ { c'4 ( b4 )  } >>
  }
}
     
lower =  {
  \global \clef bass
  \repeat volta 2 {
   << {  b4  a g } \\ { g4 fis  g }   >> |
   <c c'> <d a>2 |
   b,8 b c'4 b |
   a8 d g4 g, |
  }
  \repeat volta 2 {
    <g, g> <d, d>8 <d, d> <e, e>4 |
    <a,, a,> <cis, cis>8 <cis, cis> <d, d>4 |
    b8. ( a16 ) b8 fis g c |
    d d, g4 g, 
  }
}

dynamics = {
  \repeat volta 2 {
  s2.*4
  }
  \repeat volta 2 {
    s2. \sf  s2. \sf  s4. \sf s8 \< s8 s8 \! s2. 
  }
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






  


