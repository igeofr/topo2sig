#!/bin/sh
# ------------------------------------------------------------------------------
# PLAQUE RONDE RAYON
ogr2ogr -progress \
        -f "PostgreSQL" PG:"service='$C_SERVICE' active_schema=ccpl_topo" \
        -lco SCHEMA='ccpl_topo' \
        -nln "affleurant_surf" \
        "leve_topo_sql.sqlite" \
        --debug ON \
        -dialect SQLITE \
        -nlt POLYGON \
        -sql "
        SELECT
            BUFFER (geometry, CAST(SUBSTR(description,INSTR(description,'-')+1) AS REAL )/100) as geom,
            CASE
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='20' THEN '03'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='40' THEN '03'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='60' THEN '03'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='87' THEN '03'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='97' THEN '03'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='100' THEN '03'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='103' THEN '01'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='130' THEN '03'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='140' THEN '03'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='170' THEN '03'
                ELSE NULL
            END AS nature,
            CASE
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='20' THEN 'Plaque ronde'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='40' THEN 'Plaque ronde'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='60' THEN 'Plaque ronde'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='87' THEN 'Plaque ronde'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='97' THEN 'Plaque ronde'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='100' THEN 'Plaque ronde'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='103' THEN 'Grille ronde'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='130' THEN 'Plaque ronde'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='140' THEN 'Plaque ronde'
                WHEN SUBSTR(description,1,INSTR(description,'-') -1)='170' THEN 'Plaque ronde'
                ELSE NULL
            END AS type,
            CASE
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='20' THEN 'AEP'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='40' THEN 'IRRI'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='60' THEN 'ARRO'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='87' THEN 'ELECECL'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='97' THEN 'ELECSLT'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='100' THEN 'ASSAEP'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='103' THEN 'ASSAEP'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='130' THEN 'ASSAEU'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='140' THEN '00'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='170' THEN 'COM'
               ELSE NULL
            END AS reseau,
            '01' AS qualite_categorisation,
            '005' AS precision_planimetrique,
            '010' AS precision_altimetrique,
            'CCPL' AS producteur,
            date_debut as date_leve
        FROM leve_topo WHERE
            SUBSTR(description,1,INSTR(description,'-') -1)='20' OR -- DEFINIR LE CODE
            SUBSTR(description,1,INSTR(description,'-') -1)='40' OR
            SUBSTR(description,1,INSTR(description,'-') -1)='60' OR
            SUBSTR(description,1,INSTR(description,'-') -1)='87' OR
            SUBSTR(description,1,INSTR(description,'-') -1)='97' OR
            SUBSTR(description,1,INSTR(description,'-') -1)='100' OR
            SUBSTR(description,1,INSTR(description,'-') -1)='103' OR
            SUBSTR(description,1,INSTR(description,'-') -1)='130' OR
            SUBSTR(description,1,INSTR(description,'-') -1)='140' OR
            SUBSTR(description,1,INSTR(description,'-') -1)='170'
        "
