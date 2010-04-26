-module(price).
-compile(export_all).

-include("records.hrl").

toString(Price) ->
    PriceStr = integer_to_list(Price#price.price),
    Length = length(PriceStr),
    {Integer,Fraction} = lists:split(Length-2,PriceStr),
    Integer++","++Fraction++" "++Price#price.currency.
