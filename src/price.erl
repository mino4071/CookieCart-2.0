-module(price).
-compile(export_all).

-include("records.hrl").

toString(0) ->
    "0,0 SEK";
toString(Price) ->
    PriceStr = integer_to_list(Price),
    Length = length(PriceStr),
    {Integer,Fraction} = lists:split(Length-2,PriceStr),
    Integer++","++Fraction++" SEK".