# ------------------------------------------------------------------------------
# PLAQUE RONDE 3 POINTS
ogr2ogr -progress \
        -f "PostgreSQL" PG:"service='$C_SERVICE' active_schema=ccpl_topo" \
        -lco SCHEMA='ccpl_topo' \
        -nln "affleurant_surf" \
        "leve_topo_sql.sqlite" \
        --debug ON \
        -dialect SQLITE \
        -nlt POLYGON \
        -sql "

        SELECT
            st_buffer(MakePoint(x0, y0,3943),(ROUND(CAST(sqrt(x0 * x0 + y0 * y0 - (-pow(x1, 2) - pow(y1, 2) -
            2 * (((power(x1, 2) - power(x3, 2)) * (y1 - y2) + (power(y1, 2) - power(y3, 2)) * (y1 - y2) +
            (power(x2, 2) - pow(x1, 2)) * (y1 - y3) + (power(y2, 2) - power(y1, 2)) * (y1 - y3)) /
            (2 * ((x3 - x1) * (y1 - y2) - (x2 - x1) * (y1 - y3)))) * x1 - 2 * (((power(x1, 2) - power(x3, 2)) * (x1 - x2) + (power(y1, 2) - power(y3, 2)) *
            (x1 - x2) + (power(x2, 2) - power(x1, 2)) * (x1 - x3) +
            (power(y2, 2) - power(y1, 2)) * (x1 - x3)) / (2 *
            ((y3 - y1) * (x1 - x2) - (y2 - y1) * (x1 - x3)))) * y1)) AS numeric), 5)), 15) as geom,
            ROUND(CAST(sqrt(x0 * x0 + y0 * y0 - (-pow(x1, 2) - pow(y1, 2) -
            2 * (((power(x1, 2) - power(x3, 2)) * (y1 - y2) + (power(y1, 2) - power(y3, 2)) * (y1 - y2) +
            (power(x2, 2) - pow(x1, 2)) * (y1 - y3) + (power(y2, 2) - power(y1, 2)) * (y1 - y3)) /
            (2 * ((x3 - x1) * (y1 - y2) - (x2 - x1) * (y1 - y3)))) * x1 - 2 * (((power(x1, 2) - power(x3, 2)) * (x1 - x2) + (power(y1, 2) - power(y3, 2)) *
            (x1 - x2) + (power(x2, 2) - power(x1, 2)) * (x1 - x3) +
            (power(y2, 2) - power(y1, 2)) * (x1 - x3)) / (2 *
            ((y3 - y1) * (x1 - x2) - (y2 - y1) * (x1 - x3)))) * y1)) AS numeric), 2) AS rayon,
            CASE
               WHEN description='21' THEN '03'
               WHEN description='41' THEN '03'
               WHEN description='61' THEN '03'
               WHEN description='101' THEN '03'
               WHEN description='104' THEN '01'
               WHEN description='131' THEN '03'
               WHEN description='141' THEN '03'
               WHEN description='171' THEN '03'
               ELSE NULL
            END AS nature,
            CASE
               WHEN description='21' THEN 'Plaque ronde'
               WHEN description='41' THEN 'Plaque ronde'
               WHEN description='61' THEN 'Plaque ronde'
               WHEN description='101' THEN 'Plaque ronde'
               WHEN description='104' THEN 'Grille ronde'
               WHEN description='131' THEN 'Plaque ronde'
               WHEN description='141' THEN 'Plaque ronde'
               WHEN description='171' THEN 'Plaque ronde'
               ELSE NULL
            END AS type,
            CASE
               WHEN description='21' THEN 'AEP'
               WHEN description='41' THEN 'IRRI'
               WHEN description='61' THEN 'ARRO'
               WHEN description='101' THEN 'ASSAEP'
               WHEN description='104' THEN 'ASSAEP'
               WHEN description='131' THEN 'ASSAEU'
               WHEN description='141' THEN '00'
               WHEN description='171' THEN 'COM'
               ELSE NULL
            END AS reseau,
            '01' AS qualite_categorisation,
            '005' AS precision_planimetrique,
            '010' AS precision_altimetrique,
            'CCPL' AS producteur,
            date_debut as date_leve

                FROM(

                SELECT *,
                        -1*(((power(x1, 2) - power(x3, 2)) * (y1 - y2) + (power(y1, 2) - power(y3, 2)) * (y1 - y2) +
                        (power(x2, 2) - pow(x1, 2)) * (y1 - y3) + (power(y2, 2) - power(y1, 2)) * (y1 - y3)) /
                        (2 * ((x3 - x1) * (y1 - y2) - (x2 - x1) * (y1 - y3)))) AS x0,

                        -1*(((power(x1, 2) - power(x3, 2)) * (x1 - x2) + (power(y1, 2) - power(y3, 2)) *
                        (x1 - x2) + (power(x2, 2) - power(x1, 2)) * (x1 - x3) +
                        (power(y2, 2) - power(y1, 2)) * (x1 - x3)) / (2 *
                        ((y3 - y1) * (x1 - x2) - (y2 - y1) * (x1 - x3)))) as y0

                FROM
                (
                SELECT
                    id_reclass,
                    description,
                        x AS x1,
                        y AS y1,
                        LEAD(x,1) OVER (ORDER BY id_reclass) as x2,
                        LEAD(y,1) OVER (ORDER BY id_reclass) as y2,
                        LEAD(x,2) OVER (ORDER BY id_reclass) as x3,
                        LEAD(y,2) OVER (ORDER BY id_reclass) as y3,
                        date_debut
                        FROM
                (SELECT * FROM (
                         SELECT row_number() OVER(ORDER BY date_debut) +2 AS id_reclass, * FROM leve_topo

                         WHERE

                         description='21' OR -- DEFINIR LE CODE
                         description='41' OR
                         description='61' OR
                         description='101' OR
                         description='104' OR
                         description='131' OR
                         description='141' OR
                         description='171'


                         ) r ) a -- DEFINIR LE CODE
                    )  b WHERE id_reclass %3=0 AND (x2 IS NOT NULL OR x3 IS NOT NULL)

                ) c


"

