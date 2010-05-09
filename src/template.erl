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
    File = "./wwwroot/"++Str,
    case file:read_file_info(File) of
	{ok,_} ->
	    wf:state(template_was_called,false),
	    #template { file=File };
	{error,_} ->
	    "File not Found: "++File
    end.

eval(emptyCart) ->
    case wf:get_cookie(cart) of
	undefined ->
	    true;
	_ -> false
    end;
eval(product) ->
    product:load();
eval(category) ->
    category:load();

eval(Page) when is_list(Page) ->
    case wf:get_path_info() of
	Page ->
	    true;
	_ -> false
    end;
eval(_Con) ->
    false.
