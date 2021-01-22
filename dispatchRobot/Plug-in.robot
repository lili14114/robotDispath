*** Settings ***
Resource          Resource.txt
Library           Selenium2Library

*** Test Cases ***
test
    sleep    2
    Control Send    打开    ${EMPTY}    [CLASS:Edit; INSTANCE:1]    D:\\dcsdk_eventv3.db    #输入框
    sleep    1
    Control click    打开    ${EMPTY}    Button1    LEFT    #打开按钮
