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
1、三台车手动进站获取排班
    [Documentation]    测试步骤
    ...    1.总站已有真实的主机车辆获取排班时间，第一、二、三辆车在简图上方，手动进站
    ...    2.观察真实的主机车辆获取的排班时间且是否符合发车间隔的间隔时间
    ...
    ...    期望结果：能正确获取排班时间且获取的排班时间不一样
    [Setup]    登陆
    打开简图调度
    @{bustidLst}    create List    ${bus_1}[bustid]    ${bus_2}[bustid]    ${bus_3}[bustid]
    三台车手动进站获取排班时间    @{bustidLst}

2、对调车位和车辆插队
    [Documentation]    调试车辆插队和车辆对调功能
    ...
    ...    1、两台车辆车依次进总站获取排班时间，
    ...    2、在简图下方的待执行路单右击-车辆对调/插队
    ...    3、确认执行车辆对调和车辆插队前后时间对比
    ...
    ...    期望结果：车辆对调和插队后，排班时间正确交换
    #打开简图调度
    切换简图domain_frame
    @{bustidLst}    create List    ${bus_3}[bustid]    ${bus_4}[bustid]
    车辆手动进站    ${bus_4}[bustid]
    sleep    1
    车辆手动进站    ${bus_3}[bustid]
    sleep    2
    #获取A,B待执行排班时间
    Wait Until Element Is Enabled    ${iframe_line}
    Select Frame    ${iframe_line}
    unselect frame
    @{plantimeList_1}    查询简图监控车辆图标旁待执行排班时间    @{bustidLst}
    #对调车位
    切换简图domain_frame
    获取”待执行“路单更多菜单    &{ImplementtingRecord_menuDict}[exchangeCar]    #获取“对调车位”菜单
    click element    xpath=//li[@id='menu_arr1_exchangeCar']/ul/li/a    #对调车位
    sleep    1
    #获取A,B待执行排班时间
    Wait Until Element Is Enabled    ${iframe_line}
    Select Frame    ${iframe_line}
    unselect frame
    @{plantimeList_2}    查询简图监控车辆图标旁待执行排班时间    @{bustidLst}
    #车辆插队
    切换简图domain_frame
    获取”待执行“路单更多菜单    &{ImplementtingRecord_menuDict}[insertCar]    #获取“车辆插队”菜单
    click element    xpath=//li[@id='menu_arr1_insertCar']/ul/li/a    #车辆插队
    sleep    1
    #获取A,B待执行排班时间
    Wait Until Element Is Enabled    ${iframe_line}
    Select Frame    ${iframe_line}
    unselect frame
    @{plantimeList_3}    查询简图监控车辆图标旁待执行排班时间    @{bustidLst}
    #车辆停运再恢复运营
    @{hostcodeLst}    create List    ${bus_3}[hostcode]    ${bus_4}[hostcode]
    车辆停运再恢复运营    @{hostcodeLst}
    #断言
    should be equal    @{plantimeList_1}[0]    @{plantimeList_2}[1]    #对调车位后，排班时间对调
    lists should be equal    @{plantimeList_1}    @{plantimeList_3}    #插队后，排班时间与最初时间相当，也可以用上面的方法来判断

3、申请非运营指令同意后排班在简图和字轨表和待执行记录是否会取消
    [Documentation]    申请非运营指令同意后排班在简图和字轨表和待执行记录是否会取消
    ...
    ...    1、主机申请非运营指令
    ...    2、确认字轨表和待执行记录是否会取消（验证字轨表和待执行记录的数量是否会减少）
    ...
    ...    期望结果：
    ...    路单数量会减少。
    ...    ${BusoperatrecordCount} >${BusoperatrecordCount_new}
    ...    ${plantimeCount}>${plantimeCount_new} $获取简图调度字轨表中的时间
    @{bustidLst}    create List    ${bus_1}[bustid]    ${bus_2}[bustid]    ${bus_3}[bustid]
    切换简图domain_frame
    FOR    ${bustid}    IN    @{bustidLst}
        车辆手动进站    ${bustid}
    END
    sleep    5
    ${BusoperatrecordCount}    get element count    xpath=//td[contains(text(),"待执行")]    #返回元素的个数，即简图下方待执行路单个数
    获取简图调度字轨表中的排班时间    #获取到字轨表中排班时间数量${plantimeCount}
    #车辆申请停运指令（前提系统已启用自动同意）
    ${dispathJson}    Get Dispath Json    ${bus_1}[hostcode]    6
    ${data}    post request    api    /webservice/rest/dispatch    data=${dispathJson}
    ${result}    To Json    ${data.content}
    should contain    ${result}[error_text]    上报成功
    #重新统计简图待执行路单数量
    sleep    6
    ${BusoperatrecordCount_new}    get element count    xpath=//td[contains(text(),"待执行")]
    sleep    1
    #重新获取字轨表中的排班时间数量
    click element    xpath=//div[contains(text(),'排班间隔')]    #简图上方“排班间隔”
    sleep    1
    ${plantimeCount_new}    get element count    xpath=//label[@style='color:#4c4c4c;']    #返回元素的个数，即字轨表中有多少个排班时间
    click element    xpath=//button[contains(text(),"返回")]    #关闭字轨表页面
    #测试完毕后，将车辆恢复到运营状态
    ${dispathJson}    Get Dispath Json    ${bus_1}[hostcode]    106
    ${data}    post request    api    /webservice/rest/dispatch    data=${dispathJson}
    ${result}    To Json    ${data.content}
    should contain    ${result}[error_text]    上报成功
    #期望结果判断
    Should Be True    ${BusoperatrecordCount}>${BusoperatrecordCount_new}
    Should Be True    ${plantimeCount}>${plantimeCount_new}

