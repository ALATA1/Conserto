*** Settings ***
Documentation       Les variables globales déclarées ou à appeler
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
   
# Library    Collections
# Library    BuiltIn
# Library    DateTime



# Resource         ../../../Resources/Commun_conserto.robot
# Resource         ../../../Resources/Keywords.robot





*** Variables ***

${Conserto}                    //a[@class="hdr-logo-link" and @rel="home"]
${Positive_Techo}              //*[contains(text(), 'Positive') and contains(text(), 'Technologie')]    
${Barre_de_nav}                //nav[@id="nav-main" and @class="nav-main"]    #id=submit-button     # //*[@id="nav-main"]
# xpath=//nav[@id="nav-main" and .//h2[text()="Offre spéciale"]]
# //button[@id="darwin-zra-menubar" and @class="darwin-zra-menubar"]
${Positive}                    //a[contains(text(),"Positive")]
${Texte_Positive}              Nous pensons que la technologie doit avoir un impact positif sur l’avenir de tous.
${Technologie}                 //a[contains(text(),"Technologie")]
${Clients}                     //a[contains(text(),"Nos clients")]
${Academy}                     //a[contains(text(),"Academy")]
${Blog}                        //a[contains(text(),"Blog")]
${Contact}                     //a[contains(text(),"Contact")]