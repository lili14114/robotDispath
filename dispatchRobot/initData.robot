*** Settings ***
Variables         setting_kunming.py
Resource          Resource.txt
Library           Selenium2Library
Library           HttpLibrary.HTTP
Library           CustomPandasLibrary
Library           CustomLibrary
Resource          public_func.txt

*** Test Cases ***
addOrgan
    [Documentation]    添加一级机构
    ${header}    create_webPageLogin    ${ip}    koala    888888
    ${urlplay}    ${playLoad}    Add BsOrganization    &{resourceInfo}[organname]
    create session    api    ${ip}    ${header}
    ${data}    post request    api    ${urlplay}    data=${playLoad}
    Run Keyword If    ${data.status_code}==200    LOG    ${data.content}
    ...    ELSE    LOG    请求失败

searchOrgan
    ${header}    create_webPageLogin    ${ip}    koala    888888
    set to dictionary    ${header}    Content-Type=application/x-www-form-urlencoded;charset=UTF-8
    set to dictionary    ${header}    X-Requested-With=XMLHttpRequest
    create session    api    ${ip}    ${header}
    #查询机构
    ${urlplay}    ${playLoad}    Search BsOrganization    &{resourceInfo}[organname]
    ${data}    post request    api    ${urlplay}    data=${playLoad}    #查询机构
    ${result}    To Json    ${data.content}
    ${organID}    set variable    ${result}[data][0][id]    #返回机构ID
    #查询角色
    ${search_role_urlPlay}    ${search_role_playLoad}    Search Auth Role PagingQuery    &{resourceInfo}[organname]    &{resourceInfo}[organname]
    ${roleData}    post request    api    ${search_role_urlPlay}    data=${search_role_playLoad}     #查询角色
    ${role_result}    To Json    ${roleData.content}    #将返回值转成字典形式
    ${roleID}    set variable    ${role_result}[data][0][id]    #返回角色ID
    #查询用户
    ${search_user_urlPlay}    ${search_user_playLoad}    Search Auth User PagingQuery    &{resourceInfo}[organname]
    ${userData}    post request    api    ${search_user_urlPlay}    data=${search_user_playLoad}    #查询用户
    ${user_result}    To Json    ${userData.content}    #将返回值转成字典形式
    ${userID}    set variable    ${user_result}[data][0][id]    #返回角色ID
    #查询指令
    ${search_command_urlPlay}    ${search_command_playLoad}    Search DhCommanddeploy
    ${commandData}    post request    api    ${search_command_urlPlay}    data=${search_command_playLoad}     #查询指令
    ${command_result}    To Json    ${commandData.content}    #将返回值转成字典形式
    log    ${command_result}
    ${idLst}    get commandIdLst    ${command_result}
    log    ${idLst}

enler
    @{commandnameLst}    create list    恢复运营    停运    包车
    FOR    ${commandname}    IN    @{commandnameLst}
    LOG    ${commandname}
    END
