De aquí a dónde?
----------------

La identificación de las variantes genómicas es sólo el principio, en realidad esto que hicimos solamente nos dice: el individuo tiene N variantes en estas posiciones.

Qué hago con mis variantes?

Existen a la fecha 3 grandes softwares para anotar las variantes

1. Funcotator como parte de GATK4

	* Ventajas

		* Tiene integración de distintas bases de datos
		* Puedes correrlo dentro de GATK4

	* Desventajas

		* Sus bases de datos pesan muchísimo (~30Gb con compresión máxima)
		* Es moderadamente limitado a humano

2. snpEff de Pablo Cingolani

	* Ventajas

		* Tiene integración de distintas bases de datos
		* Puedes correrlo dentro de GATK4
		* **Incluye bases de datos de todos los organismos secuenciados!**
		* **Puedes construir tus bases de datos!**

	* Desventajas

		* Su sintaxis es algo inconsistente
		* Si manipulas erroneamente el archivo de configuración puedes fastidiar tu instalación
		* Puede consumir algo de RAM y si se satura el sistema puede anotar erroneamente tus variantes

3. Variant Effect Predictor de Ensembl

	* Ventajas

		* Tiene interfaz web
		* Acepta múltiples formatos
		* Incluye múltiples bases de datos
		* Incluye múltiples algoritmos de clasificación
		* Tiene acceso programático a través de su API
		* Puedes instalarlo en tu máquina

	* Desventajas

		* Sólo es útil para organismos módelo
		* Su instalación es algo voluminosa

En este taller emplearemos snpEff y Ensembl VEP

Instalación de snpEff
---------------------

En este paso necesitamos tener el entorno de gatk activado :code:`conda activate gatk`

1. Vamos a nuestro directorio :code:`$HOME`, as usual

::

	$ cd $HOME

2. Bajamos la versión actual de snpEff

::

	$ wget https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip

3. Descomprimimos

::

	$ unzip snpEff_latest_core.zip

4. Nos dirigimos a la carpeta de snpEff

::

	$ cd $HOME/snpEff

5. Cargamos el archivo de configuración de ATG

::

	$ wget https://raw.githubusercontent.com/vflorelo/Call-me-by-your-reads/master/atg.config

6. Descargamos los archivos correspondientes a la versión 99 de Ensembl (GRCh38 release 99)

::

	$ java -jar snpEff.jar download GRCh38.99

7. Agregamos los directorios de dbSNP y clinvar al directorio de snpEff

::

	$ cd $HOME

	$ mkdir -p $HOME/snpEff/db/GRCh38/clinvar

	$ mkdir -p $HOME/snpEff/db/GRCh38/dbSnp/

8. Agregamos un link que apunta a clinvar

::

	$ cd $HOME/snpEff/db/GRCh38/clinvar

::

	$ ln -s /usr/local/bioinformatics/db/GRCh38/clinvar/clinvar.vcf.gz .

8.1 Indexamos nuestro archivo de variantes con bgzip (parte de samtools)

::

	$ bgzip --reindex clinvar.vcf.gz

8.2 Indexamos nuestro archivo de variantes con tabix (parte de samtools)

::

	$ tabix -p vcf clinvar.vcf.gz

9. Agregamos un link que apunta a dbSNP

::

	$ cd $HOME/snpEff/db/GRCh38/dbSnp

::

	$ ln -s /usr/local/bioinformatics/db/GRCh38/dbSnp/00-All.vcf.gz .

9.1 Indexamos nuestro archivo de variantes con bgzip (parte de samtools)

::

	$ bgzip --reindex 00-All.vcf.gz

9.2 Indexamos nuestro archivo de variantes con tabix (parte de samtools)

::

	$ tabix -p vcf 00-All.vcf.gz

Anotación de las variantes con snpEff
-------------------------------------

1. Vamos a nuestro directorio :code:`$HOME`, as usual

::

	$ cd $HOME

2. Preparamos el escenario

::

	$ mkdir -p $HOME/05_snpeff

::

	$ cd $HOME/05_snpeff

::

	$ cp $HOME/04_gatk/S3_annotated_qd_dp_filtered_variants.vcf .

3. Anotamos los efectos primarios de nuestras variantes

::

	$ java -jar $HOME/snpEff/snpEff.jar eff GRCh38.99 -c $HOME/snpEff/atg.config -canon S3_annotated_qd_dp_filtered_variants.vcf -verbose > S3_snpEff.vcf

4. Anotamos las frecuencias alélicas de nuestras variantes a partir de la información de dbSNP

::

	$ java -jar $HOME/snpEff/SnpSift.jar annotate -c $HOME/snpEff/atg.config -noId -dbsnp -verbose S3_snpEff.vcf > S3_snpEff_dbsnp.vcf

5. Anotamos la clasificación de las variantes a partir de la información de clinvar

::

	$ java -jar $HOME/snpEff/SnpSift.jar annotate -c $HOME/snpEff/atg.config -noId -clinvar -verbose S3_snpEff_dbsnp.vcf > S3_snpEff_dbsnp_clinvar.vcf

5. Obtenemos variantes asociadas a un gen que nos interese

::

	$ java -jar $HOME/snpEff/SnpSift.jar filter "ANN[*].GENE = 'RYR1'" S3_snpEff_dbsnp_clinvar.vcf > S3_RYR1.vcf

::

	$ java -jar $HOME/snpEff/SnpSift.jar filter "ANN[*].GENE = 'RYR2'" S3_snpEff_dbsnp_clinvar.vcf > S3_RYR2.vcf

6. Visualizamos nuestra variante y sus efectos en `Ensembl VEP <https://www.ensembl.org/info/docs/tools/vep/index.html>`_

.. important::

	En nuestra terminal **local**

	::

		$ scp -i atg.pem vflorelo@atgenomics.ddns.net:05_snpeff/S3_RYR1.vcf .

	::

		$ scp -i atg.pem vflorelo@atgenomics.ddns.net:05_snpeff/S3_RYR2.vcf .

6.1 Subimos nuestro archivo a Ensembl VEP y esperamos

7. Interpretación de resultados
