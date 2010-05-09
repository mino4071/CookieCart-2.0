%%%-------------------------------------------------------------------
%%% File    : cartItem.erl
%%% Author  :  <Mino@X60S>
%%% Description : 
%%%
%%% Created : 29 Apr 2010 by  <Mino@X60S>
%%%-------------------------------------------------------------------
-module (cartItem).
-compile (export_all).

-include_lib ("nitrogen/include/wf.inc").
-include("records.hrl").

%%====================================================================
%% API Functions
%%====================================================================
load(Product) when is_record(Product,product)->
    wf:state(product,Product);
load(ProdId) ->
    wf:state(product,db:get_product(ProdId)).

load() ->
    ?PRINT(wf:state(pathInfo)),
    case wf:state(pathInfo) of
	"112"++ProdId ->
	    load(list_to_integer(ProdId)),
	    true;
	_ -> false
    end.    
%%====================================================================
%% Template Functions
%%====================================================================

id() ->
    product:id().

name() ->
    product:name().

url() ->
    product:url().

img() ->
    product:img().

description() ->
    product:description().

price() ->
    product:price().

buyLink() ->
    product:buyLink().

quantityTextbox(Class) ->
    #textbox{class=Class}.


event(Event) ->
    ?PRINT(Event).
