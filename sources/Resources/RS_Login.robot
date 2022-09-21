*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${Login URl}    http://localhost:8086/TeeDin/login
${BROWSER}     chrome
${DELAY}       0.5
${user_locate}      //input[@id='user']
${pass_locate}      //input[@id='pass']
${Login_officer}    //label[contains(text(),'เจ้าหน้าที่')]
${btn_login}        //input[@id='ok']
${text_error}       //label[@style="color: red;"]
${text_page}        //*[contains(text(),"หน้าหลัก")]
${Cilk_LogOut}      //*[contains(text(),"ออกจากระบบ")]
${text_not_alert}       Alert not found in 5 seconds.

*** Keywords ***
OpenWebpageCustomer
    Open Browser  ${Login URl}  ${BROWSER}
    maximize browser window
    Wait Until Element Is Visible   ${user_locate}   30s
    Input Text  ${user_locate}   leena
    Input Password  ${pass_locate}   123456
    Wait Until Element Is Visible  ${btn_login}  30s
    Click Button  ${btn_login}
    Sleep  1s

OpenWebpageOfficer
    Open Browser  ${Login URl}  ${BROWSER}
    maximize browser window
    Click element  ${Login_officer}
    Wait Until Element Is Visible   ${user_locate}   30s
    Input Text  ${user_locate}   user
    Input Password  ${pass_locate}   123456
    Wait Until Element Is Visible  ${btn_login}  30s
    Click Button  ${btn_login}
    Sleep  1s

CloseWebBrowser
    Close Browser
