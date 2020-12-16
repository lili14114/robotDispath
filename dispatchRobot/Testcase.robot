*** Settings ***
Library           Selenium2Library
Library           Collections
Library           String
Resource          Resource.txt
Variables         setting.py

*** Test Cases ***
create bsRecord_bsBusdiagrame_bus
    [Documentation]    简图-车辆路单-运营路单补录
    ...    测试步骤：
    ...    1、登陆网站，进入运营监控-简图调度
    ...    2、右击某台车辆，获取更多菜单
    ...    3、点击更多菜单中的“路单”按钮，进入路单页面
    ...    4、点击“运营补录”，系统弹出行车记录编辑对话框
    ...    5、输入内容，并保存路单。确认是否成功补录路单并显示在页面当中
    ...
    ...    期望结果：
    ...    路单成功补录并显示在行车记录页面当中
    ...
    ...    测试完毕
    ...    删除测试数据
    ...    重新刷新页面，退回首页
    ...
    [Setup]    Wait Until Keyword Succeeds    3x    5s    loginHEC
    ${departureTime}    DepartTime
    ${bustidXPATH}    Catenate    SEPARATOR=    css=div[id='    ${bus_1}[bustid]    ']>div[class='bus-body']
    get bsBusdiagrameMenus    ${bustidXPATH}    #点击车辆弹出更多菜单
    #wait element    &{dropdown_menuDict}[busReport]
    ${elementxpath}    get webelements    &{dropdown_menuDict}[busReport]
    wait click    ${elementxpath}[-1]    #点击车辆“路单”，进入路单页面
    wait click    xpath=//span[contains(text(),"运营补录")]    #点击“运营补录”按钮
    #选择司机
    wait click    xpath=//div[@id='drivernameID']/button[@data-toggle='dropdown']    #点击司机名称选择按钮
    wait click    xpath=//div[@class='selectEmpInfoGrid']/div/table/tbody/tr/td/div[@class='grid-body']/div[@class='grid-table-body']/table/tbody/tr/td    #勾选第一个司机
    wait click    id=selectEmpInfoGridSave    #保存勾选司机
    wait input    xpath=//div[@id='departureTimeID']/input    ${departureTime}    #输入开始时间
    wait input    id=mileageID    8.666    #输入载客公里
    wait input    id=gpsmileageID    6.8    #输入GPS公里
    wait input    id=remarkidID    robot Test    #输入路单备注
    wait input    xpath=//div[@id='changeshiftstimeid']/input    12:00    #输入交接班时间
    wait click    id=save    #保存路单编辑
    wait contains    ${departureTime}
    #测试完毕后，删掉测试数据
    wait click    xpath=//div[@class="modal-body"]/div/div[2]/div/table/tbody/tr/td/div[2]/div/table/tbody/tr/th/div    #勾选第全部记录
    wait click    xpath=//span[contains(text(),"删除")]    #点击删除按钮
    wait click    xpath=//button[contains(text(),"确定")]    #点击确认删除按钮
    wait contains    没有数据
    ${login_ip}    Catenate    SEPARATOR=    ${ip}    /index.koala
    go to    ${login_ip}

create bsRecord_bsBusdiagrame_quickAdd
    [Documentation]    简图-车辆-快速补录
    ...    测试步骤：
    ...    1、登陆网站，进入运营监控-简图调度
    ...    2、右击某台车辆，获取更多菜单
    ...    3、点击更多菜单中的“快速补录”按钮，进入快速补录页面
    ...    4、系统弹出行车记录编辑对话框
    ...    5、输入内容，并保存路单。确认是否成功补录路单并显示简图下方页面
    ...
    ...    期望结果：
    ...    路单成功补录并显示简图下方页面当中
    ...
    ...    测试完毕
    ...    进入-简图-车辆-路单-删除测试数据
    ...    重新刷新页面，退回首页
    ...
    ${departureTime}    DepartTime
    ${departuretime_new}    Catenate    SEPARATOR=    ${departureTime}    :00
    ${bustidXPATH}    Catenate    SEPARATOR=    css=div[id='    ${bus_1}[bustid]    ']>div[class='bus-body']
    get bsBusdiagrameMenus    ${bustidXPATH} \    #点击车辆弹出更多菜单
    wait click    xpath=//div[contains(text(),"行车记录")]    #点击行车记录按钮
    wait click
    #选择司机
    wait click    xpath=//div[@id='drivernameID']/button[@data-toggle='dropdown']    #点击司机名称选择按钮
    wait click    xpath=//div[@class='selectEmpInfoGrid']/div/table/tbody/tr/td/div[@class='grid-body']/div[@class='grid-table-body']/table/tbody/tr/td    #勾选第一个司机
    wait click    id=selectEmpInfoGridSave    #保存勾选司机
    wait click    css=#siteideID>[data-toggle="dropdown"]    #选择终到站点
    wait click    xpath=//div[@id='siteideID']/ul/li/a    #终到站点-选择线路起点站
    wait input    id=testSpanId    5    #输入上下行间隔
    wait input    xpath=//input[@onkeyup='InOutTime(this)']    ${departuretime_new}    #输入发车时间
    wait input    id=upMileageID    8.666    #输入上行载客公里
    wait input    id=downmileageID    5.66    #输入下行载客公里
    wait input    id=upgpsmileageID    6.8    #上行GPS公里
    wait input    id=downgpsmileageID    7    #下行GPS公里
    wait input    id=memoID    robot Test    #备注
    wait input    xpath=//input[@data-toggle="itemShow"]    robot edit    #补录和修改原因
    wait click    id=save    #保存路单编辑
    wait contains    ${departureTime}
    #测试完毕后，删掉测试数据 --进入车辆路单页面
    ${login_ip}    Catenate    SEPARATOR=    ${ip}    /index.koala
    go to    ${login_ip}
    get bsBusdiagrameMenus    ${bustidXPATH}    #点击车辆弹出更多菜单
    #wait element    &{dropdown_menuDict}[busReport]
    ${elementxpath}    get webelements    &{dropdown_menuDict}[busReport]
    wait click    ${elementxpath}[-1]    #点击车辆“路单”，进入路单页面
    #-删除数据，并返回主页
    wait click    xpath=//div[@class="modal-body"]/div/div[2]/div/table/tbody/tr/td/div[2]/div/table/tbody/tr/th/div    #勾选第全部记录
    wait click    xpath=//span[contains(text(),"删除")]    #点击删除按钮
    wait click    xpath=//button[contains(text(),"确定")]    #点击确认删除按钮
    wait contains    没有数据
    go to    ${login_ip}

