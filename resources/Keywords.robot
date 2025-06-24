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
    # # Verif Elements bloc nav 
    # Conditions menu nav     Positive
    
    # Log  Page Accueil - vérif logo et quelques éléments de la page : 
    # Vérifier logo   ${Conserto}
    # Verif positive techo   ${postech}   ${Positif_Techo_info} 
    # Verif ilots
    
Page Accueil verif titre 
    [Arguments]     ${Title}  
    Log  Page Accueil - vérif du titre attendu :  
    Verif title   ${Title}



Page d'accueil de Conserto cas 2 
    [Arguments]     ${Title}  
    # Maximize Brows
    
    Log  Page Accueil - vérif titre et éléments du menu nav : 
    Verif title   ${Title}
    # Verif Elements bloc nav 
    Conditions menu nav     Positive
    Verif positive techo2  ${Positif_Techo_info}   ${Clients_texte}

    Log  Page Accueil - vérif logo et quelques éléments de la page : 
    Vérifier logo   ${Conserto}
    # Verif positive techo   ${postech}   ${Positif_Techo_info} 
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


Autres verifs Idnow 
    Barre de Nav Idnow    ${Barre_de_nav_Idnow}    
    Barre de Nav Idnow    ${Barre_de_nav_Idnow2}
    Action nav Idnow      Secteurs   Assurances
    Afficher Tous Les cas     Solutions    ${Solutions}[0]
    
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
    # Capture element screenshot    ${Barre_de_nav}
    Capture Element Et Sauvegarde      ${Barre_de_nav}    Screenshot   nav
    # Element Should Contain     ${Barre_de_nav}    ${Nav_texte}

    Log   2ème méthode de vérif élements du bloc nav : 
    Element Should Contain    ${Barre_de_nav}      ${Positive_texte}   
    Element Should Contain    ${Barre_de_nav}      ${Techo_texte}   
    Element Should Contain    ${Barre_de_nav}      ${Clients_texte}   
    Element Should Contain    ${Barre_de_nav}      ${Academy_texte}   
    Element Should Contain    ${Barre_de_nav}      ${Blog_texte}   
    Element Should Contain    ${Barre_de_nav}      ${Contact_texte}


Verif positive techologie  
    [Arguments]    ${texte}  # ${texte2}
    ${status}    Run Keyword And Return Status    Wait Until Page Contains    ${texte}    10  
    ${text}=    Set Variable   positive technologie   # ${Positif_Techo_info}     # Positive Technologie
    ${textes}=    Set Variable   Positive\nTechnologie
    ${xpath1}=   Set Variable    xpath=//h1[contains(text(), "${Positif_Techo_info}")] 
    ${xpath2}=   Set Variable    xpath=//h1[translate(normalize-space(.), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = '${text}'] 
    ${xpath3}=   Set Variable    xpath=//div[normalize-space(.)="${texte}"] 
    ${xpath4}=   Set Variable    xpath=//div[@class="words-container" and contains(normalize-space(.), "${texte}")]
    ${xpath5}=   Set Variable    xpath=//div[@class="first-word has-primary-color"]
    ${xpath6}=   Set Variable    xpath=//div[@class="second-word has-dark-color"]


    IF    ${status}
        Log    Méthode 1 - On constate bien que "${texte}" est bien visible. 
        Wait Until Page Contains Element    ${xpath1}    20s
        Page Should Contain Element    ${xpath1}
        Wait Until Page Contains Element    ${xpath2}    15s
        
        Log    Méthode 2 - Chercher un div qui a pour texte combiné "Positif Technologie"
        Wait Until Page Contains Element       ${xpath3}     10s
        Capture Element Screenshot     ${xpath3}
        Element Text Should Be    ${xpath3}    ${textes} 


        Log    Méthode 3 - Version robuste (ignorer les espaces multiples, sauts de ligne, etc.)
        Wait Until Page Contains Element       ${xpath4}    10s
        Capture Element Screenshot     ${xpath4}
        Element Text Should Be    ${xpath4}    ${textes} 
        
        Log    Méthode 4 - Vérification des deux sous-éléments séparément
        Element Should Contain    ${xpath5}    ${Posit_texte}      # Positive 
        Element Should Contain    ${xpath6}    ${Tech_texte}       # Technologie

        Log    Méthode 5 - Complets 
        ${part1}=    Get Text    ${xpath5}
        ${part2}=    Get Text    ${xpath6}
        Should Be Equal    ${part1} ${part2}    ${Positif_Techo_info}

    ELSE
        Log   L'élement "${texte}" attendu non trouvé. Tentative de Screenshot.   
        # Run Keyword    Verif positive techo   ${Clients}   ${texte2} 
        # Run Keyword And Ignore Error    Capture Page Screenshot
        Run Keyword And Ignore Error    Capture Page Et Sauvegarde     Screenshot   capture_Absence_PositiveTecho
    END




