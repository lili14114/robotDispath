*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           Collections
Library           CustomLibrary
Library           RequestsLibrary
Library           requests

*** Test Cases ***
Login
    Open Browser    http://10.200.9.183:8074/login.koala    Chrome
    sleep    1
    input text    id=j_username    enler
    input text    id=j_password    888888
    input text    id=jCaptchaCode    111111
    click element    id=loginBtn
    sleep    1
    ${cookie}    get cookies    value
    Set Global Variable     ${cookie}
    log    ${cookie}
    sleep    2

Logout
    click element    id=btn1
    click element    xpath=//a[@class='glyphicon glyphicon-off']
    sleep    1

bs_roadinfo
    click element    xpath=//a[@href='#menuMark178']
    sleep    1
    click element    css=li[data-mark='menuMark192']
    sleep    5
    click element    css=tr[data-index='0']>td[index='2']>div[class='btn-group']
    sleep    3
    click element    xpath=/html/body/div[2]/div[3]/div/div/div[2]/div/div/div/table/tbody/tr/td/div[2]/div[2]/table/tbody/tr[1]/td[4]/div/ul/li[1]/a
    sleep    1

closeBrowser
    Close Browser
