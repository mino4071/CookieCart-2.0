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
    case PathInfo of
	[] ->
	    #template { file=env(tpl_main)};
	"112" ++ ProdId ->
	    product:load(list_to_integer(ProdId)),
	    tpl(PathInfo,tpl_product);
	"99" ++ CatId ->
	    category:load(list_to_integer(CatId)),
	    tpl(PathInfo,tpl_category);
	_ ->
	    #template { file="./wwwroot/"++ PathInfo}
    end.

event(Event) ->
    ?PRINT(Event).


%%====================================================================
%% Internal Functions
%%====================================================================
env(Par) ->
    {ok,Val} = application:get_env(Par),
    Val.

tpl(IdStr,Default) ->
    Path = "./tpl/" ++ IdStr ++ ".tpl",
    case file:read_file_info(Path) of
	{ok,_} ->
	    #template { file=Path };
	{error,_} ->
	    #template{ file=env(Default) }
    end.


%%====================================================================
%% Debug Functions
%%====================================================================
render_page(String) ->
    String.

template() ->
    %% Hacka-dodel-doo
    wf:state(template_was_called,false),
    #template { file="./wwwroot/contact.tpl"}.