# ------------------------------------------------------------------------------
# PLAQUE RONDE par 2 POINTS
ogr2ogr -progress \
        -f "PostgreSQL" PG:"service='$C_SERVICE' active_schema=ccpl_topo" \
        -lco SCHEMA='ccpl_topo' \
        -nln "affleurant_surf" \
        "leve_topo_sql.sqlite" \
        --debug ON \
        -dialect SQLITE \
        -nlt POLYGON \
        -sql "SELECT
      BUFFER (geometry, ST_Distance( GeomFromText('POINT('||x1||' '||y1||')'),GeomFromText('POINT('||x2||' '||y2||')') )) as geom,
      CASE
         WHEN description='22' THEN '03'
         WHEN description='42' THEN '03'
         WHEN description='62' THEN '03'
         WHEN description='88' THEN '03'
         WHEN description='98' THEN '03'
         WHEN description='102' THEN '03'
         WHEN description='105' THEN '01'
         WHEN description='132' THEN '03'
         WHEN description='142' THEN '03'
         WHEN description='172' THEN '03'
         ELSE NULL
      END AS nature,
      CASE
         WHEN description='22' THEN 'Plaque ronde'
         WHEN description='42' THEN 'Plaque ronde'
         WHEN description='62' THEN 'Plaque ronde'
         WHEN description='88' THEN 'Plaque ronde'
         WHEN description='98' THEN 'Plaque ronde'
         WHEN description='102' THEN 'Plaque ronde'
         WHEN description='105' THEN 'Grille ronde'
         WHEN description='132' THEN 'Plaque ronde'
         WHEN description='142' THEN 'Plaque ronde'
         WHEN description='172' THEN 'Plaque ronde'
         ELSE NULL
      END AS type,
      CASE
         WHEN description='22' THEN 'AEP'
         WHEN description='42' THEN 'IRRI'
         WHEN description='62' THEN 'ARRO'
         WHEN description='88' THEN 'ELECECL'
         WHEN description='98' THEN 'ELECSLT'
         WHEN description='102' THEN 'ASSAEP'
         WHEN description='105' THEN 'ASSAEP'
         WHEN description='132' THEN 'ASSAEU'
         WHEN description='142' THEN '00'
         WHEN description='172' THEN 'COM'
         ELSE NULL
      END AS reseau,
     '01' AS qualite_categorisation,
     '005' AS precision_planimetrique,
     '010' AS precision_altimetrique,
     'CCPL' AS producteur,
      date_debut AS date_leve

        FROM
        (
        SELECT
        id_reclass,
		geometry,
    description,
        x1,
        y1,
		    x2,
		    y2,
        date_debut
        FROM
        (
        SELECT
        		id_reclass,
				geometry,
				description,
                x AS x1,
                y AS y1,
                LEAD(x,1) OVER (ORDER BY id_reclass) as x2,
                LEAD(y,1) OVER (ORDER BY id_reclass) as y2,
                date_debut
                FROM
        (SELECT * FROM (
                 SELECT row_number() OVER(ORDER BY date_debut) +1 AS id_reclass, * FROM leve_topo WHERE
                 description='22' OR -- DEFINIR LE CODE
                 description='42' OR
                 description='62' OR
                 description='88' OR
                 description='98' OR
                 description='102' OR
                 description='105' OR
                 description='132' OR
                 description='142' OR
                 description='172'

                  ) r ) a
        		)  b WHERE id_reclass %2=0 AND (x2 IS NOT NULL)

     ) s
