-module (category).
-compile (export_all).

-include_lib ("nitrogen/include/wf.inc").
-include("records.hrl").

-define(CATEGORY,wf:state(category)).

load(CatId) ->
    wf:state(category,db:get_category(CatId)),
    
    IdStr = integer_to_list(CatId),
    Path = "./tpl/" ++ IdStr ++ ".tpl",
    case file:read_file_info(Path) of
	{ok,_} ->
	    #template { file=Path };
	{error,_} ->
	    #template{ file="./tpl/CC_category.tpl" }
    end.

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

%%%%%% Field Access Functions %%%%%%

name() ->
    (?CATEGORY)#category.name.

url() ->
    "./"++ integer_to_list((?CATEGORY)#category.id).

event(Event) ->
    ?PRINT(Event).
