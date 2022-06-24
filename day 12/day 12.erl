-module(main).
-export([main/1]).

parse_split_input([], CaveMap) -> 
    CaveMap;
parse_split_input([<<"">>|ConnectionList], CaveMap) ->
    parse_split_input(ConnectionList, CaveMap);
parse_split_input([Connection|ConnectionList], CaveMap) ->
    [Cave1, Cave2] = binary:split(Connection, <<"-">>),
    CaveMap2 =  
        if not (Cave2 == <<"start">>) ->
            maps:put(Cave1, sets:add_element(Cave2, maps:get(Cave1, CaveMap, sets:new())), CaveMap);
        true ->
            CaveMap
        end,
    CaveMap3 = 
        if not (Cave1 == <<"start">>) ->
            maps:put(Cave2, sets:add_element(Cave1, maps:get(Cave2, CaveMap2, sets:new())), CaveMap2);
        true ->
            CaveMap2
        end,
    parse_split_input(ConnectionList, CaveMap3).

parse_input(Input) ->
    SplitInput = binary:split(Input, <<"\n">>, [global]),
    parse_split_input(SplitInput, maps:new()).

walk_caves_1(_, <<"end">>, _) ->
    1;
walk_caves_1(CaveMap, CurrentCave, VisitedCaves) ->
    case ets:lookup(cave_walk, {CurrentCave, VisitedCaves}) of
        [] ->
            Neighbours = sets:filter(
                fun 
                    (E) -> not sets:is_element(E, VisitedCaves) 
                end, 
                maps:get(CurrentCave, CaveMap)),
            LowercaseCave = string:lowercase(CurrentCave),
            VisitedCaves2 = 
            if 
                LowercaseCave == CurrentCave ->
                    sets:add_element(CurrentCave, VisitedCaves);
                true ->
                    VisitedCaves
            end,
            Result = sets:fold(fun (X, A) -> walk_caves_1(CaveMap, X, VisitedCaves2) + A end, 0, Neighbours),
            ets:insert(cave_walk, {{CurrentCave, VisitedCaves}, Result}),
            Result;
        [{_, Result}] ->
            Result
    end.

walk_caves_2(_, <<"end">>, _) ->
    1;
walk_caves_2(CaveMap, CurrentCave, VisitedCaves) ->
    Neighbours = maps:get(CurrentCave, CaveMap),
    LowercaseCave = string:lowercase(CurrentCave),
    VisitedCaves2 = 
    if 
        LowercaseCave == CurrentCave ->
            sets:add_element(CurrentCave, VisitedCaves);
        true ->
            VisitedCaves
    end,
    sets:fold(
        fun (X, A) -> 
            IsVisited = sets:is_element(X, VisitedCaves),
            if 
                IsVisited ->
                    walk_caves_1(CaveMap, X, VisitedCaves2) + A;
                true ->
                    walk_caves_2(CaveMap, X, VisitedCaves2) + A
            end
        end, 0, Neighbours
    ).

main(Arg) -> 
    {ok, Txt} = file:read_file("day 12.txt"),
    Parsed = parse_input(Txt),
    ets:new(cave_walk, [set, named_table]),
    Result1 = walk_caves_1(Parsed, <<"start">>, sets:new()),
    Result2 = walk_caves_2(Parsed, <<"start">>, sets:new()),
    io:fwrite("~p~n~p~n", [Result1, Result2]).
