*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${RemoveQuestion_URL}        http://localhost:8086/TeeDin/listpersonquestions
${Cilk_Remove}              (//*[contains(text(),"ลบคำถาม")])[1]
${text_not_alert}         Alert not found in 5 seconds.