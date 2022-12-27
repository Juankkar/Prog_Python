Actividad_R
================
Juan Carlos García Estupiñán
2022-11-28

# En caso de algún problema con el código, adjunto el repositorio donde lo he almacenado en mi cuenta de [GitHub](https://github.com/Juankkar/Programacion_Python_R).

## Resultado en Markdown: [documents](https://github.com/Juankkar/Programacion_Python_R/blob/main/Actividad_R/documents)

# Actividad - Programación en R

Esta actividad evaluada consiste en una serie de ejercicios que debe
responder dentro de los *chunks* o trozos de código disponibles después
de cada pregunta. Recuerda incluir la carga de los paquetes necesarios
para la ejecución del código.

## Librerías a usar:

``` r
# Paquetes necesarios
packages <- c("tidyverse", "seqinr", "glue")

# Instalamos los paquetes 
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)){
  install.packages(packages[!installed_packages])
}
# Cargar las librarías
invisible(lapply(packages, library, character.only = TRUE))
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
    ## ✔ ggplot2 3.4.0      ✔ purrr   0.3.5 
    ## ✔ tibble  3.1.8      ✔ dplyr   1.0.10
    ## ✔ tidyr   1.2.1      ✔ stringr 1.4.1 
    ## ✔ readr   2.1.3      ✔ forcats 0.5.2 
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## 
    ## Attaching package: 'seqinr'
    ## 
    ## 
    ## The following object is masked from 'package:dplyr':
    ## 
    ##     count

# Parte 1 (evaluacionR.csv)

## Pregunta 1.

Descargar el archivo evaluacionR.csv e importar dicha información a un
dataframe identificado como **df** usando el url que se indica en el
trozo de código.

``` r
url1 <- "https://www.dropbox.com/s/ms29mvjj0pdq9oz/evaluacionR.csv?dl=1"
fichero <- "../data_raw/df.csv"
sistema_operativo <- "linux" # Poner si se encuenctra en windows o linux
# # Windows
# # download.file(url,"../data_raw/df.csv", method="wininet")
# # Linux
if(sistema_operativo == "linux" && !file.exists(fichero)){
  download.file(url1,fichero, method="wget")
  print("Has descargado los datos para Linux")
} else if(sistema_operativo == "windows" && !file.exists(fichero)){
  ### No funciona muy bien en Windows esta condicion por las rutas
  download.file(url1,fichero, method="wininet") 
  print("Has descargado los datos para Windows")
} else{
  print("Los datos ya estaban descargados")
}
```

    ## [1] "Los datos ya estaban descargados"

``` r
# Datos
df <- read.csv(file = "../data_raw/df.csv")
```

## Pregunta 2.

¿Cuál es el tipo de cada una de las variables presentes en el dataframe
**df**?

``` r
## Vemos los tipos de objetos
lapply(df, typeof)
```

    ## $X
    ## [1] "integer"
    ## 
    ## $Gene
    ## [1] "character"
    ## 
    ## $Gene.name
    ## [1] "character"
    ## 
    ## $Tissue
    ## [1] "character"
    ## 
    ## $TPM
    ## [1] "double"
    ## 
    ## $pTPM
    ## [1] "double"
    ## 
    ## $nTPM
    ## [1] "double"

## Pregunta 3.

¿Cuántos registros (filas) y variables (columnas) tiene el dataframe
**df?**

``` r
rows <- nrow(df)
cols <- ncol(df)

vector_respuesta <- c(`n filas`=rows, `n columnas`=cols) 
vector_respuesta
```

    ##    n filas n columnas 
    ##       8192          7

## Pregunta 4.

Agrupar el dataframe **df** por la variable **Tissue** y agregar
columnas con la media de TPM, el valor máximo de TPM y el valor mínimo
de TPM para cada tipo de Tissue. Almacenar el resultado en **df1**.

``` r
df1 <- df %>%
      group_by(Tissue) %>%
      summarise(maximo=max(TPM),
                minimo=min(TPM))
df1 %>% head()
```

    ## # A tibble: 6 × 3
    ##   Tissue                                        maximo minimo
    ##   <chr>                                          <dbl>  <dbl>
    ## 1 adipose tissue                                 282.     0  
    ## 2 adrenal gland                                  108.     0  
    ## 3 amygdala                                       104.     0.2
    ## 4 angular gyrus                                   94.6    0.1
    ## 5 angular gyrus (white matter)                   151.     0  
    ## 6 anterior cingulate cortex, supragenual-dorsal   75      0.2

## Pregunta 5.

Mostrar mediante un gráfico de puntos la relación entre TPM y nTPM
usando el dataframe **df**.

``` r
df %>%
      ggplot(aes(TPM, nTPM)) +
      geom_point(size=1.5) +
      # geom_smooth(method = "lm") +
      labs(
        title = "Actividad 5 Programación R, Máster de Bioinformática VIU",
        subtitle = "Autor: Juan Carlos García Estupiñán",
        x="Transcripts per million (TPM)",    # He estado buscando informacion sobre esto y creo que es a lo que se refiere con TPM
        y="Normalize transcript per million (nTPM)"
      ) +
      theme_classic() +
      theme(
        plot.title = element_text(face = "bold", size = 14, hjust = .5),
        plot.subtitle = element_text(face = "bold", size = 14, hjust = .5),
        # axis.line=element_line(size = 1),
        axis.ticks = element_line(size = 1),
        axis.title = element_text(face = "bold", size = 12),
        axis.text = element_text(face = "bold", size = 11)
      )
