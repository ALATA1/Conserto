*** Settings ***
Documentation    CONSERTO
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Library    Collections
Library    RequestsLibrary

Resource         ../../../Resources/Commun_conserto.robot
Resource         ../../../Resources/Keywords.robot
Resource         ../../../Variables/Global_variables.robot
 
# git push origin main:test
# Jenkins : Id = Test_Cons

Test Setup      Prérequis test   # NONE   Préparer Test
Test Teardown   Close Browser   # Capture Erreur Unique

*** Variables ***

${BASE_URL}       https://conserto.pro
${PAGE_PATH}      /technologie/agilite/
${FULL_URL}       ${BASE_URL}${PAGE_PATH}

${IMG_XPATH}      //header[@class='article-header single-offer__header']/div[@class='left']//picture//img
${H1_XPATH}       //header[@class='article-header single-offer__header']//h1[contains(@class, 'article-h1')]
${B_XPATH}        //header[@class='article-header single-offer__header']//b[contains(@class, 'h3') and contains(@class, 'has-pharerose-color')]

${EXPECTED_H1}    Culture Agile
${EXPECTED_B}     Une culture agile qui se traduit dans les résultats
${OUTPUT_FILE}    downloaded_image.jpg




*** Test Cases ***

Vérifier Section Culture Agile Et Télécharger L’Image
    Open Browser    ${FULL_URL}    chrome
    Maximize Browser Window

    # Vérifier que l’image est bien présente dans le DOM (même si invisible)
    Page Should Contain Element    xpath=${IMG_XPATH}

    # Vérifier les titres
    Element Text Should Be    xpath=${H1_XPATH}    ${EXPECTED_H1}
    Element Text Should Be    xpath=${B_XPATH}     ${EXPECTED_B}

    # Récupérer l’attribut src (ou fallback sur data-src si lazy loading)
    ${src}=    Get Element Attribute    xpath=${IMG_XPATH}    src
    Run Keyword If    '${src}' == '' or '${src}' == None
    ...    ${src}=    Get Element Attribute    xpath=${IMG_XPATH}    data-src

    Should Not Be Empty    ${src}
    Log    Image src: ${src}

    # Construire l’URL absolue si besoin (ne concatène que si URL relative)
    ${is_absolute}=    Evaluate    "'${src}'.startswith('http')"
    Run Keyword If    not ${is_absolute}    Set Variable    ${src}    ${BASE_URL}${src}
    Log    Image URL final: ${src}

    ${parsed}=    Evaluate    __import__('urllib.parse', fromlist=['urlparse']).urlparse('${src}')
    ${base_url}=  Set Variable    ${parsed.scheme}://${parsed.netloc}
    ${path}=      Set Variable    ${parsed.path}${parsed.params}${parsed.query}${parsed.fragment}

    Log    Base URL: ${base_url}
    Log    Path: ${path}

    # Télécharger l'image
    Create Session    img_dl    ${base_url}
    ${response}=    GET On Session    img_dl    ${path}
    Should Be Equal As Integers    ${response.status_code}    200

    Create Binary File    ${OUTPUT_FILE}    ${response.content}
    File Should Exist    ${OUTPUT_FILE}




   