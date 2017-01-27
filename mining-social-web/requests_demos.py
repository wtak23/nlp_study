# -*- coding: utf-8 -*-
#%%
import requests
r = requests.get('https://www.python.org',params=None)
print r
print type(r)
print r.status_code
print 'Python is a programming language' in r.content
