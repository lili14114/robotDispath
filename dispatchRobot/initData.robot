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
    create session    api    ${ip}    ${header}
    #添加机构
    ${urlplay}    ${playLoad}    Add BsOrganization    &{resourceInfo}[organname]
    ${data}    post request    api    ${urlplay}    data=${playLoad}
    Run Keyword If    ${data.status_code}==200    LOG    ${data.content}
    ...    ELSE    LOG    请求失败

addRole
    [Documentation]    添加一级机构
    ${header}    create_webPageLogin    ${ip}    koala    888888
    create session    api    ${ip}    ${header}
    #查询机构
    ${subid}    ${belongto}    searchOrgan
    #添加角色
    ${role_urlplay}    ${role_playload}     Add Auth Role    &{resourceInfo}[organname]    ${subid}
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
    [Documentation]    添加一级机构
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

enler
    #查询机构    \    恢复运营    停运    包车
    ${subid}    ${belongto}    searchOrgan
