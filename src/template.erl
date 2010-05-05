%%%-------------------------------------------------------------------
%%% File    : template.erl
%%% Author  :  <Mino@X60S>
%%% Description : 
%%%
%%% Created : 27 Apr 2010 by  <Mino@X60S>
%%%-------------------------------------------------------------------
-module(template).

-compile(export_all).

-include_lib ("nitrogen/include/wf.inc").
-include("records.hrl").

%%====================================================================
%% API functions
%%====================================================================
test() ->
    "test".

conditional(Con,File) ->
    case eval(Con) of
	true ->
	    action(File);
	_ ->
	    []
    end.

conditional(Con,True,False) ->
    case eval(Con) of
	true ->
	    action(True);
	_ ->
	    action(False)
    end.

%%====================================================================
%% Internal functions
%%====================================================================
action(Str) ->
    case file:read_file_info(Str) of
	{ok,_} ->
	    wf:state(template_was_called,false),
	    #template { file=Str };
	{error,_} ->
	    Str
    end.

eval(emptyCart) ->
    case wf:get_cookie(cart) of
	undefined ->
	    true;
	_ -> false
    end;
eval(product) ->
    case wf:state(product) of
	undefined ->
	    false;
	_ -> true
    end;
eval(category) ->
    case wf:state(category) of
	undefined ->
	    false;
	_ -> true
    end;
eval(_Con) ->
    true.