4、计划调整正确更改排班时间
    [Documentation]    1.robot4车进站获取到排班时间
    ...    2.进入简图调度-右击-计划调整 ->robot4
    ...    3.车次设置为3，发车间隔为6
    ...    4. 后面的三台车分批次进入
    ...    5.确认三台车是否成功获取排班，且排班间隔为间隔6
    ...
    ...    期望结果：正确获取排班且排班间隔为6. 即${diff}[0]=[6.0,6.0]
    #打开简图调度
    #切换简图domain_frame
    车辆手动进站    ${bus_4}[bustid]
    ${plan_diff}    set variable    6
    #切换简图domain_frame
    获取简图车辆更多菜单    ${bus_4}[bustid]    &{dropdown_menuDict}[adjust_plantime]
    ${plantime}    Get Mytool Times    %H:%M    #生成当前系统时间
    input text    xpath=//input[@id='adjusttimeID']    ${plantime}    #输入当前系统时间
    click element    xpath=//input[@id='toexecbustimeID']    #勾选是否按车次调整间隔
    input text    css=#execcountID    3    #输入车次
    input text    xpath=//input[@id='timeintervalID']    ${plan_diff}    #输入发车间隔
    click element    xpath=//button[@id='save']    #计划调整保存
    #执行至少三台手动进站
    @{bustidLst}    create List    ${bus_1}[bustid]    ${bus_2}[bustid]    ${bus_3}[bustid]
    unselect frame
    三台车手动进站获取排班时间    @{bustidLst}
    ${diff}    get_time_difference    ${plantimeLst}
    log    ${diff}[0]
    should be equal as Numbers    ${diff}[0]    ${plan_diff}    #验证车辆进站后拿到的排班时间按修改后的间隔

5、司机刷卡获取排班时间通知
    [Documentation]    司机刷卡获取排班通知
    ...
    ...    测试步骤：
    ...    1、主机上线
    ...    2、车辆刷卡
    ...    3、用户进入系统”通知报表“
    ...    4、选择37路100，检索 条件为”通知公告“
    ...    5、查询最新的通知信息
    ...
    ...    期望结果：
    ...    最新的通短信内容包含”已完成“字样或”系统暂无此卡信息“
    #司机刷卡查看排班
    ${EmployeJson}    Get DispatchEmployee Json    ${bus_1}[hostcode]    212121213    #司机刷卡报文
    ${data}    post request    api    /webservice/rest/dispatch    data=${EmployeJson}
    ${result}    To Json    ${data.content}
    should contain    ${result}[error_text]    上报成功
    打开通知报表
    #确认报表最新内容是否包含司机刷卡排班通知
    click element    xpath=//div[@data-role='notice_type']/button[@data-toggle='dropdown']    #点击【通知类型”】倒小三角
    sleep    1
    click element    xpath=//a[contains(text(),"通知公告")]    #选择“通知公告”
    sleep    5
    click element    xpath=//span[contains(text(),"37路100")]    #【树形菜单选择37路100】
    click element    xpath=//button[@id='notice_search']    #查询
    sleep    10
    ${content}    get text    xpath=//*[@class='table-responsive']/table/tbody/tr/td/div[2]/div[2]/table/tbody/tr    #通知报表中通知内容中含有“已完成“或”系统暂无此卡信息“
    Should Contain Any    ${content}    已完成    系统暂无此卡信息

6、获取的排班时间能否下发到主机
    [Documentation]    1、车辆上传GPS进总站，获取到排班时间
    ...    2、进入通知报表，查看是否有下发排班通知
    ...
    ...    期望结果：通知报表生成排班通知
    打开通知报表
    click element    xpath=//div[@data-role='notice_type']/button[@data-toggle='dropdown']    #点击【通知类型”】倒小三角
    sleep    1
    click element    xpath=//a[contains(text(),"单发排班")]    #选择“单发排班”
    sleep    6
    click element    xpath=//span[contains(text(),"37路100")]    #【树形菜单选择37路100】
    click element    xpath=//button[@id='notice_search']    #查询
    sleep    3
    click element    xpath=//tr[@data-index='0']    #通知报表有排班时间通知
