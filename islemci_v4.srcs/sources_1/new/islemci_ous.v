`timescale 1ns/1ps

`define BELLEK_ADRES    32'h8000_0000
`define VERI_BIT        32
`define ADRES_BIT       32
`define YAZMAC_SAYISI   32
/*Hocam ofice de de yanýnýza gelmiþtim çift always ile çözülmediði için sizin testbanchinizde sýkýntý çýkarýyor 
ama eðer ks ve ds buyruklarýnýn çalýþtýðýný görmek istiyorsanýz arkalarýna rastegele bir buyruk atýp sizin testbanchinizde çalýþtýðýný 
görebilirsizin. Çift alwayse çýkarmaya çalýþtým ama çok vaktimi ayýramadým sýnav tarihleri çok yakýndý kusara bakmayýn*/
 // bellek_yaz('h8000_0028, 32'h00500293); bu buyrukla deneyebilirsiniz.
 // tekte bütün buyruklarý çalýþtýrýp denerseniz çalýþtýðýný göreceksiniz.

module islemci_ous (
//localparam wKS = 32'b0000000_00011_01000_001_00000_1110011;
    input                       clk,
    input                       rst,
    output reg [`ADRES_BIT-1:0]    bellek_adres,
   // output reg ilerle_cmb,
    input   [`VERI_BIT-1:0]     bellek_oku_veri,
    output reg [`VERI_BIT-1:0]     bellek_yaz_veri,
    output  reg                    bellek_yaz
);

