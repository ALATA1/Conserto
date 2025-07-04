*** Settings ***
Documentation       Les variables globales déclarées ou à appeler
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Library    Collections
Library    RequestsLibrary


# Library    Collections
# Library    BuiltIn
# Library    DateTime



# Resource         ../../../Resources/Commun_conserto.robot
# Resource         ../../../Resources/Keywords.robot





*** Variables ***
${OPTIONS}=    add_argument(--headless)    add_argument(--disable-gpu)
...            add_argument(--no-sandbox)    add_argument(--disable-dev-shm-usage)
...            add_argument(--window-size=1920,1080)

${Conserto}                    //a[@class="hdr-logo-link" and @rel="home"]
${Positive_Techo}              //*[contains(text(), 'Positive') and contains(text(), 'Technologie')]    
${Barre_de_nav}                //nav[@id="nav-main" and @class="nav-main"]   # //*[@id="nav-main"]   #//nav[@id="nav-main" and @class="nav-main"]    #id=submit-button     # //*[@id="nav-main"]
# xpath=//nav[@id="nav-main" and .//h2[text()="Offre spéciale"]]
# //button[@id="darwin-zra-menubar" and @class="darwin-zra-menubar"]
${Positive}                    //a[contains(text(),"Positive")]
${historique}                  //div[@class='control-block']
${histo}                       //div[@class='control-items']
${annees_2013}                 //div[@class="item active" and @data-index="0"]
${Textes_complets_Positive}    //div[@class='text-wysiwyg']     #//*[contains(text(), '${Texte_Positive}') and contains(text(), '${Texte_Positive_2}')]
${Texte_Positive}              ${Texte_Positive_1}\n${Texte_Positive_2}
${Texte_Positive_1}            Nous pensons que la technologie doit avoir un impact positif sur l’avenir de tous.
${Texte_Positive_2}            La mission de Conserto est de cultiver le sens et les savoirs par la différence.
${Culture_Agile}               //a[contains(text(),"Culture Agile")]
${Technologie}                 //a[contains(text(),"Technologie")]
${Clients}                     //a[contains(text(),"Nos clients")]
${Academy}                     //a[contains(text(),"Academy")]
${Blog}                        //a[contains(text(),"Blog")]
${Contact}                     //a[contains(text(),"Contact")]
${Positif_Techo_info}          Positive Technologie    # Positive\nTechnologie
${Texte_Posit_Techo}           Positive
${postech}                     //h1[contains(text(),"positive technologie")]   #//div[@class='words-container']
${Mobile_menu}                 //button[@class='mobile-menu-button']
${Info_2013}                   //div[@class="slider-item" and @data-index="0"]/div/div[2]/div[@class='timeline-item__content']  

${Posit_texte}                 Positive
${Tech_texte}                  Technologie
${Positive_texte}              POSITIVE
${Techo_texte}                 TECHNOLOGIE
${Clients_texte}               NOS CLIENTS
${Academy_texte}               ACADEMY
${Blog_texte}                  BLOG
${Contact_texte}               CONTACT

${Nav_texte}                   ${Positive_texte}\n${Techo_texte}\n${Clients_texte}\n${Academy_texte}\n${Blog_texte}\n${Contact_texte}

${Bloc_contact}                //div[@class="content-wrapper"]
${Title_bloc_contact}          //h1[@class="title"]
# ${Ilots_Infra}                 //div[contains(@class, "ilots-container")]//a[contains(@class, 'offer-item offer-infra-cloud') and contains(., "Infra / Cloud")]
# ${Ilots_Devops}                //div[contains(@class, "ilots-container")]//a[contains(@class, 'ooffer-item offer-devops') and contains(., "Devops")] 
# ${Ilots_Dev}                   //div[contains(@class, "ilots-container")]//a[contains(@class, 'offer-item offer-dev') and contains(., "Dev")] 
# ${Ilots_Agence_Web}            //div[contains(@class, "ilots-container")]//a[contains(@class, 'offer-item offer-agenceweb') and contains(., "Agence Web")] 
# ${Ilots_Culture_Agile}         //div[contains(@class, "ilots-container")]//a[contains(@class, 'offer-item offer-agilite') and contains(., "Culture Agile")]     
#${Ilots_Culture_Agile}        //div[contains(@class, "ilots-container")]//a[contains(., "Culture Agile")]

