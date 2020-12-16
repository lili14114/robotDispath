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
    ${departureTime}    Get Mytool Times    hourdelta
    ${bustidXPATH}    Catenate    SEPARATOR=    css=div[id='    ${bus_1}[bustid]    ']>div[class='bus-body']
    get bsBusdiagrameMenus    ${bustidXPATH} \    #点击车辆弹出更多菜单
    #wait element    &{dropdown_menuDict}[busReport]
    ${elementxpath}    get webelements    &{dropdown_menuDict}[busReport]
    wait click    ${elementxpath}[-1]    #点击车辆“路单”保存
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
    wait click    xpath=//div[@class="modal-body"]/div/div[2]/div/table/tbody/tr/td/div[2]/div/table/tbody/tr/th/div    #勾选第一条记录
    wait click    xpath=//span[contains(text(),"删除")]    #点击删除按钮
    wait click    xpath=//button[contains(text(),"确定")]    #点击确认删除按钮
    wait contains    没有数据
    ${login_ip}    Catenate    SEPARATOR=    ${ip}    /index.koala
    go to    ${login_ip}
