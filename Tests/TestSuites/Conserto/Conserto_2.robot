*** Settings ***
Documentation    CONSERTO
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Library    Collections
Library    RequestsLibrary
# Library    ../../../Helpers/diff_words.py



# Suite Setup     Nettoyer Dossier Logs
Resource         ../../../Resources/Commun_conserto.robot
Resource         ../../../Resources/Keywords.robot
Resource         ../../../Variables/Global_variables.robot




# Test Setup       NONE  # Open Browser
# Test Teardown    NONE  # Close Browser  
# git push origin main:test
# Jenkins : Id = Test_Cons Kolima2431121980@

Test Setup      Prérequis test   # NONE   Préparer Test
Test Teardown   Close Browser   # Capture Erreur Unique

##############################################################                                                                   
#./Helpers/run-test.py -i CONSERTO --keepbrowseropened       #
#####################################################################################################################################
# robot Tests/TestSuites/Conserto/conserto_1.robot                                                                                  #
# robot -d Screenshot/ Tests/TestSuites/Conserto/conserto_1.robot                                                                   #
# robot -d Screenshot/ Tests/                                                                                                       #
# robot -d Resultats/ Tests/                                                                                                        #
# robot -d Resultats/ Tests/TestSuites/Conserto/conserto_2.robot                                                                           #
# robot   --output Logs/output.xml   --log Logs/log.html   --report Logs/report.html   Tests/TestSuites/Conserto/conserto_1.robot   #
#####################################################################################################################################

*** Test Cases ***

Automatisation du site conserto cas 2
    [Documentation]       Scénario CONSERTO-CON0001 : Vérifier quelques éléments du site conserto.
    ...                   JDD : Salarié chez conserto, ayant une adresse mail et un mot de passe actifs.
    [Tags]    CON0001    ETAT:Stable    TYPE:CONSERTO     PRIORITE:P1 
    Ouverture Navigateur    ${URL_CONSERTO}    Hors mobile      # Hors mobile  Avec Mobile  
    Vérifier logo conserto
    Action Barre de navigation 
    Verif positive techologie    ${Positif_Techo_info}
    Page acceuil verifs ilots et agences     ${Accueil_Ilots_container_texte}
    Selectionner agence par index      Toutes
    Test actions Ilots   

    
    


















