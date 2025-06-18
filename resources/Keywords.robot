*** Settings ***
Documentation       Les variables globales déclarées ou à appeler
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Library    Collections

   
# Library    Collections
# Library    BuiltIn
# Library    DateTime


# Resource         ../../../Resources/Commun_conserto.robot
# Resource         ../../../Variables/Global_variables.robot





*** Keywords ***

Page d'accueil de Conserto 
    [Arguments]     ${Title}  
    Maximize Brows
    Log  Page Accueil - vérif titre et éléments du menu nav : 
    Verif title   ${Title}
    # Verif Elements bloc nav 
    Conditions menu nav     Positive
    
    Log  Page Accueil - vérif logo et quelques éléments de la page : 
    Vérifier logo   ${Conserto}
    Verif positive techo   ${postech}   ${Positif_Techo_info} 
    Verif ilots
    


Verif title 
    [Arguments]     ${Title} 
    ${html}=    Get Source
    FOR    ${titre}    IN    ${Title}
        Should Contain    ${html}    ${titre}
        ${log}=    Set Variable    ${titre}
        Log    ${log}
        Log To console    ${log}   
        Title Should Be   ${Title}
    END


Verif textes page acceuil 
    [Arguments]     ${texte}      ${Texte2}      
    Wait Until Element Is Visible    xpath=//div//p//span[text()='${texte}']      10 
    ${texte_value}=    Get text    xpath=//div//p//span[text()='${texte}'] 
    Wait Until Element Is Visible    xpath=//div//p//span[text()='${texte2}']      10
    ${text_values}=   Get text    xpath=//div//p//span[text()='${Texte2}']
    Wait Until Keyword Succeeds	    5s	3s   Capture Page Screenshot

Verif Elements bloc nav 
    [Arguments]    # ${Posit_texte}   ${Tech_texte}   ${Cli_texte}   ${Aca_texte}   ${Blo_texte}   ${Cont_texte}
    
    Log   1ère méthode de vérif élements du bloc nav :
    Wait Until Element Is Visible    ${Barre_de_nav}      10 
    ${nav_value}=    Get text    ${Barre_de_nav} 
    ${nav_values}=   Get Value    ${Barre_de_nav}
    # Element Should Contain     ${Barre_de_nav}    ${Nav_texte}

    Log   2ème méthode de vérif élements du bloc nav : 
    Element Should Contain    ${Barre_de_nav}      ${Positive_texte}   
    Element Should Contain    ${Barre_de_nav}      ${Techo_texte}   
    Element Should Contain    ${Barre_de_nav}      ${Clients_texte}   
    Element Should Contain    ${Barre_de_nav}      ${Academy_texte}   
    Element Should Contain    ${Barre_de_nav}      ${Blog_texte}   
    Element Should Contain    ${Barre_de_nav}      ${Contact_texte}


Verif positive techo
    [Arguments]    ${xpath}    ${texte_attendu} 
    Verifier Titre Visible     ${xpath}    ${texte_attendu}  

Vérifier logo
    [Arguments]    ${xpath_logo}
    Wait Until Element Is Visible    ${xpath_logo}    10
    Page Should Contain Element    ${xpath_logo}
    Sleep  3s
    Wait Until Keyword Succeeds    2 x    2 s    Capture Element Screenshot    ${xpath_logo}     

Verifier Titre Visible  
    [Arguments]    ${xpath}    ${texte_attendu}
    Log    méthode réutilisable pour vérifier un texte : 
    Wait Until Element Is Visible    ${xpath}    10
    Element Text Should Be           ${xpath}    ${texte_attendu}   
    Sleep  0.5s
    Log    Extraire et tester dynamiquement : 
    ${titre}=    Get Text    xpath=${postech}
  

    
Verif ilots
    Wait Until Keyword Succeeds    2 x    2 s    Vérifier quelques mots avec une boucle 
    Action Scroll   ${footer}      
    Capture Et Sauvegarde     capture_footer


Vérifier quelques mots avec une boucle
    ${html}=    Get Source
    FOR    ${mot}    IN    @{mots_attendus}
        Should Contain    ${html}    ${mot}
        ${log}=    Set Variable    ${mot}
        Log    ${log}
        Log to console      ${log}  
    END



Action Scroll   
    [Arguments]     ${element} 
    Wait Until Keyword Succeeds    2 x    2 s        Wait Until Element Is Visible   ${element}        60
    Scroll Element Into View    ${element} 


Remonter en haut
    Execute JavaScript    window.scrollTo(0, 0)
    Sleep    2s
    Capture Page Screenshot


Nettoyer Dossier Logs
    [Arguments]    ${destination}=Logs
    Create Directory    ${destination}
    # Move File    output.xml    ${destination}/output.xml
    # Move File    log.html      ${destination}/log.html
    # Move File    report.html   ${destination}/report.html


Test navigation fonctionne
    Conditions menu nav     Positive
    Culture agile
    Culture Technologie
    Culture Clients 
    Culture Academy
    Culture Blog
    Culture Contact


Conditions menu nav 
    [Arguments]    ${texte}
    ${Action_1}=      Run Keyword And Return Status    Wait Until Page Contains    ${texte}    10  
    ${Action_2}=      Run Keyword And Return Status    Wait Until Element Is Visible    ${Barre_de_nav}      10
    ${Action_3}=      Run Keyword And Return Status    Wait Until Element Is Visible    ${Mobile_menu}       10
    Run Keyword If    ${Action_1}   Verif Elements bloc nav 
    ...    ELSE IF    ${Action_2}    Barre de Navigation
    ...    ELSE IF    ${Action_2}    Barre mobile nav

    IF  '${texte}'=='***'      
        Log    Aucune requête exécutée. 
    END


