\header {
   title             = "Duet in G"
   subtitle          = "for two guitars"
   piece             = "Andante"
   opus              = ""
   composer          = "Ferdinando Carulli (1770-1841)"
   
   mutopiainstrument = "Guitar Duet"
   mutopiacomposer   = "CarulliF"
   mutopiatitle      = "Duet in G"
   date              = "19th C."
   style             = "Classical"
   copyright         = "Creative Commons Attribution-ShareAlike 2.5"
   source            = "Manuscript"
   maintainer        = "jeff covey <jeff.covey@pobox.com>"
   lastupdated       = "2006/09/14"
 footer = "Mutopia-2006/09/14-17"
 tagline = \markup { \override #'(box-padding . 1.0) \override #'(baseline-skip . 2.7) \box \center-align { \small \line { Sheet music from \with-url #"http://www.MutopiaProject.org" \line { \teeny www. \hspace #-1.0 MutopiaProject \hspace #-1.0 \teeny .org \hspace #0.5 } • \hspace #0.5 \italic Free to download, with the \italic freedom to distribute, modify and perform. } \line { \small \line { Typeset using \with-url #"http://www.LilyPond.org" \line { \teeny www. \hspace #-1.0 LilyPond \hspace #-1.0 \teeny .org } by \maintainer \hspace #-1.0 . \hspace #0.5 Copyright © 2006. \hspace #0.5 Reference: \footer } } \line { \teeny \line { Licensed under the Creative Commons Attribution-ShareAlike 2.5 License, for details see: \hspace #-0.5 \with-url #"http://creativecommons.org/licenses/by-sa/2.5" http://creativecommons.org/licenses/by-sa/2.5 } } } }
}

\version "2.7.40"

global =  {
   % lilytidy template: guitar
   \transposition c
   \set Staff.midiInstrument = "acoustic guitar (nylon)"
   % lilytidy template end
   \key g \major
   \time 12/8
   \skip 1.*16
   \bar "|."
}

guitarone =  \relative c'' {
   b8[ g d']  c[ a e']  d[ g fis]  g[ fis e]                 | % 1
   < d b >4. < c a > < b g > r4 r8                           | % 2
   a8[ gis b]  a[ c b]  c[ e dis]  e[ c a]                   | % 3
   b[ d cis]  d[ c b] a4. r4 r8                              | % 4
   b8[ g d']  c[ a e']  d[ g fis]  g[ fis e]                 | % 5
   < d b >4. < c a > < b g > r4 r8                           | % 6
   a8[ gis b]  c[ d e]  d[ g d]  c[ b a]                     | % 7
   g[ g' d]  b[ d b] g4. r4 r8                               | % 8
   d'8[ c b]  b[ a gis] gis4 r8 r  e'[ d]                    | % 9
   c[ e d]  b[ d c] a4 r8 r4 r8                              | % 10
   c[ b a]  a[ g fis] fis4 r8 r  d'[ c]                      | % 11
   b[ d c]  a[ c b] g4 r8 r4 r8                              | % 12
   e'4. r4 r8 r  a,[ b]  c[ d e]                             | % 13
   d4. r4 r8 r  g,[ a]  b[ c d]                              | % 14
   e[ fis g]  e[ c a]  g[ g' d]  c[ b a]                     | % 15
   g[ g' d]  b[ d b] g4. r4 r8                               | % 16
}

guitartwo =  \relative c' {
   g4 b'8 a,4 c'8 b,4 d'8  e[ d c]                           | % 1
   < d, b' >4. < dis fis > < e g >  g,8[ a b]                | % 2
   < c e >4 r8 < c e >4 r8 < c e >4 r8 < c e >4 < cis e >8   | % 3
   <  d[ g >8 b' ais]  b[ a g]  fis[ e d]  c[ b a]           | % 4
   g4 b'8 a,4 c'8 b,4 d'8 < c,  e'[ > d' c]                  | % 5
   < d, b' >4. < dis fis > < e g >  g,8[ a b]                | % 6
   < c e >4 r8 < c e a >4 r8 < d g b >4 r8 < d  a'[ > g fis] | % 7
   < g, g' >4. < g b d g > < g b d g > r4 r8                 | % 8
   < e' gis b >4. r4 r8 r  e[ fis]  gis[ a b]                | % 9
   < a, a' >4 r8 < e gis' >4 r8  a[ a' g]  fis[ g e]         | % 10
   < d fis a >4 r8 r4 r8 r8  d[ e]  fis[ g a]                | % 11
   g4 r8 < d fis >4.  e,8[ g' a]  b[ c d]                    | % 12
   c,8[ c' b]  c[ a g] fis2.                                 | % 13
   b,8[ b' ais]  b[ g fis] e2.                               | % 14
   < c  c'[ >8 d' e] c4 c,8 < d g >4 b'8 < d,  a'[ > g fis]  | % 15
   < g, g' >4. < g b d g > < g b d g > r4 r8                 | % 16
}



\score {
   \context StaffGroup = "duet" <<
      \context Staff = "guitarone" << \global \guitarone >>
      \context Staff = "guitartwo" << \global \guitartwo >>
   >>
   
   \layout { }
   \midi { \tempo 8=228 }
}