"
# ------------------------------------------------------------------------------
# PLAQUE CARREE PAR 2 POINTS DU MEME COTE
ogr2ogr -progress \
        -f "PostgreSQL" PG:"service='$C_SERVICE' active_schema=ccpl_topo" \
        -lco SCHEMA='ccpl_topo' \
        -nln "affleurant_surf" \
        "leve_topo_sql.sqlite" \
        --debug ON \
        -dialect SQLITE \
        -nlt POLYGON \
        -sql "
        SELECT
            id_reclass,
            SetSRID(MakePolygon(GeomFromText('LINESTRING('||x1||' '||y1||','||x2||' '||y2||','||x3||' '||y3||','||x4||' '||y4||','||x1||' '||y1||')')),3943) as geometry,
            CASE
               WHEN description='23' THEN '03'
               WHEN description='28' THEN '03'
               WHEN description='43' THEN '03'
               WHEN description='48' THEN '03'
               WHEN description='63' THEN '03'
               WHEN description='68' THEN '03'
               WHEN description='106' THEN '01'
               WHEN description='111' THEN '03'
               WHEN description='112' THEN '03'
               WHEN description='133' THEN '03'
               WHEN description='138' THEN '03'
               WHEN description='143' THEN '03'
               WHEN description='148' THEN '03'
               WHEN description='187' THEN '03'
               ELSE NULL
            END AS nature,
            CASE
               WHEN description='23' THEN 'Plaque carrée'
               WHEN description='28' THEN 'Regard'
               WHEN description='43' THEN 'Plaque carrée'
               WHEN description='48' THEN 'Regard'
               WHEN description='63' THEN 'Plaque carrée'
               WHEN description='68' THEN 'Regard'
               WHEN description='106' THEN 'Grille carrée'
               WHEN description='111' THEN 'Regard'
               WHEN description='112' THEN 'Plaque carrée'
               WHEN description='133' THEN 'Plaque carrée'
               WHEN description='138' THEN 'Regard'
               WHEN description='143' THEN 'Plaque carrée'
               WHEN description='148' THEN 'Regard'
               WHEN description='187' THEN 'Plaque carrée'
               ELSE NULL
            END AS type,
            CASE
               WHEN description='23' THEN 'AEP'
               WHEN description='28' THEN 'AEP'
               WHEN description='43' THEN 'IRRI'
               WHEN description='48' THEN 'IRRI'
               WHEN description='63' THEN 'ARRO'
               WHEN description='68' THEN 'ARRO'
               WHEN description='106' THEN 'ASSAEP'
               WHEN description='111' THEN 'ASSAEP'
               WHEN description='112' THEN 'ASSAEP'
               WHEN description='133' THEN 'ASSAEU'
               WHEN description='138' THEN 'ASSAEU'
               WHEN description='143' THEN '00'
               WHEN description='148' THEN '00'
               WHEN description='187' THEN 'COM'
               ELSE NULL
            END AS reseau,
           '01' AS qualite_categorisation,
           '005' AS precision_planimetrique,
           '010' AS precision_altimetrique,
           'CCPL' AS producteur,
           date_debut AS date_leve


            FROM
            (
            SELECT
            id_reclass,
            geometry,
            description,
            x1,
            y1,
          x2,
          y2,


          (x1 -((y2-y1) / (SQRT(POWER((x2-x1),2) + POWER((y2-y1),2)))) * (Distance(MakePoint(x1,y1),MakePoint(x2,y2)))) AS x4,
          (y1 +((x2-x1) / (SQRT(POWER((x2-x1),2) + POWER((y2-y1),2)))) * (Distance(MakePoint(x1,y1),MakePoint(x2,y2)))) AS y4,

          ((x1 -((y2-y1) / (SQRT(POWER((x2-x1),2) + POWER((y2-y1),2)))) * (Distance(MakePoint(x1,y1),MakePoint(x2,y2)))) + (x2-x1)) AS x3,
          ((y1 +((x2-x1) / (SQRT(POWER((x2-x1),2) + POWER((y2-y1),2)))) * (Distance(MakePoint(x1,y1),MakePoint(x2,y2)))) + (y2-y1)) AS y3,
          date_debut

            FROM
            (
            SELECT
                id_reclass,
          	  geometry,
              description,
                    x AS x1,
                    y AS y1,
                    LEAD(x,1) OVER (ORDER BY id_reclass) as x2,
                    LEAD(y,1) OVER (ORDER BY id_reclass) as y2,
                    date_debut
                    FROM
            (SELECT * FROM (
                     SELECT row_number() OVER(ORDER BY date_debut) +1 AS id_reclass, * FROM leve_topo WHERE
                     description='23' OR
                     description='28' OR
                     description='43' OR
                     description='48' OR
                     description='63' OR
                     description='68' OR
                     description='106' OR
                     description='111' OR
                     description='112' OR
                     description='133' OR
                     description='138' OR
                     description='143' OR
                     description='148' OR
                     description='187'
                     ) r ) a
                )  b WHERE id_reclass %2=0 AND (x2 IS NOT NULL)

          ) s
