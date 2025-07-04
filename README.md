<!--

Logs/
.pabotsuitenames
chromedriver.exe
geckodriver.exe
msedgedriver.exe
Documentation/~*.docx
Documentation/*.tmp
JDD/sample.json
.venv
results/

Jenkins : 
Id = Test_Cons
Pass = Kolima2431121980@
===============================================================
Process pour merger ta branche develop vers la branche master : 
===============================================================
Étapes : 
* Supposons que t'as fait ton dev sur la branche (develop), et que ton dev est terminé et tu veux le pusher 
ur la branche (master) afin de la mettre à jour.

==========
Étapes 1 :
==========
 * Assurez-vous que vous êtes sur la branche develop en faisant la commande suivante : 
git checkout develop

==========
Étapes 2 :
==========
 * Tirez les dernières modifications de la branche develop pour être à jour :
Pour cela, fait la commande suivante : 
git pull origin develop

==========
Étapes 3 :
==========
 * Passez à la branche master  en faisant la commande suivante :
git checkout master

==========
Étapes 4 :
==========
 * Tirez les dernières modifications de la branche master à l'aide de cette commande suivante :
git pull origin master

==========
Étapes 5 :
==========
 * Fusionnez la branche develop dans master à l'aide de cette commande :
git merge develop

Remarque de l'étape 5 : 
 * Si tout va bien, la fusion sera automatique.
 * Si des conflits apparaissent, vous devrez les résoudre manuellement dans les fichiers concernés, puis valider la fusion 
   en faisant la commande suivante :

   git add <fichier_conflit>
   git commit

==========
Étapes 6 :
==========
 * Poussez les changements sur la branche master distante via cette ligne de commande :
 git push origin master



<!--
Vérifier un flux dans dynatace : 
Ouvrir dynatrace.
Se connecter à l'environnement de test.
Cliquer sur service ou faire une recherche avec le mot service et Cliquer sur service.
saisir le nom de l'api (exemple :  devis-pro) et cliquer sur le bon choix dans les propositions.
Exemple :  recn_iard-devis-protection-personne-v1
Cliquer sur Service dans le tableau affiché en couleur bleue.
En bat du tableau, vous aurez un menu (Services) affiché avec le lien de la requette en bas.
Cliquer sur le lien de la requette.
Cliquer sur " View distributed traces ".
Ouverture de la view et cliquer sur la requette correspondant à l'heure d'exécution.
Affichage de la requette et clique encore sur le lien de la requette affichée ==> on verra les infos et l'API appelée. 

>


Changement Profil
    [Arguments]    ${user}    ${pwd}
    ${tmp_utilisateur}    Env Get Value    ${user}
    ${tmp_password}    Env Get Value    ${pwd}
    # Open TstFac Browser
    Sleep    5s
    ${tmp_url}    Env Get Value    URL_connexion
    Go To    ${tmp_url}
    Sleep    5s
    Saisir Matricule    ${tmp_utilisateur}    ${tmp_password}    
    Sleep    5s
    

Changement Profil 2
    # Wait Until Element Is Visible       ${Env_RECN} 
    Wait Until Element Is Visible       ${Env_RECW} 
    Click Element                       ${Env_RECW}    
    # Saisir Matricule    ${tmp_utilisateur}    ${tmp_password}     
    Saisir Matricule    utilisateur_SGE           password   
    Sleep    5s 


    
<!-- 
${txt_conffirmation_devis}              //textarea[contains(text(),'2350 I.T.')]

DOE Renseigner Date Effet 
    [Arguments]         ${NBJ}
    Generer Date Effet  ${NBJ}
    Wait Until Element Is Visible       ${chmp_date_effet}
    Wait Until Element Is Enabled       ${chmp_date_effet}
    Input Field                         ${chmp_date_effet}      ${DATE_EFFET}

Tab
    Press Keys  None    TAB

DEX Choisir Expedition
    [Arguments]         ${OP}
    Select Drop MD                      ${drop_exped}    ${OP} 

Select Drop MD
    [Arguments]                         ${Inputliste}    ${valeur}
    AWait Browser Ready And Complete
    Wait Until Element Is Visible       ${Inputliste} 
    Wait Until Element Is Enabled       ${Inputliste} 
    Click Element                       ${Inputliste}/../../../..
    Press Keys                          None    BACKSPACE
    #press_key_directly                 ${valeur}
    Wait Until Element Is Visible       //div[@class='Select-option is-focused']/../div/span[starts-with(text(),'${valeur}')]
    Click Element                       //div[@class='Select-option is-focused']/../div/span[starts-with(text(),'${valeur}')]
    AWait Browser Ready And Complete

DER Renseigner Date Effet 
    [Arguments]         ${NBJ}
    Generer Date Effet  ${NBJ}
    Input Field                         ${chmp_date_effet}      ${DATE_EFFET}

Generer Date Effet
    [Arguments]     ${NB_Days}
    ${date}=        Get Current Date      UTC      
    ${plus14}=      Add Time To Date      ${date}        ${NB_Days} days
    ${FORMAT}=      Switch Date Format
    ${gen_date}=    Convert Date          ${plus14}      ${FORMAT}
    ${gen_date_2}=    Convert Date          ${plus14}      %d/%m/%Y
    Set Suite Variable      ${DATE_EFFET}      ${gen_date}
    Set Suite Variable      ${DATE_EFFET_FORMAT}      ${gen_date_2}

DER Renseigner Adresse L2
    [Arguments]     ${OP}
    Input Field      ${chmp_adr_l2}      ${OP}

Garantie 
    Wait Until Element Is Visible        ${AttLieuProp_Garantie}  
    ${Verif_AttLieuProp_Garantie}=    Get text    ${AttLieuProp_Garantie} 
    ${Verif_AttLieuProp_Garantie2}=    Get text    ${AttLieuProp_Garantie2} 
    ${Verif_AttLieuProp_Garantie3}=    Get text    ${AttLieuProp_Garantie3}   
    ${Verif_AttLieuProp_Garantie4}=    Get text    ${AttLieuProp_Garantie4} 
    ${Verif_AttLieuProp_Garantie5}=    Get text    ${AttLieuProp_Garantie5}  
    # Changement de Window : 
    # Wait Until Keyword Succeeds         20 x    2 s   Switch Window  locator=NEW
    # Capture Page Screenshot
    Close Window 
    Wait Until Keyword Succeeds	    20s	5s       Switch Window    MAIN
    Switch Window 
    Wait Until Keyword Succeeds	    20s	5s       Switch Window    MAIN
    Wait Until Keyword Succeeds         20 x    2 s   Switch Window  locator=NEW

390 Selectionner Membre Foyer
    [Arguments]         ${idMemb}
    Wait Until Element Is Enabled           ${btn_membres_foyer} 
    Wait Until Element Is Visible           ${tab_liste_membre}
    Click Element                           //tbody/tr[${idMemb}]/td[1]
    Click Element                           ${btn_memb_foyer_ok} 


351 Selectionner Uh Au Contrat
    AWait Browser Ready And Complete
    Click Element                           ${btn_uh_au_cont}
    Wait Until Element Is Visible           ${tab_prem_res}      60
    Click Element                           ${tab_prem_res}
    Click Element                           ${btn_ok_uh}

341 Recupere Numero Lieu 
    Wait Until Element Is Visible       ${txt_num_lieu} 
    ${PHLIEU}=     Get Text        ${txt_num_lieu} 
    ${NumLieu} =	Get Substring	${PHLIEU}		-3
    Set Suite Variable	${LieuR}	${NumLieu}
    log to console      ${LieuR}


    
       

# # Ouvrir Navigateur Metier           utilisateur_EA           password       #   utilisateur_EA     utilisateur_SGE     utilisateur_reseau  (RECN)
    # # Ouvrir Navigateur Metier         utilisateur_SGE           password       #utilisateur_RSO    utilisateur2_RSO    utilisateur_SGE   utilisateur_SIEGE    (PPCOR)
    # Ouvrir Navigateur Metier         utilisateur_SG           password       # utilisateur_SG   utilisateur_reseau_1       utilisateur_reseau_2      utilisateur_reseau_3   (RECW)      
    # # Ouvrir Navigateur Metier         utilisateur1_SGE_Raqv2           password    # utilisateur1_RSE_Raqv2     utilisateur1_SGE_Raqv2 (TDV3)
    

-->

<!-- 
Teststststs

    # Cas 1 : 
    ${Action_1}=      Run Keyword And Return Status      Element Should Be Visible     ${Bloc_Adress_dev_de_souscrip_autrecaszonier} 
    ${Action_2}=      Run Keyword And Return Status      Element Should Be Visible     ${Bloc_Adresse_devis_de_souscription_zonier} 
    Run Keyword If    ${Action_1}    Bloc adress zonier cas 2
    ...    ELSE IF    ${Action_2}    Bloc adress zonier cas 1  
    Attendre Traitement

    # Cas 2 : 
    [Arguments]     ${SUPP}    
    # Wait Until Element Is Visible                ${Choix_Supp_autom_Dom_MEG_Raqv2}         60   
    Run Keyword If      '${SUPP}' == 'Oui'       Click Element     ${Choix_Supp_autom_Dom_MEG_Raqv2_oui}  
    Run Keyword If      '${SUPP}' == 'Non'       Click Element     ${Choix_Supp_autom_Dom_MEG_Raqv2_non}     
    # Capture Element Screenshot                                     ${Choix_Supp_autom_Dom_MEG_Raqv2}         
    
    IF  '${SUPP}'=='***'       
        Press Keys  None  TAB 
    END

    IF  '${SUPP}' == 'Oui' 
        # Wait Until Element Is Visible                ${Champ_date_date_effet_suppression_dom}         60  
        Press Keys  None  TAB  
        # press_key_directly      ${Champ_date_date_effet_suppression_dom} 
        # Click Element           ${Champ_date_date_effet_suppression_dom} 
        # Clear Element Text      ${Champ_date_date_effet_suppression_dom}
        # Capture Page Screenshot 
        Sleep    3s 
        Wait Until Keyword Succeeds	    30s	5s     MaifTstFacLibrary.Press Backspace
        Sleep    3s 
        Click Element           ${SuppTexte_Champ_date_date_effet_suppression_dom}    
        Input Text              ${Champ_date_date_effet_suppression_dom}     ${date_effet_suppression_dom} 
        # Input Field             ${Champ_date_date_effet_suppression_dom}     ${date_effet_suppression_dom} 
        Capture Element Screenshot             ${Champ_date_date_effet_suppression_dom}    
    ELSE        
        Repeat Keyword    3 times     Press Keys  None  TAB   
    END

    # Cas 3 : 
    [Arguments]       ${SUPP}     ${text_SUPP}  
    # ${Action_1}=      Run Keyword And Return Status      Element Text Should Be      ${Reconstruction_Raqv2}     ${Texte}
    ${Action_1}=      Run Keyword And Return Status      Page Should Contain     ${text_SUPP}  
    ${Action_2}=      Run Keyword And Return Status      Page Should Not Contain     ${text_SUPP}  
    Run Keyword If    ${Action_1}    Suppression automatique Raqv2      ${SUPP}  
    ...    ELSE IF    ${Action_2}    Page Should Not Contain       ${text_SUPP}
    Capture Page Screenshot       
    
    IF  '${text_SUPP}'=='***'      
        Press Keys  None  TAB 
    END 

    IF  '${SUPP}'=='***'       
        Press Keys  None  TAB 
    END 

<!--


<!-- Contrats RAQVAM2_Réaliser un devis de souscription Raqvam2 à effet A. 
    [Documentation]       Scénario A01 : Réaliser un devis de souscription Raqvam2 à effet A.
    ...                   SOC PP : TDV3 4002611M [ 3911649D 5208163T 5174092H- 4695670A] : 3708848H 3684786 3621569 3607055 
    ...                   Type de lieu = [Domicile] ; Nature du lieu = [Maison - Les 3 types Appartements] ; Situation juridique = [propriétaire].
    [Tags]    A01       ETAT:Stable       TYPE:TNR         PRIORITE:P1        CONTRAT:RAQVAM2      CNTHM-4282  
    Ouvrir Navigateur Metier         utilisateur1_SGE_Raqv2           password 
    # Ouvrir Navigateur Metier         utilisateur_SG           password       # utilisateur_SG   utilisateur_reseau_1       utilisateur_reseau_2      utilisateur_reseau_3   (RECW)      
    Ouvrir nora distribution 
    Recuperer Societaire      A01
    Saisir Champ Soc via Nora      ${SOC} 
    Page débuter le devis Raqvam2                      
    Page Contexte et adresse Devis RAQVAM2      Téléphone      NON      Adresse(s) connue(s)       Coche adresse connue      ACM     Continuer        # Adresse(s) connue(s)   Nouvelle adresse  
    # Page Desrisque Raqvam2 lot unitaire 
    # Page Description du risque Raqvam2 Global   
    Page Desrisque Raqvam2    
    # # # Cas facultatif bloc DDA  
    # # Besoins et tarifs RAQVAM2 
    Page formules et options Raqv2       PRECO ARBITRAGE         OFFRE ARBITRAGE      Enregistrer le(s) devis 
    # Page choisir les formules Raqv2       PRECO ARBITRAGE         OFFRE ARBITRAGE      Enregistrer le(s) devis
    Page Action devis Raqvam2 
    Actions devis Raqvam2 réalisé    -->
<!-- 
Bloc Description du Lieu Raqv2 méthode click 
    [Arguments]         ${type_lieu}    ${nature_lieu}     ${situation_juridique}      ${complsit_juridique_Raqvam2}     ${nombre_pieces}      
    ...                 ${nombre_occupants}    ${dependance}     ${patrimoine_mobilier}     ${Objetsprecieux} 
    AWait Browser Ready And Complete
    Wait Until Keyword Succeeds    10 x    2 s    switch window         Devis RAQVAM 2 
    Détention et Récapitulatif 
    Select Drop Raqvam2         ${drop_champ1_type_lieu_Raqv2}           ${drop_options_type_lieu_Raqv2}                  ${type_lieu}                
    Select Drop Raqvam2         ${drop_nutre_lieu_Raqvam2}               ${drop_options_nature_lieu_options_Raqv2}        ${nature_lieu}                                  
    Select Drop Raqvam2         ${drop_situation_juridique_Raqvam2}      ${drop_options_situation_juridique_Raqvam2}      ${situation_juridique}
    Select Drop Raqvam2         ${drop_complsit_juridique_Raqvam2}       ${drop_options_complsit_situation_juridique_Raqv2}     ${complsit_juridique_Raqvam2}   
    Select Drop Raqvam2         ${drop_nb_piece_Raqvam2}                 ${drop_options_nb_piece_Raqvam2}                 ${nombre_pieces}    
    Select Drop Raqvam2         ${drop_nb_occupants_Raqvam2}             ${drop_options_nb_occupants_Raqvam2}                 ${nombre_occupants}
    Elément(s) d'agrément Raqvam2   
    Select Drop Raqvam2         ${drop_depandence_Raqvam2}               ${drop_options_depandence_Raqvam2}               ${dependance}       
    Select Drop Raqvam2         ${drop_pat_mob_Raqvam2}                  ${drop_options_pat_mob_Raqvam2}                  ${patrimoine_mobilier}  
    Select Drop Raqvam2         ${drop_Objetsprecieux_Raqvam2}           ${drop_options_Objetsprecieux_Raqvam2}           ${Objetsprecieux} 
    Reconstruction sup au plafond RIE     NON  
    Press Keys  None  TAB -->

<!-- 
IAR - Devis AHA - Decrire Risque 2             Domicile   Propriétaire    ***    Appart. RdC    4    41 000         10 000        1 à 50 m² -->

<!-- 
Usage prof Raqv2
    [Arguments]     ${USAGEPRO}     ${Type_usage_pro}    
    Wait Until Element Is Visible                ${UsagePro_Raqv2}         60      
    Run Keyword If      '${USAGEPRO}' == 'Oui'       Click Element     ${UsagePro_Raqv2_oui} 
    # Run Keyword If      '${USAGEPRO}' == 'Non'       Click Element     ${UsagePro_Raqv2_non}   
    Capture Element Screenshot            ${UsagePro_Raqv2} 

    IF  '${USAGEPRO}' == 'Oui' 
        Wait Until Element Is Visible        ${drop_champ_list_type_usage_pro}         60   
        Select Drop Raqvam2      ${drop_champ_list_type_usage_pro}      ${drop_options_list_type_usage_pro}       ${Type_usage_pro}
        Select Drop NOR          ${drop_champ_list_type_usage_pro}      ${drop_options_list_type_usage_pro}       ${Type_usage_pro}      ${ListeTypeYsagePro}              
    ELSE  
        Press Keys  None  TAB   
    END 

    Wait Until Element Is Visible        ${UsagePro_Raqv2}         60    
    Run Keyword If      '${Type_usage_pro}' == 'Accueil de personnes'                 Click Element     ${drop_champ_list_type_usage_pro}  
    Run Keyword If      '${Type_usage_pro}' == 'Chambre d'hôte'                       Click Element     ${drop_champ_list_type_usage_pro}  
    Run Keyword If      '${Type_usage_pro}' == 'Assistante maternelle'                Click Element     ${drop_champ_list_type_usage_pro}  
    
    Run Keyword If      '${Type_usage_pro}' == 'Activité agricole ou forestière'      Click Element     ${drop_champ_list_type_usage_pro}  
    Run Keyword If      '${Type_usage_pro}' == 'Activité industrielle'                Click Element     ${drop_champ_list_type_usage_pro}  
    Run Keyword If      '${Type_usage_pro}' == 'Bijouterie'                           Click Element     ${drop_champ_list_type_usage_pro}   
    Run Keyword If      '${Type_usage_pro}' == 'antiquité ou armurerie'               Click Element     ${drop_champ_list_type_usage_pro}  
    Run Keyword If      '${Type_usage_pro}' == 'Hôtellerie ou restauration'           Click Element     ${drop_champ_list_type_usage_pro}  
    Run Keyword If      '${Type_usage_pro}' == 'Transport'                            Click Element     ${drop_champ_list_type_usage_pro}  
             
    Run Keyword If      '${Type_usage_pro}' == 'Activité intellectuelle'              Click Element     ${drop_champ_list_type_usage_pro}  
    Run Keyword If      '${Type_usage_pro}' == 'Activité médicale ou paramédicale'    Click Element     ${drop_champ_list_type_usage_pro}  
   
    Run Keyword If      '${Type_usage_pro}' == 'Autre'                                Click Element     ${drop_champ_list_type_usage_pro}           
    Capture Page Screenshot 


    IF  '${Type_usage_pro}' == 'Accueil de personnes'  
        Wait Until Element Is Visible                ${drop_champ_list_type_usage_pro}         60 
        Select Drop Raqvam2      ${drop_champ_list_type_usage_pro}      ${drop_options_list_type_usage_pro}       ${Type_usage_pro} 
    END 

    IF  '${Type_usage_pro}' == 'Chambre d'hôte'  
        Wait Until Element Is Visible                ${drop_champ_list_type_usage_pro}         60 
        Select Drop Raqvam2      ${drop_champ_list_type_usage_pro}      ${drop_options_list_type_usage_pro}       ${Type_usage_pro} 
    END 
    
    IF  '${Type_usage_pro}' == 'Assistante maternelle'   
        Wait Until Element Is Visible                ${drop_champ_list_type_usage_pro}         60 
        Select Drop Raqvam2      ${drop_champ_list_type_usage_pro}      ${drop_options_list_type_usage_pro}       ${Type_usage_pro} 
    END 
     -->


<!-- Users réseaux : 85492B / 85493T / 85576M / 85577J -->
<!--PRODUIT:AHAANDETAT:Stable -->
<!-- Get Window Handles         #Renvoie toutes les poignées de fenêtre enfant du navigateur sélectionné sous forme de liste.
Get Window Identifiers      #Renvoie et consigne les attributs id de toutes les fenêtres du navigateur sélectionné.
Get Window Names     #Renvoie et consigne les noms de toutes les fenêtres du navigateur sélectionné.
Get Window Position     #Renvoie la position actuelle de la fenêtre.
Get Window Size     #Renvoie la largeur et la hauteur actuelles de la fenêtre sous forme d’entiers.
Get Window Titles     #Renvoie et consigne les titres de toutes les fenêtres du navigateur sélectionné. 
Capture Page Screenshot
Delete All Cookies
Get All Links
Get Browser Ids
Get Table Cell
Go Back
Handle Alert
Press Keys    enter      
Close Window
Wait Until Keyword Succeeds	    20s	5s       Switch Window    MAIN
Switch Window
Switch Window  locator=NEW

Solution  :
https://stackoverflow.com/questions/48922190/how-to-compare-a-variable-to-two-values-by-using-or-condition-in-robot-framewor
Should Be True     '${accountNumChk}'=='6' or '${accountNumChk}'=='7'
ou
${check1}=    Run Keyword And Return Status    Should Be Equal As Strings    ${accountNumChk}    6
Run Keyword If     not ${check1}    Should Be Equal As Strings    ${accountNumChk}    7


Solution 2:
https://9to5answer.com/how-to-compare-two-strings-equal-or-not-in-robot-framework

${xyz}    Get Text    xpath=/html/body/div/div[2]/div[3]/div/div/div/div/h3
${abc}    Get Text    xpath=/html/body/div/div[4]/div[3]/div/div/div/div/h3
Should Be Equal As Strings    ${xyz}    ${abc}

Solution 3 : 

Should Be True     """${variable 1}""" == """${variable 1}"""
ou

Should Be True     """${variable 1}""".lower() == """${variable 1}""".lower()
ou

Should Be True     """${variable 1}""" in """${variable 1}"""



Select Radio Button	contact	email


Regul Stock
    [Arguments]    ${cip_produit}    ${quantite}    ${vendeur}
    Log to console  Regul Stock
    Wait Until Element Is Visible    css=div.canvas-container:nth-child(1) div.internal div:nth-child(1) div.webinput-container span.twitter-typeahead:nth-child(1) > input.webinput-input.tt-input:nth-child(2)     ${wait_timeout}
    Send Keys Write     ${cip_produit}
    Wait Until Keyword Succeeds	    30s	5s       Send Key Press      enter
    Wait Until Keyword Succeeds	    30s	5s       Send Keys TypeWrite      g
    Wait Until Element Is Visible    css=div.canvas-container:nth-child(1) div.internal div:nth-child(1) div.webinput-container > input.webinput-input:nth-child(1)     ${wait_timeout}
    Send Keys Write      ${quantite}
    Send Key Press      enter
    Wait Until Element Is Visible    //input[@class='webinput-input']     ${wait_timeout}
    Send Keys Write      ${vendeur}
    Wait Until Keyword Succeeds	    30s	5s       Send Key Press      enter
    Wait Until Element Is Visible    css=div.canvas-container:nth-child(1) div.internal div:nth-child(1) div.webinput-container > input.webinput-input.webinput-input-standyby:nth-child(1)     ${wait_timeout}
    Wait Until Keyword Succeeds	    30s	5s       Send Key Press    f1
    Wait Until Keyword Succeeds	    30s	5s       Send Key Press    down
    Wait Until Keyword Succeeds	    30s	5s       Send Key Press    down
    Wait Until Keyword Succeeds	    30s	5s       Send Key Press    down
    Wait Until Keyword Succeeds	    30s	5s       Send Key Press    enter
    Wait Until Keyword Succeeds	    30s	5s       Send Keys TypeWrite      o
    Wait Until Keyword Succeeds	    30s	5s       Send Keys TypeWrite      o
    Wait Until Keyword Succeeds	    30s	5s       Send Keys TypeWrite      s
    #Send Keys TypeWrite      131119


    Aller dans GestionTeleservices
    Log to console  Gestion / Teleservices
    Send Keys TypeWrite      G
    Send Keys TypeWrite      S
    Send Keys TypeWrite      S
    Send Keys TypeWrite      S
    Send Key Press     enter
-->


<!-- ########################################################################################################################
# Lancer le test avec le navigateur firefox :                                                                          #
#./Helpers/run-test.py -i 41400 --launchvariables RECN --browsername firefox --reporter Disabled  --keepbrowseropened  #
# Lancer le test avec le navigateur métier :                                                                           #
#./Helpers/run-test.py -i 20235 --launchvariables RECN --reporter Disabled  --keepbrowseropened --reconnect Darwin     #               
########################################################################################################################
# Ouverture navigateur metier pour le lancement du script existant (Script Bruno DRAHI): 
# Test Setup       Ouvrir Navigateur
# Ouverture navigateur metier (ENV=RECN) avec user siège : 
Test Setup       Ouvrir Navigateur Metier           utilisateur_EA           password   
# Ouverture navigateur metier (ENV=RECN) avec user réseau : 
# Test Setup       Ouvrir Navigateur Metier           utilisateur_reseau           password  
# Ouverture navigateur metier (ENV=RECW) avec user réseau : 
# Test Setup       Ouvrir Navigateur Metier            utilisateur_reseau_1           password     -->



<!-- [RECN]
URL_connexion = https://build-darwin.opunmaif.fr/tenants/RECN
URL_connexion2 = https://build-darwin.opunmaif.fr/tenants/RECW
URL_connexion_PPCOR = https://build-darwin.opunmaif.fr/tenants/PPRODCOR
utilisateur_SGE_PPCOR = 82451P
utilisateur_RSO_PPCOR = 82492K                                                                     
utilisateur2_RSO_PPCOR = 82493H
utilisateur_AC = 85508B
# Chargé études : SGEC : droit 14 sur IAR  :
utilisateur_CE = 85450M
utilisateur_CVFF = 85671B
utilisateur_DECLA = 85427B   
utilisateur_EA = 85005K 
utilisateur_SGE = 85013M
password = E2k19Mae85a!
utilisateur_reseau = 85492B   
utilisateur_reseau_1 = 85493T 
utilisateur_reseau_2 = 85576M 
utilisateur_reseau_3 = 85577J  

    # Capture Element Screenshot       ${Page_MEG_Bloc_Adress}
    # Capture Page Screenshot   
    # Wait Until Keyword Succeeds	    30s	5s       Send Key Press   down
    # Wait Until Keyword Succeeds	    30s	5s       Send Key Press   enter
    # Send Key Press      enter
    # Wait Until Keyword Succeeds	    30s	5s     Send Key Press   down
    #   ${TITLE_Caisse}     Caisse
        &{client_1}       nom=BEUGNIES    prenom=AVEZARD   addresse=ADRESSE NON RENSEIGNEE   tel=0600000000    datenaiss=120715
        @{list_produits}    DAFALGAN 1G     MAXILASE
        &{multi_reglement}   CB=100  Cheque=50
        ${num_vendeur}      1
        &{Gestion_caisse}     text1=Gestion de la caisse    text2=QA SMART-RX Tests Automatisés    text3=CARTE BANCAIRE    text4=AGNES HOLLE   text5=Règlement Vente    text6=BEUGNIES AVEZARD ALPHONSE   text7=Hors ordonnance   text8=2,18 €   text9=Règlt facture p/CARTE DE PAIEMENT 22348 BEUGNIES AVEZARD ALPHONSE Banque 1     text10=01
        ${text1}     Gestion de la caisse
        ${text2}     QA SMART-RX Tests Automatisés
        ${nom_medecin}      GABILLARD
        @{expected_results}    Create List      Gestion de la caisse    QA SMART-RX Tests Automatisés
        &{DICT_REGLEMENT}       ESPECES=f1    CHEQUES=f3    AUTRES=f5    VIREMENT=f6    CB=f7    CREDIT=f9
        ${text2}     QA SMART-RX Tests Automatisés
        
    # Send Keys TypeWrite      @{list_produits}[0]
    # Verifier existance du texte
    [Arguments]    ${text}
    Log to console    Verifier l'existance du texte : ${text}
    Element Should Be Visible    ${text1}
    Element Should Be Visible    ${text2}

        Wait Until Keyword Succeeds	    30s	5s       Send Key Press    down
    Wait Until Keyword Succeeds	    30s	5s       Send Key Press    down
    Wait Until Keyword Succeeds	    30s	5s       Send Key Press    down
    Wait Until Keyword Succeeds	    30s	5s       Send Key Press    enter

    # Wait Until Keyword Succeeds	    30s	5s       Send Key Press   down
    # Wait Until Keyword Succeeds	    30s	5s       Send Key Press   enter
    # Send Key Press      enter
    # Wait Until Keyword Succeeds	    30s	5s     Send Key Press   down
    # Click Element              ${drop_Statut2}

    # Press Keys  None  down
    # Press Keys  None   down
    # Press Keys  None  enter
    # Sleep     3s
    # Wait Until Keyword Succeeds	    30s	5s     MaifTstFacLibrary.Press Enter
    # Wait Until Keyword Succeeds	    30s	5s       Send Keys   down
    # Wait Until Keyword Succeeds	    30s	5s       Send Keys   enter
    # Send Key Press      enter
    # Wait Until Keyword Succeeds	    30s	5s     keyword_projet.Send Key Press 

Clear Entry Field
  [Arguments]  ${textField}
  Press Keys  ${textField}   COMMAND+a  BACKSPACE

  
     
Effectuer une Verifi Page
    Wait Until Element Is Visible    ${Gestion_de_la_caisse}

Effectuer Recherche texte
    [Arguments]    ${text1}    ${text2}
    #Input Text    ${champ_recherche}    ${nom} ${prenom}
    Wait Until Element Is Visible    //*[contains(text(), '${text1}')]
    Wait Until Element Is Visible    //*[contains(text(), '${text2}')]

Verifier informations client
    [Arguments]    ${client_nom}    ${client_adresse}    ${client_phone}
    Log to console    Verifier informations client : ${client_nom} ${client_adresse} ${client_phone}
    ${logs}=   recuperer_logs
    Log to console      ${logs}
Autres cas
    [Arguments]     ${type_reglement}
    Wait Until Keyword Succeeds	    30s	5s       Send Key Press      &{DICT_REGLEMENT}[${type_reglement}] 
    # 
    # AWait Browser Ready And Complete
    
 
 Infos Etat civil cas 3 
    [Arguments]          ${CIV}    #${Statut}  
    Wait Until Element Is Visible       ${ChoixCivilite}        60
    Wait Until Element Is Visible       ${Monsieur}      60  
    Run Keyword If      '${CIV}' == 'Monsieur'       Click Element     ${Monsieur}     
    Run Keyword If      '${CIV}' == 'Madame'       Click Element     ${Madame}      
    Sleep       2s            
    Clear Element Text         ${Champ_Nom_Foyer} 
    Input Text                 ${Champ_Nom_Foyer}               ${Noms.nom1}        
    Clear Element Text         ${Champ_Prenom_Foyer}       
    Input Text                 ${Champ_Prenom_Foyer}           ${Prenoms.prenom5} 
    Clear Element Text         ${Champ_Date_Naiss}
    Input Text                 ${Champ_Date_Naiss}             ${DateDeNaissances.dateNaissance4} 
    Click Element              ${drop_Statut}
    # #Select Drop Strict         ${drop_Statut}            ${Statut} 
    # Input Field                ${drop_Statut}           ${Statut}  
    # Wait Until Keyword Succeeds	    30s	5s       Send Key Press   down
    # Wait Until Keyword Succeeds	    30s	5s       Send Key Press   enter
    # Send Key Press      enter
    # Wait Until Keyword Succeeds	    30s	5s     Send Key Press   down
    # Click Element              ${drop_Statut2}

    # Press Keys  None  down
    # Press Keys  None   down
    Sleep     3s
    # Press Keys  None  enter
    # Sleep     3s
    Wait Until Keyword Succeeds	    30s	5s     MaifTstFacLibrary.Press Enter
    # Wait Until Keyword Succeeds	    30s	5s       Send Keys   down
    # Wait Until Keyword Succeeds	    30s	5s       Send Keys   enter
    # Send Key Press      enter
    # Wait Until Keyword Succeeds	    30s	5s     keyword_projet.Send Key Press 
    Press Keys  None  TAB
    Press Keys  None  TAB
Repeat Keyword	5 times	Go to Previous Page
Repeat Keyword    5 times     Go Back
Repeat Keyword    5 times     Go Back
    # Press Keys  None  TAB
    # Press Keys  None  TAB
    # Select Drop                         ${drop_depandence}       ${dependance}
    # Input Field       ${drop_Surface_du_LUD}           ${SurfaceLUD} 
    # Wait Until Keyword Succeeds	    30s	5s       Send Keys   down
    # Wait Until Keyword Succeeds	    30s	5s     MaifTstFacLibrary.Press Downarrow
    # Wait Until Keyword Succeeds	    30s	5s     MaifTstFacLibrary.Press Downarrow
    # Wait Until Keyword Succeeds	    30s	5s     MaifTstFacLibrary.Press Downarrow
    # Press Keys      None          ENTER    ENTER  


     # Wait Until Keyword Succeeds	    30s	5s       Send Key Press   down
    # Wait Until Keyword Succeeds	    30s	5s     MaifTstFacLibrary.Press Enter
    # Wait Until Keyword Succeeds	    30s	5s       Send Keys   down
    # Press Keys  None  down
    # Press Keys  None  TAB
    # Wait Until Keyword Succeeds	    30s	5s     MaifTstFacLibrary.Press Enter
    # Press Keys      None          ENTER    ENTER

    # Wait Until Keyword Succeeds	    30s	5s     MaifTstFacLibrary.Press Downarrow    ==>  Appuyez sur la flèche vers le bas
    # Wait Until Keyword Succeeds	    30s	5s     MaifTstFacLibrary.Press End   ==> Press Fin
    # Wait Until Keyword Succeeds	    30s	5s     MaifTstFacLibrary.Press Uparrow   ==> Press Flèche vers le haut
    # Wait Until Keyword Succeeds	    30s	5s     MaifTstFacLibrary.Press Enter   ==> Appuyez sur Entrée
    # Wait Until Keyword Succeeds	    30s	5s     MaifTstFacLibrary.Press Tab   ==> Press Tab
    # Wait Until Keyword Succeeds	    30s	5s     MaifTstFacLibrary.Api Response   ==> Api
    # Wait Until Keyword Succeeds	    30s	5s     MaifTstFacLibrary.Press Backspace   ==> Bouton backspace

 
    # Wait Until Keyword Succeeds	    30s	5s       Send Key Press   down
    # Wait Until Keyword Succeeds	    30s	5s       Send Key Press   enter
    # Send Key Press      enter
    # Wait Until Keyword Succeeds	    30s	5s     Send Key Press   down  

    Should Be Empty      ${columnlist}     ==> Doit être vide
    Should Not Be Empty  ${columnlist}      ==>  Ne Doit être vide
    Should Not Contain Any  ==> Ne doit pas contenir de 
# Derogationssssssss
#     [Arguments]     ${coef_pondtion} 
#     Wait Until Element Is Visible       ${Coef_derog}        60   
#     Click Element                       ${Coef_derog}
    # Input Text        ${Coef_derog}           ${coef_pondtion}  
    # Input Field       ${Coef_derog}           ${coef_pondtion}       
    # Press Keys  None  TAB
    # Select Drop  ${drop_moif_derog}  ${MOTIF} 


Champ date
    Press Keys          ${Champ_Calendrier}               CTRL+a
    Sleep   2s
    Press Keys          ${Champ_Calendrier}               BACKSPACE
    Sleep   2s
    Input Text          ${Champ_Calendrier}               ${Date}
    Sleep   2s
    Input Field         ${Champ_Calendrier}               ${Date} 
    Sleep   2s
    press keys  ${Champ_Calendrier}  CTRL+a+BACKSPACE
    Sleep   2s
    Input Field         ${Champ_Calendrier}               20082023
    Press Keys  None  TAB



git checkout feature/Ibrahima
git pull
git add .
git commit -m "Bonjour Bruno "
git push
git config --global user.name "Ibrahima ALATA"
git config --global user.email "ibrahima.alata@externe.maif.fr"
git add .
git push
git checkout develop ==> Switched to a new branch 'develop'
git pull
git push
git add .
git commit -m "Bonjour Bruno "
git push
git checkout master ==> Switched to branch 'master'
git flow init
git checkout develop
git flow feature start alata ==> Créer une nouvelle branche alata et Switched to a new branch 'feature/alata'
git flow feature finish alata ==> Merge la branch alata dans dev et supprime la branche alata
git add .
git commit -m " Merci Bruno "
git push
git push --set-upstream origin feature/alata
git push
git add .
git commit -m " correction AHA "
git push




C:\Users\34008B\Projets\darwin_tnr-pc-master\Tests\Data\IARD_Commun


IAR Bloc description du lieu
    [Arguments]                         ${Resid_bat}     ${No_lib_voie}   ${Lib_Comp}   ${Code_Postal}     ${Commune} 
    Wait Until Element Is Visible           ${Champ_Resid_bat}        60
    Click Element                           ${Champ_Resid_bat}     
    Sleep       2s
    Input Text      ${Champ_Resid_bat}                    ${Resid_bat}
    Input Text      ${Champ_No_lib_voie}                  ${No_lib_voie}
    Input Text      ${Champ_Lib_Complt}                   ${Lib_Comp}
    Input Text      ${Champ_Code_Postal_ville}            ${Code_Postal}
    Press Keys      None      TAB
    Wait Until Element Is Visible           ${Champ_Commune_à_renseigner1}        60
    # Click Element                           ${Champ_Commune_à_renseigner_2}
    Select Drop     ${Champ_Commune_à_renseigner1}        ${Commune}
    Sleep    2s
    # Press Keys      None      ENTER
    Wait Until Keyword Succeeds	    30s	5s     MaifTstFacLibrary.Press Downarrow
    Press Keys      None      ENTER
    # Input Text      ${Champ_Commune_à_renseigner1}         ${Commune}
    # Select Drop     ${Champ_Commune_à_renseigner}        ${Commune}

    # Select Drop Strict                  ${Champ_Resid_bat}                   ${Resid_bat}
    # Select Drop Strict                  ${Champ_No_lib_voie}                 ${No_lib_voie}
    # Select Drop                         ${Champ_Lib_Complt}                  ${Lib_Comp}
    # Select Drop                         ${Champ_Code_Postal_ville}           ${Code_Postal}
    # Select Drop                         ${Champ_Commune_à_renseigner1}       ${Commune}
    # Select Drop                         ${Champ_Commune_à_renseigner}        ${Commune}
    # # Wait Until Element Is Visible           ${Champ_Commune_à_renseigner}
    # # Click Element                           ${Champ_Commune_à_renseigner} 
    # # Click Element                           ${Champ_Commune_à_renseigner} 
    # Select Drop Strict                  ${drop_nutre_lieu}          ${nature_lieu}
    # Select Drop                         ${drop_nb_pieces}           ${nombre_pieces}
    # Input Field                ${drop_Assureur_précédent}         ${AssPreced} 
    # Input Text        ${Champ_Antiquites}           ${Antiquites} 
    # Input Field       ${Champ_Antiquites}           ${Antiquites} 


Element Value Should Be          La valeur de l’élément doit être 
Element Value Should Not Be          La valeur de l’élément ne doit pas être 
Element Value Should Be              La valeur de l’élément doit être 

AHJ-Verif message risque
    [Arguments]     ${Message_Risque}
    Wait Until Element Is Visible       ${ZoneMessagesRisque}        60   
    Wait Until Element Is Visible       ${txt_conf_risque_enreg}        60   
    Page Should Contain        ${Message_Risque}  
    Page Should Contain Element       ${Message_Risque}
    Element Text Should Be      ${txt_conf_risque_enreg}      ${Message_Risque} 
    Wait Until Element Contains     ${txt_conf_risque_enreg}      ${Message_Risque} 
    Element Should Contain       ${txt_conf_risque_enreg}      ${Message_Risque} 
    # Textfield Should Contain      ${ZoneMessagesRisque}       ${Message_Risque}        
    # Textfield Value Should Be      ${ZoneMessagesRisque}       ${Message_Risque}
    # Sleep    2s
    # Textfield Should Contain      ${txt_conf_risque_enreg}       ${Message_Risque}        
    # Textfield Value Should Be      ${txt_conf_risque_enreg}       ${Message_Risque}
    # Element Value Should Not Be          La valeur de l’élément ne doit pas être 
    # Element Value Should Be              La valeur de l’élément doit être 





Wait Until Keyword Succeeds    10 x    2 s    switch window              NORA Distribution
 


# Resil autom*
#     ${Action_1}=      Run Keyword And Return Status      Click Element If Present     ${rd_resil_auto_oui}
#     ${Action_2}=      Run Keyword And Return Status      Wait Until Element Is Visible     ${chk_benef_principal}       60  
#     Run Keyword If    ${Action_1}    Click Element If Present     ${rd_resil_auto_oui}
#     ...    ELSE IF    ${Action_2}    Wait Until Element Is Visible     ${chk_benef_principal}       60  
#     Attendre Traitement

# Date Resil autom*    
#     ${Action_01}=      Run Keyword And Return Status      Input Field       ${Champ_Resil_Autom}        29072023
#     ${Action_02}=      Run Keyword And Return Status      Wait Until Element Is Visible     ${chk_benef_principal}       60  
#     Run Keyword If    ${Action_01}    Input Field       ${Champ_Resil_Autom}        29072023
#     ...    ELSE IF    ${Action_02}    Wait Until Element Is Visible     ${chk_benef_principal}       60  
#     Attendre Traitement
   
   
   
   
    IAR Bloc - Deplier bloc Devis en cours

    Parcourir Liste Devis IAR    RAQVAM 2
    Valider Roue Crantee Contrat      ${LIGNE}
    Roue Crantee Contrat dev Raqv2        ${LIGNE}        Modifier (devis)    




    APB-Parcours-Modification Contrat 
    Parcourir Liste Devis IAR
    Parcourir Liste Devis IAR cas 2
   

    Get Window Titles
    Get Window Handles
    Get Window Identifiers
    Get Window Names
    Get Window Position
    Get Window Size

    # Wait Until Keyword Succeeds    10 x    2 s    Get Window Titles
    # Selectionner Windows    2

    
    Wait Until Keyword Succeeds    10 x    2 s    Textfield Should Contain            ${Presence_Assistance_maternelle}          ${Texte_AssMater}
    Wait Until Keyword Succeeds    10 x    2 s    Textfield Value Should Be           ${Presence_Assistance_maternelle}          {Texte_AssMater} 


    Element Should Be Disabled              ${drop_compl_situation}

    AHJ-Verif message risque
    [Arguments]     ${Message_Risque}
    Wait Until Element Is Visible       ${ZoneMessagesRisque}        60   
    Wait Until Element Is Visible       ${txt_conf_risque_enreg}        60   
    Page Should Contain        ${Message_Risque}  
    Page Should Contain Element       ${Message_Risque}
    Element Text Should Be      ${txt_conf_risque_enreg}      ${Message_Risque} 
    Wait Until Element Contains     ${txt_conf_risque_enreg}      ${Message_Risque} 
    Element Should Contain       ${txt_conf_risque_enreg}      ${Message_Risque} 
    # Textfield Should Contain      ${ZoneMessagesRisque}       ${Message_Risque}        
    # Textfield Value Should Be      ${ZoneMessagesRisque}       ${Message_Risque}
    # Sleep    2s
    # Textfield Should Contain      ${txt_conf_risque_enreg}       ${Message_Risque}        
    # Textfield Value Should Be      ${txt_conf_risque_enreg}       ${Message_Risque}
    # Element Value Should Not Be          La valeur de l’élément ne doit pas être 
    # Element Value Should Be 
    
    
    Copier un texte     ${130_Num_Avenant}       CTRL+a    CTRL+c

    Copier un texte   
    [Arguments]        ${Champ}    ${Action1}    ${Action2}
    Wait Until Element Is Visible        ${Champ}         60 
    Click Element          ${Champ}
    Press Keys	  ${Champ}	      ${Action1} 	    ${Action2}  
    Sleep      5s  
 




    Action Coller un texte   
    # [Arguments]        ${Action}
    Wait Until Element Is Visible        ${310_14_coller_Num_Avenant}         60  
    Wait Until Keyword Succeeds    10 x    2 s   Click Element          ${310_14_coller_Num_Avenant} 
    Press Keys  None  TAB
    # Press Keys	   ${ChampNumAVenant}	   ${Action} 
    Press Keys	   ${ChampNumAVenant}         CTRL+v   
    

    # Click Element         ${drop_champ1_type_lieu_Raqv2}
    # Mouse Over                           ${drop_champ1_type_lieu_Raqv2} 
    # Selectionner un texte       ${drop_champ1_type_lieu_Raqv2}      CTRL+a   
    # Clear Element Text         ${drop_champ1_type_lieu_Raqv2} 
    # Sleep    2s 
    # Wait Until Keyword Succeeds	    30s	5s    MaifTstFacLibrary.Press Backspace 
    # Press Keys      None      ENTER
    # # Selectionner un texte       ${drop_champ1_type_lieu_Raqv2}      CTRL+a
    # # Clear Element Text         //*[@id="type_lieu_select"]/div/div
    # # Selectionner un texte       ${drop_champ1_type_lieu_Raqv2}      CTRL+a
    # # Clear Element Text         //*[@id="type_lieu_select"]/div/div/div
    # # Selectionner un texte       ${drop_champ1_type_lieu_Raqv2}      CTRL+a
    # # Clear Element Text         //*[@id="type_lieu_select"]/div/div/div/div
    # # Selectionner un texte       ${drop_champ1_type_lieu_Raqv2}      CTRL+a
    # # Clear Element Text         //*[@id="type_lieu_select"]/div/div/div/div/input
    # # Selectionner un texte       ${drop_champ1_type_lieu_Raqv2}      CTRL+a
    # # Clear Element Text         //*[@id="type_lieu_options"]


    ${TopBar}                       //*[@class="darwin-topbar-menu"]
    ${bouton_lanceurApplication}    //button[@id="darwin-zra-menubar" and @class="darwin-zra-menubar"]
    ${Zone_rechercheApplication}    //input[@class="input-container-field"]
    ${applicationAOuvrir}           //div[@class="darwin-zra-item-hover"]
    ${bouton_clear}                 //*[@class="darwin-clear-input-icon"]

Page Contexte et adresse Devis RAQVAM2 
    [Arguments]     ${Rav2_OrgContact}     ${CONT}     ${ADRS}     ${INFO_ADRS}     ${AssurPrecedent}      ${ACTION}  
    # AWait Browser Ready And Complete 
    # Wait Until Keyword Succeeds    10 x    2 s    Get Window Titles
    # Selectionner Windows    2
    Wait Until Keyword Succeeds    10 x    2 s    switch window       Devis RAQVAM2 
    Détention et Récapitulatif 
    Contact et date d'effet Raqvam2      ${Rav2_OrgContact}       
    Contexte Raqvam2     ${CONT}     
    # # Adresse du risque Raqvam2
    Bloc Adresse du risque Raqvam2       ${ADRS}
    Renseigner info Adresse du risque Raqvam2       ${INFO_ADRS}
    # # Antécédents Raqvam2         
    Bloc Antécédents Raqvam2**        ${AssurPrecedent}             
    Action Page Caracteristique Raqv2     ${ACTION} 
    # # Actions nouvelle adresse           
    # # Actions adresse connue   
    Actions adresse             
    Action Page Caracteristique Raqv2     ${ACTION}
OZO
    $ est utilisé pour les variables scalaires.
    @ est utilisé pour les variables de liste.
    & est utilisé pour les variables de dictionnaire.
    % est utilisé pour les variables d’environnement.

 
 
[11:03] CAULLEECHURN Luxmee
 Verification des Franchises Affichées - VAM 4Roues            Difference=Oui    Plenitude=Oui    Essentiel=Oui    Pertinence=***
    ...                                                           FranchProp=***    Valeur_Diff1=500,00 €    Valeur_Diff2=770,00 €    Valeur_Diff3=***    Valeur_Plen1=240,00 €    
    ...                                                           Valeur_Plen2=500,00 €        Valeur_Plen3=770,00 €       Valeur_Plen4=***        Valeur_Plen5=***        
    ...                                                           Valeur_Ess1=240,00 €    Valeur_Pert1=***    Valeur_FrProp1=***
   


Selectionner Formule
    [Arguments]         ${Formule}
    Wait Until Keyword Succeeds    10 x    2 s     Wait Until Element Is Visible    ${chk_formule_2}       60
    Run Keyword If      '${Formule}' == '01'        Select Checkbox     ${chk_formule_1}
    Run Keyword If      '${Formule}' == '02'        Select Checkbox     ${chk_formule_2}
    Run Keyword If      '${Formule}' == '03'        Select Checkbox     ${chk_formule_3}
    Run Keyword If      '${Formule}' == '04'        Select Checkbox     ${chk_formule_4}
    ${passed} =         Run Keyword And Return Status	    Wait Until Element Is Visible       ${chk_reco_form_1}     5     error=False
    Run Keyword If	    ${passed}	Preconiser Formule  ${Formule}   
    # Sleep    2s

Preconiser Formule 
    [Arguments]         ${PrecFormule}
    AWait Browser Ready And Complete
    Wait Until Keyword Succeeds    10 x    2 s     Wait Until Element Is Visible    ${chk_reco_form_1}       60
    Run Keyword If      '${PrecFormule}' == '01'        Select Checkbox     ${chk_reco_form_1}
    Run Keyword If      '${PrecFormule}' == '02'        Select Checkbox     ${chk_reco_form_2}
    Run Keyword If      '${PrecFormule}' == '03'        Select Checkbox     ${chk_reco_form_3}
    Run Keyword If      '${PrecFormule}' == '04'        Select Checkbox     ${chk_reco_form_4}
    Sleep    2s
    # Capture Page Screenshot



# Resil autom*
#     ${Action_1}=      Run Keyword And Return Status      Click Element If Present     ${rd_resil_auto_oui}
#     ${Action_2}=      Run Keyword And Return Status      Wait Until Element Is Visible     ${chk_benef_principal}       60  
#     Run Keyword If    ${Action_1}    Click Element If Present     ${rd_resil_auto_oui}
#     ...    ELSE IF    ${Action_2}    Wait Until Element Is Visible     ${chk_benef_principal}       60  
#     Attendre Traitement

# Date Resil autom*    
#     ${Action_01}=      Run Keyword And Return Status      Input Field       ${Champ_Resil_Autom}        29072023
#     ${Action_02}=      Run Keyword And Return Status      Wait Until Element Is Visible     ${chk_benef_principal}       60  
#     Run Keyword If    ${Action_01}    Input Field       ${Champ_Resil_Autom}        29072023
#     ...    ELSE IF    ${Action_02}    Wait Until Element Is Visible     ${chk_benef_principal}       60  
#     Attendre Traitement  

    Wait Until Element Contains     ${Inputliste}     ${List}        
    Element Text Should Be      ${Inputliste}       ${List}
    Element Should Contain       ${Inputliste}      ${List}


    Checking List Items 
    [Arguments]         ${Inputliste}    ${List} 
    Wait Until Element Is Visible      ${Inputliste}         60 
    ${Verif_Element_Inputliste}=    Get text    ${Inputliste} 
    Capture Element Screenshot         ${Inputliste} 
    Should Be Equal As Strings    ${Verif_Element_Inputliste}    ${List}      
    Wait Until Element Contains     ${Inputliste}     ${List}     
    Element Text Should Be      ${Inputliste}       ${List}
    Element Should Contain       ${Inputliste}      ${List} 


Select Drop valeur 
    [Arguments]                         ${Inputliste}    ${valeur}
    AWait Browser Ready And Complete
    Wait Until Element Is Visible       ${Inputliste} 
    Wait Until Element Is Enabled       ${Inputliste} 
    Click Element                       ${Inputliste}/../../../..
    Press Keys                          None    BACKSPACE
    #press_key_directly                 ${valeur}
    Wait Until Element Is Visible       //div[@class='Select-option is-focused']/../div/span[starts-with(text(),'${valeur}')]
    Click Element                       //div[@class='Select-option is-focused']/../div/span[starts-with(text(),'${valeur}')]
    AWait Browser Ready And Complete
    

Select Options By    id=damageinsurance    text    No Coverage
      

pipeline {
    agent any

    stages {
        stage('Préparation') {
            steps {
                echo 'Préparation de l’environnement...'
            }
        }

        stage('Build') {
            steps {
                echo 'Compilation du projet...'
                // Exemple : sh 'npm install' ou 'mvn clean install'
            }
        }

        stage('Tests') {
            steps {
                echo 'Exécution des tests...'
                // Exemple : sh 'npm test' ou 'pytest'
            }
        }

        stage('Déploiement') {
            steps {
                echo 'Déploiement en cours...'
            }
        }
    }
}





Recuperer Societaire*
    [Arguments]         ${IDTEST}      
    ${environment}=       Env Get Env   
    ${jdd}=     Csv Load    JDD/SOC_AHJ.csv
    ${couloir_rec}=     JsonPath Match      soc[?(@.COULOIR=='${environment}' & @.IDTEST=='${IDTEST}')]    ${jdd}
    Set Suite Variable      ${SOC}      ${couloir_rec}[0][SOCIETAIRE] 


Scroll To Element And Click
    [Arguments]    ${Element-path-From}
    
    FOR    ${INDEX}    IN RANGE    1    15
        Press Keys      None    ARROW_DOWN
        ${passed}=  	    Run Keyword And Return Status       Click Element    ${Element-path-From}  
        Run Keyword If     '${passed}'=='True'       Exit For Loop 
    END


Input Field
    [Arguments]    ${Element}   ${Text} 
    AWait Browser Ready And Complete
    Wait Until Element Is Visible       ${Element}         60 
    Wait Until Element Is Enabled       ${Element}         60
    Click Element                       ${Element}
    press_key_directly                  ${Text}
    AWait Browser Ready And Complete
    
Select Drop
    [Arguments]                         ${Inputliste}    ${valeur}           
    ${str}=                             Replace String      ${Inputliste}     input     div
    ${ITEMS}=                           Replace String      ${str}     Input     Items
    AWait Browser Ready And Complete
    Click Element                       ${Inputliste}
    Click Element                       ${ITEMS}/div[contains(text(),'${valeur}')]

Select Drop Strict
    [Arguments]                         ${Inputliste}    ${valeur}       
    IF  '${valeur}'!='***'
        ${str}=                             Replace String      ${Inputliste}     input     div
        ${ITEMS}=                           Replace String      ${str}     Input     Items
        AWait Browser Ready And Complete
        Click Element                       ${Inputliste}
        Click Element                       ${ITEMS}/div[text()='${valeur}']
    END



Select Drop MD
    [Arguments]                         ${Inputliste}    ${valeur}
    AWait Browser Ready And Complete
    Wait Until Element Is Visible       ${Inputliste} 
    Wait Until Element Is Enabled       ${Inputliste} 
    Click Element                       ${Inputliste}/../../../..
    Press Keys                          None    BACKSPACE
    #press_key_directly                 ${valeur}
    Wait Until Element Is Visible       //div[@class='Select-option is-focused']/../div/span[starts-with(text(),'${valeur}')]
    Click Element                       //div[@class='Select-option is-focused']/../div/span[starts-with(text(),'${valeur}')]
    AWait Browser Ready And Complete


Element Value Should Be Empty   
    [Arguments]             ${ELEMENT} 
    ${val}=	                Get Element Attribute	    ${ELEMENT}      value
    Should Be True          ${val}     ${EMPTY}  
Element Value Should Not Be Empty   
    [Arguments]             ${ELEMENT} 
    ${val}=	                Get Element Attribute	    ${ELEMENT}      value
    Should Not Be True      ${val}     ${EMPTY}         
Element Value Should Be  
    [Arguments]             ${ELEMENT}      ${VALUE}
    ${val}=	                Get Element Attribute	    ${ELEMENT}      value
    Should Be True          '${val}'=='${VALUE}'  
Go To Login Page
    Go To    ${LOGIN URL}
    Login Page Should Be Open

Input Password
    [Arguments]    ${password}
    Input Text      password    ${password}

Input Username
    [Arguments]     ${username}
    Input Text      login    ${username}

Scroll Page To Location
    [Arguments]             ${x_location}    ${y_location}
    Execute JavaScript      window.scrollTo(${x_location},${y_location})

Input Date Browser 
    [Documentation]
    [Arguments]     ${ID}   ${TXT}
    Run Keyword If  '${BROWSER}'=='chrome'   Execute JavaScript    document.getElementById('${ID}').value = '${TXT}'
    Run Keyword If  '${BROWSER}'=='firefox'   Press Keys    //input[@id="${ID}"]   ${TXT}
Ouvrir Navigateur
    Open Tstfac Browser

Lancer navigateur_metier
    [Arguments]          ${APP}
    Log to console    \n Lancement du navigateur métier
    #Lancer Application   ${URL_${APP}}
    Lancer le navigateur métier     ${URL_${APP}}
    #Verif 1 
          

Ouvrir Application
    [Arguments]          ${APP}
    Lancer Application   ${URL_${APP}}

Detecter Type Erreur
    Set Suite Variable      ${ENV_ERROR}    None
    FOR    ${ERROR1}    IN      @{ERRORS}
        ${found}=  	    Run Keyword And Return Status       Page Should Contain    ${ERROR1}    loglevel=NONE
        Run Keyword If     ${found}       Set Suite Variable      ${ENV_ERROR}    ${ERROR1}
        Run Keyword If     ${found}       Exit For Loop 
    END
    ${found}=  	        Run Keyword And Return Status       Page Should Contain Element      //span[@class='rf-msgs-err']/span    
    Run Keyword If              ${found}       Recuperer Message Erreur   
    Run Keyword If            '${ENV_ERROR}'!='${None}'     Set Test Message             Exception Message: ${ENV_ERROR}
Recuperer Message Erreur
    ${Erreur_pop}=              Get Text        //span[@class='rf-msgs-err']/span       
    Set Suite Variable          ${ENV_ERROR}    ${Erreur_pop}
Fermer Navigateur
    Run Keyword If Test Failed            Detecter Type Erreur
    Close TstFac Browser
Click Element If Present
    [Arguments]         ${ELEMENT}
    ${found}=  	                Run Keyword And Return Status             Page Should Contain Element         ${ELEMENT}
    Run Keyword If            ${found}                  Click Element                    ${ELEMENT}

Generer Date Effet
    [Arguments]     ${NB_Days}
    ${date}=        Get Current Date      UTC      
    ${plus14}=      Add Time To Date      ${date}        ${NB_Days} days
    ${FORMAT}=      Switch Date Format
    ${gen_date}=    Convert Date          ${plus14}      ${FORMAT}
    ${gen_date_2}=    Convert Date          ${plus14}      %d/%m/%Y
    Set Suite Variable      ${DATE_EFFET}      ${gen_date}
    Set Suite Variable      ${DATE_EFFET_FORMAT}      ${gen_date_2}

Generer Date Effet Darwin
    [Arguments]     ${NB_Days}
    ${date}=        Get Current Date      UTC      
    ${plus14}=      Add Time To Date      ${date}        ${NB_Days} days
    ${FORMAT}=      Switch Date Format Darwin
    ${gen_date}=    Convert Date          ${plus14}      ${FORMAT}
    ${gen_date_2}=    Convert Date          ${plus14}      %d/%m/%Y
    Set Suite Variable      ${DATE_EFFET}      ${gen_date}
    Set Suite Variable      ${DATE_EFFET_FORMAT}      ${gen_date_2}

Generer Immatriculation VAM
    ${pt1} =	Generate Random String	2	[UPPER]
    ${pt2} =	Generate Random String	3	[NUMBERS]
    ${pt3} =	Generate Random String	2	[UPPER]
    Set Suite Variable      ${IMMAT_PT1}      ${pt1}
    Set Suite Variable      ${IMMAT_PT2}      ${pt2}
    Set Suite Variable      ${IMMAT_PT3}      ${pt3}
Generer Date Passé
    [Arguments]  ${NB_Days}
    ${date}=        Get Current Date      UTC     
    ${plus14}=      Subtract Time From Date      ${date}        ${NB_Days} days
    ${FORMAT}=      Switch Date Format
    ${gen_date}=    Convert Date          ${plus14}      ${FORMAT}
    # [Return]    ${gen_date}
    RETURN    ${gen_date}

Switch Date Format 
    ${D_FORMAT}=   Set Variable If          '${BROWSERNAME}' =='firefox'     ${FORMAT_FF}
    ...            ${FORMAT_CH}
    # [Return]      ${D_FORMAT}
    RETURN    ${D_FORMAT}


Switch Date Format Darwin
    ${D_FORMAT}=   Set Variable If          '${BROWSERNAME}' =='Darwin'     ${FORMAT_FF}
    ...            ${FORMAT_CH}
    # [Return]      ${D_FORMAT}
    RETURN      ${D_FORMAT}






Rechercher Variante
    [Arguments]         ${liste_variante}    ${valeur_recherche}   
    ${nb_donne}=         Get Element Count               ${liste_variante}
    FOR    ${INDEX}    IN RANGE    1    ${nb_donne}
        ${txt}=      Get Text     //ul[1]/li[${INDEX}]/a
        Run Keyword If    '${result}' == '${valeur_recherche}'    Exit For Loop
    END
    ${INDEX}=   Set Variable If      '${result}' == '${result1}'     ${INDEX}
    ...            NO_RESULT
    RETURN    ${INDEX}

Generer Libelle lot 
    [Arguments]     ${nmlt}
    ${UUIDD}=   Gen Uuid Lot
    RETURN    ${nmlt}-${UUIDD}
Switcher Tab
    [Arguments]         ${i}
    # Afficher la tab "i"
    #Wait For Testability Ready 
    Sleep               6
    Switch Window       ${i}

    # Send Keys TypeWrite      g
    # Sleep    1
    # Wait Until Keyword Succeeds	    30s	3s       Select Window	NEW


Send Key Press       enter
    Log to console    Click sur ENTER
    Wait Until Keyword Succeeds	    30s	5s       Send Key Press   enter
    Wait Until Keyword Succeeds	    30s	3s       Select Window	NEW
    

Suite test assur precedent      
    Wait Until Keyword Succeeds    10 x    2 s      Send Key Press   down
    Wait Until Keyword Succeeds    10 x    2 s      Send Key Press   down
    Wait Until Keyword Succeeds    10 x    2 s      Press Keys  None  enter

    
    -->