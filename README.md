# AsyaDrawFPC

AsyaDraw is a free simple ASCII graphics editor using Free Pascal

AsyaDraw uses the CRT library

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
* Tab + b,u,g,c,r,m,o,l,d,n,a,e,t,y,w - Change colors
* space - Draw
* Backspace - Delete
* Escape - Save & exit