Verif positive techo
    [Arguments]    ${xpath}    ${texte_attendu} 
    Verifier Titre Visible     ${xpath}    ${texte_attendu}  

Vérifier logo
    [Arguments]    ${xpath_logo}
    Wait Until Element Is Visible    ${xpath_logo}    10
    Page Should Contain Element    ${xpath_logo}
    Capture Element Et Sauvegarde      ${xpath_logo}    Screenshot   logo        

Verifier Titre Visible  
    [Arguments]    ${xpath}    ${texte_attendu}
    Log    méthode réutilisable pour vérifier un texte : 
    Wait Until Element Is Visible    ${xpath}    10
    Element Text Should Be           ${xpath}    ${texte_attendu}   
    Sleep  0.5s
    Log    Extraire et tester dynamiquement : 
    # ${titre}=    Get Text    xpath=${postech}
    ${titre}=    Get Text    ${xpath}
  


Verif ilots
    Wait Until Element Is Visible    ${Positive}    10
    Wait Until Keyword Succeeds    2 x    2 s    Click Element        ${Positive}  
    # Wait Until Keyword Succeeds    2 x    2 s    Vérifier quelques mots avec une boucle 
    Action Scroll   ${footer}      
    Capture Page Et Sauvegarde     Screenshot   capture_footer


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


Nettoyage captures
    [Arguments]    ${destination}=Logs
    Create Directory    ${destination}
    # Move File    output.xml    ${destination}/output.xml
    # Move File    log.html      ${destination}/log.html
    # Move File    report.html   ${destination}/report.html
    Supprimer Captures Selenium



Nettoyer Dossier Logs
    [Arguments]    ${destination}=Logs
    Create Directory    ${destination}
    # Move File    output.xml    ${destination}/output.xml
    # Move File    log.html      ${destination}/log.html
    # Move File    report.html   ${destination}/report.html
    Supprimer Captures Selenium

    
Supprimer Captures Selenium
    ${captures}=    List Files In Directory    ${OUTPUTDIR}    selenium-screenshot-*.png
    FOR    ${f}    IN    @{captures}
        Remove File    ${OUTPUTDIR}/${f}
    END

Nettoyer Dossier Resultats
    [Arguments]    ${destination}=Resultats
    Create Directory    ${destination}
    # Move File    output.xml    ${destination}/output.xml
    # Move File    log.html      ${destination}/log.html
    # Move File    report.html   ${destination}/report.html
    Supprimer Captures Resultats

Supprimer Captures Resultats
    ${captures}=    List Files In Directory    ${OUTPUTDIR}    selenium-element-screenshot-*.png
    FOR    ${f}    IN    @{captures}
        Remove File    ${OUTPUTDIR}/${f}
    END


Nettoyer les captures
    [Arguments]    ${destination}=Conserto-1 
    Create Directory    ${destination}
    # Move File    output.xml    ${destination}/output.xml
    # Move File    log.html      ${destination}/log.html
    # Move File    report.html   ${destination}/report.html
    Supprimer Captures dossier mere 

Supprimer Captures dossier mere 
    ${captures}=    List Files In Directory    ${OUTPUTDIR}    selenium-element-screenshot-*.png
    FOR    ${f}    IN    @{captures}
        Remove File    ${OUTPUTDIR}/${f}
    END


Test navigation fonctionne
    Barre du menu navigation     # Positive
    Culture agile
    Culture Technologie
    Culture Clients 
    Culture Academy
    Culture Blog
    Culture Contact


Barre du menu navigation 
    # [Arguments]    ${texte}
    ${Action_1}=      Run Keyword And Return Status    Wait Until Element Is Visible    ${Mobile_menu}       10  
    ${Action_2}=      Run Keyword And Return Status    Wait Until Page Contains    ${Posit_texte}    10  
    ${Action_3}=      Run Keyword And Return Status    Wait Until Element Is Visible    ${Barre_de_nav}      10
    # ${Action_3}=      Run Keyword And Return Status    Wait Until Keyword Succeeds	    5s	3s    Wait Until Element Is Visible    ${Mobile_menu}      
    # Run Keyword If    ${Action_1}    Barre de Navigation    
    # ...    ELSE IF    ${Action_2}    Verif Elements bloc nav
    # ...    ELSE IF    ${Action_3}    Barre mobile nav    

    Run Keyword If    ${Action_1}    Barre mobile nav         
    ...    ELSE IF    ${Action_2}    Barre de Navigation 
    ...    ELSE IF    ${Action_3}    Verif Elements bloc nav


    # IF  '${texte}'=='***'      
    #     Log    Aucune requête exécutée. 
    # END


