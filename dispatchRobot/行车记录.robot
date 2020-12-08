*** Settings ***
Library           Selenium2Library
Resource          线路信息.txt
Resource          公共方法.txt
Library           Collections
Resource          简图调度.txt
Library           RequestsLibrary
Library           CustomLibrary
Resource          通知报表.txt
Variables         setting.py    '8047'

*** Test Cases ***
test
    log    ${DeviceLst}
