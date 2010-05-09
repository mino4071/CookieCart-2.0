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

-define(i2l(Integer),integer_to_list(Integer)).

%%====================================================================
%% Template Functions
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

list(Template) ->
    File = "./wwwroot/" ++ Template,
    Cart = get_cart(),
    CartItemList = Cart#cart.products,
    Data = db:get_products(CartItemList),
   
    Render = fun({Quantity,Product}) ->
		     product:load(Product#product{quantity=Quantity}),
		     wf:state(template_was_called,false),
		     wf:render(#template{ file=File })
	     end,
    
    [Render(X)||X<-Data].

quantityTextbox() ->
    quantityTextbox("").
quantityTextbox(Class) ->
    #textbox{class=Class, text=?i2l(product:quantity())}.

rowTotal() ->
    price:toString(product:quantity() * product:raw_price()).

totalPrice() ->
    Cart = get_cart(),
    CartItemList = Cart#cart.products,
    Data = db:get_products(CartItemList),
    price:toString(sum_cart(Data)).

deleteLink() ->
    Delegate = #event{type=click, delegate=cart, 
		      postback={delete,product:id()}},
    #link{text="delete", actions=Delegate}.

%%====================================================================
%% External Functions
%%====================================================================
add(Quantity, Product) ->
    Cart = get_cart(),
    ProdId = product:get_Id(Product),
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

sum_cart([]) ->
    0;
sum_cart([{Quantity,Product}|Tail]) ->
    (Quantity * product:get_price(Product)) + sum_cart(Tail).

event({delete,ProdId}) ->
    Cart = get_cart(),
    Products = [X||X<-Cart#cart.products,X#cartItem.prodId /= ProdId],
    
    set_cart(Cart#cart{products=Products}),
    wf:redirect("").

    
    
