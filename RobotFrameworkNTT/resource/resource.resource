*** Settings ***
Library    Zoomba.GUILibrary
Library    FakerLibrary
Library    XML
Library    RequestsLibrary
Library    String
Library    Collections
Resource   ../GUI/pages/KeywordsGUI.robot
Resource   ../API/pages/KeywordsAPI.robot

*** Variables ***
${URL}                    https://front.serverest.dev/
${BASE_URL}               https://serverest.dev


*** Keywords ***
I access serverest
    Open Browser      url=${URL}      browser=Chrome
    Maximize Browser Window

I close serverest
    Close Browser