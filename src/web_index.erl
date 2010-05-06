%%%-------------------------------------------------------------------
%%% File    : web_index.erl
%%% Author  :  <Mino@X60S>
%%% Description : 
%%%
%%% Created : 29 Apr 2010 by  <Mino@X60S>
%%%-------------------------------------------------------------------
-module (web_index).
-compile (export_all).

-include_lib ("nitrogen/include/wf.inc").
-include("records.hrl").

%%====================================================================
%% Nitrogen Functions
%%====================================================================
main() -> 
    PathInfo = wf:get_path_info(),
    {Path,Info} = path_info(PathInfo),
    wf:state(pathInfo,Info),
    
    File = "./wwwroot/"++Path++".html",
    case file:read_file_info(File) of
	{ok,_} ->
	    #template { file=File };
	{error,_} ->
	    ?PRINT(PathInfo),
	    #template{ file=env(error) }
    end.

event(Event) ->
    ?PRINT(Event).


%%====================================================================
%% Internal Functions
%%====================================================================
path_info(Str) ->
    {Path,Info} = path_info(lists:reverse(Str),[]),
    {lists:reverse(Path),Info}.
path_info([],Acc) ->
    {"xedni",Acc};
path_info([$/|Tail],Acc) ->
    {Tail,Acc};
path_info([Head|Tail],Acc) ->
    path_info(Tail,[Head|Acc]).

env(Par) ->
    {ok,Val} = application:get_env(Par),
    Val.


%%====================================================================
%% Debug Functions
%%====================================================================
render_page(String) ->
    String.

template() ->
    %% Hacka-dodel-doo
    wf:state(template_was_called,false),
    #template { file="./wwwroot/contact.tpl"}.

