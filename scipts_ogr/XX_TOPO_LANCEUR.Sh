#!/bin/sh
# ------------------------------------------------------------------------------

# VARIABLES DATES
export DATE_YM=$(date "+%Y%m")
export DATE_YMD=$(date "+%Y%m%d")
export DATE_Y_M=$(date "+%m/%Y")

# LECTURE DU FICHIER DE CONFIGURATION
. "`dirname "$0"`/config.env"

# REPERTOIRE DE TRAVAIL
cd $REPER
echo $REPER

# ------------------------------------------------------------------------------
# DEBUT
echo $DATE_YM 'Debut > PG'

# PERMET DE CONVERTIR LE FICHIER CSV EN FICHIER SQLITE
ogr2ogr -progress -f "SQLite" -dsco SPATIALITE=YES  -lco LAUNDER=NO -oo X_POSSIBLE_NAMES=Easting -oo Y_POSSIBLE_NAMES=Northing -oo Z_POSSIBLE_NAMES=Elevation \
-dialect SQLITE \
-nln "leve_topo" \
-sql "SELECT
          *,
          Name AS numero,

          Easting AS x,
          Northing AS y,
          Elevation AS z,

          Description AS description,

          "'"Easting RMS"'" AS rms_x, --Ecart-type Sigma = RMS (Root Man Square)
          "'"Northing RMS"'" AS rms_y,
          "'"Elevation RMS"'" AS rms_z,

          "'"Antenna height"'" AS antenne_hauteur,
          "'"Antenna height units"'" AS antenne_unite,

          "'"Averaging start"'" as date_debut,
          "'"Averaging end"'" as date_fin,

          PDOP AS pdop,

          "'"Base easting"'" AS base_x,
          "'"Base northing"'" AS base_y,
          "'"Base elevation"'" AS  base_z,

          Baseline AS base_ligne,

          "'"CS name"'" AS projection
      FROM leve_topo" \
leve_topo_sql.sqlite leve_topo.csv

# ------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------- TOPO --------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------
# NUAGE DE POINTS
ogr2ogr -progress \
        -f "PostgreSQL" PG:"service='$C_SERVICE' active_schema=ccpl_topo" \
        -lco SCHEMA='ccpl_topo' \
        -nln "point_leve" \
        "leve_topo_sql.sqlite" \
        --debug ON \
        -dialect SQLITE \
        -sql "SELECT
              geometry AS geom,
              numero as numero_point,
              x,
              y,
              z,
              description AS code,
              rms_x,
              rms_y,
              rms_z,
              antenne_hauteur,
              antenne_unite,
              pdop,
              base_x,
              base_y,
              base_z,
              base_ligne,
              projection,
              'CCPL' AS producteur,
              date_debut AS horodatage
        FROM leve_topo"

# ------------------------------------------------------------------------------------------------------------------------------------------------------------
sh TOPO_affleurant.sh > 'logs/'$DATE_YMD'_TOPO_affleurant.txt'
sh TOPO_cloture.sh > 'logs/'$DATE_YMD'_TOPO_cloture.txt'
sh TOPO_haie.sh > 'logs/'$DATE_YMD'_TOPO_haie.txt'.
sh TOPO_mobilier.sh > 'logs/'$DATE_YMD'_TOPO_mobilier.txt'
sh TOPO_mur.sh > 'logs/'$DATE_YMD'_TOPO_mur.txt'
sh TOPO_point_canevas.sh > 'logs/'$DATE_YMD'_TOPO_point_canevas.txt'
sh TOPO_reseau.sh > 'logs/'$DATE_YMD'_TOPO_reseau.txt'
sh TOPO_talus.sh > 'logs/'$DATE_YMD'_TOPO_talus.txt'
sh TOPO_vegetation.sh > 'logs/'$DATE_YMD'_TOPO_vegetation.txt'
sh TOPO_voirie.sh > 'logs/'$DATE_YMD'_TOPO_voirie.txt'


echo 'Fin > PG'
