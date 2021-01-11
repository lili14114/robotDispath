*** Settings ***
Resource          Resource.txt
Library           Selenium2Library
Library           Collections
Variables         setting.py

*** Test Cases ***
dropMenu_map
    [Documentation]    验证简图-车辆-更多菜单中的仅查看相关功能是否正确
    [Setup]    Wait Until Keyword Succeeds    3x    5s    loginHEC
    ${bustidXPATH}    Catenate    SEPARATOR=    css=div[id='    ${bus_1}[bustid]    ']>div[class='bus-body']
    #轨迹
    get bsBusdiagrameMenus_first    ${bustidXPATH}    #点击车辆弹出更多菜单
    ${elementxpath}    get webelements    &{dropdown_menuDict}[GPS_history]
    wait click    ${elementxpath}[-1]    #点击“轨迹”，进入轨迹页面
    wait contains    回放日期
    wait click    xpath=//button[contains(text(),'返回')]    #退回页面
    #定位、线路、视频、报警
    @{elementsXpath}    create list    &{dropdown_menuDict}[mapGPS]    &{dropdown_menuDict}[roadGPS]    &{dropdown_menuDict}[video]    &{dropdown_menuDict}[roadGPS]
    FOR    ${XPATH}    IN    @{elementsXpath}
        wait BsBusdiagrameViceIframe    #回到副frame，获取更多弹窗
        wait Rightclick    ${bustidXPATH}
        wait BsBusdiagrameIframe    #选择简图主frame
        wait click    ${XPATH}    #点击“线路”按钮
        wait click    xpath=//button[contains(text(),'返回')]    #退回线路监控页面
    END
    [Teardown]    Login_indexPage    ${ip}

dropMenu_notify
    [Documentation]    验证简图-车辆-更多菜单中"通知“
    ${bustidXPATH}    Catenate    SEPARATOR=    css=div[id='    ${bus_1}[bustid]    ']>div[class='bus-body']
    #轨迹
    get bsBusdiagrameMenus_first    ${bustidXPATH}    #点击车辆弹出更多菜单
    wait click    &{dropdown_menuDict}[notify]    #点击”通知“按钮
    wait click    id=ztreeData_2_switch    #加载树形菜单
    wait input    id=phrase_textID    Notify_robotframework    #输入通知内容
    wait click    id=save    #点击发送按钮
    wait contains    发送成功
    wait click    xpath=//button[contains(text(),"返回")]
    Login_indexPage    ${ip}    #关闭通知对话框
    #通知报表确认结果
    wait click    xpath=//a[@href='#menuMark486']    #【统计报表】
    wait click    xpath=//a[contains(text(),"通知报表")]    #【通知报表】
    wait click    xpath=//span[contains(text(),"31路100")]    #【树形菜单选择37路100】
    ${time}    Get Time
    wait input    id=notice_enddateID    ${time}
    wait click    xpath=//button[@id='notice_search']    #查询
    Wait Until Keyword Succeeds    3x    5s    wait contains    Notify_robotframework
    #测试完毕后，进入数据库清除测试数据
    @{result}    connect_mysql    td_busonlinedisp_haikou_20200610    DELETE FROM dh_mdispatchcommand \ where billdate > '2020-12-16 00:00:00' and \ dh_mdispatchcommand.BusTId='201126142457482' \
    [Teardown]    Login_indexPage    ${ip}

