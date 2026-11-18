#!/bin/bash
for c in "$@"; do
 curl -s -m 30 "https://wmsc.lcsc.com/ftps/wm/product/detail?productCode=$c" | python3 -I -c "
import sys,json
try:
    d=json.load(sys.stdin)['result']
    p=[(x['ladder'],x['usdPrice']) for x in d['productPriceList']]
    print('$c',d['productModel'],'|',d['brandNameEn'],'|',d['encapStandard'],'| stock',d['stockNumber'],'| min',d['minBuyNumber'],'|',p[:4])
except Exception as e: print('$c','ERR',e)"
 sleep 1
done
