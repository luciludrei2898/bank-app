
// VARIABLES GLOBALES
let id = "";

function fInicio(){
    fRellenarCombos('#div_combo_select');
}

function fRellenarCombos(donde){
    let sql="SELECT * FROM cuentas ORDER BY c_titular";

    const URL = "assets/php/servidor.php?peticion=EjecutarSelect&sql=" + sql;

    //Debemos de pedirsela al servidor
            
    fetch(URL)
        .then((response) => response.json())
        .then((data) => {
            console.log("cuentas", data);
            let html = `<select id="cuenta_id">"`;
            html += `<option>--</option>`;
            data.datos.forEach(item => {
                html+= `<option id="m_id_cuenta" value="${item.c_num_cta}">${item.c_titular}</option>`
            });
            html += `</select>`;
            document.querySelector(donde).innerHTML = html;
        });

}

function fMostrarContacto(){
    document.querySelector("#div_contacto").style.display='flex';
    document.querySelector("#div_beneficios").style.display='none';
    document.querySelector("#div_cuentas").style.display='none';
    document.querySelector("#div_movimientos").style.display='none';


}

function fMostrarBeneficios(){
    document.querySelector("#div_contacto").style.display='none';
    document.querySelector("#div_beneficios").style.display='flex';
    document.querySelector("#div_cuentas").style.display='none';
    document.querySelector("#div_movimientos").style.display='none';


}

function fMostrarCuentas(){

    document.querySelector("#div_beneficios").style.display='none';
    document.querySelector("#div_contacto").style.display='none';
    document.querySelector("#div_cuentas").style.display='flex';
    document.querySelector("#div_movimientos").style.display='none';


    let sql = "Select * FROM cuentas ORDER BY c_num_cta";
    const URL = "assets/php/servidor.php?peticion=EjecutarSelect&sql=" + sql;

    fetch(URL)
    .then((response) => response.json())
    .then((data) => {
        console.log("CUENTAS", data);

        let html = "";

        data.datos.forEach( item => {
            html += `<div class="div_cuenta">`;
            html += `<div class="num_cuenta">Número de cuenta: ${item.c_num_cta}</div>`;
            html += `<div class="nif_cuenta"> NIF/NIE: ${item.c_nif}</div>`;
            html += `<div class="titular_cuenta">Titular: ${item.c_titular}</div>`;
            html += `<div class="saldo_cuenta">Saldo: ${item.c_saldo}€</div>`;
            html +=  `<div class="basura" onclick="fBorrarCuenta('${item.c_num_cta}')">  
                        <i class="fas fa-trash" title="Borrar ${item.c_num_cta}"></i> </div>`;
            html +=  `<div class="edit" onclick="fMostrarFormulario('#modificar_cuenta','${item.c_num_cta}')"> 
                        <i class="fas fa-edit" title="Editar ${item.c_num_cta}"></i> </div>`;
            html +=  `</div>`;

            let id = item.c_num_cta;
            console.log("ID PASADO: ", id)

        });


        document.querySelector("#cajon_cuentas").innerHTML = html;
    })
}

function fMostrarMovimientos(){

    document.querySelector("#div_beneficios").style.display='none';
    document.querySelector("#div_contacto").style.display='none';
    document.querySelector("#div_cuentas").style.display='none';
    document.querySelector("#div_movimientos").style.display='flex';

    let sql = "Select * FROM movimientos ORDER BY m_id ASC";
    const URL = "assets/php/servidor.php?peticion=EjecutarSelect&sql=" + sql;

    fetch(URL)
    .then((response) => response.json())
    .then((data) => {
        console.log("MOVIMIENTOS", data);

        let html="";

        data.datos.forEach(item => {
            html+= `<div class="div_movimiento">`;
            html += `<div class="num_movimiento">Número de movimiento: ${item.m_id}</div>`;
            html += `<div class="num_cuenta_movimiento"> Número de cuenta: ${item.m_c_num_cta}</div>`;
            html += `<div class="fecha_movimiento">Fecha: ${item.m_fecha}</div>`;
            html += `<div class="importe_movimiento">Importe: ${item.m_importe}€</div>`;
            html += `<div class="concepto_movimiento">Concepto: ${item.m_concepto}</div>`;
            html += `<div class="basura" onclick="fBorrarMovimiento('${item.m_id}')">  
                        <i class="fas fa-trash" title="Borrar ${item.m_id}"></i> </div>`;
            html+=  `<div class="edit" onclick="fMostrarFormulario('#modificar_movimiento','${item.m_id}')" >   
                        <i class="fas fa-edit" title="Editar ${item.m_id}"></i></div>`;
            html+=  `</div>`;

        });

        document.querySelector("#cajon_movimientos").innerHTML = html;
    })

}

