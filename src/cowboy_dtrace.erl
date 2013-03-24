-module(cowboy_dtrace).


-export([
         entry/2,
         entry/4,
         return/2,
         return/4
        ]).

-define(DT_ROUTER, 801).
-define(DT_ENTRY, 1).
-define(DT_RETURN, 2).


-define(ENTRY(Module, Fun),dyntrace:p(?DT_ID, 1, atom_to_list(?MODULE), Fun)).
-define(RETURN(Module, Fun),dyntrace:p(?DT_ID, 2, atom_to_list(?MODULE), Fun)).

entry(Module, Function) ->
    dyntrace:p(?DT_ROUTER, ?DT_ENTRY, atom_to_list(Module), Function).

return(Module, Function) ->
    dyntrace:p(?DT_ROUTER, ?DT_RETURN, atom_to_list(Module), Function).

entry(Module, Function, Ints, Strings) ->
    erlang:apply(dyntrace, p, [?DT_ROUTER, ?DT_ENTRY] ++ Ints, [atom_to_list(Module), Function] ++ Strings).

return(Module, Function, Ints, Strings) ->
    erlang:apply(dyntrace, p, [?DT_ROUTER, ?DT_RETURN] ++ Ints, [atom_to_list(Module), Function] ++ Strings).

