import pytest
from playwright.sync_api import Page, expect


@pytest.fixture(scope="session")
def django_server():
    # Démarrer le serveur Django pour les tests
    pass


def test_button_toggles_text(page: Page):
    # Naviguer vers la page
    page.goto("http://localhost:8000/")

    # Localiser les éléments
    text_element = page.locator("#text")
    button = page.locator("button")

    # Vérifier le texte initial
    expect(text_element).to_have_text("Texte initial")

    # Cliquer sur le bouton
    button.click()

    # Vérifier le changement
    expect(text_element).to_have_text("Texte modifié !")

    # Cliquer à nouveau
    button.click()
    expect(text_element).to_have_text("Texte initial")