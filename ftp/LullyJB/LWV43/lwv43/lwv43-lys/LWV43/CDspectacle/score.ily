
\score {
  \new StaffGroupNoBar <<
    \newStaffWithLyrics << 
      \scoreInit \global \voixDessus \includeNotes "voix-dessus"
    >>  \includeLyrics "paroles1"
    \newStaffWithLyrics << 
      \global \voixHauteContre \includeNotes "voix-haute-contre"
    >>  \includeLyrics "paroles1"
    \newStaffWithLyrics << 
      \global \voixTaille \includeNotes "voix-taille"
    >>  \includeLyrics "paroles1"
    \newStaffWithLyrics << 
      \global \basse \includeNotes "voix-basse"
    >>  \includeLyrics "paroles1"
    \new StaffGroupNoBracket <<
      \newStaff << \global \dessus \includeNotes #"dessus"  >>
      \newStaff << \global \hauteContre \includeNotes #"haute-contre" >>
      \newStaff << \global \taille \includeNotes #"taille" >>
      \newStaff << \global \quinte \includeNotes #"quinte" >>
      \newStaff << \global \basse \includeNotes #"basse1" >>
      \newStaff << \global \basse \includeNotes #"basse2" >>
    >>
  >>
  \header {
    entree = "SIXIÈME ENTRÉE"
    breakbefore = #(break-before?)
  }
  \layout { #(define tweak-key (*current-piece*)) }
  \midi { \tempo 4 = 144 }
}
