# Verschachtelte Zählschleifen

Ein Dreieck aus Sternchen auszugeben, ist ein Standard, um den Einsatz von zwei verschachtelten Zählschleifen zu demonstrieren und zu üben.

Ein Beispiel dafür hat Ray Yao in einer Beispielsammlung gegeben.

# Ray Yao's example script: "10. Print a triangle pattern"

```bash
rows=9
for((x=1; x<=rows; x++))
do
    for((y=1; y<=rows - x; y++))
    do
        echo -n " "
    done
    for((y=1; y<=2*x-1; y++))
    do
        echo -n "*"
    done
    echo
done
```

## Ablaufoptimierung

Das Skript gibt 126 Ausgabebefehle (126-mal "echo"). Performanter ist es, erst den gesamten String zusammenzusetzen und ihn am Ende mit einem einzigen echo-Kommando auszugeben.

```bash
rows=9
for((x=1; x<=rows; x++))
do
    for((y=1; y<=rows - x; y++)) # Adds a chain of spaces.
    do
        triangle="$triangle "
    done

    for((y=1; y<=2*x-1; y++))    # Adds a chain of stars.
    do
        triangle="$triangle*"
    done

    triangle="$triangle\\n"      # Adds sign for newline. 
done
echo -e "${triangle:: -2}"       # Output without the last two chars.

exit 0
```

Beim abschließenden Ausgabebefehl werden die letzten beiden Zeichen ausgelassen: "\\n", der letzte Zeilenumbruch.

## Ein Dreieck plotten

Ich erläutere kurz, wie solch ein Dreiecksmuster erzeugt wird.

Lasse ich ich nur die Sternchen ausgeben und entferne dafür allen anderen Kommandos, dann ergibt sich folgender Code:

``` bash
rows=9
for((x=1; x<=rows; x++))
do
    for((y=1; y<=2*x-1; y++))
    do
        echo -n "*"
    done
    echo
done
```

Mit folgender Ausgabe:


``` less
*
***
*****
*******
*********
***********
*************
***************
*****************
```

Ein gleichschenkliges Dreieck entsteht dadurch, dass zusätzlich vor den Sternchen in einer Zeile eine Reihe von Leerzeichen ausgegeben wird. Statt der Leerzeichen habe ich für diese Demonstration Punkte eingesetzt, dadurch wird Folgendes ausgegeben:

``` less
........*
.......***
......*****
.....*******
....*********
...***********
..*************
.***************
*****************
```
Der Code, der dieses Muster erzeugt sieht wie folgt aus:

``` bash
rows=9
for((x=1; x<=rows; x++))
do
    for((y=1; y<=rows - x; y++))
    do
        echo -n "."  # Ausgabe ohne Zeilenumbruch
    done

    for((y=1; y<=2*x-1; y++))
    do
        echo -n "*"  # Ausgabe ohne Zeilenumbruch
    done

    echo  # Zeilenende, d. h. Ausgabe eines Zeilenumbruchs
done
```

Ebenso leicht kann man ein auf der Spitze stehendes gleichschenkliges Dreieck plotten:

``` bash
rows=9
for((x=rows; x>=1; x--))          # Counts down, because of "x--".
do

    for((y=1; y<=rows - x; y++))  # End value "rows - x" grows from line to line,
    do                            # because x becomes smaller with every loop.

        echo -n " "

    done

    for((y=1; y<=2*x-1; y++))
    do
        echo -n "*"
    done

    echo

done
```

``` less
*****************
 ***************
  *************
   ***********
    *********
     *******
      *****
       ***
        *
```

## Einen Davidstern plotten

Um eine komplexere Aufgabe umzusetzen, bin ich nach sehr kurzer Überlegung darauf gekommen, dass ich zwei Dreiecke kombinieren könnte. Dies ist in einem Davidstern der Fall; in einem Davidstern durchdringen und überlagern einander zwei Dreiecke.

Auch in diesem Fall werden Dreiecke durch zwei ineinander verschachtelte Zählschleifen erstellt, also durch eine Schleife in einer Schleife. Allerdings zuerst ein auf der Basis stehendes Dreieck, danach ein auf seiner Spitze stehendes, welches das erste Dreieck teilweise überlagert, so dass ein Figur entsteht, die einem Davidstern weitgehend gleicht.

Zwei Ergebnisse sind die Bash-Skripte

 * david
 * david_06

```bash

#! /usr/bin/bash
 #
 # david, 2023-05-10
 #
 # Plot a star of david.
 #
 # Bernd Storck, https://www.facebook.com/BStLinux/
 #


 ### Start Values ================================

declare -A matrix=
y=0
max_X=0
defaultWidth=26

if [ -z "$1" ] || grep -Evq '^[0-9]+$' <<< "$1"; then
  width=$defaultWidth
elif [ "$1" -lt 16 ]; then
  width=16  # Sets to minimum width.
else
  width=$1
fi

 # Restricts to a maximum width:
maxWidth=$(( ( $(tput cols) - 4 ) / 2 ))
if (( width > maxWidth )); then
  width=$maxWidth
fi

(( width % 2 != 0 )) && width=$(( width - 1 ))  # Width has to be even!


 ### 1. filling the 2D matrix: triangle 1 =====

for (( i=0; i<width; i=i+2, y++ ))
do
  x=$(( width - i + 1 ))

  for (( j=1; j<=i; j++ ))
  do
    (( x++ ))
    matrix[$y,$x]='x'
  done

  [ "$x" -gt "$max_X" ] &&  max_X="$x"
done


 ### 2. filling of the 2D matrix: triangle 2 =====

xEnd=$max_X
[ ! "$width" -gt "$defaultWidth" ] && y=4 || y=$(( (width - defaultWidth) / 4 + 4 ))

for (( i=width-1; i>=1; i=i-2 ))
do
  x=$(( width - i + 2 ))

  for (( j=i; j>=1; j-- ))
  do
    (( x++ ))
    matrix[$y,$x]='x'
  done
  (( y++ ))
done


 ### Output ==================================

for (( i=0; i<=y; i++ ))
do
  for (( j=0; j<=xEnd-1; j++ ))
  do
    case "${matrix[$i,$j]}" in
      '')  echo -n ' ';;
      x)   echo -n '* ';;
    esac
  done
  echo
done

exit 0
```

Das Skript kann ohne oder mit einer Zahl als Parameter gestartet werden, also beispielsweise `./david` oder `./david 45`.

# Skript-Varianten

## david_color

Das Bash-Skript david_color plottet einen farbigen Stern, beim Aufruf kann eine Größe und eine Farbe angefordert werden. Der Aufruf `./david_color --help` listet auf, welche Farbnamen das Skript zuordnen kann.

### animate

`animate` ist ein Skript, das `david_colors` wiederholt aufruft, so dass der Eindruck einer einfachen Animation entsteht.

# Referenced Literature
* Ray Yao: "Linux Shell Scripting Examples, Bash Scripting Examples: Linux Shell Scripting Workbook", 21. Februar 2023, ASIN B0BWHKXN3R

# About the Author

I am a German residing in Berlin and have following formal it qualifications:

* Informationstechnologe Multimedia (SNI)
* Internetprogrammierer (elop)
* WE Certified Professional Web Designer & Professional Web Developer
* WE Certified Web Admin Grade 1
* WE Certified Webmaster
* LPI Linux Essentials
* LPIC 1
* WE Certifided JavaScript Developer
* Zend Certified PHP Engineer

## Kontakt

Bernd Storck, https://www.facebook.com/BStLinux/