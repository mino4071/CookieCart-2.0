%%%-------------------------------------------------------------------
%%% File    : cart.erl
%%% Author  :  <Mino@X60S>
%%% Description : 
%%%
%%% Created : 29 Apr 2010 by  <Mino@X60S>
%%%-------------------------------------------------------------------
-module(cart).
-compile(export_all).

-include_lib ("nitrogen/include/wf.inc").
-include("records.hrl").

%%====================================================================
%% API Functions
%%====================================================================
list()->
    Cart = get_cart(),
    CartItemList = Cart#cart.products,
    ProdIdList = [X#cartItem.prodId||X<-CartItemList],
    Data = db:get_products(ProdIdList),
    Map = #product{name=name@text, url=name@url},
    Body = [#link{ id=name },
	    #br{}],
    #panel{id=cart_content, body = 
	   [#bind{ data = Data, map = Map, body = Body}]}.

%%====================================================================
%% External Functions
%%====================================================================
add(Quantity, ProdId) ->
    Cart = get_cart(),
    Prods = cc_add(#cartItem{prodId=ProdId,quantity=Quantity},
		   Cart#cart.products, []),
    set_cart(Cart#cart{products=Prods}),
    wf:update(cart_content,list()).

%%====================================================================
%% Internal Functions
%%====================================================================
set_cart(Cart) ->
    wf:session(cart,Cart),
    wf:set_cookie(cart,wf:pickle(Cart)),
    case true of %%Check if user is logged in
	true ->
	    []; %%add cart to db
	_ ->
	    []
    end.

get_cart() ->
    ?PRINT(wf:session(cart)),
    case wf:session(cart) of
	undefined ->
	    Cart = case cookie of %%check user logged in
		       cookie ->
			   cookie_cart();
		       db ->
			   db_cart()
		   end,
	    wf:session(cart,Cart),
	    Cart;
	Cart ->
	    Cart
    end.

cookie_cart() ->
    case wf:get_cookie(cart) of
	undefined ->
	    #cart{products=[]};
	Cart ->
	    wf:depickle(Cart)
    end.

db_cart() ->
    #cart{products=[]}.

cc_add(Item,[],Acc) ->
    [Item|lists:reverse(Acc)];
cc_add(Item,[HD|TL],Acc) ->
    case Item#cartItem.prodId == HD#cartItem.prodId of
	true ->
	    NewQty = Item#cartItem.quantity + HD#cartItem.quantity,
	    lists:reverse(Acc,[HD#cartItem{quantity=NewQty}|TL]);
	false ->
	    cc_add(Item,TL,[HD|Acc])
    end.
