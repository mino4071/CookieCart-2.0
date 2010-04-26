-module(cart).
-compile(export_all).

-include_lib ("nitrogen/include/wf.inc").
-include("records.hrl").

list()->
    Cart = get_cart(),
    CartItemList = Cart#cart.products,
    ProdIdList = [X#cartItem.prodId||X<-CartItemList],
    Data = db:get_products(ProdIdList),
    Map = #product{name=name@text, url=name@url},
    Body = [#link{ id=name },
	    #br{}],
    #bind{ data = Data, map = Map, body = Body}.

add(Quantity, ProdId) ->
    Cart = get_cart(),
    Prods = cc_add(#cartItem{prodId=ProdId,quantity=Quantity},
		   Cart#cart.products, []),
    wf:set_cookie(cart,wf:pickle(Cart#cart{products=Prods})).

%%%%%% Internal Functions %%%%%%

get_cart() ->
    case wf:get_cookie(cart) of
	undefined ->
	    #cart{products=[]};
	Cart ->
	    wf:depickle(Cart)
    end.

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
	    
    
