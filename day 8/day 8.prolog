#!/usr/bin/env swipl
:- use_module(library(clpfd)).

head([H|_], H).

segments("abcefg", 0).
segments("cf", 1).
segments("acdeg", 2).
segments("acdfg", 3).
segments("bcdf", 4).
segments("abdfg", 5).
segments("abdefg", 6).
segments("acf", 7).
segments("abcdefg", 8).
segments("abcdfg", 9).

updated_substitute_list([], [], [], []).
updated_substitute_list([], [], [_|ALT], [_|RT]) :-
    updated_substitute_list([], [], ALT, RT).

updated_substitute_list([R|CT], [OG|OGT], [OG|ALT], [R|RT]) :- 
    updated_substitute_list(CT, OGT, ALT, RT).

updated_substitute_list(CT, [OG|OGT], [AL|ALT], [_|RT]) :- 
    dif(OG, AL),
    updated_substitute_list(CT, [OG|OGT], ALT, RT).

substitues([], _, _).
substitues([A|AT], AL, R) :-
    atom_chars(AL, ALC),
    atom_chars(A, AS),
    segments(K, N),
    string_chars(K, KS),
    sort(AS, ASS),
    length(AS, CL),
    length(CN, CL),
    length(KS, CL),
    updated_substitute_list(CN, ASS, ALC, R),
    permutation(CN, KS),
    write(CN),
    substitues(AT, AL, R),
    !.
    
    
