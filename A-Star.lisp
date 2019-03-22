(DEFUN HARVESINE (COR1 COR2)
  "CALCULA LA DISTANCIA DE DOS CORDENADAS"
  (if (not (equal cor1 cor2))
    (progn (SETF COR1 (RAD COR1) COR2 (RAD COR2))
    (SETF LAT (- (FIRST COR1) (FIRST COR2)) LON (- (SECOND COR1) (SECOND COR2)) R 6371)
    (SETF A (+ (SQ (SIN (/ LAT 2))) (* (COS (FIRST COR1)) (COS (FIRST  COR2)) (SQ (SIN (/ LON 2))))))
    (* 2 R (ASIN (SQRT A))))
    0))

(DEFUN SQ (NUM)
  "CUADRADO"
  (* NUM NUM))

(DEFUN RAD (COR)
  "PASA CORDENADAS A RADIANES"
  (LIST (* PI (/ (FIRST COR) 180)) (* PI (/ (SECOND COR) 180))))

;la lista de entrada esta compuesta de varias listas de este tipo
;(lugar (cordenadas) ((destino distancia)(destino distancia)))
;LOS NODOS SON (NUMERO PADRE DISTANCIA-TOTAL DISTANCIA-VIAJADA UBICACION)
(DEFUN BUSCAR-RUTA (ORIGEN DESTINO)
  "ENCUENTRA LA MEJOR RUTA ENTRE  DOS PUNTOS"
  (SETQ ABIERTO NIL CERRADO NIL OR ORIGEN DES DESTINO LAST 0 BEST NIL)
  (SETQ COR-D (SECOND (SU-SUB DES)))
  (SETF SUB (SU-SUB OR))
  (PUSH (LIST 0 NIL (HARVESINE (SECOND SUB) COR-D) 0 OR) CERRADO)
  (SETQ PADRE 0 V 0)
  (EXPAND (THIRD SUB))
  (A-ESTRELLA)
  (REGRESO))

(DEFUN EXPAND (LST)
  "CREA LOS NODOS QUE OCURREN AL EXPANDIR UN NODO"
  (COND
    ((NULL LST))
    ((EXISTE  (CAAR LST)) (EXPAND (CDR LST)))
    (T (PROGN
      (INCF LAST)
      (PUSH (LIST LAST PADRE (+ V (SECOND (CAR LST)) (DIST (FIRST (CAR LST)))) (+ V (SECOND (CAR LST))) (FIRST (CAR LST))) ABIERTO)
      (IF (AND (equal DES (car (LAST (CAR ABIERTO)))) (or (null best) (< (FOURTH (CAR ABIERTO)) (FOURTH BEST))))
        (SETQ BEST (CAR ABIERTO)))
      (EXPAND (CDR LST))))))

