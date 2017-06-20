% Grammatik
satz(S) :- befehl_satz(S).
satz(S) :- frage_satz(S).

frage_satz(F) :- append(FW,RS,F), frage_wort_obj(FW), spezif_verbobj(RS).
frage_satz(F) :- append(FW,RS,F), frage_wort_ort(FW), spezif_verbortobj(RS).

spezif_verbobj(RS)    :- append(FV,Sub,RS), frage_verb(FV), substantiv(Sub).
spezif_verbortobj(RS) :- append(FV,OD,RS),  frage_verb(FV), spezif_ortobj(OD).

spezif_ortobj(OO) :- append(Ort,OD,OO), ort(Ort), obj_dativ(OD).
obj_dativ(OD) :- append(Art,Nom,OD), dat_artikel_maenl(Art), adj_nomen_dat(Nom).
obj_dativ(OD) :- append(Art,Nom,OD), dat_artikel_weibl(Art), adj_nomen_dat(Nom).

adj_nomen_dat(DO) :- append(Col,Nom,DO), farbe_akus_weibl(Col), nomen_maenl(Nom).
adj_nomen_dat(DO) :- nomen_maenl(DO).
adj_nomen_dat(DO) :- append(Col,Nom,DO), farbe_akus_weibl(Col), nomen_weibl(Nom).
adj_nomen_dat(DO) :- nomen_weibl(DO).
adj_nomen_dat(DO) :- farbe_akus_weibl(Col).

substantiv(SP) :- append(Art,Nom,SP), subst_artikel_maenl(Art), adj_nomen_subst_maenl(Nom).
substantiv(SP) :- append(Art,Nom,SP), subst_artikel_weibl(Art), adj_nomen_akus_weibl(Nom).

adj_nomen_subst_maenl(SP) :- append(Col,Nom,SP), farbe_subst_maenl(Col), nomen_maenl(Nom).
adj_nomen_subst_maenl(SP) :- nomen_maenl(SP).

befehl_satz(B)  :- append(VP,OP,B), verb_transitiv(VP),   objekt_satz(OP).
befehl_satz(B)  :- append(VP,OP,B), verb_intransitiv(VP), ort_objekt_satz(OP).

objekt_satz(OP) :- append(Art,Nom,OP), obj_artikel_maenl(Art), adj_nomen_akus_maenl(Nom).
objekt_satz(OP) :- append(Art,Nom,OP), obj_artikel_weibl(Art), adj_nomen_akus_weibl(Nom).
objekt_satz(OP) :- pronomen_akusativ_maenl(OP).
objekt_satz(OP) :- pronomen_akusativ_weibl(OP).
objekt_satz(OP) :- append(Art,Nom,OP), obj_unb_artikel_maenl(Art), nomen_maenl(NP).
objekt_satz(OP) :- append(Art,Nom,OP), obj_unb_artikel_weibl(Art), nomen_weibl(NP).


adj_nomen_akus_maenl(NP) :- append(Col,Nom,NP), farbe_akus_maenl(Col), nomen_maenl(Nom).
adj_nomen_akus_maenl(NP) :- nomen_maenl(NP).
adj_nomen_akus_weibl(NP) :- append(Col,Nom,NP), farbe_akus_weibl(Col), nomen_weibl(Nom).
adj_nomen_akus_weibl(NP) :- nomen_weibl(NP).
adj_nomen_akus_maenl(NP) :- farbe_akus_maenl(Col).
adj_nomen_akus_weibl(NP) :- farbe_akus_weibl(Col).

ort_objekt_satz(OP) :- append(Obj,PP,OP), objekt_satz(Obj), ort_satz(PP).

ort_satz(PP) :- append(Ort,Obj,PP), ort(Ort), objekt_satz(Obj).

obj_artikel_maenl([den]).
obj_artikel_weibl([die]).

obj_unb_artikel_weibl([eine]).
obj_unb_artikel_maenl([einen]).

dat_artikel_maenl([dem]).
dat_artikel_weibl([der]).

pronomen_akusativ_maenl([ihn]).
pronomen_akusativ_weibl([sie]).

nomen_maenl([wuerfel]).
nomen_maenl([ball]).
nomen_maenl([tisch]).
nomen_weibl([pyramide]).


verb_transitiv([nimm]).
verb_intransitiv([lege]).
verb_intransitiv([stell]).
verb_intransitiv([stelle]).
verb_transitiv([nehme]).

farbe_akus_weibl([rote]).
farbe_akus_weibl([blaue]).
farbe_akus_weibl([gruene]).
farbe_akus_maenl([roten]).
farbe_akus_maenl([blauen]).
farbe_akus_maenl([gruenen]).
farbe_subst_maenl([rote]).
farbe_subst_maenl([blaue]).
farbe_subst_maenl([gruene]).

ort([auf]).
ort([unter]).

frage_wort_obj([wo]).
frage_wort_ort([was]).
frage_verb([liegt]).
frage_verb([ist]).

subst_artikel_maenl([der]).
subst_artikel_weibl([die]).
