%%%-------------------------------------------------------------------
%%% File    : db.erl
%%% Author  :  Mino
%%% Description : a database API for the CookieCart e-commerce framework.
%%%
%%% Created : 25 Apr 2010 by  Mino
%%%-------------------------------------------------------------------
-module(db).

-compile (export_all).

-include_lib ("nitrogen/include/wf.inc").

-include("records.hrl").

reset() ->
    mnesia:stop(),
    mnesia:delete_schema([node()]),
    start(),
    init().

start()->
    io:format("~n*******************~n" ++
	      "  Starting mnesia~n" ++
	      "*******************~n"),
                 
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(ids, [{attributes, record_info(fields, ids)},
			      {disc_copies, [node()]}]),
    
    mnesia:create_table(category, [{attributes, record_info(fields, category)},
				   {disc_copies, [node()]}]),
    
    mnesia:create_table(product, [{attributes, record_info(fields, product)},
				  {disc_copies, [node()]}]).

init() ->
    add_category(#category{name="Cookies"}),
    add_category(#category{name="Cakes"}),
    add_category(#category{name="Pies"}),
    
    add_product(#product{name="Choco Cookie", cat_id = 1,
			 description="Some very tasty cookies!",
			 price=1000,
			 quantity=5}),
    add_product(#product{name="Wedding Cake", cat_id = 2,
			 description="Some very tasty cookies!",
			 price=1000,
			 quantity=10}),
    add_product(#product{name="Meat Pie", cat_id = 3,
			 description="Some very tasty cookies!",
			 price=1000,
			 quantity=15}).


%%====================================================================
%% API functions
%%====================================================================

%%--------------------------------------------------------------------
%% Category functions
%%--------------------------------------------------------------------
add_category(Category) ->
    Id = mnesia:dirty_update_counter(ids,category_id,1),
    URL = "99" ++ integer_to_list(Id),
    Cat = Category#category{id = Id, url = URL},    
    Fun = fun() ->
		  mnesia:write(Cat)
	  end,
    case mnesia:transaction(Fun) of
	{aborted,Reason} ->
	    ?PRINT(Reason),
	    throw(dberror);
	_ -> ok
    end.

get_categories()->
    Fun = fun() ->
		  R = #category{ _ = '_'},
		  mnesia:select(category, [{R, [], ['$_']}])
	  end,
    call(Fun).

get_category(Id) ->
    Fun = fun() ->
		  hd(mnesia:read(category,Id))
	  end,
    call(Fun).


%%--------------------------------------------------------------------
%% Product functions
%%--------------------------------------------------------------------

add_product(Product) ->
    Id = mnesia:dirty_update_counter(ids,product_id,1),
    URL = "112" ++ integer_to_list(Id),
    Prod = Product#product{id = Id, url = URL},    
    Fun = fun() ->
		  mnesia:write(Prod)
	  end,
    call(Fun).


get_product(ProdId) ->
    Fun = fun() ->
		  hd(mnesia:read(product,ProdId))
	  end,
    call(Fun).

get_products([]) -> [];
get_products(ProdIdList=[Head|_]) when is_integer(Head) ->
    Fun = fun() ->
		  [hd(mnesia:read(product,X))||X<-ProdIdList]
	  end,
    call(Fun);
get_products(CartItemList=[Head|_]) when is_record(Head,cartItem) ->
    Fun = fun() ->
		  [{X#cartItem.quantity,
		    hd(mnesia:read(product,X#cartItem.prodId))}
		   ||X<-CartItemList]
	  end,
    call(Fun);
get_products(CatId) when is_integer(CatId) ->
    Fun = fun() ->
		  R = #product{ cat_id = CatId, _ = '_'},
		  mnesia:select(product, [{R, [], ['$_']}])
	  end,
    call(Fun).

%%====================================================================
%% Internal functions
%%====================================================================

call(Fun) ->
    case mnesia:transaction(Fun) of
	{aborted,Reason} ->
	    ?PRINT(Reason),
	    throw(dberror);
	{atomic,Result} -> Result
    end.