"
# ------------------------------------------------------------------------------
# CARREE PAR 2 POINTS
ogr2ogr -progress \
        -f "PostgreSQL" PG:"service='$C_SERVICE' active_schema=ccpl_topo" \
        -lco SCHEMA='ccpl_topo' \
        -nln "affleurant_surf" \
        "leve_topo_sql.sqlite" \
        --debug ON \
        -dialect SQLITE \
        -nlt POLYGON \
        -sql "SELECT
        id_reclass,
		SetSRID(MakePolygon(GeomFromText('LINESTRING('||x1||' '||y1||','||x4||' '||y4||','||x2||' '||y2||','||x3||' '||y3||','||x1||' '||y1||')')),3943) as geometry,
    CASE
       WHEN description='24' THEN '03'
       WHEN description='27' THEN '03'
       WHEN description='44' THEN '03'
       WHEN description='47' THEN '03'
       WHEN description='64' THEN '03'
       WHEN description='67' THEN '03'
       WHEN description='107' THEN '01'
       WHEN description='110' THEN '03'
       WHEN description='113' THEN '03'
       WHEN description='134' THEN '03'
       WHEN description='137' THEN '03'
       WHEN description='144' THEN '03'
       WHEN description='147' THEN '03'
       WHEN description='188' THEN '03'
       ELSE NULL
    END AS nature,
    CASE
       WHEN description='24' THEN 'Plaque carrée'
       WHEN description='27' THEN 'Regard'
       WHEN description='44' THEN 'Plaque carrée'
       WHEN description='47' THEN 'Regard'
       WHEN description='64' THEN 'Plaque carrée'
       WHEN description='67' THEN 'Regard'
       WHEN description='107' THEN 'Grille carrée'
       WHEN description='110' THEN 'Regard'
       WHEN description='113' THEN 'Plaque carrée'
       WHEN description='134' THEN 'Plaque carrée'
       WHEN description='137' THEN 'Regard'
       WHEN description='144' THEN 'Plaque carrée'
       WHEN description='147' THEN 'Regard'
       WHEN description='188' THEN 'Plaque carrée'
       ELSE NULL
    END AS type,
    CASE
       WHEN description='24' THEN 'AEP'
       WHEN description='27' THEN 'AEP'
       WHEN description='44' THEN 'IRRI'
       WHEN description='47' THEN 'IRRI'
       WHEN description='64' THEN 'ARRO'
       WHEN description='67' THEN 'ARRO'
       WHEN description='107' THEN 'ASSAEP'
       WHEN description='110' THEN 'ASSAEP'
       WHEN description='113' THEN 'ASSAEP'
       WHEN description='134' THEN 'ASSAEU'
       WHEN description='137' THEN 'ASSAEU'
       WHEN description='144' THEN '00'
       WHEN description='147' THEN '00'
       WHEN description='188' THEN 'COM'
       ELSE NULL
    END AS reseau,
     '01' AS qualite_categorisation,
     '005' AS precision_planimetrique,
     '010' AS precision_altimetrique,
     'CCPL' AS producteur,
     date_debut AS date_leve

        FROM
        (
        SELECT
        id_reclass,
        geometry,
        description,
        x1,
        y1,
		x2,
		y2,


		(((x1 + x2)/2) - ((y1 - y2)/2)) AS x3,
		(((y1 + y2)/2) + ((x1 - x2)/2)) AS y3,

		(((x1 + x2)/2) + ((y1 - y2)/2)) AS x4,
		(((y1 + y2)/2) - ((x1 - x2)/2)) AS y4,

    date_debut


        FROM
        (
        SELECT
        		id_reclass,
              geometry,
				        description,
                x AS x1,
                y AS y1,
                LEAD(x,1) OVER (ORDER BY id_reclass) as x2,
                LEAD(y,1) OVER (ORDER BY id_reclass) as y2,
                date_debut
                FROM
        (SELECT * FROM (
                 SELECT row_number() OVER(ORDER BY date_debut) +1 AS id_reclass, * FROM leve_topo WHERE
                 description='24' OR
                 description='27' OR
                 description='44' OR
                 description='47' OR
                 description='64' OR
                 description='67' OR
                 description='107' OR
                 description='110' OR
                 description='113' OR
                 description='134' OR
                 description='137' OR
                 description='144' OR
                 description='147' OR
                 description='188' ) r ) a
        		)  b WHERE id_reclass %2=0 AND (x2 IS NOT NULL)

     ) s
