*** Settings ***
Documentation       keywords tests site conserto
Library    SeleniumLibrary 
Library    OperatingSystem
Library    String
Library    Collections


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

${CHROME OPTIONS}       add_argument=--headless  add_argument=--disable-gpu

${URL_IDNOW}            https://www.idnow.io/
${Title_Idnow}          IDnow - La confiance au cœur de l'identité.
${Title2_Idnow}         La confiance au cœur de l'identité.



*** Keywords ***

############################################
#########  OUVERTURE DU NAVIGATEUR #########

Ouverture Navigateur 
    # # Chargement de la page d'accueil conserto : 
    # [Arguments]     ${URL}    # ${browser}  
    # Open Browser    ${URL}    chrome   # edge   chrome  # options=${CHROME OPTIONS}      
    # # Maximize Brows
    # # Set Window Size    1920    1080
    # Maximize Browser Window
    # Capture Et Sauvegarde       capture_home 
    
    
    Log     Ouverture avec Headless modules mode 
    [Arguments]     ${URL}
    ${HEADLESS}=    Get Environment Variable    HEADLESS    false

    Log     Crée l'objet ChromeOptions
    # ${options}=    Create List
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys

    Log     Si HEADLESS = true, ajoute les bons arguments
    Run Keyword If    '${HEADLESS}' == 'true'    Call Method    ${options}    add_argument    --headless
    Run Keyword If    '${HEADLESS}' == 'true'    Call Method    ${options}    add_argument    --disable-gpu

    Log     Ouvre le navigateur avec les options configurées
    # Run Keyword If    '${HEADLESS}' == 'true'    Append To List    ${options}    add_argument(--headless)    add_argument(--disable-gpu)
    Open Browser    ${URL}    ${BROWSER}    options=${options}
    # Set Window Size    1280    1024
    # Maximize Brows
    Maximize Browser Window
    Sleep    1s
    Capture Page Screenshot


Lancer Chrome Selon Environnement
    [Arguments]     ${URL}    
    ${os}=    Get Operating System
    Run Keyword If    '${os}' == 'Windows'    Ouvrir Chrome Normal
    Run Keyword Unless    '${os}' == 'Windows'    Ouvrir Chrome Headless
    Go To    ${URL}
    Wait Until Page Contains Element    //body    timeout=15s
    Capture Page Screenshot
    [Teardown]    Close Browser 


Lancer Chrome En Headless
    [Arguments]     ${URL}
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --window-size=1920,1080
    Open Browser    ${URL}    chrome    options=${options}
    Maximize Brows
    Capture Et Sauvegarde       capture_home 


Détecter OS Avec Python
    [Arguments]     ${URL}
    ${os}=    Evaluate    platform.system()    platform
    Log    OS détecté (via Python) : ${os}

    Run Keyword If    '${os}' == 'Windows'    Ouvrir Chrome Normal
    Run Keyword Unless    '${os}' == 'Windows'    Ouvrir Chrome Headless

    Go To    ${URL}
    Wait Until Page Contains Element    //body    timeout=15s
    Capture Page Screenshot


Ouvrir Chrome Normal
    Open Browser    about:blank    chrome
    Maximize Browser Window

Ouvrir Chrome Headless
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --window-size=1920,1080
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Create WebDriver    Chrome    chrome_options=${options}



Maximize Brows
    Set Window Size    1920    1080
    # Reload Page 
    # AWait Browser Ready And Complete
    Maximize Browser Window
    Sleep    3s

AWait Browser Ready And Complete
    Wait Until Page Is Loaded


Wait Until Page Is Loaded
    Wait Until Keyword Succeeds    10s    1s
    ...    Execute JavaScript    return document.readyState == "complete"




Capture Et Sauvegarde
    [Arguments]     ${image_name}
    Sleep   3s
    Wait Until Keyword Succeeds    10s    1s    
    ...  Capture Page Screenshot    Screenshot/${image_name}.png
 

Déplacer un dossier
    [Arguments]    ${source_dossier}=Screenshot   ${destination}=Logs 
    Move Directory    ${source_dossier}    ${destination}


Accepter les cookies
    [Arguments]     ${texte}
    Wait Until Element Is Visible    xpath=//button[contains(., '${texte}')]    timeout=10
    Click Button    xpath=//button[contains(., '${texte}')]
    Wait Until Keyword Succeeds    10s    1s    Capture Page Screenshot


 
########################################################
##########  ENVOIE DU RAPPORT DE TEST PAR MAIL #########


Envoyer un mail
    email_content = """ibrahima.alata@externe.maif.fr""" % (total_suite, passed_suite, failed_suite, suitepp, total, passed, failed, testpp, total_keywords, passed_keywords, failed_keywords, kwpp, elapsedtime, generator)
    
    msg.set_payload(email_content)
    
    # Start server
    server.starttls()
    
    # Login Credentials for sending the mail
    server.login(msg['From'], password)
    
    server.sendmail(sender, recipients, msg.as_strin