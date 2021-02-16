Introducción
------------
Ya tenemos nuestras secuencias en formato fastq y salieron bien de calidad. Qué hago con las secuencias para el llamado de variantes?

El siguiente paso es alinear dichas lecturas sobre un genoma de referencia que nos permita detectar variaciones **con respecto de ese genoma**

.. important::

	En llamado de variantes es de suma importancia especificar cual fue la referencia que se empleó

	La secuencia de referencia del genoma humano no es la misma en 2021 que la que se liberó en Mayo de 2000, en total ha sufrido 19 revisiones para un total de 20 versiones.

.. note::

	'The human reference genome GRCh38 was released from the Genome Reference Consortium on 17 December 2013. This build contained around 250 gaps, whereas the first version had roughly 150,000 gaps'

.. important::

	En este taller emplearemos la versión GRCh38 (hg38) del genoma humano.

.. warning::

	No obstante Illumina y otras compañias no han migrado aún sus archivos hacia la nueva versión del genoma, por lo que tenemos que hacer un par de transformaciones antes de iniciar

1. Creamos un directorio donde vamos a albergar archivos de soporte

::

	$ cd $HOME

::

	$ mkdir 00_other

2. Descargamos el archivo de coordenadas que provee el fabricante de nuestro kit de secuenciación

::

	$ cd $HOME/00_other

::

	$ wget https://support.illumina.com/content/dam/illumina-support/documents/downloads/productfiles/trusight/trusight-one-expanded-file-for-ucsc-browser-v2-0-bed.zip

::

	$ unzip trusight-one-expanded-file-for-ucsc-browser-v2-0-bed.zip

3. Descargamos el programa liftOver que nos permite transformar sets de coordenadas entre ensamble GRCh37 y GRCh38

::

	$ mkdir -p $HOME/bin

::

	$ cd $HOME/bin

::

	$ wget https://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/liftOver

::

	$ chmod 775 liftOver

4. Descargamos el archivo *chain* para que liftOver sepa como transformar entre coordenadas

::

	$ cd $HOME/00_other

::

	$ wget ftp://hgdownload.soe.ucsc.edu/goldenPath/hg19/liftOver/hg19ToHg38.over.chain.gz

::

	$ gunzip hg19ToHg38.over.chain.gz

5. Transformamos nuestro archivo de coordenadas para actualizarlo a la última versión del genoma

::

	$ liftOver "TSOne Expanded BED v2.0.txt" hg19ToHg38.over.chain TSO_xt_hg38.bed unmapped

Y dónde está el genoma?
-----------------------

En este taller vamos a emplear el genoma de referencia GRCh38 que viene incluido en el paquete de trabajo de GATK (*bundle*).

.. admonition:: Nota
	:class: toggle

		Este *bundle* pesa mucho y puede llevar tiempo descargarlo, de modo que en este taller **no lo vamos a descargar**, no obstante, de dejamos los comandos para que puedas descargarlo en tu computadora (~40 Gb)

		::

			$ pip3 install gsutil

			$ mkdir -p /usr/local/bioinformatics/bundle

			$ mkdir -p /usr/local/bioinformatics/db/GRCh38/clinvar

			$ mkdir -p /usr/local/bioinformatics/db/GRCh38/dbSnp

			$ cd /usr/local/bioinformatics/bundle

			$ gsutil -m cp -r \
			  "gs://genomics-public-data/resources/broad/hg38/v0/1000G.phase3.integrated.sites_only.no_MATCHED_REV.hg38.vcf" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/1000G.phase3.integrated.sites_only.no_MATCHED_REV.hg38.vcf.idx" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/1000G_omni2.5.hg38.vcf.gz" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/1000G_omni2.5.hg38.vcf.gz.tbi" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/1000G_phase1.snps.high_confidence.hg38.vcf.gz" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/1000G_phase1.snps.high_confidence.hg38.vcf.gz.tbi" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/Axiom_Exome_Plus.genotypes.all_populations.poly.hg38.vcf.gz" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/Axiom_Exome_Plus.genotypes.all_populations.poly.hg38.vcf.gz.tbi" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf.idx" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dict" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.alt" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.amb" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.ann" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.bwt" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.pac" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.sa" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.fai" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz.tbi" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz.tbi" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/hapmap_3.3.hg38.vcf.gz" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/hapmap_3.3.hg38.vcf.gz.tbi" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/scattered_calling_intervals/" \
			  "gs://genomics-public-data/resources/broad/hg38/v0/wgs_calling_regions.hg38.interval_list" \
			  .

			$ conda activate gatk

			$ cd /usr/local/bioinformatics/db/GRCh38/clinvar

			$ wget ftp://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/clinvar.vcf.gz

			$ bgzip --reindex clinvar.vcf.gz

			$ tabix -p vcf clinvar.vcf.gz

			$ cd /usr/local/bioinformatics/db/GRCh38/dbSnp

			$ wget ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/VCF/00-All.vcf.gz

			$ bgzip --reindex 00-All.vcf.gz

			$ tabix -p vcf 00-All.vcf.gz

