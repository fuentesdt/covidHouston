from requests import get
from requests.exceptions import RequestException
from contextlib import closing
from bs4 import BeautifulSoup
import json

def simple_get(url):
    """
    Attempts to get the content at `url` by making an HTTP GET request.
    If the content-type of response is some kind of HTML/XML, return the
    text content, otherwise return None.
    """
    try:
        with closing(get(url, stream=True)) as resp:
            if is_good_response(resp):
                return resp.content
            else:
                return None

    except RequestException as e:
        log_error('Error during requests to {0} : {1}'.format(url, str(e)))
        return None


def is_good_response(resp):
    """
    Returns True if the response seems to be HTML, False otherwise.
    """
    content_type = resp.headers['Content-Type'].lower()
    return (resp.status_code == 200 
            and content_type is not None 
            and content_type.find('html') > -1)


def log_error(e):
    """
    It is always a good idea to log errors. 
    This function just prints them, but you can
    make it do anything.
    """
    print(e)

raw_html = simple_get('https://e.infogram.com/df363bec-e9b9-4eea-bee6-418fe93ec0ca')
len(raw_html)

html = BeautifulSoup(raw_html, 'html.parser')
# @thomas-nguyen-3 @pvtruong-mdacc
rawdatascript = html.select('script')[4].contents[0]
jsondata = json.loads(rawdatascript[23:-1])
rawdata = jsondata['elements'][1]['data']



import csv
with open('datatmp.csv', 'w' ) as datafile:
    writer = csv.writer(datafile)
    writer.writerow(['Day','Date'] + rawdata[0][0][1:])
    for iii,idrow in enumerate(rawdata[0]):
      print idrow
      if iii == 19:
        writer.writerow([iii, 'April ' + idrow[0],idrow[1], idrow[2].replace(',','')])
      elif iii > 0:
        writer.writerow([iii, idrow[0],idrow[1], idrow[2].replace(',','')])




