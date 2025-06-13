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
    [Arguments]     ${Title}
    Title Should Be   ${Title} 
    # Page Should Contain Element   xpath=//a[contains(text(), 'Nous contacter')]
    
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


Nettoyer Dossier Logs
    # # Remove Directory    Logs    recursive=True
    # Create Directory    Logs
    [Arguments]    ${destination}=Logs
    Create Directory    ${destination}
    # Move File    output.xml    ${destination}/output.xml
    # Move File    log.html      ${destination}/log.html
    # Move File    report.html   ${destination}/report.html