*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${Register_URL}                     http://localhost:8086/TeeDin/register
${Browser}                      chrome
${RE_Username}                  //input[@id='username']
${RE_Password}                  //input[@id='password']
${RE_Compassword}               //input[@id='repassword']
${RE_Fristname}                 //input[@id='firstname']
${RE_Lastname}                  //input[@id='lastname']
${RE_Gmail}                     //input[@id='m_email']
${RE_Idcard}                    //input[@id='idcard']
${LOG_FILE}                     //input[@type='file']
${RE_Cilkbutton}                //button[@id='ok']
${text_page}                    //label[@for='tab-1']
${text_not_alert}               Alert not found in 5 seconds.
