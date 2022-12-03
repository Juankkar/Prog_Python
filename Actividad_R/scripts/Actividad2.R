#/usr/bin/env RScript

# Actividad - Programación en R

# Esta actividad evaluada consiste en una serie de ejercicios que debe responder dentro de los *chunks* o trozos de código disponibles después de cada pregunta. Recuerda incluir la carga de los paquetes necesarios para la ejecución del código.

## Librerías a usar:

# Paquetes necesarios
packages <- c("tidyverse", "seqinr", "glue")

# Instalamos los paquetes 
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)){
  install.packages(packages[!installed_packages])
}
# Cargar las librarías
invisible(lapply(packages, library, character.only = TRUE))

# Parte 1 (evaluacionR.csv)

## Pregunta 1.

# Descargar el archivo evaluacionR.csv e importar dicha información a un dataframe identificado como **df** usando el url que se indica en el trozo de código.

url1 <- "https://www.dropbox.com/s/ms29mvjj0pdq9oz/evaluacionR.csv?dl=1"
fichero <- "../data_raw/df.csv"
sistema_operativo <- "linux" # Poner si se encuenctra en windows o linux

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


# Datos
df <- read.csv(file = "../data_raw/df.csv")

## Pregunta 2.

# ¿Cuál es el tipo de cada una de las variables presentes en el dataframe **df**?


str(df)
   
## Pregunta 3.
 
#  ¿Cuántos registros (filas) y variables (columnas) tiene el dataframe **df?**

rows <- nrow(df)
cols <- ncol(df)

vector_respuesta <- c(n_row=rows, n_col=cols) 
vector_respuesta


## Pregunta 4.
 
# Agrupar el dataframe **df** por la variable **Tissue** y agregar columnas con la media de TPM, el valor máximo de TPM y el valor mínimo de TPM para cada tipo de Tissue. Almacenar el resultado en **df1**.

df1 <- df %>%
      group_by(Tissue) %>%
      summarise(maximo=max(TPM),
                minimo=min(TPM))
df1 %>% head()

## Pregunta 5.
 
# Mostrar mediante un gráfico de puntos la relación entre TPM y nTPM usando el dataframe **df**.

df %>%
      ggplot(aes(TPM, nTPM)) +
      geom_point(size=1.5) +
      # geom_smooth(method = "lm") +
      labs(
        title = "Actividad 5 Programación R, Máster de Bioinformática VIU",
        subtitle = "Autor: Juan Carlos García Estupiñán",
        x="TPM",
        y="nTPM"
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

## Pregunta 6.
 
# A partir de los datos de **df**, mostrar mediante un gráfico de puntos la relación entre TPM y nTPM para los registros en donde la variable Tissue sea igual a "angular gyrus (white matter)" o igual a "angular gyrus". Colorear de forma distinta dependiendo del tipo de Tissue.

## Esqueleto principal de los siguienets gráifcos
plot_6_y_5 <- df %>% 
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
    plot.subtitle = element_text(face = "bold", size = 14, hjust = .5),
    axis.line=element_line(size = 1),
    axis.ticks = element_line(size = 1),
    axis.title = element_text(face = "bold", size = 12),
    axis.text = element_text(face = "bold", size = 11),
    legend.title = element_text(face="bold",size = 10,hjust = .5),
    legend.text = element_text(size = 10, hjust = .5),
    legend.position = "top",
    legend.background = element_rect(color = "black", size = .75)
        )

## Gráfico de la actividad 5
plot_6_y_5 +
  geom_point(pch=21, color="black", size=1.5) +
  labs(
        title = "Actividad 5 Programación R, Máster de Bioinformática VIU",
        subtitle = "Autor: Juan Carlos García Estupiñán",
        x="TPM",
        y="nTPM"
      ) 

## Pregunta 7.
 
# Mostrar los mismos datos de la pregunta 6 usando facet_grid para separar la información de los dos tejidos en dos gráficos colocados uno al lado del otro.

plot_6_y_5 +
  geom_point(pch=21, color="black", size=1.5,
             show.legend = FALSE) +
  facet_grid(~Tissue, scales = "free") +
  labs(
        title = "Actividad 6 Programación R, Máster de Bioinformática VIU",
        subtitle = "Autor: Juan Carlos García Estupiñán",
        x="TPM",
        y="nTPM"
      ) +
  theme(
    strip.background = element_blank(),
    strip.text = element_text(color = "black", size = 12, face = "bold")
  )

# Parte 2 (ncrna_NONCODE[v3.0].fasta)

## Pregunta 8.

# Descargar el archivo ncrna_NONCODE[v3.0].fasta e importar los datos usando el paquete seqinr visto en las  prácticas de las últimas sesiones. Recuerde que el archivo se encuetra comprimido. Almacenar los datos en el objeto **ncrna**.

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



if (!exists("ncrna")){
  ncrna <- read.fasta(file = "../data_raw/ncrna_NONCODE[v3.0].fasta")
}


## Pregunta 9.

# Revisar las funciones disponibles del paquete seqinr. Indicar qué función se puede utilizar para ver el listado y una breve descripción de las funciones incluidas en el paquete.


library(help="seqinr")


## Pregunta 10.

# Extraer en un objeto **secuencia** todas las secuencias del objeto **ncrna** usando la función **getSequence** de seqinr. ¿de qué tipo es el objeto **secuencia**? 

secuencia <- getSequence(ncrna)
typeof(secuencia) # Se trata de una lista


## Pregunta 11.

# Extraer  las secuencias que empiezan con "acct". ¿Cuántas secuencias cumplen con la condición?


### Con la función system() (base) podemos correr comandos de la línea de comandos en un script de R
### los cuales son muy útiles para este trabajo. 
### Por otro lado glue es un paquete muy útil que he encontrado y uso mucho, permite 
### añadir a una string otra string mediante {}

## Necesitamos pasarlo a mayúscula
empieza_acct <- toupper("acct") 

## Creamos una variable para filtrar las frecuencias que empiezan por ACCT
x <- glue('grep -v ">" ../data_raw/ncrna_NONCODE[v3.0].fasta | grep "^{empieza_acct}" > ../data_raw/empieza_acct.txt')
system(x)

## Contamos el número de secuencias que presentan esta subsecuencia al principio
y <- 'wc -l ../data_raw/empieza_acct.txt'
system(y)


## Pregunta 12.

# Extraer las secuencias que terminan con "tttttt". ¿Cuántas secuencias cumplen con la condición?

## Necesitamos pasarlo a mayúscula
termina_tttttt <- toupper("tttttt")

## Creamos una variable para filtrar las frecuencias que terminan por TTTTTT
x1 <- glue('grep -v ">" ../data_raw/ncrna_NONCODE[v3.0].fasta | grep "{termina_tttttt}$" > ../data_raw/termina_tttttt.txt')
system(x1)

## Contamos el número de secuencias que presentan esta subsecuencia al principio
y1 <- 'wc -l ../data_raw/empieza_acct.txt'
system(y1)
