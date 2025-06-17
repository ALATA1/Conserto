*** Settings ***
Documentation    CONSERTO
Library    SeleniumLibrary
Library    OperatingSystem
Library    String


# Suite Setup     Nettoyer Dossier Logs
Resource         ../../../Resources/Commun_conserto.robot
Resource         ../../../Resources/Keywords.robot
Resource         ../../../Variables/Global_variables.robot


Test Setup       NONE  # Open Browser
Test Teardown    Close Browser  
# git push origin main:test
# Jenkins : Id = Test_Cons

##############################################################                                                                   
#./Helpers/run-test.py -i CONSERTO --keepbrowseropened       #
#####################################################################################################################################
# robot Tests/TestSuites/Conserto/conserto_1.robot                                                                                  #
# robot -d Screenshot/ Tests/TestSuites/Conserto/conserto_1.robot                                                                   #
# robot -d Screenshot/ Tests/                                                                                                       #
# robot -d Resultats/ Tests/                                                                                                        #
# robot   --output Logs/output.xml   --log Logs/log.html   --report Logs/report.html   Tests/TestSuites/Conserto/conserto_1.robot   #
#####################################################################################################################################

*** Test Cases ***

Automatisation du site conserto
    [Documentation]       Scénario CONSERTO-CON0001 : Vérifier quelques éléments du site conserto.
    ...                   JDD : Salarié chez conserto, ayant une adresse mail et un mot de passe actifs.
    [Tags]    CON0001    ETAT:Stable    TYPE:CONSERTO     PRIORITE:P1 
    Ouverture Navigateur    ${URL_CONSERTO}    ${BROWSER_3}       # ${BROWSER}  ${BROWSER_2}    ${BROWSER_3}      

    Page d'accueil de Conserto   ${Title_1}   
    Nettoyer Dossier Logs
    Test navigation fonctionne


    
