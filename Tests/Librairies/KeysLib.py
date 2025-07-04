from selenium import webdriver
from SeleniumLibrary import SeleniumLibrary
from robot.libraries.BuiltIn import BuiltIn
import time
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.common.keys import Keys
import selenium.webdriver.support.ui as ui
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.touch_actions import TouchActions
from selenium.webdriver.common.action_chains import ActionChains


class KeysLib_disabled():

    def current_browser(self):
        return BuiltIn().get_library_instance('SeleniumLibrary').driver

    def ouvrir_tab(self, url):
        driver = BuiltIn().get_library_instance('SeleniumLibrary').driver
        driver.execute_script("window.open('{}');".format(url))
        windows = driver.window_handles
        window = windows[-1]
        # Ligne du dessous, a test si ouverture onglet bug
        #WebDriverWait(driver, 5).until(EC.number_of_windows_to_be(window))
        driver.switch_to_window(window)

    # Le numero onglet correspond a la position de l'onglet voulu, le premier est le 0
    def change_tab(self, numeroonglet):
        driver = BuiltIn().get_library_instance('SeleniumLibrary').driver
        windows = driver.window_handles
        numeroonglet = int(numeroonglet)
        window = windows[numeroonglet]
        driver.switch_to_window(window)

     # Le numero onglet 1 correspond au tab qui va se faire fermer, le numero onglet 2, au tab que l'on va reouvrir
    def fermer_tab(self, numeroonglet1, numeroonglet2):
        driver = BuiltIn().get_library_instance('SeleniumLibrary').driver
        windows = driver.window_handles
        numeroonglet1 = int(numeroonglet1)
        numeroonglet2 = int(numeroonglet2)
        window = windows[numeroonglet1]
        driver.switch_to_window(window)
        driver.close()
        window2 = windows[numeroonglet2]
        driver.switch_to_window(window2)

    def press_enter(self):
        driver = BuiltIn().get_library_instance('SeleniumLibrary').driver
        actions = ActionChains(driver)
        actions.send_keys(Keys.ENTER)
        actions.perform()

    def press_tab(self):
        driver = BuiltIn().get_library_instance('SeleniumLibrary').driver
        actions = ActionChains(driver)
        actions.send_keys(Keys.TAB)
        actions.perform()

    def press_uparrow(self):
        driver = BuiltIn().get_library_instance('SeleniumLibrary').driver
        actions = ActionChains(driver)
        actions.send_keys(Keys.ARROW_UP)
        actions.perform()

    def press_leftarrow(self):
        driver = BuiltIn().get_library_instance('SeleniumLibrary').driver
        actions = ActionChains(driver)
        actions.send_keys(Keys.ARROW_LEFT)
        actions.perform()

    def press_rightarrow(self):
        driver = BuiltIn().get_library_instance('SeleniumLibrary').driver
        actions = ActionChains(driver)
        actions.send_keys(Keys.ARROW_RIGHT)
        actions.perform()

    def press_downarrow(self):
        driver = BuiltIn().get_library_instance('SeleniumLibrary').driver
        actions = ActionChains(driver)
        actions.send_keys(Keys.ARROW_DOWN)
        actions.perform()

    def press_pagedown(self):
        driver = BuiltIn().get_library_instance('SeleniumLibrary').driver
        actions = ActionChains(driver)
        actions.send_keys(Keys.PAGE_DOWN)
        actions.perform()

    def press_end(self):
        driver = BuiltIn().get_library_instance('SeleniumLibrary').driver
        actions = ActionChains(driver)
        actions.send_keys(Keys.END)
        actions.perform()

    def press_backspace(self):
        driver = BuiltIn().get_library_instance('SeleniumLibrary').driver
        actions = ActionChains(driver)
        actions.send_keys(Keys.BACKSPACE)
        actions.perform()

    def press_key_directly(self, touche):
        driver = BuiltIn().get_library_instance('SeleniumLibrary').driver
        actions = ActionChains(driver)
        actions.send_keys(touche)
        actions.perform()

    


# Fonction permettant de choisir de demarrer un nouveau navigateur ou de continuer sur un de lance

    def demarrer_nav_ou_continuer(self, browserclose):
        ouvert = 2
        browsertest = int(browserclose)
        if browsertest != 0:
            try:
                BuiltIn().get_library_instance('SeleniumLibrary').driver
                ouvert = 1
            except:
                ouvert = 2
        else:
            ouvert = 2
        return ouvert

    def write_binary_file(path, content):
        with open(path, 'wb') as f:
            f.write(content)


    