${Ilots_Infra}                 //div[contains(@class, "ilots-container")]//a[contains(., "Infra")]
${Ilots_Devops}                //div[contains(@class, "ilots-container")]//a[contains(., "Devops")]
${Ilots_Dev}                   //div[contains(@class, "ilots-container")]//a[contains(., "Dev")] 
${Ilots_Agence_Web}            //div[contains(@class, "ilots-container")]//a[contains(., "Agence Web")]
${Ilots_Culture_Agile}         //div[contains(@class, "ilots-container")]//a[contains(., "Culture Agile")]

${Xpath_IMG}                   //header[@class='article-header single-offer__header']/div[@class='left']//picture//img

${FILE1_OUTPUT_Infra}          downloaded_image_Infra.jpg
${FILE2_OUTPUT_Devops}         downloaded_image_Devops.jpg
${FILE3_OUTPUT_Dev}            downloaded_image_Dev.jpg
${FILE4_OUTPUT_Agence_Web}     downloaded_image_Agence_Web.jpg
${FILE5_OUTPUT_Culture_Agile}  downloaded_image_Culture_Agile.jpg


${Nom_Bloc_contact}            //input[contains(@Id, "wpforms-284-field_2") and @placeholder="Nom"]
${Prénom_Bloc_contact}         //input[contains(@Id, "wpforms-284-field_4") and @placeholder="Prénom"]
${Email_Bloc_contact}          //input[contains(@Id, "wpforms-284-field_5") and @placeholder="Email"]

${Champ_Agence}                id=wpforms-284-field_6   
${Champ_contact}               id=wpforms-284-field_7   
${Champ_saisi_Message}         id=wpforms-284-field_8

${FICHIER_REFERENCE}           page_reference_positive.txt
# ${FICHIER_REFERENCE}    ./page_reference.txt
${FICHIER_REF_POSITIVE}        page_reference_positive.txt
${FICHIER_REF_TECHO}           page_reference_technologie.txt
${FICHIER_REF_CLIENTS}         page_reference_nos_clients.txt
${FICHIER_REF_ACADEMY}         page_reference_academy.txt
${FICHIER_REF_BLOG}            page_reference_nos_blog.txt
${FICHIER_REF_CONTACT}         page_reference_contact.txt



${VotreMessage}    Objet : Candidature pour un poste de testeur chez Conserto.\n
...    Bonjour Madame, Monsieur,\n
...    Je me permets de vous adresser ma candidature pour un poste de testeur au sein de votre entreprise.\n
...    Fort d’une expérience de 5 ans dans le domaine des tests automatisés, je suis particulièrement intéressé par les valeurs portées par Conserto et par les projets innovants que vous conduisez.\n
...    Je joins à ce message mon CV ainsi qu’une lettre de motivation, et je reste à votre disposition pour toute information complémentaire ou un éventuel entretien.\n
...    Je vous remercie de l’attention portée à ma candidature et vous prie d’agréer, Madame, Monsieur, l’expression de mes salutations distinguées.\n
...    Cordialement,


${Button_Envoyer_Message}      //button[@type="submit" and @id="wpforms-submit-284"]        #//*[@id="wpforms-submit-284"]
${Checkbox_contact}            id=wpforms-284-field_9_3


##########################################################################################
############################ VARIABLES IDNOW #############################################
@{Secteurs}    Banque traditionnelle    Assurances    Jeux    Voyage   
...    Ressources humaines   Fintech    Mobilité   Crypto   Télécommunication
@{Solutions}   Vérification d’identité automatisée    Vérification d’identité en personne    
...    Vérification d’identité guidée par des experts    Services de confiance
@{Centre de connaissances}    Blog    Cas Clients    Webinaires    
...    Rapports et guides    Glossaire    Pôle développeurs
@{Société}    Presse    Carrières    Nos valeurs    Partenaires    Références    À propos
@{Contact}    Support utilisateurs    Contactez notre équipe de ventes  


${Barre_de_nav_Idnow}          //nav[@class='site-nav']
${Barre_de_nav_Idnow2}         //*[@id="menu-navigation-fr"]


${Texte1_activite}         Nous transformons la confiance en avantage stratégique.
${Texte2_activite}         Grâce à nos solutions d’identité SaaS pilotées par l’IA, vous bénéficiez d’une sécurité extensible, d’une conformité évolutive et d’une prévention de la fraude en temps réel. De quoi naviguer sereinement dans un monde digital complexe.