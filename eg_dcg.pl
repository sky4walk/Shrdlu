/*
    Simple English Sentences and Expression DCG Examples
    ----------------------------------------------------

    This file contains two examples of using Definite Clause Grammars.

    The first is a grammar of simple English sentences will produce a parse
    tree to show how a sentence has been parsed.

    An example of the output of the english sentence grammar is as follows:

	    ?- phrase(sentence(X),[the,house,likes,the,boy]).
	    X = sentence(
		          noun_phrase(
					determiner(the),
					noun(house)
				     ),
			  verb_phrase(
					verb(likes),
					noun_phrase(
						      determiner(the),
						      noun(boy)
						   )
				     )
			)
    (This output has been hand formatted to show the structure more clearly)

    The second is a grammar for simple maths expressions that evaluates the
    expression as well as checking to see if it is correctly formulated.

    An example of the output of the math expression grammar is as follows:

	?- phrase(exp(N), "1+2*5-3").
	N = 8

*/

/************************************************************************
**  The English Sentence Example
************************************************************************/

% the parse tree is returned by the structure given in the head of the rule

sentence( sentence(N,V) )	--> noun_phrase( N ), verb_phrase( V ).

noun_phrase( noun_phrase(D,N) )	--> determiner( D ), noun( N ).

verb_phrase( verb_phrase(V,N) )	--> verb( V ), noun_phrase( N ).

% the following DCG rules define a database of determiner, noun and verb
% terminal symbols.
% You can increase the range of sentences by adding new terminal symbols here

determiner( determiner(the) )	--> [the].

noun( noun(boy) )		--> [boy].
noun( noun(house) )		--> [house].

verb( verb(likes) )		--> [likes].

/************************************************************************
**  The Math Expression Example
************************************************************************/

exp(Z)				--> term(X), "+", exp(Y), {Z is X + Y}.
exp(Z)				--> term(X), "-", exp(Y), {Z is X - Y}.
exp(Z)				--> term(Z).

term(Z)				--> mynumb(X), "*", term(Y), { Z is X * Y}.
term(Z)				--> mynumb(X), "/", term(Y), { Z is X / Y}.
term(Z)				--> mynumb(Z).

mynumb(C)			--> "+", mynumb(C).
mynumb(C)			--> "-", mynumb(X), {C is -X}.
mynumb(X)			--> [C], { "0" =< C, C =< "9", X is C - "0"}.