"
# ------------------------------------------------------------------------------
# RECTANGLE PAR 3 POINTS
ogr2ogr -progress \
        -f "PostgreSQL" PG:"service='$C_SERVICE' active_schema=ccpl_topo" \
        -lco SCHEMA='ccpl_topo' \
        -nln "affleurant_surf" \
        "leve_topo_sql.sqlite" \
        --debug ON \
        -dialect SQLITE \
        -nlt POLYGON \
        -sql "SELECT
        id_reclass,
		SetSRID(MakePolygon(GeomFromText('LINESTRING('||x1||' '||y1||','||x2||' '||y2||','||x3b||' '||y3b||','||x4||' '||y4||','||x1||' '||y1||')')),2154) as geometry,
    CASE
       WHEN description='25' THEN '03'
       WHEN description='45' THEN '03'
       WHEN description='65' THEN '03'
       WHEN description='85' THEN '02'
       WHEN description='86' THEN '02'
       WHEN description='95' THEN '02'
       WHEN description='96' THEN '02'
       WHEN description='108' THEN '01'
       WHEN description='114' THEN '01'
       WHEN description='135' THEN '03'
       WHEN description='145' THEN '03'
       WHEN description='180' THEN '03'
       WHEN description='181' THEN '03'
       WHEN description='182' THEN '03'
       WHEN description='183' THEN '03'
       WHEN description='184' THEN '03'
       WHEN description='185' THEN '03'
       WHEN description='186' THEN '03'
       WHEN description='200' THEN '02'
       WHEN description='202' THEN '02'
       WHEN description='204' THEN '02'
       WHEN description='206' THEN '03'
       WHEN description='220' THEN '02'
       WHEN description='222' THEN '02'
       WHEN description='224' THEN '03'
       ELSE NULL
    END AS nature,
    CASE
       WHEN description='25' THEN 'Plaque rectangle'
       WHEN description='45' THEN 'Plaque rectangle'
       WHEN description='65' THEN 'Plaque rectangle'
       WHEN description='85' THEN 'Chambre'
       WHEN description='86' THEN 'Armoire'
       WHEN description='95' THEN 'Chambre'
       WHEN description='96' THEN 'Armoire'
       WHEN description='108' THEN 'Grille rectangle'
       WHEN description='114' THEN 'Avaloir'
       WHEN description='135' THEN 'Plaque rectangle'
       WHEN description='145' THEN 'Plaque rectangle'
       WHEN description='180' THEN 'Plaque rectangle'
       WHEN description='181' THEN 'Plaque rectangle'
       WHEN description='182' THEN 'Plaque rectangle'
       WHEN description='183' THEN 'Plaque rectangle'
       WHEN description='184' THEN 'Plaque rectangle'
       WHEN description='185' THEN 'Plaque rectangle'
       WHEN description='186' THEN 'Plaque rectangle'
       WHEN description='200' THEN 'Armoire'
       WHEN description='202' THEN 'Coffret'
       WHEN description='204' THEN 'Transformateur'
       WHEN description='206' THEN 'Plaque'
       WHEN description='220' THEN 'Armoire'
       WHEN description='222' THEN 'Coffret'
       WHEN description='224' THEN 'Plaque'
       ELSE NULL
    END AS type,
    CASE
       WHEN description='25' THEN 'AEP'
       WHEN description='45' THEN 'IRRI'
       WHEN description='65' THEN 'ARRO'
       WHEN description='65' THEN 'ARRO'
       WHEN description='85' THEN 'ELECECL'
       WHEN description='86' THEN 'ELECECL'
       WHEN description='95' THEN 'ELECSLT'
       WHEN description='96' THEN 'ELECSLT'
       WHEN description='108' THEN 'ASSAEP'
       WHEN description='114' THEN 'ASSAEP'
       WHEN description='180' THEN 'COM'
       WHEN description='181' THEN 'COM'
       WHEN description='182' THEN 'COM'
       WHEN description='183' THEN 'COM'
       WHEN description='184' THEN 'COM'
       WHEN description='185' THEN 'COM'
       WHEN description='186' THEN 'COM'
       WHEN description='200' THEN 'ELEC'
       WHEN description='202' THEN 'ELEC'
       WHEN description='204' THEN 'ELEC'
       WHEN description='206' THEN 'ELEC'
       WHEN description='220' THEN 'GAZ'
       WHEN description='222' THEN 'GAZ'
       WHEN description='224' THEN 'GAZ'
       ELSE NULL
    END AS reseau,
     '01' AS qualite_categorisation,
     '005' AS precision_planimetrique,
     '010' AS precision_altimetrique,
     'CCPL' AS producteur,
     date_debut AS date_leve


        FROM
        (
        SELECT
          id_reclass,
          geometry,
          description,
          x1,
          y1,
		      x2,
		      y2,

    (x1 -((y2-y1) / (SQRT(POWER((x2-x1),2) + POWER((y2-y1),2)))) * (Distance(MakePoint(x2,y2),MakePoint(x3,y3)))) AS x4,
    (y1 +((x2-x1) / (SQRT(POWER((x2-x1),2) + POWER((y2-y1),2)))) * (Distance(MakePoint(x2,y2),MakePoint(x3,y3)))) AS y4,

    ((x1 -((y2-y1) / (SQRT(POWER((x2-x1),2) + POWER((y2-y1),2)))) * (Distance(MakePoint(x2,y2),MakePoint(x3,y3)))) + (x2-x1)) AS x3b,
    ((y1 +((x2-x1) / (SQRT(POWER((x2-x1),2) + POWER((y2-y1),2)))) * (Distance(MakePoint(x2,y2),MakePoint(x3,y3)))) + (y2-y1)) AS y3b,
    date_debut

        FROM
        (
        SELECT
        		id_reclass,
            geometry,
				description,
                x AS x1,
                y AS y1,
                LEAD(x,1) OVER (ORDER BY id_reclass) as x2,
                LEAD(y,1) OVER (ORDER BY id_reclass) as y2,
				        LEAD(x,2) OVER (ORDER BY id_reclass) as x3,
                LEAD(y,2) OVER (ORDER BY id_reclass) as y3,
                date_debut
                FROM
        (SELECT * FROM (
                 SELECT row_number() OVER(ORDER BY date_debut) +2 AS id_reclass, * FROM leve_topo WHERE
                 description='25' OR
                 description='45' OR
                 description='65' OR
                 description='65' OR
                 description='85' OR
                 description='86' OR
                 description='95' OR
                 description='96' OR
                 description='108' OR
                 description='114' OR
                 description='180' OR
                 description='181' OR
                 description='182' OR
                 description='183' OR
                 description='184' OR
                 description='185' OR
                 description='186' OR
                 description='200' OR
                 description='202' OR
                 description='204' OR
                 description='206' OR
                 description='220' OR
                 description='222' OR
                 description='224'
                 ) r ) a
        		)  b WHERE id_reclass %3=0 AND (x2 IS NOT NULL OR x3 IS NOT NULL)

     ) s