(DEFUN EXISTE (NOM)
  "CHECA SI UN ELEMENTO YA SE USO"
  (NOT (NULL (FIND NOM (MAPCAR #'CAR (MAPCAR #'LAST CERRADO))))))

(DEFUN DIST (NOM)
  "TOMA UN NOMBRE Y REGRESA DISTANCIA AL DESTINO"
  (HARVESINE COR-D (SECOND (SU-SUB NOM))))


(DEFUN SU-SUB (NOM)
  "REGRESA LA SUB-LISTA RECIVIENDO UN NOMBRE"
  (assoc nom bd  :test #'equal))

(DEFUN VERIFICAR ()
  "VERIFICA SI BEST ES EL MEJOR POSIBLE"
  (IF (NULL BEST) NIL
    (NULL (MEMBER-IF #'(LAMBDA (X) (> (FOURTH BEST) (THIRD X))) ABIERTO))))

(DEFUN REGRESO ()
  "CREA LA LISTA DEL CAMINO"
  (SETQ R (LIST BEST))
  (REGRESO2)
  (SETQ DIST (THIRD BEST))
  (SETQ R (MAPCAR #'CAR (MAPCAR #'LAST R)))
  (push (fourth best) R))

(DEFUN REGRESO2 ()
  "AUXILIAR DE REGRESO"
  (cond
    ((null (caDar R)))
    (t (progn (PUSH (REGRESO3 (CADAR R)) R)
      (regreso2)))))

(DEFUN REGRESO3 (P)
  "AUXILIAR DE REGRESO"
  (ASSOC P CERRADO))

(defun get-min (LST)
  "SACA EL VALOR MINIMO DE UNA LISTA"
  (cond
    ((NULL LST))
    ((< (CAR LST) M) (PROGN (SETQ M (CAR LST)) (GET-MIN (CDR LST))))
    (T (GET-MIN (CDR LST)))))

(DEFUN MENOR ()
  (SETQ M 100000000000)
  (GET-MIN  (MAPCAR #'THIRD ABIERTO))
  (SETQ ME (CAR (MEMBER-IF #'(LAMBDA (X) (= M (THIRD X))) ABIERTO))))

(DEFUN A-ESTRELLA ()
  (MENOR)
  (SETQ ABIERTO (REMOVE ME ABIERTO))
  (if (NOT (EXISTE (CAR (LAST ME))))
    (PROGN (PUSH ME CERRADO)(SETQ PADRE (CAR ME) V (FOURTH ME))(EXPAND (THIRD (SU-SUB (car (LAST ME))))))
    (PUSH ME CERRADO))
  (IF (NOT (VERIFICAR)) (A-ESTRELLA)));VERIFICAR

(DEFUN SET-BD ()
  (SETQ BD '(("Tijuana"	(32.5027 -117.00371) (("Ensenada" 104) ("Nogales" 781)))
    ("Ensenada" (31.86613 -116.59972) (("Tijuana" 104) ("Nogales" 820) ("SanQuintin" 185)))
    ("SanQuintin"	(30.4833 -115.95) (("Ensenada" 185) ("Rosarito" 267)))
    ("Rosarito"	(30.4833 -115.3667) (("SanQuintin" 267) ("SantaRosalina" 901)))
    ("SantaRosalina"	(27.34045 -112.26761) (("Rosarito" 901) ("Loreto" 197)))
    ("Loreto"	(22.27248 -101.98898) (("SantaRosalina" 197) ("LaPaz" 356)))
    ("LaPaz"	(24.1164329 -110.337743) (("Loreto" 356) ("SanLucas" 158)))
    ("SanLucas"	(22.8962225 -109.968017) (("LaPaz" 158)))
    ("Nogales" (30.8 -110.3833) (("Tijuana" 781) ("Ensenada" 820) ("Hermosillo" 277) ("Chihuahua" 706)))
    ("Hermosillo" (29.1026 -110.9773200) (("Nogales" 277) ("Chihuahua" 689) ("Guaymas" 134)))
    ("Chihuahua" (28.6353 -106.089) (("Nogales" 706) ("Hermosillo" 689) ("Delicias" 87.7)))
    ("Guaymas" (27.91928 -110.89755) (("Delicias" 819) ("LosMochis" 361) ("Hermosillo" 134)))
    ("Delicias" (19.1667 -103.85) (("Guaymas" 819) ("Chihuahua" 87.7) ("Torreon" 389) ("Monterrey" 723)))
    ("LosMochis" (25.7667 -108.9667) (("Guaymas" 361) ("Culiacan" 209) ("Torreon" 888)))
    ("Culiacan" (25.1533 -108.1732) (("LosMochis" 209) ("Torreon" 700) ("Durango" 465) ("Mazatlan" 220)))
    ("Mazatlan" (23.2494 106.4111) (("Culiacan" 220) ("Durango" 255) ("Zacatecas" 540) ("Tepic" 275)))
    ("Tepic" (21.5039 -104.89521) (("Mazatlan" 275) ("SanLuisPotosi" 539) ("Guadalajara" 206) ("Guanajuato" 478) ("Zacatecas" 543)))
    ("Guadalajara" (20.66682 -103.39182) (("Tepic" 206) ("SanLuisPotosi" 337) ("Guanajuato" 276) ("Manzanillo" 297) ("Colima" 291) ("Morelia" 289)))
    ("Colima" (19.2433 -103.725) (("Morelia" 572 ) ("Guadalajara" 291) ("Manzanillo" 15) ("Cuernavaca" 892) ("LazaroCardenas" 340)))
    ("Manzanillo" (19.05922 -104.30156) (("Colima" 15) ("Guadalajara" 297) ("LazaroCardenas" 348)))
    ("LazaroCardenas" (19.6806 -101.75) (("Manzanillo" 348) ("Colima" 340) ("Cuernavaca" 555) ("Acapulco" 349) ("Chilpancingo" 433)))
    ("Acapulco" (16.8638 -99.8816) (("LazaroCardenas" 349) ("Chilpancingo" 105) ("PuertoEscondido" 390)))
    ("PuertoEscondido" (17.0871 -97.3484) (("Acapulco" 390) ("Chilpancingo" 487) ("Oaxaca" 251)))
    ("Oaxaca" (17.0669 -96.7203) (("PuertoEscondido" 251) ("Chilpancingo" 622) ("Villahermosa" 602) ("Puebla" 366)))
    ("Chilpancingo" (26.2738 -102.3071) (("Oaxaca" 622) ("PuertoEscondido" 487) ("Acapulco" 105) ("Puebla" 284) ("Cuernavaca" 187)))
    ("Cuernavaca" (18.9167 -99.25) (("Chilpancingo" 187) ("LazaroCardenas" 555) ("Colima" 892) ("CiudadDeMexico" 86.6) ("Puebla" 161)))
    ("SanLuisPotosi" (22.14982 -100.97916) (("Tepic" 539) ("Guadalajara" 291) ("Zacatecas" 194) ("Guanajuato" 193) ("Tampico" 432) ("CiudadVictoria" 332)))
    ("Torreon" (25.54389 -103.41898) (("Culiacan" 700) ("LosMochis" 888) ("Delicias" 389) ("Saltillo" 256) ("Monterrey" 338) ("Durango" 243)))
    ("Durango" (24.0277 -104.65756) (("Torreon" 243) ("Mazatlan" 255) ("Culiacan" 465) ("Zacatecas" 289)))
    ("Zacatecas" (22.76843 -102.58141) (("Durango" 289) ("SanLuisPotosi" 194) ("Mazatlan" 540) ("Tepic" 543) ("CiudadVictoria" 802)))
    ("Saltillo" (25.4333 -105.8667) (("Torreon" 256) ("Monterrey" 86.9) ("CiudadVictoria" 365)))
    ("Monterrey" (25.67507 -100.31847) (("Saltillo" 86.9) ("Torreon" 338) ("Delicias" 723) ("CiudadVictoria" 284)))
    ("CiudadVictoria" (23.74174 -99.1459900) (("Monterrey" 284) ("Saltillo" 365) ("Zacatecas" 802) ("SanLuisPotosi" 332) ("Tampico" 237)))
    ("Tampico" (22.21505 -97.85292) (("CiudadVictoria" 237) ("SanLuisPotosi" 432) ("Guanajuato" 605) ("PozaRica" 236)))
    ("PozaRica" (20.53315 -97.45946) (("Tampico" 236) ("CiudadDeMexico" 295) ("Veracruz" 268) ("Guanajuato" 558)))
    ("Veracruz" (19.18095 -96.1429) (("PozaRica" 268) ("Puebla" 289) ("Villahermosa" 467)))
    ("Guanajuato" (21.01858 -101.2591) (("Tampico" 605) ("SanLuisPotosi" 193) ("Guadalajara" 276) ("Tepic" 478) ("PozaRica" 538) ("CiudadDeMexico" 379) ("Morelia" 176)))
    ("Morelia" (19.70078 -101.18443) (("Colima" 572) ("Guadalajara" 289) ("Guanajuato" 176) ("CiudadDeMexico" 312)))
    ("CiudadDeMexico" (19.42847 -99.12766) (("PozaRica" 295) ("Guanajuato" 379) ("Cuernavaca" 86.6) ("Morelia" 312) ("Puebla" 138)))
    ("Puebla" (19.04334 -98.20193) (("CiudadDeMexico" 138) ("Veracruz" 289) ("Chilpancingo" 284) ("Oaxaca" 366) ("Villahermosa" 754)))
    ("Villahermosa" (17.98689 -92.93028) (("Puebla" 754) ("Veracruz" 467) ("Oaxaca" 603) ("Chetumal" 575) ("Campeche" 382)))
    ("Merida" (20.97537 -89.61696) (("Campeche" 184) ("Cancun" 303)))
    ("Cancun" (21.17429 -86.84656) (("Merida" 303) ("Chetumal" 383)))
    ("Campeche" (19.84386 -90.52554) (("Chetumal" 418) ("Merida" 184) ("Villahermosa" 382)))
    ("Chetumal" (18.51413 -88.30381) (("Cancun" 383) ("Villahermosa" 575) ("Campeche" 418))))))

(defun write-non-empty-list-to-a-file (file-name lst)
  "writes a non empty list to a file if the list is empty creates the file with a return"
  (with-open-file (str file-name
                     :direction :output
                     :if-exists :supersede
                     :if-does-not-exist :create)
    (dolist (e lst)
      (format str "~A~%" e))
    (format str "~%")))


;(trace a-ESTRELLA EXISTE EXPAND)
;(TRACE A-ESTRELLA EXPAND)

;(MAIN '"Chetumal" '"SanLucas")
;(EXT:SAVEINITMEM  "A-ESTRELLA.exe" :INIT-FUNCTION 'main :EXECUTABLE T :NORC T)
(defun get-file (filename)
  (with-open-file (stream filename)
    (loop for line = (read-line stream nil)
          while line
          collect line)))

(DEFUN MAIN ()
  (SET-BD)
  (setf l (get-file "/home/eschullert/Documents/Programming/Lisp/GPS/res.txt"))
  (BUSCAR-RUTA (first l) (second l))
  (write-non-empty-list-to-a-file "/home/eschullert/Documents/Programming/Lisp/GPS/res.txt" R)
  (EXT:EXIT))

(EXT:SAVEINITMEM  "astar.bin" :INIT-FUNCTION 'main :EXECUTABLE T :NORC T)
