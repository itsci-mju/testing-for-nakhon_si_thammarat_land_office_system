*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${UploadFile_Url}         http://localhost:8086/TeeDin/uploadfile
${file_image}             //input[@id='file_image']
${file_Detail}            //textarea[@id='file_Detail']
${file_url}               //input[@id='file_url']
${Cilck_Button}           //input[@id='ok']
${text_not_alert}         Alert not found in 5 seconds.
${Detail_alert_1}         (//*[@data-bv-validator='notEmpty'])[1]
${Detail_alert_2}         (//*[@data-bv-validator='stringLength'])[1]
${file_alert_1}           (//*[@data-bv-validator='notEmpty'])[2]



