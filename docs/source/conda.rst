:code:`conda create -n ATGenomics`
----------------------------------

Actualmente las ciencias genómicas se mueven muy rapidamente, instalar y configurar programas ya no es una prioridad para hacer ciencia reproducible ya que existen gestores de paquetes que hacen la tarea por ti

.. admonition:: Distintos gestores de paquetes
	:class: toggle

		* Ubuntu & Debian usan apt
		* Fedora & CentOS usan dnf
		* Arch & OpenSUSE pueden usar packman
		* NodeJS usa npm
		* Python usa pip
		* Perl usa cpan
		* R usa cran

A pesar de haber esfuerzos integrales para optimizar la gestión de paquetes, existen ecosistemas que no interactuan tan bien unos con otros, por ejemplo no puedes instalar paquetes deb con dnf, o rpm con apt.

Entonces, para que el usuario se preocupe lo menos posible por la gestión de programas, podemos usar `conda <https://docs.conda.io/en/latest/miniconda.html>`_

.. important::

	Conda es un gestor de paquetes que permite la creación de ambientes que aislan los programas y bibliotecas del resto del sistema (pero no son contenedores).

	Con conda puedes instalar facilmente programas con versiones específicas y en espacios específicos, por lo que puedes reproducir un protocolo con comandos muy simples.

En este taller emplearemos conda para instalar 3 herramientas:

* `FastQC <https://www.bioinformatics.babraham.ac.uk/projects/fastqc>`_
* `bwa <https://github.com/lh3/bwa>`_
* `samtools <https://github.com/samtools/samtools>`_

Pero primero debemos instalar conda, para ello, primero ingresamos a la instancia y ejecutamos los siguientes comandos, los ejecutaremos a la par que tú :)

1. Empezamos como siempre en nuestra carpeta `$HOME`

	::

		$ cd $HOME

2. Descargamos el instalador de conda	(versión miniconda)

	::

		$ wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

3. Ejecutamos el instalador (aquí te esperamos para hacerlo a la par)

	::

		$ bash Miniconda3-latest-Linux-x86_64.sh

4. Para que los cambios surtan efecto, debemos reiniciar nuestra terminal ya que el archivo de control `.bashrc` fue modificado por conda para poder *saber* donde está ubicado el ejecutable y donde va a poder instalar programas y ambientes

	::

		$ exit

5. Volvemos a ingresar a la instancia y esta vez notaremos que aparece una pista adicional en nuestra terminal: un cuadrito verde que dice "base" que nos indica 1) que estamos usando conda, y 2) que estamos en un ambiente "base"


6. Posteriormente vamos a agregar *canales* a la configuración de conda, para que conda *sepa* de donde descargar los programas

	* Agregamos canales default:

		::

			$ conda config --add channels defaults

	* Agregamos canales para bioinformática:

		::

			$ conda config --add channels bioconda

	* Agregamos canales para programas varios:

		::

			$ conda config --add channels conda-forge

7. Habiendo hecho esto, ahora si, creamos un nuevo entorno llamado gatk que va a contener los programas FastQC, bwa y samtools

	::

		$ conda create -n gatk -c bioconda samtools bwa fastqc

8. Activamos nuestro entorno para poder revisar los datos de secuenciación

	::

		$ conda activate gatk

.. tip::

	Al activar el entorno "gatk" veremos que nuestro prompt nos lo indica cambiando la bandera verde "base" a "gatk"

.. important::

	A partir de hoy, cada que ingreses a la instancia, recuerda verificar qué entornos tienes activados. Si no tienes activado el entorno `gatk` debes activarlo ejecutando :code:`$ conda activate gatk`

:code:`$PATH` una vez más, con sentimiento
------------------------------------------

Una parte de la configuración la realiza conda, no obstante también usaremos programas que no tienen receta de conda. Para que estos programas funcionen debemos configurar nuestro `$PATH`

1. Creamos una carpeta donde van a vivir estos programas:

	::

		$ mkdir -p $HOME/bin

.. danger::

	Los siguientes pasos los debemos hacer **una sóla** vez

2. Agregamos esta ruta al `$PATH` modificando el archivo `.bashrc`

	::

		$ echo "PATH=\$PATH:\$HOME/bin" >> .bashrc

3. Guardamos la variable para que el cambio sea persistente entre sesiones:

	::

		$ echo "export PATH" >> .bashrc
