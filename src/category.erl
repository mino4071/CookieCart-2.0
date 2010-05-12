%%%-------------------------------------------------------------------
%%% File    : category.erl
%%% Author  :  <Mino@X60S>
%%% Description : 
%%%
%%% Created : 29 Apr 2010 by  <Mino@X60S>
%%%-------------------------------------------------------------------
-module (category).
-compile (export_all).

-include_lib ("nitrogen/include/wf.inc").
-include("records.hrl").

%%-API----------------------------------------------------------------
-export([load/0,
	 load/1]).
%%-Template-----------------------------------------------------------
-export([loadFromPath/0,
	 list/0,
	 list/1,
	 listProducts/0,
	 listProducts/1,
	 name/0,
	 url/0]).

-define(CATEGORY,wf:state(category)).

%% @type category() = #category{id=integer(), name=string(), url=string()}

%%====================================================================
%% API Functions
%%====================================================================

%%--------------------------------------------------------------------
%% @private
%% @spec load(CatId) -> ok
%% @doc loads a category into memory.
%% @end
%%--------------------------------------------------------------------
load(CatId) ->
    wf:state(category,db:get_category(CatId)).

%%--------------------------------------------------------------------
%% @private
%% @spec load() -> ok
%% @doc Uses pathinfo to load a category into memory.
%% @end
%%--------------------------------------------------------------------
load() ->
    case wf:state(pathInfo) of
	"99"++CatId ->
	    load(list_to_integer(CatId)),
	    true;
	_ -> false
    end.

%%====================================================================
%% Template Functions
%%====================================================================

%%--------------------------------------------------------------------
%% @spec loadFromPath() -> []
%% @doc Uses pathinfo to load a category into memory.
%% @end
%%--------------------------------------------------------------------
loadFromPath() ->
    load(),
    [].

%%--------------------------------------------------------------------
%% @spec list() -> HTML
%% @doc returns a list of links to every category.
%% @end
%%--------------------------------------------------------------------
list()->
    Data = db:get_categories(),
    Map = #category{name=name@text, url=name@url},
    Body = [#link{ id=name },
	    #br{}],
    #bind{ data = Data, map = Map, body = Body}.

%%--------------------------------------------------------------------
%% @spec listProducts() -> HTML
%% @doc returns a list of every product in the currently 
%%      loaded category.
%% @end
%%--------------------------------------------------------------------
listProducts() ->
    Data = db:get_products((?CATEGORY)#category.id),
    Map = #product{name=name@text, url=name@url},
    Body = [ #link{id=name},
	     #br{}],
    #bind{ data = Data, map = Map, body = Body}.

%%--------------------------------------------------------------------
%% @spec list(Template) -> HTML
%% @doc Each category is loaded into memory. For each category 
%%      Template is evaluated.
%%      Template typically contains calls to display the currently 
%%      loaded category.
%% @end
%%--------------------------------------------------------------------
list(Template) ->
    File = "./wwwroot/"++Template,
    Data = db:get_categories(),

    Render = fun(Category) ->
		     wf:state(category,Category),
		     wf:state(template_was_called,false),
		     wf:render(#template{ file=File })
	     end,
[Render(X)||X<-Data].

%%--------------------------------------------------------------------
%% @spec listProducts(Template) -> HTML
%% @doc Each product in the currently loaded category is loaded into
%%      memory. For each product Template is evaluated.
%% @end
%%--------------------------------------------------------------------
listProducts(Template) ->
    File = "./wwwroot/" ++ Template,
    Data = db:get_products((?CATEGORY)#category.id),
    
    Render = fun(Product) ->
		     product:load(Product#product{quantity="1"}),
		     wf:state(template_was_called,false),
		     wf:render(#template{ file=File })
	     end,
    
    [Render(X)||X<-Data].

%%--------------------------------------------------------------------
%% Field Access Functions 
%%--------------------------------------------------------------------

%%--------------------------------------------------------------------
%% @spec name() -> string()
%% @doc Returns the name of the currently loaded category.
%% @end
%%--------------------------------------------------------------------
name() ->
    (?CATEGORY)#category.name.

%%--------------------------------------------------------------------
%% @deprecated No longer needed.
%% @spec url() -> string()
%% @doc Returns the URL to the currently loaded category.
%% @end
%%--------------------------------------------------------------------
url() ->
    "./"++ integer_to_list((?CATEGORY)#category.id).

%% @hidden
event(Event) ->
    ?PRINT(Event).
