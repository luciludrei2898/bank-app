<?php
    $datos = array();
    $cnx = Conexion::conectar();
    // Cargar temas
    $sql = "SELECT *
            FROM temas
            WHERE 
                tema_prop_id = 2
            ORDER BY tema_visitas DESC, tema_titulo";
    echo $sql."<hr>";        
            
    // Cargar palabras
    $datos['palabras'] = array();
    for ($i=0; $i<count($datos['temas']); $i++){
        $tema_id = $datos['temas'][$i]['tema_id'];
        $sql = "SELECT DISTINCT k.key_palabra 
                FROM keywords as k, keys_temas as kt
                WHERE 
                    kt.keytema_tema_id = 12 AND
                    kt.keytema_key_id = k.key_id
                ORDER BY key_palabra";
        echo $sql."<br>";
        $rs = mysqli_query($cnx, $sql); 
        while ( $k = mysqli_fetch_assoc($rs)){
            $datos['palabras'][] = $k;
        }                   
    }
    mysqli_close($cnx);
    echo "<pre>";
    echo var_export($datos);
    echo "</pre>";