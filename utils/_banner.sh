#!/bin/bash
#
# Print banner art.

#######################################
# Print a board. 
# Globals:
#   BG_BROWN
#   NC
#   WHITE
#   CYAN_LIGHT
#   RED
#   GREEN
#   YELLOW
# Arguments:
#   None
#######################################
print_banner() {

  clear
  
  printf "\n"

  printf "${GREEN}";
  printf "   ##     ##  ##    ####    ##        ####    ######   ######  \n";
  printf "  ####    ##  ##   ##  ##   ##       ##  ##     ##     ## \n";
  printf " ##  ##    ####    ##  ##   ##       ##  ##     ##     ## \n";
  printf " ######     ##     ##  ##   ##       ##  ##     ##     #### \n";
  printf " ##  ##    ####    ##  ##   ##       ##  ##     ##     ## \n";
  printf " ##  ##   ##  ##   ##  ##   ##       ##  ##     ##     ## \n";
  printf " ##  ##   ##  ##    ####    ######    ####      ##     ###### \n";
  printf " VERSÃO AXOLOTE 1.0 - VERSÃO WASAP 4.0 -  VERSÃO DE TESTES \n";
  printf "${NC}";
  printf "\n"
  printf "\n"
printf "\n";
}
