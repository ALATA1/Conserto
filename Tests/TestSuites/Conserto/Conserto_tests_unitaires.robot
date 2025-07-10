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




   
    # Barre du menu navigation 
    # # Fermer Le Popup S'il Apparaît
    # Test navigation fonctionne 
      
    # Verif positive techologie    ${Positif_Techo_info}
    # Page acceuil verifs ilots et agences     ${Accueil_container}    ${Accueil_Ilots_container_texte}
    # # Actions agence par agence   1
    # # Tester Tous Les Indicateurs 
    # # Tester Un Élément Aléatoire
    # Vérifier Le Contenu Actif Correspond    4      //div[@class="agencies-block alignwide custom-block "]      #//*[starts-with(normalize-space(text()), "Pink touch in the pink city !")]
    # # Activer Tous Les Éléments Et Vérifier Contenu
    # Capture Page Screenshot
    # Test actions Ilots   


    
    # Page Accueil verif titre   
    # Barre du menu navigation 
    # # Element Barre de nav        ${Positive}      POSITIVE          capture_page_positive
    # # # Générer Fichier De Référence
    # # Vérifier Texte Complet De La Page
    # # # Comparer Texte Lignes
    # # # Test Comparaison
    # # # Comparer Deux Textes
    # Test navigation fonctionne 
    # # # Générer Fichier De Référence
    # # Vérifier Texte Complet De La Page    ${FICHIER_REF_POSITIVE}
    # # Vérifier logo conserto  
    # # Verif positive techologie    ${Positif_Techo_info}
    # # Page acceuil verifs     ${Accueil_container}    ${Accueil_Ilots_container_texte}
    # # Test actions Ilots   

    # # # # Verif elements ilots   # ${Positive}
    # # # # Cliquer sur un lien ilots    Infra
    # # # # Wait Until Element Is Visible    ${Ilots_Infra}    10
    # # # # Wait Until Keyword Succeeds    2 x    2 s    Click Element    ${Ilots_Infra}
    # # # # Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Conserto}
    # # # # Actions Ilots    ${Ilots_Culture_Agile}
    # # # Actions Ilots    ${Ilots_Infra}               ${FILE1_OUTPUT_Infra}
    # # # Actions Ilots    ${Ilots_Devops}              ${FILE2_OUTPUT_Devops}
    # # # Actions Ilots    ${Ilots_Dev}                 ${FILE3_OUTPUT_Dev}
    # # # Actions Ilots    ${Ilots_Agence_Web}          ${FILE4_OUTPUT_Agence_Web}
    # # # Actions Ilots    ${Ilots_Culture_Agile}       ${FILE5_OUTPUT_Culture_Agile}
    # Test actions Ilots

    # # # # Lancer Chrome En Headless    ${URL_CONSERTO}
    # # # # Page d'accueil de Conserto cas 2   ${Title_1} 
      
    # # # # Nettoyer Dossier Logs
    # # # # Nettoyer Dossier Resultats
    # # # # Nettoyer les captures 
    # # # # # Test navigation fonctionne

    # # # # Conditions menu nav     Positive
    # # # # # Values nav    Positive
    # # # # Values nav2   ${Barre_de_nav}   ${Mobile_menu}
    # # # # # Culture agile
    # # # # # Culture Technologie
    # # # # # Culture Clients 
    # # # # # Culture Academy
    # # # # # Culture Blog
    # # # # # Culture Contact
    
    
    # # # # Test navigation fonctionne


    

    

    # # # # Verif positive techo   ${postech}   ${Positif_Techo_info} 
    # # # Verif ilots    ${Positive}


    # # Element Barre de nav   ${Positive}    POSITIVE      capture_page_positive     ${FICHIER_REF_POSITIVE} 


    # # Element Barre de nav sans   ${Contact}    CONTACT      capture_page_contact     ${FICHIER_REF_CONTACT}     
    # # Renseigner les infos contact    ALATA     Alpha     alpha.alata@conserto.pro    Niort    Candidature     ${VotreMessage}    Non   