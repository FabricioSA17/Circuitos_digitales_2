// Tarea 1 circuitos digitales 2
// Henry Fabricio Salazar ALvarado B87179

module controlador(clk, reset, enter, llego_vehiculo, vehiculo_adentro, clave, comp_abierto, comp_cerrado, alarma_pin, alarma_vehiculo
);

input clk, reset, enter, llego_vehiculo, vehiculo_adentro;
input [15:0] clave;
output reg comp_abierto, comp_cerrado, alarma_pin, alarma_vehiculo;

// Cantidad de estados y contador
reg [3:0] estado;
reg [1:0] contador;
reg [3:0] siguiente_estado;
reg [1:0] siguiente_contador;

// Se nombrea las constantes de los estados para usarlas facilmente
parameter door_close = 4'b0001; 
parameter detect_veh = 4'b0010;
parameter door_open = 4'b0100; 
parameter door_bloq = 4'b1000; 
parameter correct_pin = 16'h9A4; 


// Maquina de estados
always @(posedge clk) begin
    if (reset) begin
        estado <= door_close;
        contador <= 2'b0;
    end 
    else begin
        estado <= siguiente_estado;
        contador <= siguiente_contador;
    end    
end


always @(*) begin

siguiente_estado = estado;
siguiente_contador = contador;

case (estado) // aqui entran los casos
    
    door_close: begin
        comp_cerrado = 1'b1;
        comp_abierto = 1'b0;
        alarma_pin = 1'b0;
        alarma_vehiculo = 1'b0;
    end

    detect_veh: begin
        comp_cerrado = 1'b1;
        comp_abierto = 1'b0;
        alarma_pin = 1'b0;
        alarma_vehiculo = 1'b0;

        if (llego_vehiculo && enter && clave==correct_pin) begin
            siguiente_estado = door_open;
            siguiente_contador = 2'b00;
        end

        else begin
            if (contador >= 3) 
            begin
                siguiente_estado = door_bloq;
                alarma_pin = 1'b1;
            end
            
            else begin
            siguiente_estado = door_close;
            siguiente_contador = contador + 1;
            end 
        end
    end

    door_open: begin
        comp_cerrado = 1'b0;
        comp_abierto = 1'b1;
        alarma_pin = 1'b0;
        alarma_vehiculo = 1'b0;

        if (vehiculo_adentro) begin
            comp_abierto = 1'b0;
            comp_cerrado = 1'b1;
            if (llego_vehiculo) begin
                siguiente_estado = door_bloq;
                alarma_vehiculo = 1'b1;
            end

            else begin
                siguiente_estado = door_close;
            end
        end

    end


    door_bloq: begin
        comp_cerrado = 1'b0;
        comp_abierto = 1'b0;
        alarma_pin = 1'b1;
        alarma_vehiculo = 1'b1;
        if (reset) begin
            siguiente_estado = door_close;
            
        end

    end

    default: siguiente_estado = estado;
endcase

end


endmodule