Barre de Navigation
    Wait Until Element Is Visible    ${Barre_de_nav}      timeout=15s
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Barre_de_nav} 
    

Barre mobile nav
    [Arguments]    ${texte}
    Wait Until Element Is Visible    ${Mobile_menu}      timeout=15s
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Mobile_menu}
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${texte}


Culture agile
    Maximize Brows
    Barre de Navigation
    Wait Until Element Is Visible    ${Positive}      timeout=15s
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Positive} 
    Element Should Contain     //div    ${Texte_Positive}
    Element Text Should Be    ${Textes_complets_Positive}    ${Texte_Positive}
    Page Should Contain       ${Texte_Positive}
    Action Scroll   ${footer}
    Controle historique conserto
    Remonter en haut
    Maximize Brows



Controle historique conserto
    Wait Until Element Is Visible    ${historique}      timeout=15s
    Wait Until Element Is Visible    ${histo}      timeout=15s
    Wait Until Element Is Visible    ${annees_2013}      timeout=15s
    Page Should Contain       2013
    Wait Until Keyword Succeeds	    5s	3s      Cliquer sur le numero annee    2013    0 
 
    

Cliquer sur le numero annee
    [Arguments]    ${annee}    ${index} 
    Log    Déclaration de variables :  
    ${xpath}=    Set Variable    ${histo}//div[text()="${annee}"]
    ${xpath_element1}=    Set Variable    //div[@class="slider-item" and @data-index="${index}"] 
    ${xpath_element2}=    Set Variable    div/div[2]/div[@class='timeline-item__content'] 
    ${xpath_infos}=    Set Variable    ${xpath_element1}/${xpath_element2}
    Log    Pointer sur l'année : 
    Scroll Element Into View    xpath=${xpath}
    Wait Until Keyword Succeeds	    5s	3s      Click Element     xpath=${xpath}
    Log    Infos elements pointé : 
    Wait Until Element Is Visible    xpath=${xpath_infos}      10
    ${2013_value}=    Get text    ${xpath_infos}
    Sleep    3s
    Wait Until Keyword Succeeds	    5s	3s    Capture Element Screenshot    ${xpath_infos}

Info annee 2013
    [Arguments]    ${index}
    # ${xpath}=    Set Variable    (//*[text()="2013"])[${index}]  
    ${xpath_element1}=    Set Variable    //div[@class="slider-item" and @data-index="${index}"] 
    ${xpath_element2}=    Set Variable    div/div[2]/div[@class='timeline-item__content'] 
    ${xpath_infos}=    Set Variable    ${xpath_element1}/${xpath_element2}    #//div[@class="slider-item" and @data-index="${index}"]/div/div[2]/div[@class='timeline-item__content'] 
    Wait Until Element Is Visible    xpath=${xpath_infos}      10
    Wait Until Keyword Succeeds	    5s	3s    Capture Element Screenshot    ${xpath_infos}
    # Wait Until Element Is Visible    ${Info_2013}      60
    # Capture Element Screenshot    ${Info_2013}




Culture Technologie
    Barre de Navigation
    Wait Until Element Is Visible    ${Technologie}      60
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Technologie}


Culture Clients
    Wait Until Element Is Visible    ${Clients}      60
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Clients}


Culture Academy
    Wait Until Element Is Visible    ${Academy}      60
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Academy}


Culture Blog
    Wait Until Element Is Visible    ${Blog}      60
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Blog}


Culture Contact
    Wait Until Element Is Visible    ${Contact}      60
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Contact}



Page d'accueil Idnow 
    [Arguments]     ${Title}  
    # Maximize Brows
    Log  Page Accueil - vérif titre et éléments du menu nav : 
    Verif title Idnow   ${Title}
    # # Verif Elements bloc nav 
    # Conditions menu nav     Positive
    
    # Log  Page Accueil - vérif logo et quelques éléments de la page : 
    # Vérifier logo   ${Conserto}
    # Verif positive techo   ${postech}   ${Positif_Techo_info} 
    # Verif ilots


Barre de Nav Idnow
    [Arguments]     ${xpath}
    Scroll Element Into View    ${xpath}
    Sleep    3s 
    AWait Browser Ready And Complete
    Affichage et actualisation     ${xpath} 
    Run Keyword And Continue On Failure    Wait Until Element Is Visible    ${xpath}      timeout=30s
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${xpath}
    Wait Until Keyword Succeeds	    5s	3s      Capture Element Screenshot    ${xpath}

Affichage et actualisation 
    [Arguments]     ${xpath}
    Wait Until Page Contains Element    //body    timeout=10s

    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${xpath}    timeout=60s
    ${visible}=    Run Keyword And Return Status    Element Should Be Visible    ${xpath}

    Run Keyword If    not ${visible}    Reload Page
    Wait Until Element Is Visible    ${xpath}    timeout=60s


Action nav Idnow
    [Arguments]     ${texte}   ${element}
    Wait Until Element Is Visible    xpath=//nav//span[text()='${texte}']
    Mouse Over    xpath=//nav//span[text()='${texte}']
    Wait Until Element Is Visible    xpath=//a//span[text()='${element}']    timeout=5
    Wait Until Keyword Succeeds	    5s	3s   Click Element    xpath=//a//span[text()='${element}']
    Wait Until Keyword Succeeds	    5s	3s   Capture Page Screenshot  

Afficher Tous Les cas 
    [Arguments]     ${service}   @{element}
    ${premier}=    Set Variable    ${element}[0]
    # ${dernier}=    Set Variable    ${element}[-1]
    FOR    ${service}    IN    @{element} 
        Log    élément : ${service}
        Log    Le premier élément est : ${premier}
        Capture Page Screenshot
    END


 
