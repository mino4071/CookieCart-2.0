%%%-------------------------------------------------------------------
%%% File    : product.erl
%%% Author  :  <Mino@X60S>
%%% Description : 
%%%
%%% Created : 29 Apr 2010 by  <Mino@X60S>
%%%-------------------------------------------------------------------
-module (product).
-compile (export_all).

-include_lib ("nitrogen/include/wf.inc").
-include("records.hrl").
-include("utils.hrl").

-define(PRODUCT,wf:state(product)).

%%====================================================================
%% API Functions
%%====================================================================
load(Product) when is_record(Product,product)->
    wf:state(product,Product);
load(ProdId) ->
    wf:state(product,(db:get_product(ProdId))#product{quantity="1"}).

load() ->
    case wf:state(pathInfo) of
	"112"++ProdId ->
	    load(list_to_integer(ProdId)),
	    true;
	_ -> false
    end.

raw_price() ->
        (?PRODUCT)#product.price.

get_Id(Product) ->
    Product#product.id.

get_price(Product) ->
    Product#product.price.

%%====================================================================
%% Template Functions
%%====================================================================
loadFromPath() ->
    load(),
    [].

id() ->
    (?PRODUCT)#product.id.

name() ->
    (?PRODUCT)#product.name.

url() ->
    (?PRODUCT)#product.url.

img() ->
    image:load((?PRODUCT)#product.img).

description() ->
    (?PRODUCT)#product.description.

price() ->
    price:toString((?PRODUCT)#product.price).

buyLink() ->
    Delegate = #event{type=click, delegate=product, postback={buy,?PRODUCT}},
    #link{text="add to cart", class="icon cart_put", actions=Delegate}.

quantity() ->
    (?PRODUCT)#product.quantity.

quantityTextbox(Class) ->
    #textbox{id="Qty" ++ ?i2l(id()),
	     class=Class, 
	     text=(?PRODUCT)#product.quantity}.

event({buy,Product}) ->
    Qty = case wf:q("Qty"++ ?i2l(get_Id(Product))) of
	      [] -> 1;
	      Quantity -> ?l2i(hd(Quantity))
	  end,
    cart:add(Qty,Product);
event(Event) ->
    ?PRINT(Event).
