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
    @{elementsXpath}    create list    &{dropdown_menuDict}[mapGPS]    &{dropdown_menuDict}[roadGPS]    &{dropdown_menuDict}[video]    &{dropdown_menuDict}[roadGPS]    &{dropdown_menuDict}[alarm]
    FOR    ${XPATH}    IN    @{elementsXpath}
    wait BsBusdiagrameViceIframe    #回到副frame，获取更多弹窗
    wait Rightclick    ${bustidXPATH}
    wait BsBusdiagrameIframe    #选择简图主frame
    wait click    ${XPATH}    #点击“线路”按钮
    wait click    xpath=//button[contains(text(),'返回')]    #退回线路监控页面
    END
