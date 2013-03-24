-module(cowboy_dtrace).


-export([
         entry/2,
         entry/4,
         mw_entry/2,
         mw_entry/4,
         h_entry/2,
         h_entry/4,
         return/2,
         return/4,
         mw_return/2,
         mw_return/4,
         h_return/2,
         h_return/4
        ]).

-define(DT_GENERAL, 800).
-define(DT_MIDDLEWARE, 801).
-define(DT_HANDLER, 802).
-define(DT_ENTRY, 1).
-define(DT_RETURN, 2).


-define(ENTRY(Module, Fun),dyntrace:p(?DT_ID, 1, atom_to_list(?MODULE), Fun)).
-define(RETURN(Module, Fun),dyntrace:p(?DT_ID, 2, atom_to_list(?MODULE), Fun)).

entry(Module, Function) ->
    dyntrace:p(?DT_GENERAL, ?DT_ENTRY, atom_to_list(Module), Function).

return(Module, Function) ->
    dyntrace:p(?DT_GENERAL, ?DT_RETURN, atom_to_list(Module), Function).

mw_entry(Module, Function) ->
    dyntrace:p(?DT_MIDDLEWARE, ?DT_ENTRY, atom_to_list(Module), Function).

mw_return(Module, Function) ->
    dyntrace:p(?DT_MIDDLEWARE, ?DT_RETURN, atom_to_list(Module), Function).


h_entry(Module, Function) ->
    dyntrace:p(?DT_HANDLER, ?DT_ENTRY, atom_to_list(Module), Function).

h_return(Module, Function) ->
    dyntrace:p(?DT_HANDLER, ?DT_RETURN, atom_to_list(Module), Function).

entry(Module, Function, Ints, Strings) ->
    erlang:apply(dyntrace, p, [?DT_GENERAL, ?DT_ENTRY] ++ Ints, [atom_to_list(Module), Function] ++ Strings).

return(Module, Function, Ints, Strings) ->
    erlang:apply(dyntrace, p, [?DT_GENERAL, ?DT_RETURN] ++ Ints, [atom_to_list(Module), Function] ++ Strings).

mw_entry(Module, Function, Ints, Strings) ->
    erlang:apply(dyntrace, p, [?DT_MIDDLEWARE, ?DT_ENTRY] ++ Ints, [atom_to_list(Module), Function] ++ Strings).

mw_return(Module, Function, Ints, Strings) ->
    erlang:apply(dyntrace, p, [?DT_MIDDLEWARE, ?DT_RETURN] ++ Ints, [atom_to_list(Module), Function] ++ Strings).

h_entry(Module, Function, Ints, Strings) ->
    erlang:apply(dyntrace, p, [?DT_HANDLER, ?DT_ENTRY] ++ Ints, [atom_to_list(Module), Function] ++ Strings).
h_return(Module, Function, Ints, Strings) ->
    erlang:apply(dyntrace, p, [?DT_HANDLER, ?DT_RETURN] ++ Ints, [atom_to_list(Module), Function] ++ Strings).

