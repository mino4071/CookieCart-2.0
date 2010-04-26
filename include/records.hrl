-record(ids, 
	{table, 
	 ids}).

-record(category,
	{id,
	 name,
	 url}).

-record(product,
	{id,
	 name,
	 url,
	 cat_id,
	 img,
	 price,
	 description}).

-record(price,
	{price,
	 currency}).

-record(prodId,
	{product,
	 category}).

-record(cart,
	{products,
	 sum}).

-record(cartItem,
	{prodId,
	 quantity}).
