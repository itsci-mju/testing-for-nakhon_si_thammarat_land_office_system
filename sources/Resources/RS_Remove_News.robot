*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${RemoveNews_URL}        http://localhost:8086/TeeDin/listofficernews
${Cilk_Remove}              (//*[contains(text(),"ลบประกาศข่าว")])[1]
${Page_Remove}              //h2[contains(text(),'รายการประกาศข่าวของฉัน')]
${text_not_alert}         Alert not found in 5 seconds.