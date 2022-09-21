*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${Search_URL}           http://localhost:8086/TeeDin/searchsurvey
${Browser}             chrome
${Select_office}        //select[@id='office_id']
${Survey_number}        //input[@id='urladres']
${Cilck_Search}         //input[@id='ok']
${text_page_search}     //h2[contains(text(),'รังวัดออกโฉนดที่ดินเฉพาะราย : 1/2565')]
${text_message}         //label[@style='color: red;']
${text_not_alert}       Alert not found in 5 seconds.