# Zählschleifen und Zahlenfolgen

## Ray Yao's example script: "23. Print a diamond pattern"[^1]

```bash
#! /bin/bash

echo -n "Enter the number of rows: "
read rows
for((x=1; x<=rows; x++))
do
  for((y=1; y<=rows-x; y++))
  do
    echo -n " "
  done
  for((y=1; y<=2*x-1; y++))
  do
    echo -n "*"
  done
  echo ""
done
for((x=rows-1; x>=1; x--))
do
  for((y=1; y<=rows-x; y++))
  do
    echo -n " "
  done
  for((y=1; y<=2*x-1; y++))
  do
    echo -n "*"
  done
  echo ""
done
```

Gibt man auf die Abfrage durch read 9 ein, dann wird ausgegeben:

``` Ausgabe
Enter the number of rows: 9
        *
       ***
      *****
     *******
    *********
   ***********
  *************
 ***************
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


### Ablaufoptimierung

Auch hier bietet es sich an den Ausgabe-String zuerst zusammenzusetzen und erst am Ende durch einen einzelnes Kommando (echo oder printf) auszugeben.

```bash
txt=

for((x=1; x<=rows; x++))
do
  for((y=1; y<=rows-x; y++))
  do
    txt="$txt "
  done
  for((y=1; y<=2*x-1; y++))
  do
    txt="$txt*"
  done
  txt="$txt\\n"
done

 […]

echo -e "$txt"
```

## DRY = Don't Repeat Yourself

Der Merksatz empfiehlt, sich nicht zu wiederholen, keinen redundanten Code zu schreiben.

An Ray Yaos Beispiel ist in dieser Hinsicht interessant, dass zweimal genau der selbe Schleifenkörper durchlaufen wird.

``` bash
do
  for((y=1; y<=rows-x; y++))
  do
    echo -n " "
  done
  for((y=1; y<=2*x-1; y++))
  do
    echo -n "*"
  done
  echo ""
done
```

Allerdings mit zwei verschiedenen Schleifenköpfen:

* `for((x=1; x<=rows; x++))`
* `for((x=rows-1; x>=1; x--))`

Um diese Code-Redundanz zu verringern, kann man sich zu Nutze machen, dass die Bash zwei Formen der For-Schleife unterstützt.

## For Loops - Zwei Formen

Eine Zählschleife für die Bash im Stil der Programmiersprache C:

``` bash
for (( i=1; i<=10; ++i ))
do
  echo $i
done
```

Diese Zählschleifen im Stil von C beherrscht die Bash erst seit einiger Zeit, der herkömmliche Stil genau dieselbe Schleife in einem Bash-Skript zu schreiben, sieht wie folgt aus:

``` bash
for i in 1 2 3 4 5 6 7 8 9 10
do
  echo $i
done
```

Statt der Zahlen können auch beliebige Strings stehen, die nacheinander der Variablen i zugewiesen werden.

``` bash
for i in Eins Zwei Drei
do
  echo "..$i - $(rev <<< "$i").."
done
```

**Ausgabe**
``` Ausgabe
..Eins-sniE..
..Zwei-iewZ..
..Drei-ierD..
```

### Zählschleifen mit Hilfe des Programms seq

In der Literatur wird eine herkömmliche Zählschleife für die Bash oft mit Hilfe des Programms **seq** konstruiert, es erzeugt nummerische Sequenzen, Zahlenfolgen.

**`seq 10` ergibt:**

``` Ausgabe
1
2
3
4
5
6
7
8
9
10
```

**In einer Zählschleife eingesetzt**:

```bash
declare words=(Eins Zwei Drei Vier Fünf)

for i in $(seq 5)
do
  index=$(( i - 1 ))   # Der Index des Arrays beginnt wie üblich bei 0.
  printf "%2d.) ${words[$index]}\n" $i
done
```

**Ergibt:**
``` Ausgabe
 1.) Eins
 2.) Zwei
 3.) Drei
 4.) Vier
 5.) Fünf
```

[Mehr über seq](https://wiki.ubuntuusers.de/seq/).

## Redundanzreduziertes Script

Mit diesem Wissen über For-Schleifen in der Bash und, wenn man sich mit dem Programm seq und seinen Möglichkeiten vertraut gemacht hat, kann man ein weniger redundantes Bash-Skript formulieren, welches die selbe Ausgabe produziert, wie Ray Yaos Beispiel-Skript.

```bash
#! /bin/bash
 #
 # 23_diamond_pattern_optimized_03
 #
 # Alternative to Ray Yao's example script: "23. Print a diamond pattern"
 #

function triangle {
  for x in $1
  do
    output="$output "
    for(( y=1; y<=rows-x; y++ ))
    do
      output="$output "
    done
    for(( y=1; y<=2*x-1; y++ ))
    do
      output="$output*"
    done
    output="$output\n"
  done
}


 ### MAIN ###########################################

read -rp "Enter the number of rows: " rows

output=

triangle "$(seq $rows)"
triangle "$(seq $((rows-1)) -1 1)"

echo -e "$output"

exit 0
```

## Verwendete Kommandos und Programme

declare
: Deklariert Variablen und Arrays. (built-in)

echo
: Schreibt Text in die Standardausgabe. (built-in)

for
: Führt Kommandos für jedes Element der Liste aus. (built-in)

printf
: Seine Argumente formatiert ausgeben.

read
: Liest eine Zeile aus der Standardeingabe und teilt sie in Felder auf. (built-in)

rev
: Zeilen zeichenweise umkehren

seq
: Gibt eine Zahlenfolge aus.


## Über den Autor dieses Dokuments

Ich wohne in Berlin und habe folgende formale IT-Qualifikationen. (I am a German residing in Berlin and have following formal IT qualifications.)


* Informationstechnologe Multimedia (SNI)
* Internetprogrammierer (elop)
* WE Certified Professional Web Designer & Professional Web Developer
* WE Certified Web Admin Grade 1
* WE Certified Webmaster
* LPI Linux Essentials
* LPIC 1
* WE Certifided JavaScript Developer
* Zend Certified PHP Engineer

### Kontakt
Bernd Storck, https://www.facebook.com/BStLinux/

[^1]: Ray Yao: "Linux Shell Scripting Examples, Bash Scripting Examples: Linux Shell Scripting Workbook", 21. Februar 2023, ASIN B0BWHKXN3R
