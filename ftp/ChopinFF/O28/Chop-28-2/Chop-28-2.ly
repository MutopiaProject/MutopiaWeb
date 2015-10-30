%% Chopin, op-28-2 first shot.
%% Based on the piano-staff layout from "The Néréides" example.
%% There may be some things which I do not know why are here ...
%% especially in the score section.


%% #(ly:set-option 'old-relative)
\version "2.16.1"

\header {
    composer = "Chopin"
    title = "Prélude"
    subtitle = "No 2."
    enteredby = "Donald Axel"
    piece = ""
    copyright = "Creative Commons Attribution-ShareAlike 3.0"

  % mutopia headers.
  mutopiatitle = "Prelude: Op. 28, No. 2"
  mutopiacomposer = "ChopinFF"
  mutopiaopus = "Op. 28"
  mutopiainstrument = "Piano"
  date = "c. 1837"
  source = "Edition Peters"
  style = "Romantic"
  
  maintainer = "Donald Axel"
  maintainerEmail = "dax2@tele2adsl.dk"

 footer = "Mutopia-2013/03/23-494"
 tagline = \markup { \override #'(box-padding . 1.0) \override #'(baseline-skip . 2.7) \box \center-column { \small \line { Sheet music from \with-url #"http://www.MutopiaProject.org" \line { \concat { \teeny www. \normalsize MutopiaProject \teeny .org } \hspace #0.5 } • \hspace #0.5 \italic Free to download, with the \italic freedom to distribute, modify and perform. } \line { \small \line { Typeset using \with-url #"http://www.LilyPond.org" \line { \concat { \teeny www. \normalsize LilyPond \teeny .org }} by \concat { \maintainer . } \hspace #0.5 Copyright © 2013. \hspace #0.5 Reference: \footer } } \line { \teeny \line { Licensed under the Creative Commons Attribution-ShareAlike 3.0 (Unported) License, for details \concat { see: \hspace #0.3 \with-url #"http://creativecommons.org/licenses/by-sa/3.0" http://creativecommons.org/licenses/by-sa/3.0 } } } } }
}



treble = \new Voice {
    \key a \minor
    \tempo "Lento"
    \set PianoStaff.connectArpeggios = ##t
    \phrasingSlurUp
    
    %% bar 1-2
    s1*2 |
    
    %% bar 3
    e'2..(                       b8 |
    
    %% bar 4
    d'1)
    
    %% bar 5
    d'4.\(      \acciaccatura fis'16 
                 e'8   d'4.      a8 |
    
    %% bar 6 - 7
    b4      b8. b16     b2~         |  b2\)             r2      |

    %% bar 8 - 9
    r2                  b'4.( fis'8 |  a'1)

    %% bar 10
    a'4.\(    \acciaccatura cis''16 
                 b'8   a'4.     e'8 | 
    %% bar 11
    fis'4    fis'8. fis'16 fis'2~   | fis'1\)

    %% bar 12
    r1

    %% bar 13
    r4       a'2.~\(                |

    %% bar 14
    a'2..                       e'8 |

    %% bar 15
    f'1->\)                         |
    
    %% bar 16
    f'4.\(     \acciaccatura a'16
               g'8     f'4.     c'8 |
    %% bar 17
    d'4     d'8. d'16  d'2~\)       |

    %% bar 18
    d'2                r2           |

    %% bar 19
    d'4.\(  \acciaccatura f'16  e'8   d'4. a8 ~   
    %% bar 20
    <<\new Voice {\voiceOne b4 b8. b16} {\voiceTwo a2}>>

    \clef bass \voiceOne
    <e gis b>4    <dis fis b>4      |

    %% bar 21 - 23
    <e gis b>2\)     
    << { b4.(  c'8  <c e a>1\arpeggio )} \\
    <d e gis>2
    >>
    
    \bar "||"
}

bass = \new Voice {
    \key a \minor
    
    \voiceTwo
    %% bar 1  %% remove sustainOn, only to be used much later
    e,8\sustainOn g    e,     g
    e,                g    e,     g
    %% bar 2
    e,8               g    e,     g
    e,                g    e,     g
    %% bar 3
    \oneVoice
    <e, b,>\(        <g ais,>    <e, b,>     <g g,>
    <e, b,>          <g ais,>    <e, b,>     <g g,>
    %% bar 4
    <d, b,>          <g ais,>    <d, b,>     <g g,>
    <d, b,>          <g ais,>    <d, b,>     <g g,>\)
    %% bar 5
    <d, a,>\(      <g! gis,>     <d, a,>     <g g,>
    <d, a,>        <fis gis,!>   <d, a,>     <fis fis,>
    %% bar 6
    <g,, g,>       <e g>         <g, d>      <es g>
    <g, d>         <e g>         <g, d>      <es g>
    %% bar 7
    <g, d>         <e g>         <g, d>      <es g>
    <g, d>         <e g>         <g, d>      <e  g>\)

    %% bar 8
    <b, fis>\(     <d' eis>      <b  fis>    <d'  d>
    <b, fis>       <d' eis>      <b  fis>    <d'  d>
    %% bar 9
    <a, fis>       <d' eis>      <a, fis>    <d'  d>
    <a, fis>       <d' eis>      <a, fis>    <d'  d>\)
    %% bar 10
    <a, e>\(       <d' dis>      <a, e>      <d'  d>
    <a, e>         <cis' dis>    <a, e>      <cis' cis>
    %% bar 11
    <a, dis>       <cis' cisis>  <a, dis>    <cis' cis>
    <a, dis>       <cis' cisis>  <a, dis>    <cis' cis>
    %% bar 12
    <a, dis>       <cis' cisis>  <a, dis>    <cis' cis>
    <a, dis>       <c'   cisis>  <a, dis>    <c'   c  >\)
    %% bar 13
    <fis, dis>\(   <a   cisis>   <fis, dis>  <a    c  >
    <fis, dis>     <a   cisis>   <fis, dis>  <a    c  >

    | %% bar 14
    <fis, dis>     <a   cisis>   <fis, dis>  <a    c  >
    <f,   dis>     <a   cisis>   <f,   dis>  <a    c  >\)
    | %% bar 15
    <e,   c!>\(    <a   b,>      <e,   c>    <a    a,>
    <e,   c>       <a   b,>      <e,   c>    <a    a,>
    | %% bar 16
    <e,   c>       <a   b,>      <e,   c>    <a    a,>
    <e,   c>       <a   b,>      <e,   c>    <a    a,>\)
    | %% bar 17
    r1
    | %% bar 18
    r2 
    <e,   c>8\(    <f   b,>      <e,   c>    <f    a,>

    | %% bar 19
    <e,   c>       <f   b,>      <e,   c>    <f    a,>\)
    r2
    | %% bar 20
    r1

    | %% bar 21
    r2
    e,4   <b,, b,>  
    
    | %% bar 22
    <e, b,>2    <e,, e,>2
    <a,, a,>1\arpeggio 
}

bassTwo = \new Voice {
    \voiceOne
    %% bar 1
    b,8(          ais,     b,     g,
    b,8           ais,     b,     g,
    %% bar 2
    b,8           ais,     b,     g,
    b,8           ais,     b,     g,)
}

middleDynamics = {
    s4\p s2. |
    s1*11
    %% bar 13 
    s2
    \crescTextCresc
    \set decrescendoText = \markup { \italic "dimin" }
    \set decrescendoSpanner = #'text
    s2 \>
    s1  s1  s1\!
    s1^\markup { "slentando" }
    s1*3
    %% bar 21
    s2
    s2^\markup { "sostenuto" }
    %% bar 22
    s1
    s1
}

\paper {
    ragged-last-bottom = ##f
}

theScore = \score{
    \context PianoStaff <<
        \context Staff = "treble" <<
            \clef treble
	    \treble
        >>
	\new Dynamics <<
	    \middleDynamics
	>>
        \context Staff = "bass" <<
	    \clef bass
	    \bass
	    \bassTwo
        >>
    >>
    \layout {
        \context {
            \PianoStaff
            \override StaffGrouper #'staff-staff-spacing #'basic-distance = #15
        }
    }
    
    
  \midi {
    \tempo 4 = 72
    }


}
			   
\book{
    \score { \theScore }
}

%%% Local variables:
%%% LilyPond-indent-level:4
%%% End:
