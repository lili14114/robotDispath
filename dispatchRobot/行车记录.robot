*** Settings ***
Library           Selenium2Library
Resource          线路信息.txt
Resource          公共方法.txt
Library           Collections
Resource          简图调度.txt
Library           RequestsLibrary
Library           CustomLibrary
Resource          通知报表.txt
Resource          车辆路单.txt
Variables         setting.py    183_8074

*** Test Cases ***
1、车辆手动进出站，验证路单状态
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
    sleep    2
    #车辆出左总站
    获取简图车辆更多菜单    @{varLst}[0]    &{dropdown_menuDict}[outSite]    #手动出总站
    sleep    2
    click element    xpath=//button[@id='save']    #对车辆手动“进站”保存    #此时frame停留在domain_frame中
    sleep    2
    #验证车辆生成运行中路单
    @{targetLst}    create list    ${bus_5}[internalNo]    运行中
    @{recordLst}    ${flag}    获取简图下方路单明细并验证结果    @{targetLst}
    Should Be Equal    ${flag}    ${true}    #验证简图下方是否包含此运行中路单
    ${BusrecordStr}    ${BusrecordResultLst}    获取简图_车辆_路单明细并验证结果    ${bus_5}[bustid]
    Should Contain    ${BusrecordStr}    运行中    #验证简图-车辆-路单是否包含此运行中路单
    #关闭路单页面
    click element    xpath=//button[contains(text(),"返回")]    #关闭页面
    #车辆进右总站，结束路单
    @{varLst2}    create list    ${bus_5}[bustid]    default
    车辆手动进站    @{varLst2}
    sleep    2
    #验证车辆生成已完成路单
    @{targetLst}    create list    ${bus_5}[internalNo]    已完成
    @{recordLst}    ${flag}    获取简图下方路单明细并验证结果    @{targetLst}
    Should Be Equal    ${flag}    ${true}    #验证简图下方是否包含此运行中路单
    ${BusrecordStr}    ${BusrecordResultLst}    获取简图_车辆_路单明细并验证结果    ${bus_5}[bustid]
    Should Contain    ${BusrecordStr}    已完成
    #关闭路单页面
    click element    xpath=//button[contains(text(),"返回")]    #关闭页面

2、简图-车辆-路单补录
    #打开简图调度
    #切换简图domain_frame
    获取简图车辆更多菜单index    ${bus_1}[bustid]    &{dropdown_menuDict}[busReport]    -1    #进入简图-车辆-路单页面
    ${departureTime}    运营路单补录
    所有行车记录页面验证结果    ${departureTime}    ${bus_1}

3、简图-行车记录-路单补录
    打开简图调度
    切换简图domain_frame
    进入简图-行车记录
    ${departureTime}    运营路单补录
    所有行车记录页面验证结果    ${departureTime}    ${bus_1}

test
    [Setup]    登陆
    打开简图调度
    切换简图domain_frame
    进入简图-行车记录
    ${departureTime}    Get Mytool Times    hourdelta
    click element    xpath=//span[contains(text(),"运营补录")]    #点击“运营补录”按钮
    #选择车辆
    click element    xpath=//div[@id='bustidID']/button[@data-toggle='dropdown']     #点击车辆编号选择按钮
    sleep    1
    sleep    1
    click element    xpath=//div[@id='drivernameID']/button[@data-toggle='dropdown']    #点击司机名称选择按钮
    sleep    1
    click element    xpath=//div[@class='selectEmpInfoGrid']/div/table/tbody/tr/td/div[@class='grid-body']/div[@class='grid-table-body']/table/tbody/tr/td    #勾选第一个司机
    click element    id=selectEmpInfoGridSave    #保存勾选司机
    input text    xpath=//div[@id='departureTimeID']/input    ${departureTime}    #输入开始时间
    input text    id=mileageID    8.666    #输入载客公里
    input text    id=gpsmileageID    6.8    #输入GPS公里
    input text    id=remarkidID    robot Test    #输入路单备注
    input text    xpath=//div[@id='changeshiftstimeid']/input    12:00    #输入交接班时间
    click element    id=save    #保存路单编辑
    sleep    2
