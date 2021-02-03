*** Settings ***
Library           sshClientLinux    10.200.9.183    root    gzbszx!QAZ!@#
Library           Selenium2Library
Resource          Resource.txt

*** Test Cases ***
plugIn_main
    [Setup]    Wait Until Keyword Succeeds    3x    5s    loginHEC
    ${bustidXPATH}    Catenate    SEPARATOR=    css=div[id='    ${bus_1}[bustid]    ']>div[class='bus-body']
    ${requestEmploeeJson}    get dispatchEmployee Json    ${bus_1}[hostcode]    ${employeeCardNo}
    ${request_6}    get dispath json    ${bus_1}[hostcode]    6
    ${request_106}    get dispath json    ${bus_1}[hostcode]    106
    #上传停运
    create webservice    ${ip}
    ${data1}    post request    api    /webservice/rest/dispatch    data=${request_6}
    ${result1}    To Json    ${data1.content}
    should contain    ${result1}[error_text]    上报成功
    sleep    1
    #确认简图车辆颜色为停运红色
    Bs_BusdiagramePage_entry    #进入主frame
    wait BsBusdiagrameViceIframe    #进入副frame
    wait element    xpath=//div[contains(text(),"${bus_1}[internalNo]")]
    ${style}    Get Element Attribute    xpath=//div[contains(text(),"${bus_1}[internalNo]")]    style
    Wait Until Keyword Succeeds    3X    5S    Should Contain    ${style}    rgb(255, 128, 171)
    Login_indexPage    ${ip}
    #激活插件
    able_plugIn    启用
    #司机打卡考勤
    ${data1}    post request    api    /webservice/rest/dispatch    data=${requestEmploeeJson}
    ${result1}    To Json    ${data1.content}
    should contain    ${result1}[error_text]    上报成功
    sleep    1
    #确认简图车辆颜色为恢复运营，为蓝色
    Bs_BusdiagramePage_entry    #进入主frame
    wait BsBusdiagrameViceIframe    #进入副frame
    wait element    xpath=//div[contains(text(),"${bus_1}[internalNo]")]
    ${style}    Get Element Attribute    xpath=//div[contains(text(),"${bus_1}[internalNo]")]    style
    Wait Until Keyword Succeeds    3X    5S    Should Contain    ${style}    rgb(33, 150, 243)
    #结束后，车辆再次上传恢复运营指令
    ${data1}    post request    api    /webservice/rest/dispatch    data=${request_106}
    Login_indexPage    ${ip}
    able_plugIn    禁用
    #车辆申请包车
    ${data1}    post request    api    /webservice/rest/dispatch    data=${request_6}
    #确认简图车辆颜色为停运红色
    Bs_BusdiagramePage_entry    #进入主frame
    wait BsBusdiagrameViceIframe    #进入副frame
    wait element    xpath=//div[contains(text(),"${bus_1}[internalNo]")]
    ${style}    Get Element Attribute    xpath=//div[contains(text(),"${bus_1}[internalNo]")]    style
    Wait Until Keyword Succeeds    3X    5S    Should Contain    ${style}    rgb(255, 128, 171)
    #司机申请考勤
    ${data1}    post request    api    /webservice/rest/dispatch    data=${requestEmploeeJson}
    #确认简图车辆颜色为停运红色
    wait element    xpath=//div[contains(text(),"${bus_1}[internalNo]")]
    ${style}    Get Element Attribute    xpath=//div[contains(text(),"${bus_1}[internalNo]")]    style
    Wait Until Keyword Succeeds    3X    5S    Should Contain    ${style}    rgb(255, 128, 171)
    #车辆恢复运营，测试结束
    ${data1}    post request    api    /webservice/rest/dispatch    data=${request_106}

searchBusinfo
    ${ip}    set variable    http://10.200.9.228:8081
    ${businfoLst}    create list
    ${header}    create_webPageLogin    ${ip}    &{resourceInfo}[organname]    888888
    create session    api    ${ip}    ${header}
    @{internalNoLst}    Create List    robot1    robot2    robot3    robot4    robot5
    FOR    ${internalNo}    IN    @{internalNoLst}
    ${bus_urlPlay}    ${bus_playLoad}    Search Businfo    ${internalNo}
    ${bus_data}    post request    api    ${bus_urlPlay}    data=${bus_playLoad}
    ${bus_result}    To Json    ${bus_data.content}    #将返回值转成字典形式
    log    ${bus_result}
    Append To List    ${businfoLst}    ${bus_result}[data][0]
    END
    log many    ${businfoLst}
    ${bus_1}    create dictionary
    set to dictionary    ${bus_1}    internalno=${businfoLst}[0][internalno]
    set to dictionary    ${bus_1}    bustid=${businfoLst}[0][bustid]
    log    ${bus_1}[internalno]
    log    ${bus_1}[bustid]
