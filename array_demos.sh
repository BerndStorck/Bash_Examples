#!/usr/bin/env bash
#
# array_demos.sh, 2024-11-09
#
# Project Description:
#
# Demo of array handling in bash scripts.
#
# Usage: Call the script without parameters.
#
# Author:     Bernd Storck
# Contact:    https://www.facebook.com/BStLinux/
#
# Copyright:  2024, Bernd Storck
# License:    GNU General Public License 3.0

# Farbnamensvariablen: ....................................
readonly BLACK='\033[0;30m'
readonly WHITE_INTENSE='\033[0;97m'
readonly YELLOW='\033[0;33m'
readonly YELLOW_BOLD='\e[1;33m'
readonly YELLOW_INTENSE='\033[0;93m'
readonly BLUE='\033[0;34m'
readonly RED='\033[0;31m'
readonly RED_INTENSE='\033[0;91m'
readonly RED_BOLD_INTENSE='\033[1;91m'
readonly ON_GREEN='\033[42m'  # Background Color
readonly COLOROFF='\e[0m'


# Terminalfensterbreite ermitteln:
lineLength="$(tput cols)"
(( lineLength-- ))


plotLine () {
# Erzeugt eine Trennlinie aus Minuszeichen.
  local divider
  for in in $(seq 1 $lineLength); do
    divider+='-'
  done
  echo "$divider"
}

printTitle () {
# Gibt eine mit ANSI-Code eingefaerbete Titelzeile aus.
  echo -e "${YELLOW_BOLD}$1${COLOROFF}\n"
}

printCode () {
# Gibt den ein Code-Beispiel mit Zeilenumbruechen 
# auf mit ANSI-Code gruen gefaerbtem Hintergrund aus.
  for line in "$@"; do
  echo -e "${BLACK}${ON_GREEN} $line ${COLOROFF}"
  done
  echo
}

printCodeIntro () {
# Gibt das gesamte Intro fuer ein einzelnes Code-Beispiel aus: Trennline, Title und Code.
  plotLine
  printTitle "$1"
  shift
  printCode "$@"
}

printCodeIntro "Dummy-Array erstellen:" 'dummyArray=("Element1" "Element2" "Element3" "Element4" "Element5")'
dummyArray=("Element1" "Element2" "Element3" "Element4" "Element5")


printCodeIntro "Laenge des Arrays:" 'arrayLength=${#dummyArray[@]}' 'echo "Das Array hat $arrayLength Elemente."'
arrayLength=${#dummyArray[@]}
echo "Das Array hat $arrayLength Elemente."

printCodeIntro "Zugriff auf das gesamte Array:" 'echo "Gesamtes Array: ${dummyArray[@]}"' 'echo "Gesamtes Array: ${dummyArray[*]}"'
echo "Gesamtes Array: ${dummyArray[@]}"
echo "Gesamtes Array: ${dummyArray[*]}"

printCodeIntro "Zugriff auf ein bestimmtes Element (z.B. das dritte Element):" 'echo "Drittes Element: ${dummyArray[2]}"'
echo "Drittes Element: ${dummyArray[2]}"

printCodeIntro "Zugriff auf alle Elemente mit einer Schleife:" 'echo "Alle Elemente:"' 'for element in "${dummyArray[@]}"; do' '  echo "$element"' 'done'
echo "Alle Elemente:"
for element in "${dummyArray[@]}"; do
  echo "$element"
done


plotLine
echo -e "${RED_BOLD_INTENSE}Man beachte folgenden Unterschied!${COLOROFF}"
echo -e "\n${YELLOW}1. Hier wird der Asterisk \"${WHITE_INTENSE}"'*'"${YELLOW}\" verwendet:${COLOROFF}"
echo -e "${YELLOW}${WHITE_INTENSE}\${dummyArray[*]}${YELLOW} wirkt wie ${WHITE_INTENSE}\"Element1 Element2 Element3\"${YELLOW} …${COLOROFF}\n"
echo -e "${BLACK}${ON_GREEN} printf \"%s\\\n\" \"\${dummyArray[*]}\" ${COLOROFF}"
printf "%s\n" "${dummyArray[*]}"

echo -e "\n${YELLOW}2. Hier wird das at-Zeichen \"${WHITE_INTENSE}@${YELLOW}\" verwendet:"
echo -e "${YELLOW}${WHITE_INTENSE}\${dummyArray[@]}${YELLOW} wirkt wie ${WHITE_INTENSE}\"Element1\" \"Element2\" \"Element3\"${YELLOW} …${COLOROFF}\n"
echo -e "${BLACK}${ON_GREEN} printf \"%s\\\n\" \"\${dummyArray[@]}\" ${COLOROFF}"
printf "%s\n" "${dummyArray[@]}"


printCodeIntro "Aendern eines Elements (z.B. das erste Element):" 'dummyArray[0]="NeuesElement1"' 'echo "Nach Aenderung: ${dummyArray[@]}"'
dummyArray[0]="NeuesElement1"
echo "Nach Aenderung: ${dummyArray[@]}"

printCodeIntro "Hinzufuegen eines neuen Elements:" 'dummyArray+=("Element6")' 'echo "Nach Hinzufuegen eines neuen Elements: ${dummyArray[@]}"'
dummyArray+=("Element6")
echo "Nach Hinzufuegen eines neuen Elements: ${dummyArray[@]}"

printCodeIntro "Laenge des Array nach dem Hinzufuegen eines neuen Elements:" 'newLength=${#dummyArray[@]}' 'echo "Das Array hat jetzt $newLength Elemente."'
newLength=${#dummyArray[@]}
echo "Das Array hat jetzt $newLength Elemente."
