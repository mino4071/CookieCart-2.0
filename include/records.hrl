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
	 quantity,
	 description}).

-record(price,
	{price,
	 currency}).

-record(prodId,
	{product,
	 category}).

-record(cart,
	{products,
	 totalPrice}).

-record(cartItem,
	{prodId,
	 quantity}).

-record(order,
	{id,
	 products}).

-record(orderItem,
	{product,
	 quantity}).
