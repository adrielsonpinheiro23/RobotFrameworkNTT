*** Settings ***
Resource          ../../resource/resource.resource
Suite Setup        Run Keywords     I access serverest 
Test Teardown      Run Keyword And Ignore Error    I Logout the application
Suite Teardown     I close serverest

*** Test Cases ***
TC1: Perform Login
    I create a new user
    I Login at the serverest Application
    Non Admin User is At Landing Page

TC2: Search for a product And Add to the List
    I create a new user
    I Login at the serverest Application
    ${PRODUCT}    Check available products
    I search for product in search bar        ${PRODUCT}
    I click on Details
    Add the Item to the List        ${PRODUCT}

TC3: Perform Registration As Admin
    I create a new user    isAdmin=${True}