```

    ## Warning: The `size` argument of `element_line()` is deprecated as of ggplot2 3.4.0.
    ## ℹ Please use the `linewidth` argument instead.

![](JuanCarlos_Garcia_Estupiñan_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

## Pregunta 6.

A partir de los datos de **df**, mostrar mediante un gráfico de puntos
la relación entre TPM y nTPM para los registros en donde la variable
Tissue sea igual a “angular gyrus (white matter)” o igual a “angular
gyrus”. Colorear de forma distinta dependiendo del tipo de Tissue.

``` r
## Esqueleto principal de los siguienets gráifcos
plot_6_y_7 <- df %>% 
  filter(Tissue == "angular gyrus (white matter)" | 
         Tissue == "angular gyrus") %>%
  mutate(Tissue=factor(Tissue,
                       levels = c("angular gyrus",
                                  "angular gyrus (white matter)"),
                       labels = c("Angular gyrus",
                                  "Angular gyrus\n(white matter)"))) %>%
  ggplot(aes(TPM, nTPM, fill=Tissue)) +
  geom_smooth(method = "lm", aes(color=Tissue), 
              se=FALSE, show.legend = FALSE) +
  scale_fill_manual(name="Tipo de\ntejido:",
                    values=c("red", "blue")) +
  scale_color_manual(name=NULL,
                         values=c("red", "blue")) +
  theme_classic() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = .5),
    plot.subtitle = element_text(face = "italic", size = 11, hjust = .5),
    axis.line=element_line(size = 1),
    axis.ticks = element_line(size = 1),
    axis.title = element_text(face = "bold", size = 12),
    axis.text = element_text(face = "bold", size = 11),
    legend.title = element_text(face="bold",size = 10,hjust = .5),
    legend.text = element_text(size = 10, hjust = .5),
    legend.position = "top",
    legend.background = element_rect(color = "black", size = .75)
        )
```

    ## Warning: The `size` argument of `element_rect()` is deprecated as of ggplot2 3.4.0.
    ## ℹ Please use the `linewidth` argument instead.

``` r
## Gráfico de la actividad 5
plot_6_y_7 +
  geom_point(pch=21, color="black", size=1.5) +
  labs(
        title = "Actividad 5 Programación R, Máster de Bioinformática VIU",
        subtitle = "Autor: Juan Carlos García Estupiñán",
        x="Transcripts per million (TPM)",
        y="Normalize transcripts per million (nTPM)"
      ) 
```

    ## `geom_smooth()` using formula = 'y ~ x'

![](JuanCarlos_Garcia_Estupiñan_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

## Pregunta 7.

Mostrar los mismos datos de la pregunta 6 usando facet_grid para separar
la información de los dos tejidos en dos gráficos colocados uno al lado
del otro.

``` r
plot_6_y_7 +
  geom_point(pch=21, color="black", size=1.5,
             show.legend = FALSE) +
  facet_grid(~Tissue, scales = "free") +
  labs(
        title = "Actividad 6 Programación R, Máster de Bioinformática VIU",
        subtitle = "Autor: Juan Carlos García Estupiñán",
        x="Transcripts per million (TPM)",
        y="Normalize transcripts per million (nTPM)"
      ) +
  theme(
    strip.background = element_blank(),
    strip.text = element_text(color = "black", size = 12, face = "bold")
  )
```

    ## `geom_smooth()` using formula = 'y ~ x'

![](JuanCarlos_Garcia_Estupiñan_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

# Parte 2 (ncrna_NONCODE\[v3.0\].fasta)

## Pregunta 8.

Descargar el archivo ncrna_NONCODE\[v3.0\].fasta e importar los datos
usando el paquete seqinr visto en las prácticas de las últimas sesiones.
Recuerde que el archivo se encuetra comprimido. Almacenar los datos en
el objeto **ncrna**.

``` r
url2 <- "http://noncode.org/datadownload/ncrna_NONCODE[v3.0].fasta.tar.gz"

