*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${RemoveNews_URL}        http://localhost:8086/TeeDin/listofficernews
${Cilk_Remove}              (//*[contains(text(),"ลบประกาศข่าว")])[1]
${text_not_alert}         Alert not found in 5 seconds.