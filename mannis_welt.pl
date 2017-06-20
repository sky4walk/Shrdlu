/*
  Kloetzchenwelt 18.12.2000
  Teil: Objekte der Kloetzchenwelt,
        deren Manipulationsmšglichkeiten
        und Ausgabe einer Situations-Beschreibung.
  Manfred Lippert, mani@mani.de, Dez. 2000
*/

/* fuer unsern LPA Prolog: */
:- dynamic liegt_auf/2.


% -----------------------------------
% **** Fakten und Ausgangs-Situation:

% Farben:

farben_name(rot, Name) :- Name = 'Rot'.
farben_name(gruen, Name) :- Name = 'Gruen'.
farben_name(blau, Name) :- Name = 'Blau'.

% Objekte und deren Attribute (Farbe, Ausgangsposition):

ist_tisch(tisch).      % Definition des Tisches

ist_hand(hand).        % Definition der Hand

ist_wuerfel(w1).       % w1 ist ein Wuerfel ...
hat_farbe(w1, rot).    % ... und ist rot
liegt_auf(w1, tisch).  % roter Wuerfel w1 liegt auf Tisch

ist_wuerfel(w2).
hat_farbe(w2, gruen).
liegt_auf(w2, tisch).  % gruener Wuerfel w2 liegt auf Tisch

ist_wuerfel(w3).
hat_farbe(w3, blau).
liegt_auf(w3, tisch).  % blauer Wuerfel w2 liegt auf Tisch

ist_kugel(k1).
hat_farbe(k1, rot).
liegt_auf(k1, tisch).  % rote Kugel k1 liegt auf Tisch

ist_kugel(k2).
hat_farbe(k2, blau).
liegt_auf(k2, tisch).  % blaue Kugel k2 liegt auf Tisch

ist_pyramide(p1).
hat_farbe(p1, gruen).
liegt_auf(p1, tisch).  % gruene Pyramide p1 liegt auf Tisch

ist_pyramide(p2).
hat_farbe(p2, blau).
liegt_auf(p2, tisch).  % blaue Pyramide p1 liegt auf Tisch

% -----------------------------------------
% **** Regeln (Manipulationen an der Welt):

nimm(X) :-             % Objekt X in die Hand nehmen
  lege_auf(X, hand).

lege_auf(Y) :-         % Objekt aus der Hand auf Y legen
  liegt_auf(X, hand),       % X ist das Objekt in der Hand
  lege_auf(X, Y).           % lege X auf Y

% zu "nimm" und "lege_auf" (intern) benötigte Prädikate:

ist_frei(X) :-         % es befindet sich nichts auf X?
  ist_tisch(X);             % auf Tisch ist immer Platz
  \+(liegt_auf(_, X)).      % frei wenn nix draufliegt

ist_belegbar(X) :-     % X ist grundsaetzlich belegbar?
  ist_tisch(X);             % Tisch kann belegt werden
  ist_hand(X);              % Hand kann belegt werden
  ist_wuerfel(X).           % Wuerfel kann belegt werden

ist_plazierbar(X) :-   % X ist grundsaetzlich plazierbar?
  ist_wuerfel(X);           % Wuerfel ist plazierbar
  ist_kugel(X);             % Kugel ist plazierbar
  ist_pyramide(X).          % Pyramide ist plazierbar

/* primitive Version:

lege_auf(X, Y) :-      % Objekt X auf Objekt Y legen
  ist_plazierbar(X),        % X muss grundsaetzlich plazierbar sein
  ist_belegbar(Y),          % Y muss grundsaetzlich belegbar sein
  ist_frei(X),              % X muss frei sein
  ist_frei(Y),              % Y muss frei sein
  retract(liegt_auf(X, _)), % X wegnehmen, wo es vorher war
  assert(liegt_auf(X, Y)).  % X auf Y legen

  besser:
*/

mache_frei(X) :-       % Objekt "frei machen"
	ist_frei(X);             % ist schon frei
	liegt_auf(Drauf, X),     % andernfalls das daraufliegende Objekt ...
	lege_auf(Drauf, tisch).  % ... auf den Tisch legen (und ggf. rekursiv frei machen)

lege_auf(X, Y) :-
  ist_plazierbar(X),        % X muss grundsaetzlich plazierbar sein
  ist_belegbar(Y),          % Y muss grundsaetzlich belegbar sein
  \+(X == Y),               % X darf nicht Y sein
  mache_frei(X),            % mache X frei
  mache_frei(Y),            % mache Y frei
  write('Ich lege '), write(X), write(' auf '), write(Y), nl,
  retract(liegt_auf(X, _)), % X wegnehmen, wo es vorher war
  assert(liegt_auf(X, Y)).  % X auf Y legen

% --------------------------------------------------------
% **** Textuelle Ausgabe der aktuellen Welt ("Situation"):

ausgabe :-			% Ausgabe der kompletten Situation
  nl,
  liste_von_objekten_auf(tisch, TischListe),
  drucke_objektliste(TischListe, 'Auf dem Tisch liegt:', 1),
  nl,
  liste_von_objekten_auf(hand, HandListe),
  drucke_objektliste(HandListe, 'In der Hand halte ich:', 1),
  nl.

ausgabe(X) :-		% Ausgabe, wo X liegt
  liegt_auf(X, Y),
  write_objekt(X), write(' ('), write(X), write(')'),
  write(' liegt auf '),
  write_objekt(Y), write(' ('), write(Y), write(')'),
  nl,
  ausgabe(Y); true.

% zu "ausgabe" (intern) benötigte Prädikate:

liste_von_objekten_auf(Worauf, Liste) :-
  findall(X, liegt_auf(X, Worauf), Liste).

write_objekt(X) :-
  objekt_name(X, Name), write(Name),
  objekt_farbe(X, Farbe), !, write(' '), write(Farbe);
  !.

objekt_name(Objekt, Name) :-
  ist_wuerfel(Objekt), Name = 'wuerfel';
  ist_kugel(Objekt), Name = 'kugel';
  ist_pyramide(Objekt), Name = 'pyramide';
  ist_tisch(Objekt), Name = 'tisch';
  ist_hand(Objekt), Name = 'hand'.

objekt_farbe(Objekt, Name) :-
  hat_farbe(Objekt, Farbe),
  farben_name(Farbe, Name).

drucke_einrueckung(0).

drucke_einrueckung(Nummer) :-
  write('   '),
  Abstieg is Nummer - 1,
  drucke_einrueckung(Abstieg).

drucke_objekte([], Einrueckung).

drucke_objekte([Kopf|Rest], Einrueckung) :-
  Abstieg is Einrueckung + 1,
  drucke_einrueckung(Einrueckung),
  write(Kopf), write(': '), write_objekt(Kopf),
  liste_von_objekten_auf(Kopf, Liste),
  drucke_objektliste(Liste, ', darauf liegt:', Abstieg),
  drucke_objekte(Rest, Einrueckung).

drucke_objektliste([], Ueberschrift, Einrueckung) :- nl.

drucke_objektliste(Liste, Ueberschrift, Einrueckung) :-
  write(Ueberschrift), nl,
  drucke_objekte(Liste, Einrueckung).
