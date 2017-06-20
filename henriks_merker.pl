/* Gedaechtnis/Erinnerungsmodul fuer SHRDLU */
/* 18.12.2000 */

:- dynamic proN_n/2.
:- dynamic proN_m/2.
:- dynamic proN_f/2.


/* proN(i,o) 
	ueberfuehrt Pronomen (1.Parameter) in Objekte (2.Parameter*/
proN(Pronom, Nomen) :- proN_m(Pronom, Nomen). 
proN(Pronom, Nomen) :- proN_f(Pronom, Nomen). 
proN(Pronom, Nomen) :- proN_n(Pronom, Nomen). 

/* im_Kontext(i)
	merkt sich ein Objekt im 'Gedaechtnis' */
im_Kontext(Obj) :- ist_m(Obj), 	retract(proN_m(diesen,X)), 	retract(proN_m(ihn,X)) ,	retract(proN_m(er,X)) ,	retract(proN_m(ihm,X)) ,
			 	assert(proN_m(diesen,Obj)),	assert(proN_m(ihn,Obj)),	assert(proN_m(er,Obj)),	assert(proN_m(ihm,Obj)).
im_Kontext(Obj) :- ist_m(Obj), 	assert(proN_m(diesen,Obj)),	assert(proN_m(ihn,Obj)),	assert(proN_m(er,Obj)),	assert(proN_m(ihm,Obj)).
im_Kontext(Obj) :- ist_f(Obj), 	retract(proN_f(diese,X)), 	retract(proN_f(sie,X)) , 	
				assert(proN_f(diese,Obj)),	assert(proN_f(sie,Obj)).
im_Kontext(Obj) :- ist_f(Obj), 	assert(proN_f(diese,Obj)),	assert(proN_f(sie,Obj)).
im_Kontext(Obj) :- retract(proN_n(dieses,X)), 	retract(proN_n(es,X)) , 	assert(proN_n(dieses,Obj)),	assert(proN_n(es,Obj)).
im_Kontext(Obj) :- assert(proN_n(dieses,Obj)),	assert(proN_n(es,Obj)).



/* explizite Zuordnung des Geschlechts, alle anderen sind implizit neutral*/
ist_m(w1).
ist_m(w2).
ist_m(w3).
ist_f(k1).
ist_f(k2).
ist_f(p1).
ist_f(p2).





