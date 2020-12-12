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
Variables         setting.py

*** Test Cases ***
1、车辆手动进出站，验证路单状态
    [Documentation]    用例结束后，浏览器停留在简图调度页面，且在简图主frame中
    ...
    ...    手动进出站，验证行车记录状态变更是否正常
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
    ${flag1}    获取简图下方路单明细并验证结果    @{targetLst}
    ${flag2}    获取简图_车辆_路单明细并验证结果    ${bus_5}[bustid]    @{targetLst}
    #关闭路单页面
    click element    xpath=//button[contains(text(),"返回")]    #关闭页面
    #车辆进右总站，结束路单
    @{varLst2}    create list    ${bus_5}[bustid]    default
    车辆手动进站    @{varLst2}
    sleep    2
    #验证车辆生成已完成路单
    @{targetLst}    create list    ${bus_5}[internalNo]    已完成
    ${flag3}    获取简图下方路单明细并验证结果    @{targetLst}
    ${flag4}    获取简图_车辆_路单明细并验证结果    ${bus_5}[bustid]    @{targetLst}
    #关闭路单页面
    click element    xpath=//button[contains(text(),"返回")]    #关闭页面
    #批量验证结果
    ${true}    Convert To Boolean    True    #转换成bool值
    @{flagLst}    create list    ${flag1}    ${flag2}    ${flag3}    ${flag4}
    FOR    ${flag}    IN    @{flagLst}
        Should Be Equal    ${flag}    ${true}    #验证简图下方是否包含此运行中路单
    END

2、简图-车辆-路单补录
    [Documentation]    用例结果后，浏览器停留在“行车记录”菜单页面
    #打开简图调度
    #切换简图domain_frame
    获取简图车辆更多菜单index    ${bus_1}[bustid]    &{dropdown_menuDict}[busReport]    -1    #进入简图-车辆-路单页面
    ${departureTime}    运营路单补录_默认车和线路
    #关闭路单页面
    click element    xpath=//button[contains(text(),"返回")]    #关闭路单页面
    所有行车记录页面验证结果    ${departureTime}    ${bus_1}

3、简图-行车记录-路单补录
    [Documentation]    用例结束后，浏览器停留在行车记录菜单
    #打开简图调度
    #切换简图domain_frame
    回到简图调度
    click element    xpath=//div[contains(text(),"行车记录")]    #点击行车记录按钮
    sleep    7
    ${departureTime}    运营路单补录    ${bus_3}[internalNo]
    回到简图调度    #回到简图调度页面
    所有行车记录页面验证结果    ${departureTime}    ${bus_3}

4、简图-快速补录
    [Documentation]    用例结束后，浏览器停留在“行车记录菜单”
    #打开简图调度
    #切换简图domain_frame
    回到简图调度
    获取简图车辆更多菜单    ${bus_4}[bustid]    &{dropdown_menuDict}[quick_input]
    ${departureTime}    Get Mytool Times    hourdelta
    ${departuretime_new}    Catenate    SEPARATOR=    ${departureTime}    :00
    #选择发车站点
    click element    xpath=//div[@id='siteidbID']/button/span
    click element    xpath=//a[contains(text(),"四中新校区")]
    #选择司机
    click element    xpath=//div[@id='drivernameID']/button[@data-toggle='dropdown']    #点击司机名称选择按钮
    sleep    1
    click element    xpath=//div[@class='selectEmpInfoGrid']/div/table/tbody/tr/td/div[@class='grid-body']/div[@class='grid-table-body']/table/tbody/tr/td    #勾选第一个司机
    click element    id=selectEmpInfoGridSave    #保存勾选司机
    input text    id=testSpanId    5    #输入上下行间隔
    input text    xpath=//input[@onkeyup='InOutTime(this)']    ${departuretime_new}    #输入发车时间
    input text    id=upMileageID    8.666    #输入上行载客公里
    input text    id=downmileageID    5.66    #输入下行载客公里
    input text    id=upgpsmileageID    6.8    #上行GPS公里
    input text    id=downgpsmileageID    7    #下行GPS公里
    input text    id=memoID    robot Test    #备注
    input text    xpath=//input[@data-toggle="itemShow"]    robot edit    #补录和修改原因
    click element    id=save    #保存路单编辑
    sleep    2
    所有行车记录页面验证结果    ${departureTime}    ${bus_4}

5、行车记录-路单补录
    [Documentation]    用例结束后，浏览器停留在“行车记录菜单”
    click element    &{menuDict}[operative_monitor]    #【运营监控】
    #进入行车记录菜单页面
    sleep    6
    ${departureTime}    运营路单补录    ${bus_5}[internalNo]
    回到简图调度
    所有行车记录页面验证结果    ${departureTime}    ${bus_5}

6、行车记录主表与副表详情数值验证
    [Documentation]    用例结束后，浏览器所处“行车记录菜单”
    ...
    ...    待加上判断司机
    ${t}    get_Mytool_times    datedelta    24
    @{vice_resultLst}    create list
    click element    &{menuDict}[operative_monitor]    #【运营监控】
    click element    xpath=//li[@data-mark='menuMark228']    #【行车记录】
    sleep    3
    input text    id=begindateID    ${t}    #检索时间YYYY-MM-DD
    click element    id=search    #查询
    sleep    3
    #获取主表结果
    ${main_result}    get text    xpath=//table[@class="table table-responsive table-bordered table-hover table-striped"]/tbody/tr    #获取主表第一条数据,str类型
    #获取副表结果
    Double Click Element    xpath=//table[@class="table table-responsive table-bordered table-hover table-striped"]/tbody/tr    #双击主表第一条记录
    sleep    1
    @{vice_xpath}    get webelements    xpath=//div[@class="rideInfo secondaryTable"]/div/table/tbody/tr/td/div[@class="grid-body"]/div[@class="grid-table-body"]/table/tbody/tr
    FOR    ${XPATH}    IN    @{vice_xpath}
        ${vice_result}    get text    ${XPATH}
        append to list    ${vice_resultLst}    ${vice_result}
    END
    log many    ${vice_resultLst}
    ${flag1}    main_vice_BusValidation    ${main_result}    ${vice_resultLst}    #判断车牌号和车辆编号
    #判断司机
    ${flag2}    main_vice_DriverValidation    ${main_result}    ${vice_resultLst}    #司机及趟次聚合是否正确
    #判断主表趟次聚合值
    ${flag3}    main_vice_TripNoValidation    ${main_result}    ${vice_resultLst}    #主表趟次聚合是否正确
    ${true}    Convert To Boolean    True    #转换成bool值
    @{flagLst}    create list    ${flag1}    ${flag2}    ${flag3}
    FOR    ${flag}    IN    @{flagLst}
        Should Be Equal    ${flag}    ${true}    #验证简图下方是否包含此运行中路单
    END

test2
    log    ${ip}
    log    ${bus_1}[internalNo]
