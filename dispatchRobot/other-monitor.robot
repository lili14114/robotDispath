*** Settings ***
Resource          Resource.txt
Library           Selenium2Library
Library           Collections
Variables         setting.py

*** Test Cases ***
DhPschedulepscreenmng
    [Documentation]    调度屏
    ...    1、验证计划时间是否正确显示
    ...    2、验证左边简图内容是否正确显示
    [Setup]    Wait Until Keyword Succeeds    3x    5s    loginHEC
    @{frame_list}    create list    Iframe0    Iframe1    Iframe2
    @{frameTime_list}    create list    IframeTime0    IframeTime1    IframeTime2
    @{iframe_text}    create list    #用于存储主框架计划时间
    @{iframeTime_text}    create list    #用于存储副框架的计划时间，例如：下一班发车时间
    wait click    &{menuDict}[operative_monitor]    #【运营监控】
    wait click    xpath=//li[@data-mark="menuMark570"]    #【调度屏】
    wait click    xpath=//a[contains(text(),"预览")]    #【预览】
    @{windows}    Get Window Handles    #获取窗口列表
    #switch window    ${windows}[-1]
    ${handle}    Switch Window    NEW    #切换到最新窗口
    FOR    ${frameTime}    IN    @{frameTime_list}    #遍历所有的左边待执行发车计划
        select frame    ${frameTime}
        wait element    xpath=//tr[@id="tip"]
        ${content_time}    get text    xpath=//tr[@id="tip"]    #获取下一步发车时间内容
        Append to list    ${iframeTime_text}    ${content_time}
        unselect frame
    END
    log many    @{iframeTime_text}    #打印左边待发车次信息
    FOR    ${frame}    IN    @{frame_list}    #遍历所有简图的待执行发车计划
        select frame    ${frame}
        wait element    xpath=//div[@id="DownStationList"]
        ${content_time_iframe}    get text    xpath=//div[@id="DownStationList"]
        Append to list    ${iframe_text}    ${content_time_iframe}
        unselect frame
    END
    log many    @{iframe_text}    #打印简图待发车次信息
    ${flag1}    listContain_text    ${iframeTime_text}    下一趟发车时间
    ${flag2}    listContain_text    ${iframe_text}    :
    ${true}    Convert to Boolean    True
    should be equal    ${flag1}    ${true}
    should be equal    ${flag2}    ${true}
    [Teardown]    Login_indexPage    ${ip}
