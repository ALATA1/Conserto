*** Settings ***
Documentation       Les variables globales déclarées ou à appeler
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
   
# Library    Collections
# Library    BuiltIn
# Library    DateTime


# Suite Setup     Nettoyer Dossier Logs

Resource         ../../../resources/Commun_conserto.robot
Resource         ../../../Variables/Global_variables.robot





*** Keywords ***