Values nav 
    [Arguments]    ${texte}
    ${status}    Run Keyword And Return Status    Wait Until Page Contains    ${texte}    10  
    
    IF    ${status}
        Log    On constate bien que "${texte}" est bien visible.
        Verif Elements bloc nav
    ELSE
        Log    "${texte}" non trouvé. Tentative de chargement de la barre de navigation.    WARN
        Run Keyword    Barre de Navigation
        # Wait Until Page Contains    ${texte}    10
        ${status2}    Run Keyword And Return Status    Wait Until Page Contains    ${texte}    10

            IF    ${status2}
                Log    "${texte}" affiché après chargement de la barre de navigation.
                Run Keyword    Barre mobile nav    
            ELSE
                Log    "${texte}" toujours non visible. Tentative via barre mobile.    WARN
                Run Keyword    Verif Elements bloc nav
            END
    END



Values nav2  
    [Arguments]    ${xpath}   ${xpath2}
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${xpath}       10 
    
    IF    ${status}
        Log    On constate bien que "${xpath}" est bien visible.
        Verif Elements bloc nav
    ELSE
        Log    "${xpath}" non trouvé. Tentative de chargement de la barre de navigation.    WARN
        # Run Keyword    Barre de Navigation
        Run Keyword    Barre mobile nav    
        # Wait Until Page Contains    ${texte}    10
        ${status2}    Run Keyword And Return Status    Wait Until Element Is Visible    ${xpath2}    10

            IF    ${status2}
                Log    "${xpath2}" affiché après chargement de la barre de navigation.
                Run Keyword    Barre mobile nav    
            ELSE
                Log    "${xpath2}" toujours non visible. Tentative via barre mobile.    WARN
                Run Keyword    Barre de Navigation
            END
    END



Barre de Navigation
    ${status}    Run Keyword And Return Status    Element Should Be Visible      ${Barre_de_nav} 
    IF     ${status}
        Log    On constate bien que "${Barre_de_nav}" est bien visible.
        Run Keyword    Nav mode global hors mobile
    ELSE   
        Log    "${Barre_de_nav}" non trouvé. Tentative de chargement de la barre de navigation.    WARN
        Run Keyword    Nav mode global avec mobile
    END


Nav mode global hors mobile 
    # Set Window Size    1280    1024
    # Maximize Browser Window
    # Maximize Brows
    Log   methode 1 :
    Wait Until Element Is Visible    ${Barre_de_nav}      timeout=20s
    Wait Until Keyword Succeeds	    5s	3s      Element Should Be Visible        ${Barre_de_nav}
    Element Attribute Value Should Be    ${Barre_de_nav}    class    nav-main

    Element Should Contain    ${Barre_de_nav}     ${Nav_texte}
    Page Should Contain Element    ${Barre_de_nav}
    Wait For Condition    return document.readyState === 'complete'    timeout=15s
    ${nav_value} =   Get Text    ${Barre_de_nav}
    Log    Valeur récupérée : ${nav_value}
    Log to console    ${nav_value}   

    Log   methode 2 : 
    Wait Until Element Is Visible    xpath=//*[@id="nav-main"]    timeout=15s
    Page Should Contain    Positive
    # Run Keyword And Ignore Error    Capture Page Screenshot
    Capture Page Et Sauvegarde     Screenshot   capture_Positive

    Log   methode 3 : 
    Wait Until Element Is Visible    xpath=//*[@id="nav-main"]    timeout=15s
    Page Should Contain    Positive
    # Run Keyword And Ignore Error    Capture Page Screenshot
    Capture Page Et Sauvegarde     Screenshot   capture_Positive2
    
    Log   methode 4 :
    Log   Screenshot capturée pour analyse
    ${html} =    Get Element Attribute    ${Barre_de_nav}    innerHTML
    Log    Contenu HTML : ${html} 


    # Log   methode 1
    # Wait Until Element Is Visible    ${Barre_de_nav}    timeout=20s
    # Page Should Contain Element    ${Barre_de_nav}
    # Wait For Condition    return document.readyState === 'complete'    timeout=15s
    
    # Log   methode 2
    # # Wait For Condition    return document.readyState === 'complete'    timeout=20s
    # Wait Until Element Is Visible    xpath=//*[@id="nav-main"]    timeout=15s
    # Page Should Contain    Positive
    # Run Keyword And Ignore Error    Capture Page Screenshot

    # Log   methode 3
    # Wait Until Element Is Visible    ${Barre_de_nav}    timeout=10s
    # ${nav_value} =   Get Text    ${Barre_de_nav}
    # Log    Valeur récupérée : ${nav_value}
    # Page Should Contain Element    ${Barre_de_nav}
    # Run Keyword And Ignore Error    Capture Page Screenshot

    # Log   methode 4 : Screenshot capturée pour analyse
    # ${html} =    Get Element Attribute    ${Barre_de_nav}    innerHTML
    # Log    Contenu HTML : ${html}

     
