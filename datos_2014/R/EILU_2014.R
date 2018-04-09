#################################################################################
# Nombre del programa:	EILU_2014.R                                          
# Autor:              	INE
# Version:            	4.0
# ?ltima modificaci?n: 	04/11/2016
#                                                                                
# Descripcion: 
#	    Este programa procesa un fichero de microdatos (md_siglas_anio.txt)
#	  a partir de un fichero de metadatos (dr_siglas_anio.xlsx) que contiene 
#   el dise?o de registro del archivo de microdatos.
#     Siglas: se refiere a las siglas de la operaci?n estad?stica
#     Anio: se refiero al a?o de producci?n de los datos
#
# Entrada:                                                           
#     - Dise?o de registro: 	dr_EILU_2014.xlsx
#     - Archivo de microdatos: 	md_EILU_2014.txt
#                                                                                
#################################################################################


assign("flag_num", 0, envir = .GlobalEnv)

atencion = function(mensaje){
  cat(mensaje)
  assign("flag_num", 1, envir = .GlobalEnv)
  
}
if(!"XLConnect" %in% installed.packages())
  install.packages("XLConnect")

library("XLConnect")

####################    Asignaci?n de par?metros    #######################
#Recogemos la ruta del script que se esta ejecutando
script.dir <- dirname(sys.frame(1)$ofile)
setwd(script.dir)

fichero_micro <- "md_EILU_2014.txt"
fichero_meta  <- "dr_EILU_2014.xlsx"

####################     INICIO     #########################
start.time <- Sys.time()
t <- proc.time()
cat("\n Inicio",start.time)

#Lectura del fichero de metadatos (METAD), Hoja "Dise?o" de archivo .xlsx
tryCatch((workBook <- loadWorkbook(fichero_meta)), error=function(e) 
        stop(paste("Error. No se puede abrir el fichero: ", fichero_meta,". Saliendo de la ejecucion...", sep = "")))
df <- readNamedRegion(workBook, name = "METADATOS")

nombresVarbls <- df[,1]
nombresTablas <- df[,2]
posiciones    <- df[,3]
tamanio       <- length(nombresVarbls)

#Capturamos las columnas con su tipo de dato
tipDatos <- as.vector(sapply(df[,4], function(x){
              if(identical(x, "A"))
                "character"
              else{
                if(identical(x, "N"))
                  "numeric"
              }
            }
          )
)

# Lectura del fichero de microdatos (MICROD)
tryCatch((df1 <- read.fwf(file = fichero_micro, widths= posiciones, colClasses=tipDatos)), error=function(e)
  stop(paste("Error. No se encuentra el fichero: ", fichero_micro,". Saliendo de la ejecuci?n...", sep = "")))

#Aplicamos los nombres de la cabecera del registro
names(df1) <- df[,1]
fichero_salida <- df1


#Liberacion de memoria y aclaraci?n de variables 
#Values
rm(flag_num,workBook,nombresVarbls,nombresTablas,posiciones,tamanio,tipDatos,df,df1)


cat("\n Fin del proceso de lectura.\n")
end.time <- Sys.time()
tiempo <- as.numeric(end.time - start.time)
cat("Tiempo transcurrido:", tiempo)