"
# ------------------------------------------------------------------------------
# RECTANGLE PAR DEUX POINTS + HAUTEUR
ogr2ogr -progress \
        -f "PostgreSQL" PG:"service='$C_SERVICE' active_schema=ccpl_topo" \
        -lco SCHEMA='ccpl_topo' \
        -nln "affleurant_surf" \
        "leve_topo_sql.sqlite" \
        --debug ON \
        -dialect SQLITE \
        -nlt POLYGON \
        -sql "
        SELECT
            id_reclass,
        		SetSRID(MakePolygon(GeomFromText('LINESTRING('||x1||' '||y1||','||x2||' '||y2||','||x3||' '||y3||','||x4||' '||y4||','||x1||' '||y1||')')),2154) as geometry,
            CASE
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='26' THEN '03'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='46' THEN '03'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='66' THEN '03'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='109' THEN '01'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='115' THEN '03'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='136' THEN '03'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='146' THEN '03'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='201' THEN '02'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='203' THEN '02'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='205' THEN '02'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='207' THEN '03'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='221' THEN '02'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='223' THEN '02'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='225' THEN '03'
               ELSE NULL
            END AS nature,
            CASE
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='26' THEN 'Plaque rectangle'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='46' THEN 'Plaque rectangle'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='66' THEN 'Plaque rectangle'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='109' THEN 'Grille rectangle'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='115' THEN 'Avaloir'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='136' THEN 'Plaque rectangle'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='146' THEN 'Plaque rectangle'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='201' THEN 'Armoire'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='203' THEN 'Coffret'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='205' THEN 'Transformateur'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='207' THEN 'Plaque'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='221' THEN 'Armoire'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='223' THEN 'Coffret'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='225' THEN 'Plaque'
               ELSE NULL
            END AS type,
            CASE
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='26' THEN 'AEP'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='46' THEN 'IRRI'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='66' THEN 'ARRO'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='109' THEN 'ASSAEP'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='115' THEN 'ASSAEP'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='136' THEN 'ASSAEU'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='201' THEN 'ELEC'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='203' THEN 'ELEC'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='205' THEN 'ELEC'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='207' THEN 'ELEC'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='221' THEN 'GAZ'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='223' THEN 'GAZ'
               WHEN SUBSTR(description,1,INSTR(description,'-') -1)='225' THEN 'GAZ'
               ELSE NULL
            END AS reseau,
             '01' AS qualite_categorisation,
             '005' AS precision_planimetrique,
             '010' AS precision_altimetrique,
             'CCPL' AS producteur,
             date_debut AS date_leve
                FROM
                (
                SELECT
                id_reclass,
                geometry,
                description,
                x1,
                y1,
        		x2,
        		y2,


        		(x1 -((y2-y1) / (SQRT(POWER((x2-x1),2) + POWER((y2-y1),2)))) * (CAST(SUBSTR(description,INSTR(description,'-')+1) AS real)/100)) AS x4,
        		(y1 +((x2-x1) / (SQRT(POWER((x2-x1),2) + POWER((y2-y1),2)))) * (CAST(SUBSTR(description,INSTR(description,'-')+1) AS real)/100)) AS y4,

        		((x1 -((y2-y1) / (SQRT(POWER((x2-x1),2) + POWER((y2-y1),2)))) *(CAST(SUBSTR(description,INSTR(description,'-')+1) AS real)/100)) + (x2-x1)) AS x3,
        		((y1 +((x2-x1) / (SQRT(POWER((x2-x1),2) + POWER((y2-y1),2)))) * (CAST(SUBSTR(description,INSTR(description,'-')+1) AS real)/100)) + (y2-y1)) AS y3,

            date_debut


                FROM
                (
                SELECT
                		id_reclass,
                    geometry,
                    description,
                        x AS x1,
                        y AS y1,
                        LEAD(x,1) OVER (ORDER BY id_reclass) as x2,
                        LEAD(y,1) OVER (ORDER BY id_reclass) as y2,
                        *
                        FROM
                (SELECT * FROM (
                         SELECT row_number() OVER(ORDER BY date_debut) +1 AS id_reclass, * FROM leve_topo WHERE
                         SUBSTR(description,1,INSTR(description,'-') -1)='26' OR
                         SUBSTR(description,1,INSTR(description,'-') -1)='46' OR
                         SUBSTR(description,1,INSTR(description,'-') -1)='66' OR
                         SUBSTR(description,1,INSTR(description,'-') -1)='109' OR
                         SUBSTR(description,1,INSTR(description,'-') -1)='115' OR
                         SUBSTR(description,1,INSTR(description,'-') -1)='136' OR
                         SUBSTR(description,1,INSTR(description,'-') -1)='146' OR
                         SUBSTR(description,1,INSTR(description,'-') -1)='201' OR
                         SUBSTR(description,1,INSTR(description,'-') -1)='203' OR
                         SUBSTR(description,1,INSTR(description,'-') -1)='205' OR
                         SUBSTR(description,1,INSTR(description,'-') -1)='207' OR
                         SUBSTR(description,1,INSTR(description,'-') -1)='221' OR
                         SUBSTR(description,1,INSTR(description,'-') -1)='223' OR
                         SUBSTR(description,1,INSTR(description,'-') -1)='225'
                         ) r ) a
                		)  b WHERE id_reclass %2=0 AND (x2 IS NOT NULL)

             ) s
