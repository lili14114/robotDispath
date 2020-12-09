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
Resource          车辆路单.txt

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
    @{varLst}    create list    ${bus_5}[bustid]    Nodefault
    ${true}    Convert To Boolean    True    #转换成bool值
    车辆手动进站    @{varLst}
    sleep    1
    #车辆出左总站
    获取简图车辆更多菜单    @{varLst}[0]    &{dropdown_menuDict}[outSite]    #手动出总站
    sleep    1
    click element    xpath=//button[@id='save']    #对车辆手动“进站”保存    #此时frame停留在domain_frame中
    #验证车辆生成运行中路单
    @{targetLst}    create list    ${bus_5}[internalNo]    已完成
    @{recordLst}    ${flag}    获取简图下方路单明细并验证结果    @{targetLst}
    Should Be Equal    ${flag}    ${true}    #验证简图下方是否包含此运行中路单
    ${BusrecordStr}    ${BusrecordResultLst}    获取简图_车辆_路单明细    ${bus_5}[bustid]
    Should Contain    ${BusrecordStr}    运行中    #验证简图-车辆-路单是否包含此运行中路单
    #关闭路单页面
    click element    xpath=//button[contains(text(),"返回")]    #关闭页面
    #车辆进右总站，结束路单
    @{varLst2}    create list    ${bus_5}[bustid]    default
    车辆手动进站    @{varLst2}
    sleep    2
    #验证车辆生成已完成路单
    ${BusrecordStr}    ${BusrecordResultLst}    获取简图_车辆_路单明细    ${bus_5}[bustid]
    Should Contain    ${BusrecordStr}    已完成
    #关闭路单页面
    click element    xpath=//button[contains(text(),"返回")]    #关闭页面

test2
    #打开简图调度
    #切换简图domain_frame
    @{recordLst}    get webelements    xpath=//table[@class='table table-responsive table-bordered table-hover table-striped' and @style='width: 2130px;']/tbody/tr    #查询简图下方所有的路单

test
    ${testLst}    create list    运行中,日班    运行中
    ${valueLst}    create list    运行中
    ${result}    should Contain multiValue    ${testLst}    ${valueLst}
    log    ${result}