if (!file.exists("../data_raw/ncrna_NONCODE[v3.0].fasta")){
  url=url2      
  temp=tempfile()
  download.file(url,temp,method = "auto", quiet = TRUE)
  untar(temp,list=TRUE)
  untar(temp,exdir="../data_raw")
  unlink(temp)
  rm(temp,url)
} else{
  print("La base de datos ya estaba descargada")
}
```

    ## [1] "La base de datos ya estaba descargada"

``` r
ncrna <- read.fasta(file = "../data_raw/ncrna_NONCODE[v3.0].fasta")
```

## Pregunta 9.

Revisar las funciones disponibles del paquete seqinr. Indicar qué
función se puede utilizar para ver el listado y una breve descripción de
las funciones incluidas en el paquete.

``` r
library(help="seqinr")
```

## Pregunta 10.

Extraer en un objeto **secuencia** todas las secuencias del objeto
**ncrna** usando la función **getSequence** de seqinr. ¿de qué tipo es
el objeto **secuencia**?

``` r
secuencia <- getSequence(ncrna)
typeof(secuencia) # Se trata de una lista
```

    ## [1] "list"

## Pregunta 11.

Extraer las secuencias que empiezan con “acct”. ¿Cuántas secuencias
cumplen con la condición?

``` r
## En esta ocasión vamos a usar una función llamada scan, sirve para leer data que no
## tiene por que ser rectangular, tiene una opción de sep que nos permite separar por líneas
## lo que nos hace obtener un vector en el que cada valor son estas \n. En mi caso que 
## estoy más acostumbrado a usar vectores antes que listas me facilita el trabajo.
ncrna_no_list <- scan("../data_raw/ncrna_NONCODE[v3.0].fasta",
                      what = character(),
                      quiet = TRUE,
                      sep = "\n")

## Eliminaos el primer y segundo elemento, debido a que son la presentación
## de los header y secuencias, no estos en sí.
ncrna_vector_preproc <- ncrna_no_list[-c(1,2)]
## Calculamos la longitud del vector, necesario para las condiciones
longitud_ncrna_vector <- length(ncrna_vector_preproc)

## Básicamente crearemos un vector que vaya desde la posición 1 (primer header) hasta el último, 
## ya que con seq() le hemos puesto que seleccione cada 2 líneas.
header <- ncrna_vector_preproc[seq(1,longitud_ncrna_vector,2)]

## Lo mismo para las secuencias, pero en este caso empiezamos en el valor 2 (primera secuencia) del
## vector, seleccionando de nuevo 2 a 2. 
secuencia <- ncrna_vector_preproc[seq(2,longitud_ncrna_vector,2)]

## Deberían tener la misma longtud ambos en ese sentido
length(header) == length(secuencia)
```

    ## [1] TRUE

``` r
## Y creamos un tibble con header y secuencia como variables
df_ncrna <- tibble(
    header=header,
    secuencia=secuencia
  )
df_ncrna %>% print(n=10)
```

    ## # A tibble: 411,552 × 2
    ##    header                                                                secue…¹
    ##    <chr>                                                                 <chr>  
    ##  1 >n1 | AB002583 | tmRNA | chloroplast Cyanidioschyzon merolae | ssrA … ACCTCG…
    ##  2 >n2 | AB002583 | RNase P RNA | chloroplast Cyanidioschyzon merolae |… AAGGCA…
    ##  3 >n3 | AB003477 | tmRNA | Synechococcus sp | 10Sa | NONCODE v2.0 | NU… GGGGCT…
    ##  4 >n4 | AB007644 | snoRNA | Arabidopsis thaliana (thale cress) | U3 | … ACGACC…
    ##  5 >n5 | AB009049 | snoRNA | Arabidopsis thaliana (thale cress) | U24 |… GGCCGG…
    ##  6 >n6 | AB009051 | snRNA | Arabidopsis thaliana (thale cress) | U6 | N… GTCCCT…
    ##  7 >n7 | AB010698 | snRNA | Arabidopsis thaliana (thale cress) | U6 | N… GTCCCT…
    ##  8 >n9 | AB013387 | snoRNA | Arabidopsis thaliana (thale cress) | U3 | … ACGACC…
    ##  9 >n10 | AB013390 | snRNA | Arabidopsis thaliana (thale cress) | U2 | … ATACCT…
    ## 10 >n11 | AB013396 | snRNA | Arabidopsis thaliana (thale cress) | U2 | … ATACCT…
    ## # … with 411,542 more rows, and abbreviated variable name ¹​secuencia

El siguiente chunk sería ya el ejercicio 11 resuelto.

``` r
## Número de secuencias que empiezan con acct. glue() es una función muy útil del paquete glue que sirve
## para añadir el valor de una string a otra mediante el uso de {}. De esta manera, como necesitamos las
## bases nitrogenadas (acct) en mayúsculas, usamos la función toupper(), y luego se lo añadimos a la 
## condición de grep.

