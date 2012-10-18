##
# You should look at the following URL's in order to grasp a solid understanding
# of Nginx configuration files in order to fully unleash the power of Nginx.
# http://wiki.nginx.org/Pitfalls
# http://wiki.nginx.org/QuickStart
# http://wiki.nginx.org/Configuration
#
# Generally, you will want to move this file somewhere, and start with a clean
# file but keep this around for reference. Or just disable in sites-enabled.
#
# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
##

server {
	listen   80; ## listen for ipv4; this line is default and implied
	listen   [::]:80 default ipv6only=on; ## listen for ipv6

	root /home/thomas/thomasupton.com/public;
	index index.html index.htm;

	server_name www.thomasupton.com;

    # Rewrite old Wordpress blog urls
    rewrite ^/blog(.*) $scheme://blog.thomasupton.com$1;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to index.html
		try_files $uri $uri/ /index.html;
		# Uncomment to enable naxsi on this location
		# include /etc/nginx/naxsi.rules
	}

	#error_page 404 /404.html;

	# redirect server error pages to the static page /50x.html
	error_page 500 502 503 504 /50x.html;
	location = /50x.html {
		root /usr/share/nginx/www;
	}
}

# Redirect to www.*
server {
    listen 80;
    server_name thomasupton.com;
    return 301 http://www.thomasupton.com$request_uri;
}

