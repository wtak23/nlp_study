web-scraping-python
"""""""""""""""""""

.. admonition:: What is this?
   
   Minimal examples/snippets for common python examples

.. contents:: `Contents`
   :depth: 2
   :local:


#######
Lookups
#######

*****************
HTTP Status Codes
*****************

https://en.wikipedia.org/wiki/List_of_HTTP_status_codes

.. rubric:: common HTTP status codes

.. csv-table:: 
    :delim: |

    2xx | **Success**
    200 | **OK**
    3xx | **Redirection**
    4xx | **Client Error**
    400 | **Bad Request**
    401 | **Unauthorized**
    402 | **Payment Required**
    403 | **Forbidden**
    404 | **Not Found**
    5xx | **Server Error**
    500 | **Internal server error**
    502 | **Bad gateway**
    503 | **Service Unavailable**
    504 | **Gateway Time-out** The server was acting as a gateway or proxy and did not receive a timely response from the upstream server


########
requests
########
.. note:: Requests is an HTTP library, written in Python, for human beings. 

.. admonition:: resources
   
    - https://tedboy.github.io/requests/index.html
    - For quick tutorial -- https://tedboy.github.io/requests/official_doc.user.quickstart.html

*******************
My minimal use-case
*******************
I probably only use the ``GET`` request, possibly passing ``params`` option.

Below is my practical use case. If I need more, dig into the official doc.

.. code-block:: python

   >>> import requests
   >>> r = requests.get('https://www.python.org',params=None)
   >>> print r
   <Response [200]>
   >>> print type(r)
   <class 'requests.models.Response'>
   >>> print r.status_code
   200
   >>> # r.text and r.content contains the url codes


- `Response <https://tedboy.github.io/requests/generated/generated/requests.Response.html#requests.Response>`__

  - result from ``requests.get``, ``GET`` request

****************
Ultra-whirl-wind
****************
Below are self-explanatory for me at this point (good for visual refresher by eye-balling the code)

Source: https://tedboy.github.io/requests/official_doc.user.quickstart.html

.. code-block:: python

    # --- 2.1 making requests --- #
    # r  = response object from GET request
    r = requests.get('https://api.github.com/events')
    r.status_code
    #>200
    r.status_code == requests.codes.ok
    #>True

    bad_r = requests.get('http://httpbin.org/status/404')
    bad_r.status_code
    #>404

    bad_r.raise_for_status()
    #>Traceback (most recent call last):
    #>  File "requests/models.py", line 832, in raise_for_status
    #>    raise http_error
    #>requests.exceptions.HTTPError: 404 Client Error

    # HTTP POST/PUT/DELETE/HEAD/OPTIONS request
    r = requests.post('http://httpbin.org/post', data = {'key':'value'})
    r = requests.put('http://httpbin.org/put', data = {'key':'value'})
    r = requests.delete('http://httpbin.org/delete')
    r = requests.head('http://httpbin.org/get')
    r = requests.options('http://httpbin.org/get')

    # --- 2.2 passing URL parameters --- #
    payload = {'key1': 'value1', 'key2': 'value2'}
    r = requests.get('http://httpbin.org/get', params=payload)
    print(r.url)
    #>http://httpbin.org/get?key2=value2&key1=value1

    # you can also pass a list of items as a value
    payload = {'key1': 'value1', 'key2': ['value2', 'value3']}
    r = requests.get('http://httpbin.org/get', params=payload)
    print(r.url)
    #>http://httpbin.org/get?key1=value1&key2=value2&key2=value3

    # --- 2.3 Response Content ---
    r = requests.get('https://api.github.com/events')
    r.text
    #>u'[{"repository":{"open_issues":0,"url":"https://github.com/...
    r.encoding
    #>'utf-8'
    r.encoding = 'ISO-8859-1'  # <- change encoding

    # --- 2.4 Binary Response Content ---
    # You can also access the response body as bytes, for non-text requests:
    r.content
    #>b'[{"repository":{"open_issues":0,"url":"https://github.com/...

    # create an image from binary data returned by a request
    from PIL import Image
    from io import BytesIO
    i = Image.open(BytesIO(r.content))

    # --- 2.5 JSON Response content ---
    # There’s also a builtin JSON decoder, in case you’re dealing with JSON data.
    # In case the JSON decoding fails, r.json() raises an exception.
    # WARNING: Some servers may return a JSON object in a failed response 
    #          Wise to check r.status_code
    r = requests.get('https://api.github.com/events')
    r.json()
    #>[{u'repository': {u'open_issues': 0, u'url': 'https://github.com/...