Alineamiento de lecturas sobre un genoma
----------------------------------------

Existen cientos de estrategias con las que se pueden alinear secuencias sobre un genoma de referencia, no obstante muchas de ellas son imprácticas cuando se trata de datos voluminosos

En esta sesión veremos una de las estrategias más ampliamente utilizadas en bioinformática (no solamente en llamado de variantes): Alineamiento basado en la transformada de Burrows-Wheeler

Este procedimiento consta de dos etapas

1. Construcción de la transformada de Burrows-Wheeler de nuestra secuencia genómica

	* Este procedimiento se omite ya que el *bundle* de GATK incluye un índice del genoma

2. Busqueda de las posiciones de las lecturas sobre la secuencia genómica mediante backtracking

	* Procedimiento:

	2.1. Preparamos el escenario

	::

		$ cd $HOME

		$ mkdir 03_bwa

		$ cd 03_bwa

	2.2. Concatenamos las lecturas

	::

		$ cat $HOME/01_reads/*R1*.gz > fwd_reads.fastq.gz

		$ cat $HOME/01_reads/*R2*.gz > rev_reads.fastq.gz

	2.3. Copiamos nuestro archivo de coordenadas

	::

		$ cp $HOME/00_other/TSO_xt_hg38.bed .

	2.4. Mapeamos las lecturas al genoma (en este paso debes tener activo el entorno gatk -> :code:`conda activate gatk` )

	::

		$ nohup bwa mem -M -t 4 /usr/local/bioinformatics/bundle/Homo_sapiens_assembly38.fasta fwd_reads.fastq.gz rev_reads.fastq.gz > S3.sam 2> S3.err &

	.. important::

		Con el comando :code:`nohup` nos aseguramos que el programa esté corriendo en el fondo y mientras eso ocurre, podemos cerrar nuestras terminales para la parte teórica

Transformada de Burrows-Wheeler
-------------------------------

.. note::

	La transformada de Burrows-Wheeler (BWT por sus siglas en inglés) tiene aplicaciones en múltiples áreas, es el fundamento de algoritmos de compresión como el protocolo gz

	La BWT consta de 4 pasos esenciales

	1. Construcción de una matriz de permutaciones
	2. Ordenamiento lexicográfico de la matriz
	3. Extracción de los campos informativos
	4. Compresión de los datos para su manejo


Comencemos con un ejemplo *sencillo* (*ish*): tomemos la palabra :code:`MISSISSIPPI`

.. |bwt_01| image:: bwt_01.png
	:width: 150 px
	:alt: command
.. |bwt_02| image:: bwt_02.png
	:width: 150 px
	:alt: command
.. |bwt_03| image:: bwt_03.png
	:width: 150 px
	:alt: command
.. |bwt_04| image:: bwt_04.png
	:width: 150 px
	:alt: command
.. |bwt_05| image:: bwt_05.png
	:width: 150 px
	:alt: command
.. |bwt_06| image:: bwt_06.png
	:width: 150 px
	:alt: command
.. |bwt_07| image:: bwt_07.png
	:width: 150 px
	:alt: command
.. |bwt_08| image:: bwt_08.png
	:width: 150 px
	:alt: command
.. |bwt_09| image:: bwt_09.png
	:width: 150 px
	:alt: command
.. |bwt_10| image:: bwt_10.png
	:width: 150 px
	:alt: command
.. |bwt_11| image:: bwt_11.png
	:width: 150 px
	:alt: command
.. |bwt_12| image:: bwt_12.png
	:width: 150 px
	:alt: command

.. admonition:: Construcción de una matriz de permutaciones

	+----------+----------+----------+----------+
	+ |bwt_01| + |bwt_02| + |bwt_03| + |bwt_04| +
	+----------+----------+----------+----------+
	+ |bwt_05| + |bwt_06| + |bwt_07| + |bwt_08| +
	+----------+----------+----------+----------+
	+ |bwt_09| + |bwt_10| + |bwt_11| + |bwt_12| +
	+----------+----------+----------+----------+

.. admonition:: Ordenamiento lexicográfico de la matriz y obtención de los campos informativos

	.. image:: bwt_13.png
		:width: 600 px

.. admonition:: Compresión de los datos

	:code:`MISSISSIPPI -> IPSSM#PISSII -> IP2SM#PI2S2I`

.. important::

	Este mismo procedimiento se aplica sobre la secuencia genómica a emplear, en el caso del genoma humano estaremos comprimiendo 25 palabras que suman >3,000,000,000 caracteres


*Tries* y búsqueda por *backtracking*
-------------------------------------

.. |backtrack_01| image:: backtrack_01.png
	:width: 150 px
	:alt: backtrack_01
.. |backtrack_04| image:: backtrack_04.png
	:width: 150 px
	:alt: backtrack_04
.. |backtrack_06| image:: backtrack_06.png
	:width: 150 px
	:alt: backtrack_06
.. |mississippi_01| image:: mississippi_01.png
	:width: 150 px
	:alt: mississippi_01
.. |mississippi_02| image:: mississippi_02.png
	:width: 150 px
	:alt: mississippi_02
.. |mississippi_03| image:: mississippi_03.png
	:width: 150 px
	:alt: mississippi_03
.. |search_01| image:: search_01.png
	:width: 200 px
	:alt: search_01
.. |search_02| image:: search_02.png
	:width: 200 px
	:alt: search_02

.. admonition:: Backtracking

	Una vez que construimos nuestra BWT, podemos buscar palabras sobre dicha BWT, para ello usamos una estrategia de *backtracking*

	+----------------+----------------+----------------+
	+ |backtrack_01| + |backtrack_04| + |backtrack_06| +
	+----------------+----------------+----------------+

.. admonition:: Busquemos la palabra inicial

	+------------------+------------------+------------------+
	+ |mississippi_01| + |mississippi_02| + |mississippi_03| +
	+------------------+------------------+------------------+

.. admonition:: Ahora busquemos sólo la palabra MISS

	+-------------+-------------+
	+ |search_01| + |search_02| +
	+-------------+-------------+


.. warning::

	Cómo podemos optimizar estas búsquedas?

	Para completar la estrategia de búsqueda los programas de mapeo de lecturas usan una estructura de datos llamada árbol de sufijos (*suffix tree*). Los árboles de sufijos son un tipo especial de *otra* estructura de datos llamada *trie* (del inglés **retrieval**).

	.. image:: trie.png
		:width: 600 px

.. important::

	Esto ocurre en nuestro programa miles de millones de veces de forma paralela! Esta combinación de algoritmos revolucionó el alineamiento de lecturas cortas

Formatos de salida: SAM
-----------------------

Una vez que concluye el proceso de mapeo de lecturas, los programas usualmente entregan un archivo en formato SAM (*sequence alignment and mapping*)

Este formato es un estándar en bioinformática y la descripción completa del formato, podemos revisar la `documentación oficial`_

.. important::

	Para fines de este curso, conoceremos la estructura mínima necesaria de dicho formato:

	+-------+-------------------------------------------------+
	+ Campo + Descripción                                     +
	+=======+=================================================+
	+  1    + Nombre de la lectura                            +
	+-------+-------------------------------------------------+
	+  2    + FLAG                                            +
	+-------+-------------------------------------------------+
	+  3    + Nombre de la secuencia de referencia (genoma)   +
	+-------+-------------------------------------------------+
	+  4    + Posición de la lectura en dicho genoma          +
	+-------+-------------------------------------------------+
	+  5    + Calidad del mapeo                               +
	+-------+-------------------------------------------------+
	+  6    + CIGAR                                           +
	+-------+-------------------------------------------------+
	+  7    + Nombre de la lectura complementaria (su *mate*) +
	+-------+-------------------------------------------------+
	+  8    + Posición de la lectura complementaria           +
	+-------+-------------------------------------------------+
	+  9    + Longitud del segmento cubierto por el par       +
	+-------+-------------------------------------------------+
	+ 10    + Secuencia de la lectura                         +
	+-------+-------------------------------------------------+
	+ 11    + Calidad de la lectura (ASCII)                   +
	+-------+-------------------------------------------------+

.. important::

	Ejemplo de un archivo SAM::

		@SQ	SN:1	LN:248956422
		@SQ	SN:2	LN:242193529
		@SQ	SN:3	LN:198295559
		@SQ	SN:4	LN:190214555
		@SQ	SN:5	LN:181538259
		@SQ	SN:6	LN:170805979
		@SQ	SN:7	LN:159345973
		@SQ	SN:8	LN:145138636
		@SQ	SN:9	LN:138394717
		@SQ	SN:10	LN:133797422
		@SQ	SN:11	LN:135086622
		@SQ	SN:12	LN:133275309
		@SQ	SN:13	LN:114364328
		@SQ	SN:14	LN:107043718
		@SQ	SN:15	LN:101991189
		@SQ	SN:16	LN:90338345
		@SQ	SN:17	LN:83257441
		@SQ	SN:18	LN:80373285
		@SQ	SN:19	LN:58617616
		@SQ	SN:20	LN:64444167
		@SQ	SN:21	LN:46709983
		@SQ	SN:22	LN:50818468
		@SQ	SN:X	LN:156040895
		@SQ	SN:Y	LN:57227415
		@SQ	SN:MT	LN:16569
		@RG	ID:test_data	LB:test_data	PL:Illumina	SM:test_data	PU:test_data
		@PG	ID:bwa	PN:bwa	VN:0.7.17-r1194-dirty	CL:bwa mem -M -t 4 /usr/local/bioinformatics/databases/Genome/Homo_sapiens_GRCh38.fasta forward_reads.fastq.gz reverse_reads.fastq.gz
		NB502037:60:HV7GWBGXC:1:11107:22080:13075	163	1	12028	0	74M	=	12153	199	CTGCTGGCCTGTGCCAGGGTGCAAGCTGAGCACTGGAGTGGAGTTTTCCTGTGGAGAGGAGCCATGCCTAGAGT	BGJHIJHHHFKDJH/GIHHE5HG2IH6JFIHHHFJHFIDJHFIDGDGG/FJDKHFIFIHCIIGGEJH/FCIFI3	MC:Z:74M	MD:Z:74	PG:Z:MarkDuplicates	RG:Z:NGS023	NM:i:0	AS:i:74	XS:i:74
		NB502037:60:HV7GWBGXC:1:21103:3654:10675	163	1	12028	0	74M	=	12257	303	CTGCTGGCCTGTGCCAGGGTGCAAGCTGAGCACTGGAGTGGAGTTTTCCTGTGGAGAGGAGCCATGCCTAGAGT	BGJHIJHHHFKDJHDGIHHEJHGFIHFJ.IHACFJHFIDJHFI5GGGG/FJDKHFIFIHGIFGGEJ6G7CIFIB	MC:Z:74M	MD:Z:74	PG:Z:MarkDuplicates	RG:Z:NGS023	NM:i:0	AS:i:74	XS:i:74
		NB502037:60:HV7GWBGXC:1:21310:18749:17844	99	1	12028	0	74M	=	12289	333	CTGCTGGCCTGTGCCAGGGTGCAAGCTGAGCACTGGAGTGGAGTTTTCCTGTGGAGAGGAGCCATGCCTAGAGT	AFIFHJHGFFKDJHGHIIHEJHGFIHGJ/JHGHGJGFIDKHGIEGGHGHFKDKHFIFIHFJFGHEKHGFDIFIC	MC:Z:72M2S	MD:Z:74	PG:Z:MarkDuplicates	RG:Z:NGS023	NM:i:0	AS:i:74	XS:i:74
		NB502037:60:HV7GWBGXC:1:23202:12800:17985	163	1	12028	0	74M	=	12199	244	CTGCTGGCCTGTGCCAGGGTGCAAGCTGAGCACTGGAGTGGAGTTTTCCTGTGGAGAGGAGCCATGCCTAGAGT	BGJHIJHHHFKDJHGGIHHEJHGFIHFJFIHHHFJHFIDJHFIDGDGGHFJDKHFIF5HGIIGCEJHG7CIFIC	MC:Z:73M	MD:Z:74	PG:Z:MarkDuplicates	RG:Z:NGS023	NM:i:0	AS:i:74	XS:i:74
		NB502037:60:HV7GWBGXC:2:11205:4868:3501	163	1	12028	0	74M	=	12224	269	CTGCTGGCCTGTGCCAGGGTGCAAGCTGAGCACTGGAGTGGAGTTTTCCTGTGGAGAGGAGCCATGCCTAGAGT	BGJHIJ7HHFKDJHGAIH2EJHGFIHEJFIHHHFJHFIDJHFI@GGGGHFJDKHFIFIHGIIGGEJFGFBIFI/	MC:Z:73M	MD:Z:74	PG:Z:MarkDuplicates	RG:Z:NGS023	NM:i:0	AS:i:74	XS:i:74
		NB502037:60:HV7GWBGXC:2:12201:8069:10334	99	1	12028	0	74M	=	12262	308	CTGCTGGCCTGTGCCAGGGTGCAAGCTGAGCACTGGAGTGGAGTTTTCCTGTGGAGAGGAGCCATGCCTAGAGT	AFIFHJHDFFGDJ12BI5HEJHGFIHGJ/JHGDGJ3/CDKHGCEGECGDE>26H/IFIHFJHGHEKHG7DIFIC	MC:Z:74M	MD:Z:74	PG:Z:MarkDuplicates	RG:Z:NGS023	NM:i:0	AS:i:74	XS:i:74
		NB502037:60:HV7GWBGXC:2:13110:9149:6398	163	1	12028	0	74M	=	12202	248	CTGCTGGCCTGTGCCAGGGTGCAAGCTGAGCACTGGAGTGGAGTTTTCCTGTGGAGAGGAGCCATGCCTAGAGT	BGJHIJHHHFKDJHGGIHHEJHGFIHFJFIHHHFJHFIDJHFIDGGGGHFJDKHFIFIHGIIGGEJHGFCIFIC	MC:Z:74M	MD:Z:74	PG:Z:MarkDuplicates	RG:Z:NGS023	NM:i:0	AS:i:74	XS:i:74
		NB502037:60:HV7GWBGXC:3:13403:15882:14640	163	1	12028	0	74M	=	12244	289	CTGCTGGCCTGTGCAAGTGTGCAACCTGAGCACTGGAGTGGAGTTTTCCTGTGGAGAGGATCCATGACTAGAGT	6GJ/76HE0F5DJ-,-51JEJA,--/6G.5-HH:J2AI152.51D1GGH651K2F5F5F./0G,EI.A7B6/6C	MC:Z:73M	MD:Z:14C2G6G35G5C7	PG:Z:MarkDuplicates	RG:Z:NGS023	NM:i:5	AS:i:49	XS:i:49
		NB502037:60:HV7GWBGXC:3:21506:17407:15401	163	1	12028	0	74M	=	12137	182	CTGCTGCCCTGTGCCAGGGTGCAAGCTGAGCACTGGAGTGGAGTTTTCCTGTGGAGAGGAGCCATGCCTAGAGT	BGJHI6-GCFGDGHDG5E2EJHGFID6JABH,-E5HFIDJ2AID1G5FHDHDK;FIFCF@IA/G/5BGFB6FIC	MC:Z:73M	MD:Z:6G67	PG:Z:MarkDuplicates	RG:Z:NGS023	NM:i:1	AS:i:69	XS:i:69
		NB502037:60:HV7GWBGXC:2:13110:7444:7717	163	1	12034	0	74M	=	12095	135	GCCTGTGCCAGGGTGCAAGCTGAGCACTGGAGTGGAGTTTTCCTGTGGAGAGGAGCCATGCCTAGAGTGGGATG	BFFIKDHEHB52HD5HGFIIF9FIH,HFGHFJ1GEFI1GGGCCFGDJHGIFIIFIHGGDKH/F(5CI1H3GFD3	MC:Z:74M	MD:Z:74	PG:Z:MarkDuplicates	RG:Z:NGS023	NM:i:0	AS:i:74	XS:i:74

FLAG
----

El FLAG es un estándar dentro de la especificación del formato SAM que nos brinda información estructural acerca de la lectura y como mapea sobre la referencia

.. important::

	Los códigos de los FLAGs tienen una base binaria, de modo que los códigos son únicos, y cada combinación de bytes indica una situación específica para la lectura correspondiente

	Los códigos del FLAG pueden ser consultados en la página del `Broad Institute`_


	+------+-------------------------------------------+
	+ Byte + Significado                               +
	+======+===========================================+
	+    1 + read paired                               +
	+------+-------------------------------------------+
	+    2 + read mapped in proper pair                +
	+------+-------------------------------------------+
	+    4 + read unmapped                             +
	+------+-------------------------------------------+
	+    8 + mate unmapped                             +
	+------+-------------------------------------------+
	+   16 + read reverse strand                       +
	+------+-------------------------------------------+
	+   32 + mate reverse strand                       +
	+------+-------------------------------------------+
	+   64 + first in pair                             +
	+------+-------------------------------------------+
	+  128 + second in pair                            +
	+------+-------------------------------------------+
	+  256 + not primary alignment                     +
	+------+-------------------------------------------+
	+  512 + read fails platform/vendor quality checks +
	+------+-------------------------------------------+
	+ 1024 + read is PCR or optical duplicate          +
	+------+-------------------------------------------+
	+ 2048 + supplementary alignment                   +
	+------+-------------------------------------------+

.. admonition:: Ejemplos de FLAGs

	.. image:: flags.png


Concise Idiosyncratic Gapped Alignment Report (CIGAR para los amigos)
---------------------------------------------------------------------

Cómo su nombre lo indica, es un reporte conciso acerca de cómo una lectura alinea con respecto de una secuencia de referencia

+-------+---------------------------------------------+
+ Clave + Significado                                 +
+=======+=============================================+
+ M     + Número de matches                           +
+-------+---------------------------------------------+
+ I     + Inserciones con respecto a la referencia    +
+-------+---------------------------------------------+
+ D     + Deleciones con respecto a la referencia     +
+-------+---------------------------------------------+
+ N     + Región saltada con respecto a la referencia +
+-------+---------------------------------------------+
+ S     + Soft clipping\*                             +
+-------+---------------------------------------------+
+ H     + Hard clipping\*\*                           +
+-------+---------------------------------------------+
+ P     + Padding (sólo ensambles de novo)            +
+-------+---------------------------------------------+
+ \=    + Match completo                              +
+-------+---------------------------------------------+
+ X     + Mismatch completo                           +
+-------+---------------------------------------------+

.. admonition:: Ejemplo de CIGARs

	.. image:: cigar.png


.. admonition:: Campos adicionales agregados por BWA

	+---+-----------------------------------------------+
	|Tag|Meaning                                        |
	+===+===============================================+
	|NM |Edit distance                                  |
	+---+-----------------------------------------------+
	|MD |Mismatching positions/bases                    |
	+---+-----------------------------------------------+
	|AS |Alignment score                                |
	+---+-----------------------------------------------+
	|BC |Barcode sequence                               |
	+---+-----------------------------------------------+
	|X0 |Number of best hits                            |
	+---+-----------------------------------------------+
	|X1 |Number of suboptimal hits found by BWA         |
	+---+-----------------------------------------------+
	|XN |Number of ambiguous bases in the referenece    |
	+---+-----------------------------------------------+
	|XM |Number of mismatches in the alignment          |
	+---+-----------------------------------------------+
	|XO |Number of gap opens                            |
	+---+-----------------------------------------------+
	|XG |Number of gap extentions                       |
	+---+-----------------------------------------------+
	|XT |Type: Unique/Repeat/N/Mate-sw                  |
	+---+-----------------------------------------------+
	|XA |Alternative hits; format: (chr,pos,CIGAR,NM;)* |
	+---+-----------------------------------------------+
	|XS |Suboptimal alignment score                     |
	+---+-----------------------------------------------+
	|XF |Support from forward/reverse alignment         |
	+---+-----------------------------------------------+
	|XE |Number of supporting seeds                     |
	+---+-----------------------------------------------+

Filtrado de lecturas
--------------------

Una vez que entendemos cómo está estructurado el formato SAM, podemos ahora hacer manipulación de nuestros archivos para que sólo conservemos la información util

0. Recuerda tener tu entorno gatk activado :code:`conda activate gatk`

1. Transformamos nuestro archivo SAM a un formato más amigable: formato BAM

::

	$ samtools view -b -h -@ 4 -f 3 -L TSO_xt_hg38.bed -o S3.tmp.bam S3.sam

2. Ordenamos por coordenadas nuestro archivo BAM

::

	$ samtools sort -l 9 -@ 4 -o S3.bam S3.tmp.bam

3. Indexamos nuestro archivo sorteado

::

	$ samtools index S3.bam

.. _`Broad Institute`: https://broadinstitute.github.io/picard/explain-flags.html

.. _`documentación oficial`: http://samtools.github.io/hts-specs/SAMv1.pdf
