%%%-------------------------------------------------------------------
%%% File    : order.erl
%%% Author  :  <Mino@X60S>
%%% Description : 
%%%
%%% Created : 12 May 2010 by  <Mino@X60S>
%%%-------------------------------------------------------------------
-module(order).

-export([add/1]).

-include("records.hrl").

%%====================================================================
%% API Functions
%%====================================================================
add(Cart) ->
    Products = cart:get_products(Cart),
    Items = [#orderItem{quantity=X, product=Y}||{X,Y} <- Products],
    Order = #order{products=Items},
    db:add_order(Order).
