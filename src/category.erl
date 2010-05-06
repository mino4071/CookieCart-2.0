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

-define(CATEGORY,wf:state(category)).

%%====================================================================
%% API Functions
%%====================================================================
load(CatId) ->
    wf:state(category,db:get_category(CatId)).

load() ->
    ?PRINT(wf:state(pathInfo)),
    case wf:state(pathInfo) of
	"99"++CatId ->
	    load(list_to_integer(CatId)),
	    true;
	_ -> false
    end.
%%====================================================================
%% Template Functions
%%====================================================================
loadFromPath() ->
    load(),
    [].

%%%%%% Default %%%%%%

list()->
    Data = db:get_categories(),
    Map = #category{name=name@text, url=name@url},
    Body = [#link{ id=name },
	    #br{}],
    #bind{ data = Data, map = Map, body = Body}.

listProducts() ->
    Data = db:get_products((?CATEGORY)#category.id),
    wf:state(product_cache,Data),
    Map = #product{name=name@text, url=name@url},
    Body = [ #link{id=name},
	     #br{}],
    #bind{ data = Data, map = Map, body = Body}.

%%%%%% Custom %%%%%%

list(Template) ->
    File = "./wwwroot/"++Template,
    Data = db:get_categories(),

    Render = fun(Category) ->
		     wf:state(category,Category),
		     wf:state(template_was_called,false),
		     wf:render(#template{ file=File })
	     end,
[Render(X)||X<-Data].

listProducts(Template) ->
    File = "./wwwroot/" ++ Template,
    Data = db:get_products((?CATEGORY)#category.id),
    wf:state(prod_cache,Data),

    Render = fun(Product) ->
		     product:load(Product),
		     wf:state(template_was_called,false),
		     wf:render(#template{ file=File })
	     end,
    
    [Render(X)||X<-Data].

%%--------------------------------------------------------------------
%% Field Access Functions 
%%--------------------------------------------------------------------

name() ->
    (?CATEGORY)#category.name.

url() ->
    "./"++ integer_to_list((?CATEGORY)#category.id).

event(Event) ->
    ?PRINT(Event).
