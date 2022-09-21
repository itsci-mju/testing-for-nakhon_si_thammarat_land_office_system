*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${AddNew_Url}            http://localhost:8086/TeeDin/addnews
${news_coverphoto}      //input[@id='news_coverphoto']
${news_topics}          //textarea[@id='news_topics']
${news_detail}          //textarea[@id='news_detail']
${news_image1}          //input[@id='news_image1']
${news_image2}          //input[@id='news_image2']
${news_image3}          //input[@id='news_image3']
${Cilk_Button}           //input[@id='ok']
${text_not_alert}         Alert not found in 5 seconds.
${photo_alert_1}         (//*[@data-bv-validator='notEmpty'])[1]
${topics_alert_1}        (//*[@data-bv-validator='notEmpty'])[2]
${topics_alert_2}        (//*[@data-bv-validator='stringLength'])[1]
${detail_alert_1}        (//*[@data-bv-validator='notEmpty'])[3]
${detail_alert_2}        (//*[@data-bv-validator='stringLength'])[2]
${image1_alert_1}        (//*[@data-bv-validator='notEmpty'])[4]
${image2_alert_1}        (//*[@data-bv-validator='notEmpty'])[5]
${image3_alert_1}        (//*[@data-bv-validator='notEmpty'])[6]