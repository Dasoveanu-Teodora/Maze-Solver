`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Student 333AA
// Engineer: DAsoveanu Maria Teodora
// 
// Create Date:    11:58:21 11/26/2021 
// Design Name: 
// Module Name:    maze 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define  dreapta               0
`define  sus                  1  
`define  stanga                2
`define  jos						3
`define  initializare			 4  //starile in care se afla robotelul
`define  set_deplasare         5
`define	verificare            6 
//parameter maze_width = 64;

module maze(

input 		          clk,
input [6 - 1:0]  starting_col, starting_row, 	// indicii punctului de start
input  			  maze_in, 			// oferã informa?ii despre punctul de coordonate [row, col]
output reg [6 - 1:0] row, col,	 		// selecteazã un rând si o coloanã din labirint
output reg		  maze_oe,			// output enable (activeazã citirea din labirint la rândul ?i coloana date) - semnal sincron	
output reg		  maze_we, 			// write enable (activeazã scrierea în labirint la rândul ?i coloana date) - semnal sincron
output reg		  done);		 	// ie?irea din labirint a fost gasitã; semnalul rãmane activ 

   reg[2:0] state;
	reg[2:0] next_state;
	//deplasarea :  dreapta orientarii // pt maze_in ==0 
	//					sens trigonometric a. i. in linie dreapta sa nu fie favorizata intoarcerea ca sa nu se impotmoleasca 
	// in bucle                                           // pt maze_in == 1
	reg [2:0] deplasare;
	//directia in care s-a facut deplasarea la pasul anterior
	reg [2:0] orientare;

	initial 
	begin
	state = 4;  //prima data automatul intra in starea de initializare
	next_state =0;
	end
	
	always @(posedge clk)begin
		if(done==0)
		begin
			state <= next_state;
		end
	
	end

	always@(*)begin

		done = 0;
		maze_oe = 0;
		maze_we = 0;
		
		case(state)
		  
		  `initializare:begin
   			row = starting_row;
				col =  starting_col;
				maze_we =1;
				orientare = `dreapta;
				deplasare = (orientare - 1+4)%4;
				next_state = `set_deplasare;
				 
			end 
		  
		 // Deplasarile sunt gandite ca si atunci cand privesti matricea labirintului
		  `set_deplasare:begin
				case(deplasare)
					0:begin
						col = col + 1; // dreapta 
					end
					1: begin
						row = row - 1; //sus
					end
					
					2: begin 
						col = col - 1; // stanga
					
					end
					3: begin
						row = row + 1; // jos
					end
				endcase	
				maze_oe = 1; 
				next_state = `verificare; 
		   end
			
			`verificare: begin
						if(maze_in == 0) 
						begin 
								maze_we = 1;
								if(col==0 || row == 0|| col == 63 ||row == 63)   // conditia de gasire a iesirii este ca roobotelul sa se afle
								begin															//pe conturul matricei
									done = 1;
								end
								//daca miscarea este valida, directia de deplasarea este noua orientare
								case(deplasare)
									0:begin
									orientare = `dreapta;
									end
									
									1:begin
									orientare =  `sus;
									end
								
									2:begin
									orientare = `stanga;
									end
									
									3:begin
									orientare = `jos;
									end
								
								endcase
								                                     // 
								 deplasare =  (orientare - 1+4)%4;  // deplasarea noua se face dreapta orientarii actualizate mai sus
								 next_state = `set_deplasare;
						end
					
						else
						begin
						// cazul in care misacrea nu este valida
						case(deplasare)
								0:begin	
									col = col - 1; //  ma reintorc in pozitia de unde am plecat
									//deplasare =  (deplasare + 1)%4;
								end

								1: begin 
									row = row + 1; //  ma reintorc in pozitia de unde am plecat
								//	deplasare =  (deplasare + 1)%4;
								 end


							  2: begin
								col = col + 1;//  ma reintorc in pozitia de unde am plecat
								//deplasare =  (deplasare + 1)%4;
								end

							 3: begin 
								row = row - 1; //  ma reintorc in pozitia de unde am plecat
							 // deplasare =  (deplasare + 1)%4;
								end
							endcase
						   deplasare =  (deplasare + 1)%4;
							next_state = `set_deplasare;
						end
				end
			endcase
end			
endmodule		