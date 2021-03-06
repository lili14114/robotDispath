*** Settings ***
Force Tags        debug
Library           Selenium2Library
Library           Screenshot
Library           Collections
Library           CustomLibrary
Library           RequestsLibrary
Library           sshClientLinux    10.200.9.183    root    gzbszx!QAZ!@#
Resource          Resource.txt

*** Test Cases ***
add_schduleName
    [Documentation]    添加排班方案
    [Setup]    Wait Until Keyword Succeeds    3x    5s    loginHEC
    wait click    xpath=//span[contains(text(),"智能排班")]    #运营排班
    wait click    xpath=//a[contains(text(),"排班方案")]    #排班方案
    wait click    xpath=//button[contains(text(),"添加")]    #添加
    wait input    xpath=//div[@class="col-lg-9"]/input[@id="plannameID"]    &{resourceInfo}[organname]    #输入方案名称
    wait click    xpath=//button[contains(text(),"保存")]    #保存
    [Teardown]    Login_indexPage    ${ip}

add_scheduleForAdd
    [Documentation]    添加排班模板
    [Setup]    Wait Until Keyword Succeeds    3x    5s    loginHEC
    wait click    xpath=//span[contains(text(),"智能排班")]    #运营排班
    wait click    xpath=//a[contains(text(),"排班模板")]    #排班模板
    FOR    ${i}    IN RANGE    10    200
        ${roadname}    Catenate    SEPARATOR=    37路    ${i}
        wait click    xpath=//button[contains(text(),"添加")]
        wait click    xpath=//fieldset[@id="parameterConfigPanel1"]/div/div/div/div/button[@data-toggle="dropdown"]    #选择线路
        wait input    xpath=//div[@class="selectRoadInfoGrid"]/div/table/thead/tr/th/div[2]/div[2]/input    ${roadname}    #输入线路名称
        wait click    xpath=//div[@class="selectRoadInfoGrid"]/div/table/thead/tr/th/div[2]/div[2]/div    #点击查询
        wait click    xpath=//div[@class="selectRoadInfoGrid"]/div/table/tbody/tr/td/div[@class="grid-body"]/div[@class="grid-table-body"]/table/tbody/tr/td    #勾选第一条记录
        wait click    id=selectRoadInfoGridSave    #保存
        wait input    id=plannameID    &{resourceInfo}[organname]
        wait click    xpath=//div[@class="btn-group selectPlantype"]/button[@data-toggle="dropdown"]    #选择发车方式
        wait click    xpath=//a[contains(text(),"间隔时间先进先出发车（全自动）")]    #全自动模式
        wait click    xpath=//tr[@class="initData"]/td/div/a[@class="box_edit"]    #上行编辑
        wait input    xpath=//input[@class="form-control table_timeInput intervalTime"]    2    #发车间隔
        wait click    xpath=//div[@class="modal-dialog ui-draggable"]/div/div[@class="modal-footer"]/button[@class="btn btn-success save"]    #保存
        wait click    xpath=//div[@class="panel-body panelDownBody"]/table/tbody/tr/td/div/a[@class="box_edit"]    #下行编辑
        wait input    xpath=//input[@class="form-control table_timeInput intervalTime"]    2    #发车间隔
        wait click    xpath=//div[@class="modal-dialog ui-draggable"]/div/div[@class="modal-footer"]/button[@class="btn btn-success save"]    #保存
        wait click    xpath=//button[@class="btn btn-success save"]    #保存
    END

test
    FOR    ${i}    IN RANGE    0    8
    log    ${i}
    END
