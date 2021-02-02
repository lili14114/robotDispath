*** Settings ***
Resource          Resource.txt
Library           CustomLibrary
Library           RequestsLibrary
Resource          pulic_func.txt

*** Test Cases ***
addOrgan
    ${header}    create_webPageLogin    ${ip}    koala    888888
    create session    api    ${ip}    ${header}
    #添加机构
    ${urlplay}    ${playLoad}    Add BsOrganization    &{resourceInfo}[organname]
    ${data}    post request    api    ${urlplay}    data=${playLoad}
    Run Keyword If    ${data.status_code}==200    LOG    ${data.content}
    ...    ELSE    LOG    请求失败

addRole
    ${header}    create_webPageLogin    ${ip}    koala    888888
    create session    api    ${ip}    ${header}
    #查询机构
    ${subid}    ${belongto}    searchOrgan
    #添加角色
    ${role_urlplay}    ${role_playload}    Add Auth Role    &{resourceInfo}[organname]    ${subid}
    ${role_data}    post request    api    ${role_urlplay}    data=${role_playload}
    Run Keyword If    ${role_data.status_code}==200    LOG    ${role_data.content}
    ...    ELSE    LOG    请求失败
    #查询角色
    ${roleID}    searchRole
    #角色授权菜单
    ${authMenu_urlplay}    ${authMenu_playload}    Api Auth Menu FindAllMenusTreeByConditions    ${roleID}
    ${authMenu_data}    post request    api    ${authMenu_urlplay}    data=${role_playload}
    Run Keyword If    ${authMenu_data.status_code}==200    LOG    ${authMenu_data.content}
    ...    ELSE    LOG    请求失败
    #角色授权页面元素
    ${authRole_urlplay}    ${authRole_playloadLst}    Api Auth Role GrantPageElementResourcesToRole    ${roleID}
    FOR    ${authRole_playload}    IN    @{authRole_playloadLst}
        ${authRole_data}    post request    api    ${authRole_urlplay}    ${authRole_playload}
        Run Keyword If    ${authRole_data.status_code}==200    LOG    ${authRole_data.content}
        ...    ELSE    LOG    请求失败
    END

addUser
    ${header}    create_webPageLogin    ${ip}    koala    888888
    create session    api    ${ip}    ${header}
    #查询机构
    ${subid}    ${belongto}    searchOrgan
    #查询角色
    ${roleID}    searchRole
    #添加用户
    ${user_urlplay}    ${user_playload}    Add Auth User    &{resourceInfo}[organname]    ${subid}
    ${user_data}    post request    api    ${user_urlplay}    ${user_playload}
    Run Keyword If    ${user_data.status_code}==200    LOG    ${user_data.content}
    ...    ELSE    LOG    请求失败
    #查询用户
    ${userID}    searchUser
    #用户分配机构
    ${userToOrgan_urlplay}    ${userToOrgan_playload}    Api DhBlineassignOrgan BlineassignOrgan    ${userID}    ${subid}
    ${userToOrgan_data}    post request    api    ${userToOrgan_urlplay}    ${userToOrgan_playload}
    Run Keyword If    ${userToOrgan_data.status_code}==200    LOG    ${userToOrgan_data.content}
    ...    ELSE    LOG    请求失败
    #用户分配角色
    ${userToRole_urlplay}    ${userToRole_playload}    Api Auth User GrantRolesToUser    ${userID}    ${roleID}
    ${userToRole_data}    post request    api    ${userToRole_urlplay}    ${userToRole_playload}
    Run Keyword If    ${userToRole_data.status_code}==200    LOG    ${userToRole_data.content}
    ...    ELSE    LOG    请求失败

