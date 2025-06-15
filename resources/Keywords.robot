*** Settings ***
Documentation       Les variables globales déclarées ou à appeler
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
   
# Library    Collections
# Library    BuiltIn
# Library    DateTime


# Resource         ../../../Resources/Commun_conserto.robot
# Resource         ../../../Variables/Global_variables.robot





*** Keywords ***

Vérifier la page d'accueil de Conserto 
    # 02 - Verif de quelques éléments de la page d'accueil
    [Arguments]     ${Title}
    Title Should Be   ${Title} 
    Page Should Contain Element     xpath=${Positive_Techo}
    # Click Element  xpath=//a[contains(text(), 'Nous contacter')]
    Sleep  0.5s
    Vérifier quelques mots avec une boucle 



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
    # # Remove Directory    Logs    recursive=True
    # Create Directory    Logs
    [Arguments]    ${destination}=Logs
    Create Directory    ${destination}
    # Move File    output.xml    ${destination}/output.xml
    # Move File    log.html      ${destination}/log.html
    # Move File    report.html   ${destination}/report.html


Navigation fonctionne
    Barre de Navigation
    Culture agile
    Culture Technologie
    Culture Clients 
    Culture Academy
    Culture Blog
    Culture Contact



Barre de Navigation
    Wait Until Element Is Visible    ${Barre_de_nav}      60
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Barre_de_nav} 
    # Capture Element Screenshot    ${Barre_de_nav}   

Culture agile
    Wait Until Element Is Visible    ${Positive}      60
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Positive} 
    Element Should Contain     //p    ${Texte_Positive}
    Page Should Contain       ${Texte_Positive}
    Action Scroll   ${footer}
    Remonter en haut


Culture Technologie
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
