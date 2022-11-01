*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${RemoveNews_URL}        http://localhost:8086/TeeDin/listofficerfile
${Cilk_Remove}            (//*[contains(text(),"ลบไฟล์")])[1]
${Page_Remove}              //h2[contains(text(),'รายการประกาศสำคัญทั้งหมด')]
${text_not_alert}         Alert not found in 5 seconds.