grantToRole
    [Documentation]    如果已成功授权菜单，再次授权，会导致取消授权菜单
    [Setup]    Wait Until Keyword Succeeds    3x    5s    LoginHEC_koala
    wait click    xpath=//span[contains(text(),"用户角色管理")]    #用户角色管理
    wait click    xpath=//li[@data-title="角色管理"]    #角色管理
    wait input    xpath=//input[@name="name"]    &{resourceInfo}[organname]    #输入角色名称
    wait click    xpath=//button[@id="roleManagerSearch"]    #查询
    wait click    xpath=//div[@data-role="selectAll"]    #勾选角色
    wait click    xpath=//button[contains(text(),"分配菜单资源")]    #分配菜单资源
    wait element    xpath=//ul[@class="resourceTree tree"]/div/input
    ${elementscount}    get element count    xpath=//ul[@class="resourceTree tree"]/div/input
    @{elements}    get webelements    xpath=//ul[@class="resourceTree tree"]/div/input
    log    ${elementscount}
    FOR    ${element}    IN    @{elements}
        wait click    ${element}
    END
    wait click    xpath=//button[contains(text(),"保存")]    #保存
    wait click    xpath=//button[contains(text(),"分配页面元素资源")]    #分配页面元素资源
    FOR    ${i}    IN RANGE    0    3
        wait click    xpath=//div[@data-role="roleGrantPageGrid"]/div/table/thead/tr/th/div/button    #分配页面元素
        wait element    xpath=//div[@id="selectPageGrid"]/div/table/tfoot/tr/td/div/div/span[@data-role="total-record"]
        ${total_record}    get text    xpath=//div[@id="selectPageGrid"]/div/table/tfoot/tr/td/div/div/span[@data-role="total-record"]
        Exit For Loop if    ${total_record}==0    #终止循环
        wait click    xpath=//div[@id="selectPageGrid"]/div/table/tbody/tr/td/div[@class="grid-body"]/div/table/tbody/tr/th/div[@data-role="selectAll"]    #勾选当前页所有的元面元素
        wait click    xpath=//button[contains(text(),"保存")]    #保存
    END

add_commandID
    [Documentation]    添加指令
    ${header}    create_webPageLogin    ${ip}    &{resourceInfo}[organname]    888888
    create session    api    ${ip}    ${header}
    #查询机构
    ${subid}    ${belongto}    searchOrgan
    #添加指令
    ${urlplay}    ${playLoadLst}    Add DhCommanddeploy    ${subid}
    FOR    ${playLoad}    IN    @{playLoadLst}
    ${data}    post request    api    ${urlplay}     data=${playLoad}
    Run Keyword If    ${user_data.status_code}==200    LOG    ${data.content}
    ...    ELSE    LOG    请求失败
    END
    #查询指令
    ${command_urlplay}    ${command_playLoad}    Search DhCommanddeploy
    ${command_data}    post request    api    ${command_urlplay}    data=${command_playLoad}
    ${commandidLst}    get response valueLst    ${command_data}    id
    #对指令批量同意操作
    FOR    ${id}    IN    ${commandidLst}
    ${command_urlplay}    update DhCommanddeploy     ${id}
    ${command_data}    post request    api    ${command_urlplay}
    Run Keyword If    ${command.status_code}==200    LOG    ${data.content}
    ...    ELSE    LOG    请求失败
    end

rewriteSQLFile
    #查询机构
    ${subid}    ${belongto}    searchOrgan
    Replace Sql Dispath    D:\\test_tools\\Bus_Server_5871_37路_基本资料    ${belongto}    ${subid}    &{resourceInfo}[organname]    #批量修改sql，执行完毕后修改后的sql，将存储在该目标下。获取修改后，可通过Navicat执行

addBusinfo
    ${header}    create_webPageLogin    ${ip}    &{resourceInfo}[organname]    888888
    create session    api    ${ip}    ${header}
    ${index}    set variable    0    #控制每条线路加50台车，如果超过50台，跳出当前线路循环
    ${start}    set variable    0    #控制加每条线路时，其CSV表的行数开始位置
    FOR    ${i}    IN RANGE    1    200
    #查询线路，获得roadid
    ${str_i}    Convert To String    ${i}
    ${roadname}    Catenate    SEPARATOR=    37路    ${str_i}    #拼接线路名
    ${data}    search roadinfo    ${roadname}    #查询到线路信息
    ${roadid}    set variable    ${data}[roadid]
    FOR    ${j}    IN RANGE    ${start}    10000
        Exit For Loop if    ${index}==50    #终止当前循环
    #获取车辆数据
        ${internalNo}    ${hostcode}    ${busplate}    ${length}    read csv file    ${j}
        ${urlPlay}    ${playLoad}    addBusinfo    ${internalNo}    ${hostcode}    ${busplate}    ${roadid}    ${roadname}
        ${response}    post request    api    ${urlPlay}    data=${playLoad}
        Run Keyword If    ${data.status_code}==200    LOG    ${data.content}
        ...    ELSE    LOG    请求失败
        sleep    0.2
    END
    END
