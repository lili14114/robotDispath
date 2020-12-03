*** Settings ***
Library           Selenium2Library
Resource          线路信息.txt
Resource          公共方法.txt
Library           Collections
Resource          简图调度.txt
Library           RequestsLibrary
Library           CustomLibrary
Resource          通知报表.txt

*** Test Cases ***
1、三台车手动进站获取排班
    [Documentation]    测试步骤
    ...    1.总站已有真实的主机车辆获取排班时间，第一、二、三辆车在简图上方，手动进站
    ...    2.观察真实的主机车辆获取的排班时间且是否符合发车间隔的间隔时间
    ...
    ...    期望结果：能正确获取排班时间且获取的排班时间不一样
    [Setup]    登陆
    打开简图调度进入domain_frame
    切换简图sec_frame
    三台车手动进站获取排班时间

2、获取的排班时间能否下发到主机
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

3、司机刷卡获取排班时间通知
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
    ${EmployeJson}    Get DispatchEmployee Json    &{bus_1}[hostcode]    212121213    #司机刷卡报文
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

4、申请非运营指令同意后排班在简图和字轨表和待执行记录是否会取消
    [Documentation]    申请非运营指令同意后排班在简图和字轨表和待执行记录是否会取消
    ...
    ...    1、主机申请非运营指令
    ...    2、确认字轨表和待执行记录是否会取消（验证字轨表和待执行记录的数量是否会减少）
    ...
    ...    期望结果：
    ...    数量会减少
    打开简图调度进入domain_frame
    ${BusoperatrecordCount}    get element count    xpath=//td[contains(text(),"待执行")]    #返回元素的个数，即简图下方待执行路单个数
    log    ${BusoperatrecordCount}
    获取简图调度字轨表中的排班时间    #获取到字轨表中排班时间数量${plantimeCount}
    #车辆申请停运指令（前提系统已启用自动同意）
    ${dispathJson}    Get Dispath Json    &{bus_1}[hostcode]    6
    ${data}    post request    api    /webservice/rest/dispatch    data=${dispathJson}
    ${result}    To Json    ${data.content}
    should contain    ${result}[error_text]    上报成功
    #重新简图待执行路单数量
    sleep    5
    ${BusoperatrecordCount_new}    get element count    xpath=//td[contains(text(),"待执行")]
    sleep    1
    #重新获取字轨表中的排班时间数量
    click element    xpath=//div[contains(text(),'排班间隔')]    #简图上方“排班间隔”
    sleep    1
    ${plantimeCount_new}    get element count    xpath=//label[@style='color:#4c4c4c;']    #返回元素的个数，即字轨表中有多少个排班时间
    click element    xpath=//button[contains(text(),"返回")]    #关闭字轨表页面
    #期望结果判断
    ${busoperatrecord_result}    Evaluate    ${BusoperatrecordCount}>${BusoperatrecordCount_new}    #比较路单待执行路单是否有减少，如果是则返回True
    ${plantime_result}    Evaluate    ${plantimeCount}>${plantimeCount_new}    #比较排班表中排班时间是否有减少，如果是则返回True
    ${result_1}    convert to string    ${busoperatrecord_result}    #将bool值 转换为string类型
    ${result_2}    convert to string    ${plantime_result}    #将bool值 转换为string类型
    Should Be Equal    ${result_1}    True
    Should Be Equal    ${result_2}    True
    #测试完毕后，将车辆恢复到运营状态
    ${dispathJson}    Get Dispath Json    &{bus_1}[hostcode]    106
    ${data}    post request    api    /webservice/rest/dispatch    data=${dispathJson}
    ${result}    To Json    ${data.content}
    should contain    ${result}[error_text]    上报成功

5、计划调整正确更改排班时间
    [Documentation]    1.robot4车进站获取到排班时间
    ...    2.进入简图调度-右击-计划调整 ->robot4
    ...    3.车次设置为3，发车间隔为6
    ...    4. 后面的三台车分批次进入
    ...    5.确认三台车是否成功获取排班，且排班间隔为间隔6
    ...
    ...    期望结果：正确获取排班且排班间隔为6
    打开简图调度进入domain_frame
    首台车进站
    切换简图sec_frame
    ${plan_diff}    set variable    6
    ${bustidXPATH}    Catenate    SEPARATOR=    css=div[id='    &{bus_4}[bustid]    ']>div[class='bus-body']
    Right Click Element    ${bustidXPATH}    #车辆bustid，右击车辆，系统弹出更多菜单
    sleep    2
    unselect Frame
    Select Frame    &{frame}[domain_frame]
    click element    xpath=//a[contains(text(),"计划调整")]    #定位“计划调整”按钮
    sleep    1
    ${plantime}    Get Mytool Times    %H:%M    #生成当前系统时间
    input text    xpath=//input[@id='adjusttimeID']    ${plantime}    #输入当前系统时间
    click element    xpath=//input[@id='toexecbustimeID']    #勾选是否按车次调整间隔
    input text    css=#execcountID    3    #输入车次
    input text    xpath=//input[@id='timeintervalID']    ${plan_diff}    #输入发车间隔
    click element    xpath=//button[@id='save']    #计划调整保存
    切换简图sec_frame
    #执行至少三台手动进站
    三台车手动进站获取排班时间
    ${diff}    get_time_difference    ${plantimeLst}
    log    ${diff}[0]
    should be equal as Numbers    ${diff}[0]    ${plan_diff}    #验证车辆进站后拿到的排班时间按修改后的间隔

是否支持批量视频配置
    [Documentation]    1、点击【资料管理】
    ...    2、睡眠1秒
    ...    3、点击【线路信息】，进入线路信息页面
    ...    4、睡眠4秒
    ...    5、勾选第一条线路信息
    ...    6、点击【修改】按钮
    ...    7、输入上行首班时间非法格式
    ...    8、点击【保存】
    ...    9、判断系统是否阻止保存并弹出提醒
    打开线路信息页面
    input text    css=#upfirsttimeID>input[type='text']    6:00
    click element    css=#save
    ${title}    Get Title
    Should Not Contain    ${title}    巴士在线

线路信息编辑格式判断
    [Documentation]    1、不填写任何内容进行保存
    ...    2、分别填写某几项必填项，进行保存
    登陆
    打开线路信息页面
    线路信息新增对话框
    click element    css=#save    #不填写任何内容进行保存
    input text    id=roadnameID    robotframeworkTest    #填写线路信息
    click element    css=#save    #保存
    Should Not Contain    ${title}    巴士在线
    click element    id=subidID
    Should Not Contain    ${title}    巴士在线
    input text    css=#upfirsttimeID>input[type='text']    6:00

test2
    [Documentation]    调试车辆插队功能
    [Setup]    登陆
    [Template]    获取”待执行“路单更多菜单
    #获取”待执行“路单更多菜单
    &{ImplementtingRecord_menuDict}[finishRoadPlan]    #将鼠标点击完成路单按钮
