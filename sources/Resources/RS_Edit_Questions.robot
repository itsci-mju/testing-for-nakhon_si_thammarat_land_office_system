*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${Questions_URL}                http://localhost:8086/TeeDin/editquestions/85
${Browser}                      chrome
${EQ_TopQuestion}               //textarea[@id='qt_topics']
${EQ_DetailQuestion}            //textarea[@id='qt_detail']
${Cilk_button}                  //input[@id='ok']
${text_page}                    //label[@for='tab-1']
${text_not_alert}               Alert not found in 5 seconds.
${message_ques_1}               (//*[@data-bv-validator='stringLength'])[1]
${message_ques}                 (//*[@data-bv-validator='notEmpty'])[1]
${message_detail_1}             (//*[@data-bv-validator='stringLength'])[2]
${message_detail}               (//*[@data-bv-validator='notEmpty'])[2]