#!/usr/bin/env bash

date_en=`cat docs/_site/sitemap.xml`
date_cn=`cat docs/_site/cn/sitemap.xml`
echo $date_en | grep -oP 'https://spacevim[^\<]*' > urls_en.txt
echo $date_cn | grep -oP 'https://spacevim[^\<]*' > urls_cn.txt


curl -H 'Content-Type:text/plain' --data-binary @urls_en.txt "http://data.zz.baidu.com/urls?site=spacevim.org&token=4MYgdYW7QHIaM01P"
curl -H 'Content-Type:text/plain' --data-binary @urls_cn.txt "http://data.zz.baidu.com/urls?site=spacevim.org&token=4MYgdYW7QHIaM01P"
