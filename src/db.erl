%%%-------------------------------------------------------------------
%%% File    : db.erl
%%% Author  :  Mino
%%% Description : a database API for the CookieCart 
%%%               e-commerce framework.
%%%
%%% Created : 25 Apr 2010 by  Mino
%%%-------------------------------------------------------------------
%% @private
-module(db).

-compile (export_all).

-include_lib ("nitrogen/include/wf.inc").

-include("records.hrl").

-export([reset/0,
	 start/0,
	 init/0,
	 add_category/1,
	 get_categories/0,
	 get_category/1,
	 add_product/1,
	 get_product/1,
	 get_products/1]).
%%--------------------------------------------------------------------
%% @spec reset() -> ok
%% @doc Halts and empties the database then successivly calls start()
%%      and init().
%% @end
%%--------------------------------------------------------------------
reset() ->
    mnesia:stop(),
    mnesia:delete_schema([node()]),
    start(),
    init().

%%--------------------------------------------------------------------
%% @spec start() -> ok
%% @doc Starts the database and loads the schema.
%% @end
%%--------------------------------------------------------------------
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
				  {disc_copies, [node()]}]),
    
    mnesia:create_table(order, [{attributes, record_info(fields, order)},
				{disc_copies, [node()]}]).

%%--------------------------------------------------------------------
%% @spec init() -> ok
%% @doc Loads the database with a default set of items.
%% @end
%%--------------------------------------------------------------------
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

%%--------------------------------------------------------------------
%% @spec add_category(category()) -> ok
%% @throws dberror
%% @doc Adds Category to the database.
%% @end
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

%%--------------------------------------------------------------------
%% @spec get_categories() -> [category()]
%% @doc Returns a list of all categories.
%% @end
%%--------------------------------------------------------------------
get_categories()->
    Fun = fun() ->
		  R = #category{ _ = '_'},
		  mnesia:select(category, [{R, [], ['$_']}])
	  end,
    call(Fun).

%%--------------------------------------------------------------------
%% @spec get_category(Id::catId()) -> Category::category()
%% @doc Fetches and  returns the category.
%% @end
%%--------------------------------------------------------------------
get_category(Id) ->
    Fun = fun() ->
		  hd(mnesia:read(category,Id))
	  end,
    call(Fun).


%%--------------------------------------------------------------------
%% Product functions
%%--------------------------------------------------------------------

%%--------------------------------------------------------------------
%% @spec add_product(Product::product()) -> ok
%% @throws dberror
%% @doc Adds a product to the database.
%% @end
%%--------------------------------------------------------------------
add_product(Product) ->
    Id = mnesia:dirty_update_counter(ids,product_id,1),
    URL = "112" ++ integer_to_list(Id),
    Prod = Product#product{id = Id, url = URL},    
    Fun = fun() ->
		  mnesia:write(Prod)
	  end,
    call(Fun).

%%--------------------------------------------------------------------
%% @spec get_product(ProdId::prodId()) -> product()
%% @doc Fetches and returns product from the database.
%% @end
%%--------------------------------------------------------------------
get_product(ProdId) ->
    Fun = fun() ->
		  hd(mnesia:read(product,ProdId))
	  end,
    call(Fun).

%%--------------------------------------------------------------------
% % @spec
%% @doc Well, it's complicated... 
%% @end
%%--------------------------------------------------------------------
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

%%--------------------------------------------------------------------
%% Order functions
%%--------------------------------------------------------------------

%%--------------------------------------------------------------------
%% @spec add_order(Order) -> ok
%% @doc Adds an order to the database
%% @end
%%--------------------------------------------------------------------
add_order(Order) ->
    Id = mnesia:dirty_update_counter(ids,order_id,1),
    Order1 = Order#order{id = Id},    
    Fun = fun() ->
		  mnesia:write(Order1)
	  end,
    call(Fun).

%%--------------------------------------------------------------------
%% @spec get_order(OrderId::orderId()) -> order()
%% @doc Fetches and returns a order from the database.
%% @end
%%--------------------------------------------------------------------
get_order(OrderId) ->
    Fun = fun() ->
		  hd(mnesia:read(order,OrderId))
	  end,
    call(Fun).

%%====================================================================
%% Internal functions
%%====================================================================
%% @hidden
call(Fun) ->
    case mnesia:transaction(Fun) of
	{aborted,Reason} ->
	    ?PRINT(Reason),
	    throw(dberror);
	{atomic,Result} -> Result
    end.
