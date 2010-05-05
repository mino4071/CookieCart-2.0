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

-define(PRODUCT,wf:state(product)).

%%====================================================================
%% API Functions
%%====================================================================
load(Product) when is_record(Product,product)->
    wf:state(product,Product);
load(ProdId) ->
    wf:state(product,db:get_product(ProdId)).
    
        
%%====================================================================
%% Template Functions
%%====================================================================
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
    Delegate = #event{type=click, delegate=product, postback={buy,id(),1}},
    #link{text="add to cart", class="icon cart_put", actions=Delegate}.

event({buy,ProdId,Qty}) ->
    cart:add(Qty,ProdId);
event(Event) ->
    ?PRINT(Event).
