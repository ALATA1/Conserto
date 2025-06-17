*** Settings ***
Documentation       keywords tests site conserto
Library    SeleniumLibrary 
Library    OperatingSystem
Library    String


# Resource         ../../../Resources/Keywords.robot
# Resource         ../../../Variables/Global_variables.robot



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
@{textes_attendus}      POSITIVE     TECHNOLOGIE     NOS CLIENTS     ACADEMY     BLOG     CONTACT
${footer}               id=footer   # xpath=//footer //*[@id="footer"]
${CHROME_OPTIONS}       add_argument(--headless)    add_argument(--window-size=1920,1080)
${BROWSER}              chrome
${BROWSER_2}            firefox 
${BROWSER_3}            edge

*** Keywords ***

############################################
#########  OUVERTURE DU NAVIGATEUR #########

Ouverture Navigateur
    # Chargement de la page d'accueil conserto : 
    [Arguments]     ${URL}    ${browser}  
    Open Browser    ${URL}    ${browser}    
    Set Window Size    1920    1080
    # Reload Page 
    AWait Browser Ready And Complete
    Maximize Browser Window
    Sleep   0.5s
    Capture Et Sauvegarde       capture_home 





AWait Browser Ready And Complete
    Wait Until Page Is Loaded


Wait Until Page Is Loaded
    Wait Until Keyword Succeeds    10s    1s
    ...    Execute JavaScript    return document.readyState == "complete"




Capture Et Sauvegarde
    [Arguments]     ${image_name}
    Wait Until Keyword Succeeds    10s    1s    
    ...  Capture Page Screenshot    Screenshot/${image_name}.png
    Sleep   0.5s
    # Wait Until Keyword Succeeds    10s    1s    
    # ...  Capture Page Screenshot    Resultats/${image_name}.png
     
    # ${dir}=    Catenate    Screenshot
    # Create Directory    ${dir}
    # # Move File    Screenshot    ${destination}/Logs
    # Déplacer un dossier
 

Déplacer un dossier
    [Arguments]    ${source_dossier}=Screenshot   ${destination}=Logs 
    Move Directory    ${source_dossier}    ${destination}





 
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