localparam GETIR        = 2'd0;
localparam COZYAZMACOKU = 2'd1;
localparam YURUTGERIYAZ = 2'd2;
reg ilerle_cmb;
reg tmp_ilerle;
reg [31:0] simdiki_asama_r=0;
reg [`VERI_BIT-1:0] yazmac_obegi [0:`YAZMAC_SAYISI-1];
reg [`ADRES_BIT-1:0] ps_r;
reg [31:0] BUYRUK;
reg [4:0] rd;
reg [4:0] rd_bf;
reg [4:0] rs;
reg [31:0] length;
reg [31:0] tmp_length;
reg signed[31:0] imm;
reg [20:0] imm_tmp;
reg [11:0] imm_tmp2;
reg [12:0] imm_tmp3;
reg signed[31:0] result;
reg signed[31:0] pc;
reg signed[31:0] kaynak_yazmac1;
reg signed[31:0] kaynak_yazmac2;
reg tmp_ilerle_cmb;

initial begin
yazmac_obegi[0]=0;
/*yazmac_obegi[1]=0;
yazmac_obegi[2]=0;
yazmac_obegi[3]=0;
yazmac_obegi[4]=0;
yazmac_obegi[5]=0;
yazmac_obegi[6]=0;
yazmac_obegi[7]=0;
yazmac_obegi[8]=0;
yazmac_obegi[9]=0;
yazmac_obegi[10]=0;
yazmac_obegi[11]=0;
yazmac_obegi[12]=0;
yazmac_obegi[13]=0;
yazmac_obegi[14]=0;
yazmac_obegi[15]=0;
yazmac_obegi[16]=0;
yazmac_obegi[17]=0;
yazmac_obegi[18]=0;
yazmac_obegi[19]=0;
yazmac_obegi[20]=0;
yazmac_obegi[21]=0;
yazmac_obegi[22]=0;
yazmac_obegi[23]=0;
yazmac_obegi[24]=0;
yazmac_obegi[25]=0;
yazmac_obegi[26]=0;
yazmac_obegi[27]=0;
yazmac_obegi[28]=0;
yazmac_obegi[29]=0;
yazmac_obegi[30]=0;
yazmac_obegi[31]=0;*/






end


always @(posedge clk) begin
    if (rst) begin
        ps_r <= `BELLEK_ADRES;
        simdiki_asama_r <= GETIR;
        bellek_adres <= `BELLEK_ADRES;
    end
    else begin
    if(simdiki_asama_r==0)begin
   // $display("%d", ps_r);
   // $display("%h", BUYRUK);
   // $display("***********************");
    ps_r=ps_r+4;
    BUYRUK=bellek_oku_veri;
   // $display("%h", BUYRUK);
    //simdiki_asama_r=1;
    ilerle_cmb=1;
    length=3;
    tmp_length=0;
    

    end
    if(simdiki_asama_r==1)begin
    ilerle_cmb=1;
      rd=BUYRUK[11:7];
      if(BUYRUK[6:0]==7'b0110111)begin
       imm=0;                             //lui
       imm[31:12]= BUYRUK[31:12];
       result=imm;
       //bellek_adres=ps_r;
      
      end
      if(BUYRUK[6:0]==7'b0010111)begin
        imm=0;
        imm[31:12]=BUYRUK[31:12];
        pc=ps_r-4;                        //aupic
        result=pc+imm;
      end
      if(BUYRUK[6:0]==7'b1101111)begin
        imm_tmp=0;
        imm_tmp[20]=BUYRUK[31];
        imm_tmp[10:1]=BUYRUK[30:21];
        imm_tmp[11]=BUYRUK[20];
        imm_tmp[19:12]=BUYRUK[19:12];    //jal
        imm=imm_tmp;
        result=ps_r;
        pc=ps_r-4;
        pc=pc+imm;
      end
      if(BUYRUK[6:0]==7'b1100111)begin
         kaynak_yazmac1=yazmac_obegi[BUYRUK[19:15]];
         imm_tmp2=BUYRUK[31:20];                     //jalr
         imm=imm_tmp2;
         result=ps_r;
        // pc=ps_r-4;
         pc=kaynak_yazmac1+imm;
           end
      if(BUYRUK[6:0]==7'b1100011)begin
     kaynak_yazmac1=yazmac_obegi[BUYRUK[19:15]];
     kaynak_yazmac2=yazmac_obegi[BUYRUK[24:20]];
     imm_tmp3=0;
     imm_tmp3[12]=BUYRUK[31];
     imm_tmp3[10:5]=BUYRUK[30:25];
     imm_tmp3[4:1]=BUYRUK[11:8];
     imm_tmp3[11]=BUYRUK[7];
     imm=imm_tmp3;
     pc=ps_r;
        if(BUYRUK[14:12]==3'b000)begin
          if(kaynak_yazmac1==kaynak_yazmac2)begin
           pc=pc+imm-4;                                 //beq
          end                         
        end
        if(BUYRUK[14:12]==3'b001)begin
          if(kaynak_yazmac1!=kaynak_yazmac2)begin
           pc=pc+imm-4;                                 //bne
          end
        end
        if(BUYRUK[14:12]==3'b100)begin
          if(kaynak_yazmac1<kaynak_yazmac2)begin
           pc=pc+imm-4;                                //blt
          end
        end
        
    end
    if(BUYRUK[6:0]==7'b0000011)begin
     kaynak_yazmac1=yazmac_obegi[BUYRUK[19:15]]; //lw
     imm_tmp2=BUYRUK[31:20];
     imm=imm_tmp2;
     bellek_adres=kaynak_yazmac1+imm;
     //$display("bellek: %h",bellek_adres);
     end
     if(BUYRUK[6:0]==7'b0100011)begin
     kaynak_yazmac1=yazmac_obegi[BUYRUK[19:15]];
     kaynak_yazmac2=yazmac_obegi[BUYRUK[24:20]];
     imm_tmp2[11:5]=BUYRUK[31:25];
     imm_tmp2[4:0]=BUYRUK[11:7];
     imm=imm_tmp2;
     bellek_adres=kaynak_yazmac1+imm;
     bellek_yaz=1'b1;
     bellek_yaz_veri=kaynak_yazmac2;
                                               //sw
     end
     if(BUYRUK[6:0]==7'b0010011)begin
     kaynak_yazmac1=yazmac_obegi[BUYRUK[19:15]];
     imm_tmp2=BUYRUK[31:20];                      //addi
     imm=imm_tmp2;   
     result=kaynak_yazmac1+imm;  
   //  $display("workt");                                       
     end
     
     if(BUYRUK[6:0]==7'b0110011)begin
     kaynak_yazmac1=yazmac_obegi[BUYRUK[19:15]];
     kaynak_yazmac2=yazmac_obegi[BUYRUK[24:20]];
     if(BUYRUK[14:12]==3'b000)begin
        if(BUYRUK[31:25]==7'b0000000)begin
           result=kaynak_yazmac2+kaynak_yazmac1; //add
        end
        if(BUYRUK[31:25]==7'b0100000)begin
           result=kaynak_yazmac1-kaynak_yazmac2; //sub
        end
     end
     if(BUYRUK[14:12]==3'b110)begin
        result=kaynak_yazmac1|kaynak_yazmac2;  //or
     end
     if(BUYRUK[14:12]==3'b111)begin
         result=kaynak_yazmac1&kaynak_yazmac2; //and
     end
     if(BUYRUK[14:12]==3'b100)begin
        result=kaynak_yazmac1^kaynak_yazmac2; //xor
     end
     end
     if(BUYRUK[6:0]==7'b1110011)begin
     $display("work_yazmaccöz"); 
       rd_bf=rd;
       rs=BUYRUK[19:15];
       length=BUYRUK[24:20]+2;
       tmp_length=2;
        if(BUYRUK[14:12]==3'b010)begin
        bellek_yaz=1;
       // length=length+1;
        end
        // ilerle_cmb<=0; 
             // $display("length: %d",length); 
   //  $display("workt");
       end
 // simdiki_asama_r=2;
// ilerle_cmb=0; 
    end
    if(simdiki_asama_r==2)begin
      // $display("simdiki asama: %d",simdiki_asama_r);  
     if(BUYRUK[6:0]==7'b0110111)begin
       yazmac_obegi[rd]=result; //lui
       bellek_adres=ps_r;
       ilerle_cmb=1;
     end
     if(BUYRUK[6:0]==7'b0010111)begin
       yazmac_obegi[rd]=result;    //aupic
       bellek_adres=ps_r;
       ilerle_cmb=1;
     end
     if(BUYRUK[6:0]==7'b1101111)begin
      yazmac_obegi[rd]=result;
      ps_r=pc;                       //jal
      bellek_adres=ps_r;
      ilerle_cmb=1;
     end
     if(BUYRUK[6:0]==7'b1100111)begin
       yazmac_obegi[rd]=result;
       ps_r=pc;                     //jalr
       bellek_adres=ps_r;
       ilerle_cmb=1;
       end
     if(BUYRUK[6:0]==7'b1100011)begin
       ps_r=pc;
       bellek_adres=ps_r; 
       ilerle_cmb=1;           //beq//bne//blt
     end
     if(BUYRUK[6:0]==7'b0000011)begin
       yazmac_obegi[rd]=bellek_oku_veri; //LW
       bellek_adres=ps_r;
       ilerle_cmb=1;
     end
     if(BUYRUK[6:0]==7'b0100011)begin
       bellek_adres=ps_r;
       bellek_yaz=1'b0;  //SW
       ilerle_cmb=1;
     end
     if(BUYRUK[6:0]==7'b0010011)begin
       yazmac_obegi[rd]=result;
       bellek_adres=ps_r;   //addi
       ilerle_cmb=1;
      end
      if(BUYRUK[6:0]==7'b0110011)begin
        yazmac_obegi[rd]=result;
        bellek_adres=ps_r;
        ilerle_cmb=1;
      end
      if(BUYRUK[6:0]==7'b1110011)begin
    //  $display("workt");
       //  $display("rd1 %d %d,bf_rd %d %d",yazmac_obegi[rd],rd,yazmac_obegi[rd_bf],rd_bf);
      // ilerle_cmb=0;   
        if(BUYRUK[14:12]==3'b001)begin
     //   $display("workt_bas");
          if(tmp_length==2)begin
            ilerle_cmb=0;
            yazmac_obegi[rd]=yazmac_obegi[rs];
           // rs=rs+1;
            rd_bf=rs;
            rs=rs+1;
            rd=rd+1;
            tmp_length=tmp_length+1;
      //      $display("workt-bas");
          end
          else begin
            if(yazmac_obegi[rs]>yazmac_obegi[rd_bf])begin   //new
              yazmac_obegi[rd]=yazmac_obegi[rs];
              rd_bf=rs;
              rd=rd+1;
              rs=rs+1;
              tmp_length=tmp_length+1;
          //    $display("workt_orta");
            end
            else begin
               tmp_length=tmp_length+1;
              rs=rs+1;
       //      $display("workt_son");
            end
          
             end
           if(tmp_length==length-1)begin
              bellek_adres=ps_r;
              ilerle_cmb=1;
           end
        end
        if(BUYRUK[14:12]==3'b010)begin
        //$display("WORK2"); 
        if(tmp_length==2)begin
         ilerle_cmb=0;
            bellek_adres=yazmac_obegi[rd];
          //  bellek_yaz=1'b1;
            bellek_yaz_veri=yazmac_obegi[rs];
           // rs=rs+1;
           // bellek_adres=bellek_adres+4;
           // rd=rd+4;
            tmp_length=tmp_length+1;
            
          /*  $display("rs:%d",rs);
            $display("bellek_adres:%h",bellek_adres);
            $display("bellek_yaz:%d",bellek_yaz);
            $display("rd:%d",rd);
            $display("rd:%d",yazmac_obegi[rd]);*/
           /* $display("rs:%d",rs);
            $display("bellek_adres:%h",bellek_adres);
            $display("bellek_yaz:%d",bellek_yaz);
            $display("WORK_bas"); */
           end
           else begin
           if(tmp_length==length)begin
            // bellek_adres=ps_r;
             ilerle_cmb=1;
             bellek_yaz=0;
             bellek_adres=ps_r;
             $display("WORK_son"); 
          //   $display("rs:%d",rs);
         /*   $display("bellek_adres:%h",bellek_adres);
            $display("bellek_yaz:%d",bellek_yaz);*/
           end
           else begin
           $display("WORK_ort"); 
            rs=rs+1;
            bellek_adres=bellek_adres+4;
           // bellek_yaz=1'b1;
            bellek_yaz_veri=yazmac_obegi[rs];
            tmp_length=tmp_length+1;
           // rs=rs+1;
           // bellek_adres=bellek_adres+4;
         /*  $display("rs:%d",rs);
            $display("bellek_adres:%h",bellek_adres);
            $display("bellek_yaz:%d",bellek_yaz);*/
           // $display("rd:%d",rd);
          //  $display("rd:%d",yazmac_obegi[rd]);
            end
           end
          /* if(tmp_length==length)begin
            // bellek_adres=ps_r;
             ilerle_cmb=1;
             bellek_yaz=0;
             bellek_adres=ps_r;
             $display("WORK_son"); 
          //   $display("rs:%d",rs);
            $display("bellek_adres:%h",bellek_adres);
            $display("bellek_yaz:%d",bellek_yaz);
           end*/
            
        end
      end
  
      
       //simdiki_asama_r=0;
    end
    if(ilerle_cmb)begin
     simdiki_asama_r=(simdiki_asama_r+1)%3;
     end
    end
end

/*assign bellek_adres = ps_r;
assign bellek_yaz_veri = 32'hdead_beef;
assign bellek_yaz = 1'b0;*/

endmodule