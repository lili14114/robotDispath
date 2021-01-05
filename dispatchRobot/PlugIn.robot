*** Settings ***
Library           sshClientLinux    10.200.9.183    root    gzbszx!QAZ!@#
Library           Selenium2Library
Resource          Resource.txt
Variables         setting.py

*** Test Cases ***
test
    ${ls}    link_server    ls
    log    ${ls}

enable_plugIn
    [Documentation]    当插件为禁用时，路单进出站默认为有效
    [Setup]    Wait Until Keyword Succeeds    3x    5s    loginHEC
    #默认手动进出站，路单有效性为”有效
    goToSite    有效
    #启用“路单默认无效”插件功能
    able_plugIn    启用
    goToSite    无效
    #再次禁用插件
    able_plugIn    禁用
    goToSite    有效
    [Teardown]    Login_indexPage    ${ip}

disable_plugIn
    [Setup]    Wait Until Keyword Succeeds    3x    5s    loginHEC
    wait click    xpath=//span[contains(text(),"资源管理")]
    wait click    xpath=//li[@data-title="自定义插件配置"]/a
    wait input    id=jarnameID    有效性    #检索条件输入功能名称
    wait input    id=plugVersionID    20201108
    wait click    id=search    #查询
    wait element    xpath=//span[@data-role="total-record"]
    wait click    xpath=//tr[@data-index="0"]/td/div    #勾选插件
    wait click    xpath=//span[contains(text(),"禁用")]    #启用插件
    wait click    xpath=//button[@data-role="confirmBtn"]    #确认
    wait contains    禁用
    [Teardown]    Login_indexPage    ${ip}