.. code-block:: python

    >>> # --- 2.11 Response Headers ---
    >>> # server’s response headers can be viewed in a special "case-insensitive" 
    >>> # version of Python dictionary (HTTP HEADER names are case-insensitive by RFC 7230)
    >>> r.headers
    {
        'content-encoding': 'gzip',
        'transfer-encoding': 'chunked',
        'connection': 'close',
        'server': 'nginx/1.0.4',
        'x-runtime': '148ms',
        'etag': '"e1ca502697e5c9317743dc078f67693f"',
        'content-type': 'application/json'
    }

    >>> # case insensitive, so both works
    >>> r.headers['Content-Type']
    'application/json'

    >>> r.headers.get('content-type')
    'application/json'

****
POST
****
- https://tedboy.github.io/requests/qs8.html
- https://tedboy.github.io/requests/qs9.html

.. code-block:: python

    >>> # --- 2.8. More complicated POST requests ---
    >> # to send form-encoded data, pass a dictionary to the ``data`` argument
    >>> payload = {'key1': 'value1', 'key2': 'value2'}
    >>> r = requests.post("http://httpbin.org/post", data=payload)
    >>> print(r.text)
    {
      ...
      "form": {
        "key2": "value2",
        "key1": "value1"
      },
      ...
    }

    >>> # JSON Encoded POST/PATCH data
    >>> import json
    >>> url = 'https://api.github.com/some/endpoint'
    >>> payload = {'some': 'data'}
    >>> r = requests.post(url, data=json.dumps(payload))

    >>> # Instead of encoding the dict yourself, you can also pass it directly 
    >>> #using the json parameter and it will be encoded automatically:
    >>> url = 'https://api.github.com/some/endpoint'
    >>> payload = {'some': 'data'}

    >>> r = requests.post(url, json=payload)

    >>> # --- 2.9 POST a multipart-encoded file
    >>> # Requests makes it simple to upload Multipart-encoded files:
    >>> url = 'http://httpbin.org/post'
    >>> files = {'file': open('report.xls', 'rb')}
    >>> r = requests.post(url, files=files)
    >>> r.text
    {
      ...
      "files": {
        "file": "<censored...binary...data>"
      },
      ...
    }

**************
Authentication
**************
- http://docs.python-requests.org/en/master/user/authentication/
- http://requests-oauthlib.readthedocs.io/en/latest/index.html#

Many web services require authentication, and there are many different types.

.. rubric:: OAuth1

.. code-block:: python

    >>> from requests_oauthlib import OAuth1

    >>> url = 'https://api.twitter.com/1.1/account/verify_credentials.json'
    >>> auth = OAuth1('YOUR_APP_KEY', 'YOUR_APP_SECRET',
    ...               'USER_OAUTH_TOKEN', 'USER_OAUTH_TOKEN_SECRET')

    >>> requests.get(url, auth=auth)
    <Response [200]>

####
json
####
https://docs.python.org/2/library/json.html

http://stackoverflow.com/questions/12309269/how-do-i-write-json-data-to-a-file-in-python

Just know:

- ``json.load`` -- takes file path
- ``json.dump`` 
- ``json.loads`` -- takes string
- ``json.dumps`` 

.. code-block:: python

    import json

    # read from file
    with open('../data/state_hash.json') as data_file:    
        state_hash = json.load(data_file)

    # write to file
    with open('data.txt', 'w') as outfile:
        json.dump(data, outfile)

###############
Random examples
###############

*******************************
Extract us population from wiki
*******************************
I like this as it demonstrates usage of ``json``, ``bs4``, and ``requests``

.. code-block:: python

    import requests
    import json
    from bs4 import BeautifulSoup

    with open('../data/state_hash.json') as data_file:    
        state_hash = json.load(data_file)

    url = 'https://en.wikipedia.org/wiki/List_of_U.S._states_and_territories_by_population'
    source_code = requests.get(url)
    soup = BeautifulSoup(source_code.content)

    # get first table in the page
    table = soup.find('table',class_="wikitable sortable")

    # store state and 2016 population in dict (to be converted to DataFrame at end)
    df_state_popu = OrderedDict(state=[],population=[])
    for row in table.findAll("tr"):
        cells = row.findAll("td")
        if len(cells) == 9:
            _state = cells[2].a.contents[0]
            print _state
            if _state in state_hash_inv:
                # only keep 50 states + DC
                df_state_popu['state'].append(_state)
                df_state_popu['population'].append(int(cells[3].contents[0].replace(',', '')))
            
            # get 52 states (50 + DC)
            if len(df_state_popu['state']) == 51:
                break
    
    df_state_popu = pd.DataFrame(df_state_popu)