function fBorrarCuenta(c_id){
    console.log("ID PARA BORRAR:", c_id);

    let sql = `call cta_borrar('${c_id}')`;
    const URL = "assets/php/servidor.php?peticion=EjecutarUpdateDelete&sql=" + sql;

    //Debemos de pedirsela al servidor
            
        fetch(URL)
        .then((response) => response.json())
        .then((data) => {
  
          
      })
      
      .finally(()=>{
  
          fMostrarCuentas();
      })
}

function fBorrarMovimiento(m_id){
    console.log("ID PARA BORRAR:", m_id);

    let sql = `call m_borrar('${m_id}')`;
    const URL = "assets/php/servidor.php?peticion=EjecutarUpdateDelete&sql=" + sql;

    //Debemos de pedirsela al servidor
            
        fetch(URL)
        .then((response) => response.json())
        .then((data) => {
  
          
      })
      
      .finally(()=>{
  
          fMostrarMovimientos();
      })
}

function fInsertarCuenta(){

    // RECOGEMOS EL TITULAR Y EL NIF

    let titular = document.querySelector('#c_titular').value;
    let nif = document.querySelector('#c_nif').value;

    
    let sql = `call cta_insertar('${nif}','${titular}')`;
    const URL = "assets/php/servidor.php?peticion=EjecutarInsert&sql=" + sql;

    //Debemos de pedirsela al servidor
            
        fetch(URL)
        .then((response) => response.json())
        .then((data) => {
  
          
      })
      
      .finally(()=>{
        document.querySelector('#c_titular').value = "";
        document.querySelector('#c_nif').value = "";         
        fMostrarCuentas();
        fInicio();
      })



}

function fInsertarMovimiento(){

        // RECOGEMOS EL TITULAR Y EL NIF

        let titular = document.querySelector('#cuenta_id').value;
        let importe = document.querySelector('#m_importe').value;
        let concepto = document.querySelector('#m_concepto').value;
    
        
        let sql = `call m_insertar('${titular}','${importe}','${concepto}')`;
        const URL = "assets/php/servidor.php?peticion=EjecutarInsert&sql=" + sql;
    
        //Debemos de pedirsela al servidor
                
            fetch(URL)
            .then((response) => response.json())
            .then((data) => {
      
              
          })
          
          .finally(()=>{
            document.querySelector('#m_importe').value = "";
            document.querySelector('#m_concepto').value = "";  
            fMostrarMovimientos();
          })

    
}

function fMostrarFormulario(nombre_formulario_con_almohadilla, mandado_id){

        id = mandado_id;

        document.querySelector('#div_cuentas').style.display = 'none';
        document.querySelector('#div_movimientos').style.display = 'none';

        // Ocultar todos los formularios
        let lista_formularios = document.querySelectorAll("#formulario_cuenta > div");
        lista_formularios.forEach(item =>{
        item.style.display = "none";
         });
        // Muestro el que me pidan
        document.querySelector(nombre_formulario_con_almohadilla).style.display = 'flex';
        // Muestro la modal
        document.querySelector('#formulario_cuenta').style.display = 'flex';
   
}

function fModificarCuenta(){

       // RECOGEMOS EL TITULAR Y EL NIF

       let titular = document.querySelector('#cm_titular').value;
       let nif = document.querySelector('#cm_nif').value;
   
       
       let sql = `call cta_modificar('${id}','${nif}','${titular}')`;
       const URL = "assets/php/servidor.php?peticion=EjecutarUpdateDelete&sql=" + sql;
   
       //Debemos de pedirsela al servidor
               
           fetch(URL)
           .then((response) => response.json())
           .then((data) => {
     
         })
         
         .finally(()=>{
            document.querySelector('#formulario_cuenta').style.display = 'none';
           document.querySelector('#cm_titular').value = "";
           document.querySelector('#cm_nif').value = "";         
           fMostrarCuentas();

           // LA VACIAMOS DE NUEVO
           id = "";

         })
   

}

function fModificarMovimiento(){

           // RECOGEMOS EL TITULAR Y EL NIF

           let importe = document.querySelector('#mm_importe').value;
           let concepto = document.querySelector('#mm_concepto').value;
       
           
           let sql = `call m_modificar('${id}','${importe}','${concepto}')`;
           const URL = "assets/php/servidor.php?peticion=EjecutarUpdateDelete&sql=" + sql;
       
           //Debemos de pedirsela al servidor
                   
               fetch(URL)
               .then((response) => response.json())
               .then((data) => {
         
             })
             
             .finally(()=>{
                document.querySelector('#formulario_cuenta').style.display = 'none';
               document.querySelector('#mm_importe').value = "";
               document.querySelector('#mm_concepto').value = "";         
               fMostrarMovimientos();
    
               // LA VACIAMOS DE NUEVO
               id = "";
    
             })

}

function fCancelarMC(){
    document.querySelector('#formulario_cuenta').style.display='none';
    document.querySelector('#div_cuentas').style.display = 'flex';
}

function fCancelarMM(){
    document.querySelector('#formulario_cuenta').style.display='none';
    document.querySelector('#div_movimientos').style.display = 'flex';
}
