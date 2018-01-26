*** Settings ***
Library  Selenium2Library
Library  XvfbRobot

*** Test Cases ***
Open login page
    Start Virtual Display    1920    1080
    Open browser  http://www.niborea.cz/  firefox
    ${title}=  Log title
    log to console  ${title}