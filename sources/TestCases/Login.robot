*** Settings ***
Library   DateTime
Library   SeleniumLibrary
Library   Collections
Library   ExcelRobot
Resource  ../Resources/Login_resources.robot

*** Test Cases ***
LoginWebCustomer
    Open Excel  ${EXECDIR}${/}TestData${/}TC02_Login.xlsx
    ${Row}  Get Row Count  TestData
    ${Column}  Get Column Count  TestData
    ${datetime}  Get Current Date  result_format=%Y%m%d%H%M%S
    Open Excel To Write  ${EXECDIR}${/}TestData${/}TC02_Login.xlsx  ${EXECDIR}${/}WriteExcel${/}TC02_Login_${datetime}.xlsx
    FOR  ${index}  IN RANGE  2  ${Row}+1
        ${testcase}  Read Cell Data By Name  TestData  A${index}
        ${username}  Read Cell Data By Name  TestData  B${index}
        ${password}  Read Cell Data By Name  TestData  C${index}
        ${expected}  Read Cell Data By Name  TestData  D${index}
        Set Suite Variable  ${usernameData}  ${username}
        Set Suite Variable  ${passwordData}  ${password}
        Set Suite Variable  ${expectedData}  ${expected}
        Set Suite Variable  ${testcaseData}  ${testcase}
        Login Page
        Check Error Page
        CloseWebBrowser
        Write to Cell By Name  TestData  F${index}  ${status}
        Write to Cell By Name  TestData  E${index}  ${ActualResult}
        Write to Cell By Name  TestData  G${index}  ${messageEr}
        Write to Cell By Name  TestData  H${index}  ${mesSuggestion}
        Save Excel
    END

*** Keywords ***
Login Page
    Open Browser  ${Login URl}  ${BROWSER}
    maximize browser window
    Wait Until Element Is Visible   ${user_locate}   30s
    Input Text  ${user_locate}   ${usernameData}
    Input Password  ${pass_locate}   ${passwordData}
    Wait Until Element Is Visible  ${btn_login}  30s
    Click Button  ${btn_login}


Check Error Page
    ${get_message}   Run keyword and ignore error    Handle Alert
    ${Actual}  Set Variable  ${EMPTY}
    ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${text_error}
    IF  '${checkVisible}' == 'True'
      ${Actual}  Get Text  ${text_error}
    ELSE  '${get_message}' == 'True'
      ${Actual}  Get Text  ${get_message}
    END

    Log To Console  Actual ${Actual}| ${expectedData}

    IF  "${Actual}" == "${expectedData}"
      Set Suite Variable  ${status}  PASSED
      Set Suite Variable  ${messageEr}  -
      Set Suite Variable  ${mesSuggestion}  -
    ELSE
      Set Suite Variable  ${status}  FAILED
      Set Suite Variable  ${messageEr}  Not Found Alert
      Set Suite Variable  ${mesSuggestion}  ควรมีการแจ้งเตือนให้ผู้ใช้งาน "${expectedData}"
      Capture Page Screenshot  ${EXECDIR}/Result/Screenshot/TC02_Login_${testcaseData}.png
    END
    Set Suite Variable  ${ActualResult}  ${Actual}