dropMenu_hand_assigh
    [Documentation]    简图-手动代发功能
    [Setup]    Wait Until Keyword Succeeds    3x    5s    loginHEC
    ${bustidXPATH}    Catenate    SEPARATOR=    css=div[id='    ${bus_1}[bustid]    ']>div[class='bus-body']
    get bsBusdiagrameMenus_first    ${bustidXPATH}    #点击车辆弹出更多菜单
    wait element    &{dropdown_menuDict}[hand_assigh]    #等待”代发“"按钮
    Mouse Over    &{dropdown_menuDict}[hand_assigh]    #将鼠标停在代发按钮位置
    wait click    xpath=//a[contains(text(),"恢复营运")]    #点击恢复运营
    #判断车辆在简图的颜色值为rgb(33, 150, 243)
    wait BsBusdiagrameViceIframe
    wait element    xpath=//div[contains(text(),"${bus_1}[internalNo]")]
    ${style}    Get Element Attribute    xpath=//div[contains(text(),"${bus_1}[internalNo]")]    style
    Wait Until Keyword Succeeds    3X    5S    Should Contain    ${style}    rgb(33, 150, 243)
    #代发停运指令
    wait Rightclick    ${bustidXPATH}    #回到更多菜单
    wait BsBusdiagrameIframe    #选择简图主frame
    wait element    &{dropdown_menuDict}[hand_assigh]    #等待”代发“"按钮
    Mouse Over    &{dropdown_menuDict}[hand_assigh]    #将鼠标停在代发按钮位置
    wait click    xpath=//a[contains(text(),"停运")]    #点击停运
    #判断车辆在简图的颜色值为rgb(255, 128, 171)
    wait BsBusdiagrameViceIframe
    wait element    xpath=//div[contains(text(),"${bus_1}[internalNo]")]
    ${style}    Get Element Attribute    xpath=//div[contains(text(),"${bus_1}[internalNo]")]    style
    Wait Until Keyword Succeeds    3X    5S    Should Contain    ${style}    rgb(255, 128, 171)
    #判断车辆图标旁边的中文字是否正确
    ${statusXPATH}    Catenate    SEPARATOR=    xpath=//div[@id='    ${bus_1}[bustid]    ']/span
    wait element    ${statusXPATH}
    ${statusName}    get text    ${statusXPATH}    #获取车辆图标旁边的停运中文字
    Should Contain    ${statusName}    停运
    #代发包车指令
    wait Rightclick    ${bustidXPATH}    #回到更多菜单
    wait BsBusdiagrameIframe    #选择简图主frame
    wait element    &{dropdown_menuDict}[hand_assigh]
    Mouse Over    &{dropdown_menuDict}[hand_assigh]
    wait click    xpath=//a[contains(text(),"包车")]
    #判断车辆在简图的颜色值为rgb(76, 175, 80)
    wait BsBusdiagrameViceIframe
    wait element    xpath=//div[contains(text(),"${bus_1}[internalNo]")]
    ${style}    Get Element Attribute    xpath=//div[contains(text(),"${bus_1}[internalNo]")]    style
    Wait Until Keyword Succeeds    3X    5S    Should Contain    ${style}    rgb(76, 175, 80)
    #判断车辆图标旁边的中文字是否正确
    wait element    ${statusXPATH}
    ${statusName}    get text    ${statusXPATH}    #获取车辆图标旁边的停运中文字
    Should Contain    ${statusName}    包车
    #车辆恢复运营，再确认路单数量，再删除路单
    wait Rightclick    ${bustidXPATH}    #回到更多菜单
    wait BsBusdiagrameIframe    #选择简图主frame
    wait element    &{dropdown_menuDict}[hand_assigh]
    Mouse Over    &{dropdown_menuDict}[hand_assigh]
    wait click    xpath=//a[contains(text(),"恢复营运")]
    #确认路单是否生成了停运等非运营路单
    wait BsBusdiagrameViceIframe    #回到副frame
    wait Rightclick    ${bustidXPATH}
    wait BsBusdiagrameIframe    #选择简图主frame
    ${elementxpath}    get webelements    &{dropdown_menuDict}[busReport]
    wait click    ${elementxpath}[-1]    #点击车辆“路单”，进入路单页面
    @{wait textLst}    create list    包车    停运
    wait contains_list    @{wait textLst}
    #测试完毕后，删掉测试数据
    wait click    xpath=//div[@class="modal-body"]/div/div[2]/div/table/tbody/tr/td/div[2]/div/table/tbody/tr/th/div    #勾选第全部记录
    wait click    xpath=//span[contains(text(),"删除")]    #点击删除按钮
    wait click    xpath=//button[contains(text(),"确定")]    #点击确认删除按钮
    wait contains    没有数据
    [Teardown]    Login_indexPage    ${ip}