create bsRecord_bsBusdiagrame
    [Documentation]    简图-行车记录-运营路单补录
    ...    测试步骤：
    ...    1、登陆网站，进入运营监控-简图调度
    ...    2、进入行车记录页面
    ...    3、点击“运营补录”，系统弹出行车记录编辑对话框
    ...    4、输入内容，并保存路单。确认是否成功补录路单并显示在页面当中
    ...
    ...    期望结果：
    ...    路单成功补录并显示在行车记录页面当中
    ...
    ...    测试完毕
    ...    删除测试数据
    ...    重新刷新页面，退回首页
    ...
    [Setup]    Wait Until Keyword Succeeds    3x    5s    loginHEC
    ${departureTime}    DepartTime
    ${bustidXPATH}    Catenate    SEPARATOR=    css=div[id='    ${bus_1}[bustid]    ']>div[class='bus-body']
    Bs_BusdiagramePage_entry    #进入简图调度页面
    wait click    xpath=//div[contains(text(),"行车记录")]    #进入“行车记录”
    wait click    xpath=//span[contains(text(),"运营补录")]    #点击“运营补录”按钮
    #选择线路
    wait click    xpath=//div[@id='roadidID']/button[@data-toggle='dropdown']    #点击线路编号选择按钮
    wait click    xpath=//div[@class='selectRoadInfoGrid']/div/table/tbody/tr/td/div[@class='grid-body']/div[@class='grid-table-body']/table/tbody/tr/td    #勾选第一个线路编号
    wait click    id=selectRoadInfoGridSave    #保存路单编辑
    #选择车辆
    wait click    xpath=//div[@id='bustidID']/button[@data-toggle='dropdown']    #点击车辆编号选择按钮
    wait click    xpath=//div[@class='selectBusInfoGrid']/div/table/tbody/tr/td/div[@class='grid-body']/div[@class='grid-table-body']/table/tbody/tr/td    #勾选第一个车辆
    wait click    id=selectBusInfoGridSave    #保存选择
    #选择司机
    wait click    xpath=//div[@id='drivernameID']/button[@data-toggle='dropdown']    #点击司机名称选择按钮
    wait click    xpath=//div[@class='selectEmpInfoGrid']/div/table/tbody/tr/td/div[@class='grid-body']/div[@class='grid-table-body']/table/tbody/tr/td    #勾选第一个司机
    wait click    id=selectEmpInfoGridSave    #保存勾选司机
    wait input    xpath=//div[@id='departureTimeID']/input    ${departureTime}    #输入开始时间
    wait input    id=mileageID    8.666    #输入载客公里
    wait input    id=gpsmileageID    6.8    #输入GPS公里
    wait input    id=remarkidID    robot Test    #输入路单备注
    wait input    xpath=//div[@id='changeshiftstimeid']/input    12:00    #输入交接班时间
    wait click    id=save    #保存路单编辑
    #查看明细--查询目标车辆
    wait click    xpath=//span[contains(text(),'更多查询')]    #点击行车记录主表更多查询
    wait click    //div[@id="bustidID"]/span    #选择车辆
    wait click    xpath=//div[@class='selectBusInfoGrid']/div/table/tbody/tr/td/div[@class='grid-body']/div[@class='grid-table-body']/table/tbody/tr/td    #勾选第一个车辆
    wait click    id=selectBusInfoGridSave    #保存选择
    #查看明细--获取副表
    wait Doubleclick    xpath=//div[@class='rideInfo main_grid']/div/table/tbody/tr/td/div[@class='grid-body']/div[@class='grid-table-body']/table/tbody/tr    #双击主表记录
    wait contains    ${departureTime}
    #测试完毕后，删掉测试数据
    wait click    xpath=//div[@class="rideInfo secondaryTable"]/div/table/tbody/tr/td/div[@class="grid-body"]/div/table/tbody/tr/th    #勾选第全部记录
    wait click    xpath=//div[@class="rideInfo secondaryTable"]/div/table/thead/tr/th/div/button/span[@class="glyphicon glyphicon-remove"]    #点击删除按钮
    wait click    xpath=//button[contains(text(),"确定")]    #点击确认删除按钮
    wait contains    没有数据
    ${login_ip}    Catenate    SEPARATOR=    ${ip}    /index.koala
    go to    ${login_ip}
