*** Settings ***
Library           Selenium2Library
Resource          线路信息.txt
Resource          公共方法.txt
Library           Collections
Resource          简图调度.txt
Library           RequestsLibrary
Library           CustomLibrary
Resource          通知报表.txt
Variables         setting.py    haikouTest

*** Test Cases ***
车辆手动进出站，验证路单状态
    [Documentation]    手动进出站，验证行车记录状态变更是否正常
    ...
    ...    1、车辆进总站
    ...    2、车辆出总站
    ...    3、车辆再进对面总站
    ...
    ...    期望结果：
    ...    第1步，生成待执行路单
    ...    第2步：生成运行中路单
    ...    第3步：生成已完成路单
    ...
    ...    当default传入【车辆手动进总站】关键字时，实现进右总站功能
    ...    当传入的参数非default，实现进左总站功能
    [Setup]    登陆
    打开简图调度
    切换简图domain_frame
    #车辆进左总站
    @{varLst}    create list    ${bus_1}[bustid]    Nodefault
    车辆手动进站    @{varLst}
    #车辆出左总站
    获取简图车辆更多菜单    @{varLst}[0]    &{dropdown_menuDict}[outSite]    #手动出总站
    sleep    1
    click element    xpath=//button[@id='save']    #对车辆手动“进站”保存    #此时frame停留在domain_frame中
    #车辆进右总站，结束路单
    @{varLst2}    create list    ${bus_1}[bustid]    default
    车辆手动进站    @{varLst2}
    sleep    2

test2
    [Setup]    登陆
    打开简图调度
    切换简图domain_frame
    获取简图车辆更多菜单    ${bus_1}[bustid]    &{dropdown_menuDict}[outSite]
    click element    xpath=//div[@id='phrase_templateID']/button[@class='btn btn-default dropdown-toggle']    #点击选择总站小三角按钮
    ${elements}    Get WebElements    xpath=//ul[@role='menu']/li[@class='selected']/a    #直接手动进站，对车辆手动“进站”保存    #此时frame停留在domain_frame中
    click element    ${elements}[1]    #点击第二个站点
    sleep    1
    click element    xpath=//button[@id='save']    #对车辆手动“进站”保存    #此时frame停留在domain_frame中
