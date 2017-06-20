%------------------------------------------------------------------------------
% Interface

do_command(Cmd, Objekt, Farbe, Obj2, Farbe2) :-
	Cmd == 1,
	ist_objekt(Objekt, Farbe, X), 
	nimm_x(X)

	; Cmd == 2,
	ist_objekt(Objekt, Farbe, X),
	ist_objekt(Obj2, Farbe2, Y),
	lege_x_auf_y(X, Y)

	; Cmd == 3,
	ist_objekt(Objekt, Farbe, X),
	ausgabe(X)

	; Cmd == 4,
	ist_objekt(Objekt, Farbe, X),
	ist_objekt(Obj2, Farbe2, Y),
	liegt_x_auf_y(X,Y)

	; Cmd == 0,
	write(' Parser 2: Eingabe nicht akzeptiert.')
 
	; nl. % (Fehler)


nimm_x(X) :-
	nimm(X) ; nl,write(' Das kann ich nicht nehmen.'), fail.


lege_x_auf_y(X, Y) :-
	lege_auf(X, Y) ; nl,write(' Das kann man nicht aufeinander legen.'), fail.


liegt_x_auf_y(X, Y) :-
	liegt_auf(X, Y), nl,write(' Ja.') ; nl,write(' Nein.').


ist_objekt(Objekt, Farbe, X) :-
	Farbe==egal, objekt_name(X, Objekt), im_Kontext(X), !
	; nonvar(Farbe), objekt_name(X, Objekt), objekt_farbe(X, Farbe), im_Kontext(X), !
	; var(Farbe), objekt_name(X, Objekt), findall(Objekt, objekt_name(X, Objekt), [X]), im_Kontext(X), !
	; proN(Objekt, X), !
	; nl,write(' Ich weiss nicht, welches Objekt gemeint ist.'), fail.


%------------------------------------------------------------------------------
% "unwichtige" W”rter entfernen

insignificant([die, den, das, der, dem]).

remove_insignificant(List, Newlist) :-
	insignificant(I),
	rmv_ins(I, List, Newlist).

rmv_ins([A|B], L, N) :-
	rmv_ins(B, L, N1),
	removeall(A, N1, N).
	
rmv_ins([], L, N) :- N = L.


%------------------------------------------------------------------------------
% Objekte

object([hand, tisch, kugel, wuerfel, pyramide, ihn, diesen, er, ihm, sie, diese, es, dieses]).

is_object([Objekt], Objekt, IFarbe) :- object(L), member(Objekt, L). % , IFarbe = unbekannt.
is_object([Farbe,Objekt], Objekt, IFarbe) :- is_color(Farbe, IFarbe), object(L), member(Objekt, L).
is_object([Farbe], Objekt, IFarbe) :- is_color(Farbe, IFarbe). % , Objekt = unbekannt.


%------------------------------------------------------------------------------
% Farben und Farbnamen

color([	['Rot',[rote, roten, rotem]],
	['Gruen',[gruene, gruenen, gruenem]],
	['Blau', [blaue, blauen, blauem]],
	[egal, [ein, eine, einen, irgendein, irgendeine, irgendeinen]]
      ]).

is_color(C, I) :-
	color(Colors), 
	member(Farbe, Colors),
	Farbe = [I, L],
	member(C, L), !.


%------------------------------------------------------------------------------
% Verben

nimm_verb([nimm, nehme]).
lege_verb([lege, stelle]).
ist_verb([liegt, ist, steht]).


%------------------------------------------------------------------------------
% Befehle

get_command(L, Cmd, IObjekt, IFarbe, IObj2, IFarbe2) :-
	is_cmd1(L, IObjekt, IFarbe), Cmd = 1, ! ;
	is_cmd2(L, IObjekt, IFarbe, IObj2, IFarbe2), Cmd = 2, ! ;
	is_cmd3(L, IObjekt, IFarbe), Cmd = 3, ! ;
	is_cmd4(L, IObjekt, IFarbe, IObj2, IFarbe2), Cmd = 4, ! ;
	Cmd = 0.


% NIMM x.
is_cmd1([Verb|Rest], IObjekt, IFarbe) :- 
	nimm_verb(Verblist), member(Verb, Verblist),
	is_object(Rest, IObjekt, IFarbe).	


% LEGE x AUF y.
is_cmd2([Verb|Rest1], IO1, IF1, IO2, IF2) :- 
	lege_verb(VerbList), member(Verb, VerbList),
	append(Objekt1, [auf|Objekt2], Rest1), is_object(Objekt1, IO1, IF1),
	is_object(Objekt2, IO2, IF2), ( nonvar(IO1),nonvar(IO2) ; IO1=IO2 ).


% WO IST x?
is_cmd3([wo,Verb|Rest], IObjekt, IFarbe) :- 
	ist_verb(Verblist), member(Verb, Verblist),
	is_object(Rest, IObjekt, IFarbe).	


% LIEGT x AUF y?
is_cmd4([Verb|Rest1], IO1, IF1, IO2, IF2) :- 
	ist_verb(VerbList), member(Verb, VerbList),
	append(Objekt1, [auf|Objekt2], Rest1), is_object(Objekt1, IO1, IF1),
	is_object(Objekt2, IO2, IF2), ( nonvar(IO1),nonvar(IO2) ; IO1=IO2 ).
	
