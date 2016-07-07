Prerender
=========

A very simple prerender docker container

# Usage

`docker run --name prerender -p '127.0.0.1:3000:3000' --restart=always interactivesolutions/prerender`

A few things to note, we are binding on 127.0.0.1 which means it's not accessible to remote connections, which is nice, no need for auth. And we also run it with restart always, because well... It's not the most stable project

# Nginx configuration

Just make sure the `proxy_pass` matches the what you have in your run command

```
location / {
    try_files $uri @prerender;
}

location @prerender {

    set $prerender 0;
    if ($http_user_agent ~* "baiduspider|twitterbot|facebookexternalhit|rogerbot|linkedinbot|embedly|quora link preview|showyoubot|outbrain|pinterest|slackbot|vkShare|W3C_Validator") {
        set $prerender 1;
    }

    if ($args ~ "_escaped_fragment_") {
        set $prerender 1;
    }

    if ($http_user_agent ~ "Prerender") {
        set $prerender 0;
    }

    if ($uri ~ "\.(js|css|xml|less|png|jpg|jpeg|gif|pdf|doc|txt|ico|rss|zip|mp3|rar|exe|wmv|doc|avi|ppt|mpg|mpeg|tif|wav|mov|psd|ai|xls|mp4|m4a|swf|dat|dmg|iso|flv|m4v|torrent|ttf|woff)") {
        set $prerender 0;
    }

    if ($prerender = 1) {
        rewrite .* /$scheme://$host$request_uri? break;
        proxy_pass http://127.0.0.1:3000;
    }

    if ($prerender = 0) {
        rewrite .* /index.html break;
    }
}

```