empieza_acct <- toupper("acct") # convertimos nuestra secuencia problema a mayúsculas

## Número de secuencias que empiezan por acct
seq_start_acct <- grep(glue("^{empieza_acct}"),df_ncrna$secuencia, value=TRUE)
## Vemos las 5 primeras filas que empiezan en acct:
seq_start_acct %>% head(n=5)
```

    ## [1] "ACCTCGACCACCCTTAACTTGGGTGCAGGTATTCAACAAAAGCAATGAATCAAGGAATGAATCAATGGATTTTCAATGGATTTATGGATTTTAAAAACAGAGAACTCAGAAATCTAACAGAAATTTAACAGAAATTTAAATTTGTCGATCTACAAATTGCCCTTATCTTTTTCCATCTTAAACTAAACGTTAATAACTTATTGTTGTTGAATACAGCTTGTGGAATGTCGGGGTACAATGTCGGGG"
    ## [2] "ACCTAGTTTTTTTAACTAAAAGTTGAGAAGGCTAGGGAACACCATTTATTTCATATTAAGATGGAAGACAAGAAATGCTGTGGTTGCAAAACCGAAACAGCTAACTGCAGTAAATGCAACTGTGGCGGTTGCAAATGCTGCCAAAAATAAGGCGAAATTTCTCTAAATTTCGTTTTAGATAAAAAGCCAGTCGTAAGACTGGTTTTTTATT"                                   
    ## [3] "ACCTCTCAAAGCTCATAGCTTTGATCAAGTGTAGTATCTGTTCTTGTCAGTGTGACAGCTGACAAACTAGCTCCTTGGAGCTAGAATATGCTGGTGTGTGTGTGGATGCTTTGACAGGCTTGCTTGTAGGGGCCATGCACACACCAGGCAGACTCCCGGAAGTTGTTCCGTCCGGAGCTGCACTTTTT"                                                          
    ## [4] "ACCTGCGGTGCAAAACATCATAATCTAGAAGAAACAAACTAATTTCTTCCAGATAATCTATTATGCTTTTTTTTTTTTTTTT"                                                                                                                                                                    
    ## [5] "ACCTATCGGCAAAAAACACAAGCAGTTGTACTAACATCAAACAGATTTTTTTTTTTTTTTT"

``` r
## Vemos el total de las secuencias anteriores con length()
n_seq_start_acct <- length(seq_start_acct); n_seq_start_acct
```

    ## [1] 650

## Pregunta 12.

Extraer las secuencias que terminan con “tttttt”. ¿Cuántas secuencias
cumplen con la condición?

``` r
## No hace falta repetir el código, pero hay que asegurarse de que tenemos el anterior 
## trozo corrido

termina_tttttt <- toupper("tttttt") # Convertimos nuestra secuencia problema a mayúsculas

## Número de secuencias que terminan con tttttt. 
## La librería glue permite agregar un string a otra con {}, a mí me parece muy útil.
seq__end_tttttt <- grep(glue("{termina_tttttt}$"),df_ncrna$secuencia, value=TRUE)
## Vemos las 5 primeras líneas que terminan en tttttt:
seq__end_tttttt %>% head(n=5)
```

    ## [1] "GTCCCTTCGGGGACATCCGATAAAATTGGAACGATACAGAGAAGATTAGCATGGCCCCTGCGCAAGGATGACACGCATAAATCGAGAAATGGTCCAAATTTTTTT"  
    ## [2] "GTCCCTTCGGGGACATCCGATAAAATTGGAACGATACAGAGAAGATTAGCATGGCCCCTGCGCAAGGATGACACGCATAAATCGAGAAATGGTCCAAATTTTTTT"  
    ## [3] "GTCCCTTAGGGGACATCCGATAAAATTGGAACGATACAGAGAAGATTAGCATGGCCCCTGCGCAAGGATGACACGCATAAATCGAGAAATGGTCCAAATTTTTTT"  
    ## [4] "GTGCTTGCCTTGGTAGCGCATATACTAAAGCTGGAATGATACAGAGAAGTTTAGCATGGCCCCTGAACAAGGATGACATTCAAATTCGTGAAGCATTCCATTTTTT" 
    ## [5] "GAGTTTGCTTCAGCAGCAAGTGTACTAAAATTAAAACAATATAGAGAAGATTAGCATGATCCCTGCACAAGTGTGACACACAAATTTGCGAAGCATTCTATTTTTTT"

``` r
## Vemos el total de secuencias anteriores con length()
n_seq__end_tttttt <- length(seq__end_tttttt); n_seq__end_tttttt
```

    ## [1] 728