Nav mode global avec mobile
    Log   methode mobile
    Wait Until Element Is Visible    ${Mobile_menu}    timeout=10s
    ${nav_value} =   Get Text    ${Mobile_menu}
    Log    Valeur récupérée : ${nav_value}
    Page Should Contain Element    ${Mobile_menu}
    # Run Keyword And Ignore Error    Capture Page Screenshot
    Capture Page Et Sauvegarde     Screenshot   capture_menu_mobile
    Log    Screenshot capturée pour analyse 

    Log   methode 
    ${html} =    Get Element Attribute    ${Barre_de_nav}    innerHTML
    Log    Contenu HTML : ${html}   
    

Barre mobile nav
    # [Arguments]    ${texte}
    Wait Until Element Is Visible    ${Mobile_menu}      timeout=15s
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Mobile_menu}
    Capture Page Et Sauvegarde     Screenshot   capture_mobile
    # Run Keyword And Ignore Error    Capture Page Screenshot

    Wait Until Element Is Visible    xpath=//nav[@id="nav-main"]      timeout=15s
    Capture Page Et Sauvegarde     Screenshot   capture_nav_mobile
    # Run Keyword And Ignore Error    Capture Page Screenshot
    
    Log    verif 1
    Wait Until Element Is Visible    xpath=//nav[@id="nav-main"]//a      timeout=15s
    ${texte_nav} =    Get Text    xpath=//nav[@id="nav-main"]//a
    Log    Liens de navigation : ${texte_nav}

    Log    verif 2
    Wait Until Element Is Visible    xpath=//nav[@id="nav-main"]//a[text()="Accueil"]      timeout=15s
    ${accueil} =    Get Text    xpath=//nav[@id="nav-main"]//a[text()="Accueil"]
    Log    Texte Accueil : ${accueil}

    Log    verif 3
    Wait Until Element Is Visible    xpath=//nav[@id="nav-main"]    timeout=10s
    Page Should Contain Element      xpath=//nav[@id="nav-main"]
    ${contenu} =    Get Text         xpath=//nav[@id="nav-main"]
    Log    Contenu nav-main : ${contenu}

    Log    verif 4
    ${html} =    Get Element Attribute    xpath=//nav[@id="nav-main"]    innerHTML
    Log    Contenu HTML de nav-main : ${html}

    Log    verif 5 : Récupérer chaque lien un par un
    Wait Until Element Is Visible    xpath=//nav[@id="nav-main"]//a      timeout=15s
    ${link1} =    Get Text    xpath=(//nav[@id="nav-main"]//a)[1]
    ${link2} =    Get Text    xpath=(//nav[@id="nav-main"]//a)[2]
    ${link3} =    Get Text    xpath=(//nav[@id="nav-main"]//a)[3]
    ${link4} =    Get Text    xpath=(//nav[@id="nav-main"]//a)[4]
    ${link5} =    Get Text    xpath=(//nav[@id="nav-main"]//a)[5]
    ${link6} =    Get Text    xpath=(//nav[@id="nav-main"]//a)[6]
    ${link7} =    Get Text    xpath=(//nav[@id="nav-main"]//a)[7]

    # Log    verif 5 : Récupérer tous les liens comme une liste (avec Get WebElements) 
    # @{links} =    Get WebElements    xpath=//nav[@id="nav-main"]//a
    # :FOR    ${el}    IN    @{links}
    # \    ${txt}=    Get Text    ${el}
    # \    Log    Lien : ${txt}

    Log    verif 6 : Recommandation 
    Wait Until Element Is Visible    xpath=//nav[@id="nav-main"]//a[contains(text(), "Accueil")]

    

    

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


 
