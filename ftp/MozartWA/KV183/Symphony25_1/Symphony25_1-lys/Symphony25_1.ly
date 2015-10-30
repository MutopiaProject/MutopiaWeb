\version "2.10.3"

\include "oboi.ly"
\include "cornib.ly"
\include "cornig.ly"
\include "violinoone.ly"
\include "violinotwo.ly"
\include "viola.ly"
\include "cellobasso.ly"

\header {
  title = "Symphony No. 25 - KV183 ( 1st Movement )"
  composer =  "Wolfgang Amadeus Mozart"
  mutopiatitle = "Symphony No. 25 - KV183 (1st Movement)"
  mutopiacomposer = "MozartWA"
  mutopiainstrument = "Orchestra: Oboes, Horns, Violins, Viola, 'Cello, Bass"
  mutopiaopus = "KV 183"
  date = "1773"
  source = "Breitkopf and Hartel (1880)"
  style = "Classical"
  copyright = "Public Domain"
  maintainer = "Stelios Samelis"
  lastupdated = "2008/April/05"
  version = "2.10.3"
 footer = "Mutopia-2008/04/16-1380"
 tagline = \markup { \override #'(box-padding . 1.0) \override #'(baseline-skip . 2.7) \box \center-align { \small \line { Sheet music from \with-url #"http://www.MutopiaProject.org" \line { \teeny www. \hspace #-1.0 MutopiaProject \hspace #-1.0 \teeny .org \hspace #0.5 } • \hspace #0.5 \italic Free to download, with the \italic freedom to distribute, modify and perform. } \line { \small \line { Typeset using \with-url #"http://www.LilyPond.org" \line { \teeny www. \hspace #-1.0 LilyPond \hspace #-1.0 \teeny .org } by \maintainer \hspace #-1.0 . \hspace #0.5 Reference: \footer } } \line { \teeny \line { This sheet music has been placed in the public domain by the typesetter, for details see: \hspace #-0.5 \with-url #"http://creativecommons.org/licenses/publicdomain" http://creativecommons.org/licenses/publicdomain } } } }
}


\score {

 \new StaffGroup {
 <<

 \new Staff = "one" {
 \oboi
 }

 \new PianoStaff <<
 \new Staff = "two" {
 \cornib
 }

 \new Staff = "three" {
 \cornig
 }
 >>

 \new PianoStaff <<
 \new Staff = "eight" {
 \violinoone
 }

 \new Staff = "nine" {
 \violinotwo
 }
 >>

 \new Staff = "ten" {
 \viola
 }

 \new Staff = "eleven" {
 \cellobasso
 }

 >>
 }

 \layout { }

}


\score {

 \unfoldRepeats

 \new StaffGroup {
 <<

 \new Staff = "one" {
 \oboi
 }

 \new PianoStaff <<
 \new Staff = "two" {
 \transposition bes
 \cornib
 }

 \new Staff = "three" {
 \transposition g
 \cornig
 }
 >>

 \new PianoStaff <<
 \new Staff = "eight" {
 \violinoone
 }

 \new Staff = "nine" {
 \violinotwo
 }
 >>

 \new Staff = "ten" {
 \viola
 }

 \new Staff = "eleven" {
 \cellobasso
 }

 >>
 }

 \midi { }

}

 \paper {
 after-title-space = 5\cm
 top-margin = 0\cm
 bottom-margin = 0.5\cm
 left-margin = 2.0\cm
 paper-width = 22\cm
 }
