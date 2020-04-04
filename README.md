# PV239_Reading_Manager_iOS
# Patrik Pluhař & Lukáš Matta

### V rámci předmětu PV239 Vývoj aplikací pro mobilní platformy na Fakultě informatiky Masarykovy Univerzity

## Funkční specifikace
Aplikace bude obsahovat 4 podstránky. Navigace mezi podstránkami bude zabezpečená tlačítkami ve spodní části obrazovky.
1. **My Library** - zde bude mít uživatel uložené své knihy, které má k dispozicii na přečtení (ne v této aplikaci). Možnost přidat/odstranit/upravit knihu. Údaje z knihy se doplní poté, co uživatle zadá její název/isbn z API. Na této podstránce bude také možnost označit knihu za přečtenou(read)/právě čtenou(reading). Výchozí stav bude nepřečtená(unread). Po kliknutí na konkrétní knihu se otevře **Book**
2. **Wishlist** - jednoduchý seznam knih, které by si uživatel přál - možnost sdílet tento seznam přes správu kliknutím na tlačítko Share. I zde je možnost rozkliknout **Book**
3. **Book** - podstránka s detaily o knize - žánr, popis, možnost ukládání zajímavých myšlenek. Podstránka bude také obsahovat tlačítko pro návrat do **My Library** nebo **Wishlist**
4. **Statistics** - grafy, vizualizace, počet přečtených knih v čase, rozdělení podle žánru, autora apod.

## Datový model
![Datový model](/images/DataModel.png?raw=true "Optional Title")

## Wireframes
[Wireframes](http://pv239.lukasmatta.com/)

## Dělba práce
* MyLibraryController - Patrik
* WishListController - Patrik
* StatisticsController - Lukáš
* BookDetailController - Lukáš
  - každý má podřízené controllery k tomu svému (např. controller na vytváření nové knihy má Patrik)
* Book, BookNote, BookState - Patrik
* User - Lukáš
