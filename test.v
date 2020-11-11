`timescale 1ns / 1ps

module test;

 wire Alarm;
 wire [1:0] OHpoz2;
 wire [3:0] OHpoz1;
 wire [3:0] OMpoz2;
 wire [3:0] OMpoz1;
 wire [3:0] OSpoz2;
 wire [3:0] OSpoz1;

 reg reset;
 reg clk;
 reg [1:0] Hpoz2;
 reg [3:0] Hpoz1;
 reg [3:0] Mpoz2;
 reg [3:0] Mpoz1;
 reg LDT;
 reg LDA;
 reg STOP_ALARM;
 reg ALARM_ON;


 aclock uut (
 .reset(reset), 
 .clk(clk), 
 .Hpoz2(Hpoz2), 
 .Hpoz1(Hpoz1), 
 .Mpoz2(Mpoz2), 
 .Mpoz1(Mpoz1), 
 .LDT(LDT), 
 .LDA(LDA), 
 .STOP_ALARM(STOP_ALARM), 
 .ALARM_ON(ALARM_ON), 
 .Alarm(Alarm), 
 .OHpoz2(OHpoz2), 
 .OHpoz1(OHpoz1), 
 .OMpoz2(OMpoz2), 
 .OMpoz1(OMpoz1), 
 .OSpoz2(OSpoz2), 
 .OSpoz1(OSpoz1)
 );
 
 
 initial begin 
  clk = 0;
  forever #1 clk = ~clk;
 end
 initial begin
 

 reset = 1;
 //Ustawienie czasu staru zegara lub alarmu
 Hpoz2 = 2;
 Hpoz1 = 3;
 Mpoz2 = 5;
 Mpoz1 = 9;
 LDT = 0; //£adowanie czasu startowego
 LDA = 0; 
 STOP_ALARM = 0; 
 ALARM_ON = 0; 
 #100 
 reset = 0;
 Hpoz2 = 0;
 Hpoz1 = 0;
 Mpoz2 = 0;
 Mpoz1 = 5;
 LDT = 0;
 LDA = 1; //£adowanie ustawieñ Alarmu
 STOP_ALARM = 0;
 wait(Alarm); 
 #1000
 STOP_ALARM = 1; 
 end
      
endmodule