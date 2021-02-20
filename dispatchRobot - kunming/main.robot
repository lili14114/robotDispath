*** Settings ***
Library           Selenium2Library
Library           CustomLibrary
Library           RequestsLibrary
Resource          Resource.txt
Resource          public_func.txt

*** Test Cases ***
addSchudle
    [Documentation]    简图调度排班间隔-发车间隔，简图调度发车间隔，流水发车台发车间隔保持一致
    ...
    ...    1、制作当天排班
    ...
    [Setup]    Wait Until Keyword Succeeds    3x    5s    loginHEC
    ${yyyy}    ${mm}    ${dd}    Get Time    year,month,day
    wait click    xpath=//span[contains(text(),"智能排班")]    #运营排班
    wait click    xpath=//a[contains(text(),"排班计划")]    #排班计划
    wait input    xapth=//input[@id="billdateID_start"]    ${yyyy}-${mm}-${dd}    #开始时间
    wait input    xapth=//input[@id="newdateID_end"]    ${yyyy}-${mm}-${dd}    #结束时间
    wait click    xpath=//div[@id="searchtimetypeID"]/button[@data-toggle="dropdown"]    #点击查询类型下拉框
    wait click    xpath=//a[contains(text(),"时间有效")]    #时间有效
    wait click    xpath=//button[@id="search"]    #查询
    wait element    xpath=//tr[@data-index="0"]
    Double Click Element    xpath=//tr[@data-index="0"]    #双击排班主表记录
    wait click    xpath=//button[contains(text(),"添加")]    #添加
    wait click    xpath=//div[@id="roadidID"]/button[@data-toggle="dropdown"]    #选择线路
    wait input    xpath=//div[@class="selectRoadInfoGrid"]/div/table/thead/tr/th/div[2]/div[2]/input    ${roadname}    #输入线路名称
    wait click    xpath=//div[@class="selectRoadInfoGrid"]/div/table/thead/tr/th/div[2]/div[2]/div    #点击查询
    wait click    xpath=//div[@class="selectRoadInfoGrid"]/div/table/tbody/tr/td/div[@class="grid-body"]/div[@class="grid-table-body"]/table/tbody/tr/td    #勾选第一条记录
    wait click    id=selectRoadInfoGridSave    #保存
    wait input    id=plannameID    测试
    wait click    xpath=//div[@id="plantypeID"]/button[@data-toggle="dropdown"]ype"]/button[@data-toggle="dropdown"]    #选择发车方式
    wait click    xpath=//a[contains(text(),"间隔时间先进先出发车（全自动）")]    #全自动模式
    wait click    xpath=//a[contains(text(),"更多配置")]    #更多配置
    wait input    xpath=//input[@id="departureintervalID"]    3
    wait click    xpath=//button[@id="save"]    #保存

checkPlanInterval
    [Documentation]    1、分别查询出简图调度排班间隔，简图调度发车间隔，流水发车台发车间隔保持一致
    ...    2、对比这四个发车间隔的值，是否一致
    ...
    ...    期望结果：一致
    ${header}    create_webPageLogin    ${ip}    wubing    888888
    create session    api    ${ip}    ${header}
    #查询线路信息
    #查询线路，获得roadid
    ${road_urlplay}    ${road_playLoad}    search roadinfo    ${roadname}    #查询到线路信息
    ${road_data}    post request    api    ${road_urlplay}    data=${road_playLoad}
    ${road_result}    To Json    ${road_data.content}    #将返回值转成字典形式
    ${roadid}    set variable    ${road_result}[data][0][roadid]    #获取线路ID
    ${belongto}    set variable    ${road_result}[data][0][belongto]    #获取线路belongto
    #查询计划表中billid
    ${index_urlplay}    ${index_playload}    search pagebindexJson
    ${index_data}    post request    api    ${index_urlplay}    data=${index_playload}
    ${index_result}    To Json    ${index_data.content}    #将返回值转成字典形式
    ${billid}    set variable    ${index_result}[data][0][billid]
    #查询排班计划表中的总右总站ID
    ${roadmng_urlplay}    ${roadmng_playload}    search pageRoadmngJson    ${billid}    ${belongto}    ${roadname}
    ${roadmng_data}    post request    api    ${roadmng_urlplay}    data=${roadmng_playload}
    ${roadmng_result}    To Json    ${roadmng_data.content}    #将返回值转成字典形式
    ${beginsiteid}    set variable    ${roadmng_result}[data][0][beginsiteid]    #左总站ID
    ${endsiteid}    set variable    ${roadmng_result}[data][0][endsiteid]    #右总站ID
    #获取简图排班计划中的左总站发车间隔和间隔id号
    ${scheduleTime_urlplay}    ${scheduleTime_playload}    search DhPschedulebtimerange    ${billid}    ${roadid}    ${beginsiteid}
    ${scheduleTime_data}    post request    api    ${scheduleTime_urlplay}    data=${scheduleTime_playload}
    ${scheduleTime_result}    To Json    ${scheduleTime_data.content}    #将返回值转成字典形式
    ${scheduleID}    set variable    ${scheduleTime_result}[data][0][id]    #计划id号
    ${schedule_timeinterval}    set variable    ${scheduleTime_result}[data][0][timeinterval]    #排班计划中发车间隔
    #获取流水发车台发车间隔
    ${currentTime_urlplay}    get CurrentTimeRange    ${roadid}
    ${currentTime_data}    get request    api    ${currentTime_urlplay}
    ${currentTime_result}    To Json    ${currentTime_data.content}    #将返回值转成字典形式
    ${currentTime_timeinterval}    set variable    ${scheduleTime_result}[data][0][timeinterval]    #流水发车台发车间隔
    #判断两个接口的发车间隔要一致
    should be equal    ${schedule_timeinterval}    ${currentTime_timeinterval}

check_monitor
    [Documentation]    简图扳手功能，打开计划执行表开关后，简图下方切换为计划执行表；关闭开关，切换为路单界面
    [Setup]    Wait Until Keyword Succeeds    3x    5s    loginHEC
    wait click    xpath=//span[contains(text(),"运营调度")]    #运营调度
    wait click    xpath=//a[contains(text(),"简图调度")]    #排班计划
    wait input    xpath=//input[@id="treeLayer_key"]    robot    #树形输入线路名
    wait click    xpath=//input[@id="treeLayer_searchBtn"]    #查询
    wait click    xpath=//span[@id="mtLocationRunDiagramTree_90_span"]    #选中robot路
