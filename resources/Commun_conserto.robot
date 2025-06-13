*** Settings ***
Documentation       keywords tests site conserto
Library    SeleniumLibrary 
Library    OperatingSystem
Library    String


Resource         ../../../resources/Keywords.robot
Resource         ../../../Variables/Global_variables.robot
# Remarques : 
# Si vous devez absolument utiliser Sleep, gardez-le court : exemple : Sleep    0.5s

# Autres recommandations pratiques : Préférez des sélecteurs robustes et explicites, c'est à dire : 
# L’élément a un ID unique	id=...
# Pas d'ID, mais des classes stables	css=...
# L’élément n’a ni ID ni classes	xpath=...
# Besoin de cibler un texte visible	xpath=//button[text()='Connexion']

# Le fichier resources.robot doit contenir	*** Keywords *** et/ou *** Variables ***, mais pas *** Test Cases ***

*** Variables ***

${URL_CONSERTO}         https://conserto.pro/
${Title_1}              Conserto - La Transformation Numérique Agile et Harmonieuse
@{mots_attendus}        ${Title_1}   Dev    DevOps    Infra/Cloud    Agilité    Agence Web    Culture Agile    Positive Technologie
${footer}               id=footer   # xpath=//footer //*[@id="footer"]
${BROWSER}              chrome


*** Keywords ***

############################################
#########  OUVERTURE DU NAVIGATEUR #########

Ouverture Navigateur
    [Arguments]     ${URL}    ${browser} 
    Open Browser    ${URL}    ${browser} 
    AWait Browser Ready And Complete
    Maximize Browser Window
    Sleep   0.5s
    Capture Et Sauvegarde       capture_home 


Vérifier la page d'accueil de Conserto  
    [Arguments]     ${Title}
    Title Should Be   ${Title} 
    # Page Should Contain Element   xpath=//a[contains(text(), 'Nous contacter')]
    
    Page Should Contain Element     xpath=//*[contains(text(), 'Positive') and contains(text(), 'Technologie')]
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

AWait Browser Ready And Complete
    Wait Until Page Is Loaded


Wait Until Page Is Loaded
    Wait Until Keyword Succeeds    10s    1s
    ...    Execute JavaScript    return document.readyState == "complete"


Action Scroll   
    [Arguments]     ${element} 
    Wait Until Keyword Succeeds    2 x    2 s        Wait Until Element Is Visible   ${element}        60
    Scroll Element Into View    ${element}

Capture Et Sauvegarde
    [Arguments]     ${image_name}
    Wait Until Keyword Succeeds    10s    1s    
    ...  Capture Page Screenshot    Screenshot/${image_name}.png 
    # ${dir}=    Catenate    Screenshot
    # Create Directory    ${dir}
    # # Move File    Screenshot    ${destination}/Logs
    # Déplacer un dossier
 

Déplacer un dossier
    [Arguments]    ${source_dossier}=Screenshot   ${destination}=Logs 
    Move Directory    ${source_dossier}    ${destination}

Nettoyer Dossier Logs
    # # Remove Directory    Logs    recursive=True
    # Create Directory    Logs
    [Arguments]    ${destination}=Logs
    Create Directory    ${destination}
    # Move File    output.xml    ${destination}/output.xml
    # Move File    log.html      ${destination}/log.html
    # Move File    report.html   ${destination}/report.html



 
########################################################
##########  ENVOIE DU RAPPORT DE TEST PAR MAIL #########


Envoyer un mail
    email_content = """ibrahima.alata@externe.maif.fr""" % (total_suite, passed_suite, failed_suite, suitepp, total, passed, failed, testpp, total_keywords, passed_keywords, failed_keywords, kwpp, elapsedtime, generator)
    
    msg.set_payload(email_content)
    
    # Start server
    server.starttls()
    
    # Login Credentials for sending the mail
    server.login(msg['From'], password)
    
    server.sendmail(sender, recipients, msg.as_string())








