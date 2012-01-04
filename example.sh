#!/bin/sh

. martin.sh

get "/" root
root () {
    header "Content-Type" "text/html"
    cat <<EOT
<html>
    <head>
        <title>hello world from $PATH_INFO<title>
    </head>
    <body>
        <img src="/DeanMartin.jpg">
        <h1>hello world from $PATH_INFO</h1>
        <a href="/ps">processes</a>
        <a href="/redirect">redirect</a>
    </body>
</html>
EOT
}

get "/ps" ps_handler
ps_handler () {
    header "Content-Type" "text/plain"
    ps aux
}

get "/DeanMartin.jpg" dean_handler
dean_handler () {
    header "Content-Type" "image/jpeg"
    cat "DeanMartin.jpg"
}

get "/redirect" redirect_handler
redirect_handler () {
    status 302
    header "Location" "http://jackjs.org/"
}

get "/query" query_handler
query_handler() {
    header "Content-Type" "text/plain"
    query_field=${QUERY_STRING%=*}
    query_str=${QUERY_STRING#*=}
    echo "you query field is $query_field, you query_str is $query_str"
    mysql -H -uroot -p137259 -h10.10.93.8 test -e "select comment from bash_test where ${query_field}='${query_str}'"

}

# standalone using the wwwoosh server
wwwoosh_run martin_dispatch 8081

# as a CGI script
#martin_dispatch
