*** Settings ***
Resource          Resource.txt
Library           Selenium2Library
Library           Collections
Variables         setting_8081.py
Library           HttpLibrary.HTTP
Library           CustomPandasLibrary

*** Test Cases ***
add_organ
    [Setup]    Wait Until Keyword Succeeds    3x    5s    Login_retry_koala
    wait click    xpath=//span[contains(text(),"资料管理")]
    wait click    xpath=//a[contains(text(),"机构信息")]
    wait click    xpath=//div[@class="grid-table-body"]/table/tbody/tr/td    #勾选第一个机构 “巴士在线”
    wait click    xpath=//span[contains(text(),"添加")]    #添加
    wait input    xpath=//div[@class="col-lg-8 col-md-8 col-sm-8"]/input[@id="organnameID"]    enler    #机构名称
    wait input    xpath=//div[@id="organtypeID"]//button[@data-toggle="dropdown"]    #选择类型机构
    wait input    xpath=//a[contains(text(),"总公司")] \    #选择总公司
    wait click    xpath=//button[contains(text(),"保存")]    #保存

add_role
    [Setup]    Wait Until Keyword Succeeds    3x    5s    Login_retry_koala
    wait click    xpath=//span[contains(text(),"用户角色管理")]
    wait click    xpath=//a[contains(text(),"角色管理")]
    wait click    xpath=//span[contains(text(),"添加")]    #添加
    wait click    xpath=//div[@id="organidID"]//button[@data-toggle="dropdown"]    #选择机构

test
    [Documentation]    1、创建机构、角色、用户
    ...    例如：用于创建压力测试的机构
    ${data}    Read Csv Data    bs_businfo_zj37_zj_term_5871_gps.db.csv    #D:\\test_tools\\dispath\\dispath\\db\\bs_businfo_zj37_zj_term_5871_gps.db.csv'
    log    ${data}
