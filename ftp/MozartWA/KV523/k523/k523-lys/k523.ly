% -*- mode: LilyPond; coding: utf-8; -*-

\version "2.6.0"
\include "defs.ly"

#(set-global-staff-size 17)

\header {
  title = "Abendempfindung (KV 523)"
  subtitle = "für eine Singstimme mit Begleitung des Pianoforte"
  composer = "Wolfgang Amadeus Mozart (1756-1791)"
  piece = "Andante."
  
  mutopiatitle = "Abendempfindung"
  mutopiacomposer = "MozartWA"
  mutopiaopus = "KV 523"
  mutopiainstrument = "Voice and Piano"
  date = "24th June 1787"
  source = "Breitkopf & Härtel (serie 7 n. 30)"
  style = "Classical"
  copyright = "Public Domain"
  maintainer = "Maurizio Tomasi"
  maintainerEmail = "zio_tom78@hotmail.com"
  maintainerWeb = "http://www.geocities.com/zio_tom78/"
  lastupdated = "2004/Oct/31"
  
  footer = "Mutopia-2005/12/09-501"
  tagline = \markup { \override #'(box-padding . 1.0) \override #'(baseline-skip . 2.7) \box \center-align { \small \line { Sheet music from \with-url #"http://www.MutopiaProject.org" \line { \teeny www. \hspace #-1.0 MutopiaProject \hspace #-1.0 \teeny .org \hspace #0.5 } • \hspace #0.5 \italic Free to download, with the \italic freedom to distribute, modify and perform. } \line { \small \line { Typeset using \with-url #"http://www.LilyPond.org" \line { \teeny www. \hspace #-1.0 LilyPond \hspace #-1.0 \teeny .org } by \maintainer \hspace #-1.0 . \hspace #0.5 Reference: \footer } } \line { \teeny \line { This sheet music has been placed in the public domain by the typesetter, for details see: \hspace #-0.5 \with-url #"http://creativecommons.org/licenses/publicdomain" http://creativecommons.org/licenses/publicdomain } } } }
}

\include "melody.ly"
\include "piano.ly"
\include "lyrics.ly"

\book {
  \score {
    <<
      \new Staff \with
      {
        fontSize = #-2
        \override StaffSymbol #'staff-space = #(magstep -2)
      }
      <<
        \set Staff.minimumVerticalExtent = #'(-2 . 2)
        \context Voice = mel {
          \set Staff.midiInstrument = #"clarinet"
          \set Staff.instrument = \markup { "Singstimme." }

          \autoBeamOff
          \melody
        }
        \lyricsto mel \new Lyrics { \text }
      >>
      
      \new PianoStaff <<
        \set PianoStaff.midiInstrument = #"acoustic grand"
        \set PianoStaff.instrument = \markup { "Pianoforte." }
        
        \context Staff = upper \upper
        \context Dynamics=dynamics \dynamics
        \context Staff = lower <<
          \clef bass
          \lower
        >>
      >>
    >>
    
    \layout {
      \context {
        \type "Engraver_group_engraver"
        \name Dynamics
        \alias Voice % So that \cresc works, for example.
        \consists "Output_property_engraver"
        
        minimumVerticalExtent = #'(-1 . 1)
        pedalSustainStrings = #'("Ped." "*Ped." "*")
        pedalUnaCordaStrings = #'("una corda" "" "tre corde")
        
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
      \context {
        \PianoStaff
        \accepts Dynamics
        \override VerticalAlignment #'forced-distance = #7
      }
      
      \context { \RemoveEmptyStaffContext }
    }  

    \midi
    {
      \context {
        \type "Performer_group_performer"
        \name Dynamics
        \consists "Piano_pedal_performer"
        \consists "Span_dynamic_performer"
        \consists "Dynamic_performer"
      }
      \context {
        \PianoStaff
        \accepts Dynamics
      }
      \tempo 4 = 90 
    }  
  }
}
