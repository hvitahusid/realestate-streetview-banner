import time
import urllib2

URL = 'http://gamli.ja.is/kort/search_json/?q=Holtsgata%207,%20101'


def request_time():
    start_time = time.time()
    urllib2.urlopen(URL).read()
    end_time = time.time()
    return end_time - start_time

experiment_start = time.time()

i = 1
while 1:
    try:
        print 'Request #%d took %.5f ms' % (i, request_time() * 1000.0)
        i += 1
        time.sleep(3)
    except Exception as e:
        print e
        time.sleep(20)

experiment_end = time.time()
experiment_time = experiment_end - experiment_start

print 'Experiment ran for %.5f ms' % (experiment_time * 1000.0)
