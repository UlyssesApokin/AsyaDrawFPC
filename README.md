# AsyaDrawFPC

AsyaDraw is a free simple ASCII graphics editor using Free Pascal

AsyaDraw uses the CRT library

![Current version: 0.1.1 2023/04/23](https://github.com/UlyssesApokin/AsyaDrawFPC/raw/main/AsyaDraw.png)

![Example](https://github.com/UlyssesApokin/AsyaDrawFPC/raw/main/Example.png)

## Minimum system requirements

* GNU/Linux operating system
* Screen size 80 by 24 characters
* Keyboard

## Install AsyaDraw

### 1. Install Free Pascal Compiler

Debian & Debian-based
````
# apt-get install fpc
````
Arch & Arch-based
````
# pacman -S fpc
````
Fedora
````
# dnf install fpc
````

### 2. Clone repository

````
$ git clone https://github.com/UlyssesApokin/AsyaDrawFPC.git
````

### 3. Compile the program

````
$ cd AsyaDrawFPC
````

````
~/AsyaDrawFPC$ fpc AsyaDraw.pas
````

````
~/AsyaDrawFPC$ rm *.o
````

````
~/AsyaDrawFPC$ rm *.ppu
````

### 4. Run the program

````
~/AsyaDrawFPC$ ./AsyaDraw
````

## Working with the AsyaDraw program

Run the program and enter the name of the file you are going to edit.

If a file with the same name does not exist, a new one will be created.

If a file with that name exists, it will be opened.

AsyaDraw is under development and may destroy a file that is not intended for her.

Do not open files of other applications in AsyaDraw.

### Control

* Arrows - Move
* Keys A..Z, a..z, 0.. 9, !../ - Brush
* Tab + tab,b,u,g,c,r,m,o,l,d,n,a,e,t,y,w - Change colors
* Space - Draw
* Backspace - Delete
* Escape - Save & exit

* "/about" - Read application information

## History of changes

#### v0.1.3 (2023/05/06)

* Add application information

#### v0.1.2 (2023/04/27)

* Bugs fixed
* Code optimization
* Add color change by double tab

#### v0.1.1 (2023/04/23)

* Pseudo GUI is now scalable
* Improve readability and code optimization

#### v0.1 (2023/04/22)

* Added draw mode and color picker mode
* Added saving and opening projects
* Added pseudo-graphical interface