"

# ------------------------------------------------------------------------------
# DESSIN PONCTUEL SUR LEQUELLE UN SIMPLE SYMBOLE EST APPLIQUE
ogr2ogr \
        -progress \
        -f "PostgreSQL" PG:"service='$C_SERVICE' active_schema=ccpl_topo" \
        -lco SCHEMA='ccpl_topo' \
        -nln "affleurant_point" \
        "leve_topo_sql.sqlite" \
        --debug ON \
        -dialect SQLITE \
        -nlt POINT \
        -sql "SELECT
        geometry,
        CASE
           WHEN description='30' THEN '04'
           WHEN description='31' THEN '04'
           WHEN description='32' THEN '04'
           WHEN description='33' THEN '04'
           WHEN description='50' THEN '04'
           WHEN description='70' THEN '04'
           WHEN description='71' THEN '04'
           WHEN description='72' THEN '04'
           WHEN description='73' THEN '04'
           WHEN description='80' THEN '07'
           WHEN description='81' THEN '07'
           WHEN description='90' THEN '06'
           WHEN description='91' THEN '06'
           WHEN description='92' THEN '06'
           WHEN description='139' THEN '04'
           WHEN description='175' THEN '06'
           WHEN description='210' THEN '06'
           WHEN description='211' THEN '06'
           WHEN description='212' THEN '06'
           WHEN description='213' THEN '06'
           WHEN description='226' THEN '04'
           WHEN description='227' THEN '04'
           ELSE NULL
        END AS nature,
        CASE
           WHEN description='30' THEN 'Borne incendie'
           WHEN description='31' THEN 'Poteau incendie'
           WHEN description='32' THEN 'Bouche à clef'
           WHEN description='33' THEN 'Robinet'
           WHEN description='50' THEN 'Vanne'
           WHEN description='70' THEN 'Vanne vidange'
           WHEN description='71' THEN 'Arroseur'
           WHEN description='72' THEN 'Bouche'
           WHEN description='73' THEN 'Purge'
           WHEN description='80' THEN 'Poteau 1 lampe'
           WHEN description='81' THEN 'Poteau 2 lampes'
           WHEN description='90' THEN 'Feu tricolore'
           WHEN description='91' THEN 'Feu tricolore déporté'
           WHEN description='92' THEN 'Feu tricolore piéton'
           WHEN description='139' THEN 'Vanne'
           WHEN description='175' THEN 'Poteau télécom'
           WHEN description='210' THEN 'Poteau électrique'
           WHEN description='211' THEN 'Poteau électrique/lampe'
           WHEN description='212' THEN 'Poteau électrique/télécom'
           WHEN description='213' THEN 'Poteau électrique/télécom/lampe'
           WHEN description='212' THEN 'Vanne'
           WHEN description='213' THEN 'Borne'

           ELSE NULL
        END AS type,
        CASE
           WHEN description='30' THEN 'AEP'
           WHEN description='31' THEN 'AEP'
           WHEN description='32' THEN 'AEP'
           WHEN description='33' THEN 'AEP'
           WHEN description='50' THEN 'IRRI'
           WHEN description='70' THEN 'ARRO'
           WHEN description='71' THEN 'ARRO'
           WHEN description='72' THEN 'ARRO'
           WHEN description='73' THEN 'ARRO'
           WHEN description='80' THEN 'ELECECL'
           WHEN description='81' THEN 'ELECECL'
           WHEN description='90' THEN 'ELECSLT'
           WHEN description='91' THEN 'ELECSLT'
           WHEN description='91' THEN 'ELECSLT'
           WHEN description='139' THEN 'ASSAEU'
           WHEN description='175' THEN 'COM'
           WHEN description='210' THEN 'ELEC'
           WHEN description='211' THEN 'MULT'
           WHEN description='212' THEN 'MULT'
           WHEN description='213' THEN 'MULT'
           WHEN description='226' THEN 'GAZ'
           WHEN description='227' THEN 'GAZ'
           ELSE NULL
        END AS reseau,
        '01' AS qualite_categorisation,
        '005' AS precision_planimetrique,
        '010' AS precision_altimetrique,
        'CCPL' AS producteur,
        date_debut AS date_leve

         FROM leve_topo WHERE
        description='30' OR
        description='31' OR
        description='32' OR
        description='33' OR
        description='50' OR
        description='70' OR
        description='71' OR
        description='72' OR
        description='73' OR
        description='80' OR
        description='81' OR
        description='90' OR
        description='91' OR
        description='92' OR
        description='139' OR
        description='175' OR
        description='210' OR
        description='211' OR
        description='212' OR
        description='213' OR
        description='226' OR
        description='227'
"



# -----------------------------------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------------------------------
