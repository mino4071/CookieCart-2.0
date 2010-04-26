<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>Code Work</title>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <script src='/nitrogen/jquery.js' type='text/javascript' charset='utf-8'>
    </script>
    <script src='/nitrogen/jquery-ui.js' type='text/javascript' charset='utf-8'>
    </script>
    <script src='/nitrogen/livevalidation.js' 
	    type='text/javascript' charset='utf-8'></script>
    <script src='/nitrogen/nitrogen.js' type='text/javascript' charset='utf-8'>
    </script>

    <link rel="stylesheet" 
	  type="text/css" 
	  href="/css/style.css" 
	  media="screen" />
  </head>

  <body>
    <div id="wrap">
      <div id="container">
        <div id="top-panel">
          <div class="left">
	    [[[web_index:render_page("smalllogin")]]]
	  </div>
          
	  <div class="right">
	    [[[web_index:render_page("internationalization")]]]
	  </div>
          
	  <div class="right">
	    [[[web_index:render_page("currency")]]]
	  </div>
          
	  <div class="right">
	    [[[web_index:render_page("tax")]]]
	  </div>
        </div> <!-- top-panel end !-->

        <div id="header">
	  <h1>Cookie Cart</h1>  
        </div>

        <div>
          <div id="searchpanel">
	    [[[web_index:render_page("mainsearch")]]]
	  </div>
          
	  <div id="locationpanel">
	    [[[web_index:render_page("location")]]]
	  </div>
        </div>
	
        <div id="sidebar">
          <div class="block">
	    <h3>Cart</h3>
	    [[[web_index:render_page("smallcart")]]]
	  </div>
	  
          <div class="block">
	    <h3>Categories</h3>
	    [[[category:list()]]]
	  </div>
          
	  <div class="block">
	    [[[web_index:render_page("Contactinfo")]]]
	  </div>
        </div> <!-- sidebar end !-->
        
	<div id="content">
	  <h2>[[[product:name()]]]</h2>
	  
	  <div class="column">
	    <img style="width:150px;"
		 src=[[[product:img()]]]/>
	  </div>

	  <div class="column">
	    <strong>Price</strong> price <br/>
	    <strong>Status</strong>status<br/>
	    <strong>Quantity</strong>quantity<br/>
	    buyLink
	  </div>

	  <div class="clear"></div>

	  <h3>Product description</h3>
	  product description
        </div>
        
	<div class="clear"></div>
        
	<div class="text-center">
	  <img src="/themes/default/img/payment_methods.gif" />
	</div>
      </div><!-- container end !-->
      
      <div id="end"></div>
      
      <div id="footer">
        <div id="credits">
       	  Powered by <a href="http://klarna.se/">Cookie Cart</a> - 
       	  <a href="http://www.nitrogenproject.com/">Nitrogen</a> - 
       	  <a href="http://riak.basho.com/">Riak</a> - 
       	  <a href="http://code.google.com/p/mochiweb/">Mochiweb</a> - 
       	</div>
      </div> <!-- footer end !-->
    </div><!-- wrap end !-->
    
    <script>
      [[[script]]]
    </script>

  </body>
</html>
