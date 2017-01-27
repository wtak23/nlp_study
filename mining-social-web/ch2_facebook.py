# -*- coding: utf-8 -*-

#http://nbviewer.jupyter.org/github/ptwobrussell/Mining-the-Social-Web-2nd-Edition/blob/master/ipynb/Chapter%202%20-%20Mining%20Facebook.ipynb

"""
Get api access token from:
https://developers.facebook.com/tools/explorer/

https://developers.facebook.com/docs/graph-api/using-graph-api/#fieldexpansion

Facebook module
$ pip install facebook-sdk
http://facebook-sdk.readthedocs.io/en/latest/api.html
"""

import os
with open(os.path.expanduser('~/.private/FB_ACCESS_TOKEN')) as f:
    ACCESS_TOKEN = f.read()

import requests 
import json

base_url = 'https://graph.facebook.com/me'