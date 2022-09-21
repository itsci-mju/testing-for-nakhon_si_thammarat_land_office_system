*** Settings ***
Library          SeleniumLibrary
Library          DebugLibrary
Library          ExcelLibrary
Library          ScreenCapLibrary

*** Variables ***
${BROWSER}           Chrome
${URL}               http://localhost:8080/Hospital/login
${TIME_WAIT}         5s

*** Test Cases ***
TC01_Login
    Begin Webpage
    Start Video Recording   alias=None   name=TC01_Login   fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document     excel-tc//TC01-Login.xlsx   login
    ${eclin}    Get Sheet   TestData
#    Debug
    FOR  ${i}    IN RANGE   2     ${eclin.max_row+1}
          ${user}        Set Variable if    '${eclin.cell(${i},1).value}'=='None'    ${Empty}     ${eclin.cell(${i},1).value}
          ${password}    Set Variable if    '${eclin.cell(${i},2).value}'=='None'    ${Empty}     ${eclin.cell(${i},2).value}

          Login Page      ${user}      ${password}

          ${Status_1}   ${message_1}  Run Keyword If    ${i}!=${eclin.max_row}    Check Error page      ${eclin.cell(${i},3).value}
          ${Status_2}   ${message_2}  Run Keyword If    ${i}==${eclin.max_row}    Check Home Page
          ${Status}       Set Variable if    ${i}==${eclin.max_row}   ${Status_2}     ${Status_1}
          ${Status}       Set Variable if    '${Status}'=='True'      Pass            Fail
          ${message}       Set Variable if    ${i}==${eclin.max_row}   ${message_2}     ${message_1}
          Write Excel Cell        ${i}    4       value=${message}        sheet_name=TestData
          Write Excel Cell        ${i}    5       value=${Status}        sheet_name=TestData
    END
    Save Excel Document       Result/TC01-Login_result.xlsx
    Close All Excel Documents
    Close All Browsers
    Stop Video Recording      alias=None


*** Keywords ***
Begin Webpage
        Open Browser            ${URL}     ${BROWSER}
        Maximize Browser Window
        Set Selenium Speed      0.3s

Login Page
    [Arguments]   ${user}    ${password}
    Input Text  //input[@id='userId']   ${user}
    Input Text  //input[@id='password']     ${password}
    Click Element    //input[@type='submit']

Check Home Page
    ${Status}   Run Keyword And Return Status   Wait Until Element Is Visible    //*[@id="accordionSidebar"]/a/div[2]
    ${message}  Set Variable if    '${Status}'=='True'      "Login สำเร็จ!"            "Login ไม่สำเร็จ!"
    [Return]   ${Status}  ${message}

Check Error page
    [Arguments]   ${message}
    ${get_message}   Run keyword and ignore error    Handle Alert
    ${Status}  Run Keyword And Return Status    Should Be Equal    ${message}     ${get_message}
    [Return]   ${Status}  ${get_message}[1]