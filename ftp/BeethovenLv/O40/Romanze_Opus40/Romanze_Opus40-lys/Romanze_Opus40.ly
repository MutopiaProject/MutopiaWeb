\version "2.10.3"

\include "flauto.ly"
\include "oboi.ly"
\include "fagotti.ly"
\include "cornig.ly"
\include "violinoprincipale.ly"
\include "violinoone.ly"
\include "violinotwo.ly"
\include "viola.ly"
\include "violoncello.ly"

\header {
  title = "Romanze - Opus 40"
  composer = "Ludwig van Beethoven"
  mutopiatitle = "Romanze - Opus 40"
  mutopiacomposer = "BeethovenLv"
  mutopiainstrument = "Violin, Orchestra"
  mutopiaopus = "Op. 40"
  date = "1803"
  source = "Breitkopf and Hartel"
  style = "Classical"
  copyright = "Public Domain"
  maintainer = "Stelios Samelis"
  lastupdated = "2007/March/28"
  version = "2.10.3"
 footer = "Mutopia-2007/12/29-944"
 tagline = \markup { \override #'(box-padding . 1.0) \override #'(baseline-skip . 2.7) \box \center-align { \small \line { Sheet music from \with-url #"http://www.MutopiaProject.org" \line { \teeny www. \hspace #-1.0 MutopiaProject \hspace #-1.0 \teeny .org \hspace #0.5 } • \hspace #0.5 \italic Free to download, with the \italic freedom to distribute, modify and perform. } \line { \small \line { Typeset using \with-url #"http://www.LilyPond.org" \line { \teeny www. \hspace #-1.0 LilyPond \hspace #-1.0 \teeny .org } by \maintainer \hspace #-1.0 . \hspace #0.5 Reference: \footer } } \line { \teeny \line { This sheet music has been placed in the public domain by the typesetter, for details see: \hspace #-0.5 \with-url #"http://creativecommons.org/licenses/publicdomain" http://creativecommons.org/licenses/publicdomain } } } }
}


\score {

 \new StaffGroup {
 <<

 \context Staff = "one" {
 \flauto
 }

 \context Staff = "two" {
 \oboi
 }

 \context Staff = "three" {
 \fagotti
 }

 \context Staff = "four" {
 \transposition g'
 \cornig
 }

 \context Staff = "five" {
 \violinoprincipale
 }

 \context Staff = "six" {
 \violinoone
 }

 \context Staff = "seven" {
 \violinotwo
 }

 \context Staff = "eight" {
 \viola
 }

 \context Staff = "nine" {
 \violoncello
 }

 >>
 }

 \layout {
 \context { \Staff
    \override VerticalAxisGroup #'minimum-Y-extent = #'(-6.5 . 6.5)
    }
 }

 \midi { }

}

 \paper {
 after-title-space = 2\cm
 bottom-margin = 1\cm
 left-margin = 1.5\cm
 paper-width = 22\cm
 }
