`timescale 1ns / 1ps

module aclock (
 input reset,  
 input clk, 
 input LDA, //Ustawienie alarmu z inputu
 input LDT, //Ustawienie zegaru z inputu 
 input STOP_ALARM, //Zatrzymanie dzialaj¹cego alarmu
 input ALARM_ON,   //Uruchomienie alarmu
 input [1:0] Hpoz2, //wejœciowe dziesi¹tki godzin
 input [3:0] Hpoz1, //wejsciowe jednostki godzin
 input [3:0] Mpoz2, //wejœciowe dziesiatki minut
 input [3:0] Mpoz1, //wejœciowe jednostki minut
 output [1:0] OHpoz2, //wyjœciowe dziesi¹tki godzin
 output [3:0] OHpoz1, //wyjœciowe jednostki godzin
 output [3:0] OMpoz2, //wyjœciowe dziesiatki minut
 output [3:0] OMpoz1, //wyjœciowe jednostki minut
 output [3:0] OSpoz2, //wyjœciowe dziesi¹tki sekund
 output [3:0] OSpoz1, //wyjœciowe jednostki sekund
 output reg Alarm  
 );


 reg [5:0] tmp_s, tmp_m, tmp_h; 
 reg [1:0] a_h2, b_h2; // Wartoœci alarmu z a_    Wartoœci  zegaru z b_
 reg [3:0] a_h1, b_h1;
 reg [3:0] a_m2, b_m2;
 reg [3:0] a_m1, b_m1;
 reg [3:0] a_s2, b_s2;
 reg [3:0] a_s1, b_s1;

 
 function [3:0] mod_10;
 input [5:0] num;
 begin
 mod_10 = (num >=50) ? 5 : ((num >= 40)? 4 :((num >= 30)? 3 :((num >= 20)? 2 :((num >= 10)? 1 :0))));
 end
 endfunction
 

 always @(posedge clk or posedge reset )
 begin
 if(reset) begin 
 a_h2 <= 2'b00;
 a_h1 <= 4'b0000;
 a_m2 <= 4'b0000;
 a_m1 <= 4'b0000;
 a_s2 <= 4'b0000;
 a_s1 <= 4'b0000;
 tmp_h <= Hpoz2*10 + Hpoz1;
 tmp_m <= Mpoz2*10 + Mpoz1;
 tmp_s <= 0;
 end 
 else begin
 if(LDA) begin 
 a_h2 <= Hpoz2;
 a_h1 <= Hpoz1;
 a_m2 <= Mpoz2;
 a_m1 <= Mpoz1;
 a_s2 <= 4'b0000;
 a_s1 <= 4'b0000;
 end 
 if(LDT) begin 
 tmp_h <= Hpoz2*10 + Hpoz1;
 tmp_m <= Mpoz2*10 + Mpoz1;
 tmp_s <= 0;
 end 
 else begin  
 tmp_s <= tmp_s + 1;
 if(tmp_s >=59) begin 
 tmp_m <= tmp_m + 1;
 tmp_s <= 0;
 if(tmp_m >=59) begin 
 tmp_m <= 0;
 tmp_h <= tmp_h + 1;
 if(tmp_h >= 23) begin 
 tmp_h <= 0;
 end 
 end 
 end

 end 
 end 
 end 
 
 always @(*) begin
 if(tmp_h>=20) begin
 b_h2 = 2;
 end
 else begin
 if(tmp_h >=10) 
 b_h2  = 1;
 else
 b_h2 = 0;
 end
 //Czas jest liczony binarnie w trzech zmiennyc tmp_h, tmp_m, tmp_s, poni¿ej rozbijamy to na wyjœciowy kod BCD
 b_h1 = tmp_h - b_h2*10; 
 b_m2 = mod_10(tmp_m); 
 b_m1 = tmp_m - b_m2*10;
 b_s2 = mod_10(tmp_s);
 b_s1 = tmp_s - b_s2*10; 
 end
 assign OHpoz2 = b_h2; 
 assign OHpoz1 = b_h1; 
 assign OMpoz2 = b_m2; 
 assign OMpoz1 = b_m1;
 assign OSpoz2 = b_s2;
 assign OSpoz1 = b_s1; 

 //Obs³uga alarmu
 always @(posedge clk or posedge reset) begin
 if(reset) 
 Alarm <=0; 
 else begin
 if({a_s2,a_s1,a_m2,a_m1,a_h2,a_h1}=={b_s2,b_s1,b_m2,b_m1,b_h2,b_h1}) //Porównie zegaru (b_) i ustawionewgo alarmu (a_)
 begin 
 if(ALARM_ON) Alarm <= 1; 
 end
 if(STOP_ALARM) Alarm <=0; 
 end
 end
 
endmodule 