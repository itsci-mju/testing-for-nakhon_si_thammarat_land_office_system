*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${Add_Answer_URL}        http://localhost:8086/TeeDin/questionsdetail/82
${Answer}               //textarea[@id='as_detail']
${Cilk_Button}          //input[@id='ok']
${message_alert}        (//*[@data-bv-validator='stringLength'])[1]
${text_not_alert}         Alert not found in 5 seconds.