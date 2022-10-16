`timescale 1ns / 1ps

module openmips(
    input wire clk,
    input wire rst,
    input wire [`RegBus] rom_data_i,    //從指令存儲器取得的指令
    output wire [`RegBus] rom_addr_o,   //輸出到指令存儲器的地址
    output wire rom_ce_o                //存儲器使能信號
    );
    
//連接IF/ID模塊與譯碼階段ID模塊的變量
wire[`InstAddrBus] pc;
wire[`InstAddrBus] id_pc_i;
wire[`InstBus] id_inst_i;

//連接譯碼階段ID模塊輸出與ID/EX模塊的輸入變量
wire [`AluOpBus] id_aluop_o;
wire [`AluSelBus] id_alusel_o;
wire [`RegBus] id_reg1_o;
wire [`RegBus] id_reg2_o;
wire id_wreg_o;
wire [`RegAddrBus] id_wd_o;

//連接ID/EX模塊輸出與執行階段EX模塊的輸入變量
wire [`AluOpBus] ex_aluop_i;
wire [`AluSelBus] ex_alusel_i;
wire [`RegBus] ex_reg1_i;
wire [`RegBus] ex_reg2_i;
wire ex_wreg_i;
wire [`RegAddrBus] ex_wd_i;

//連接執行階段EX模塊的輸出與EX/MEM模塊的輸入變量
wire ex_wreg_o;
wire [`RegAddrBus] ex_wd_o;
wire [`RegBus] ex_wdata_o;

//連接EX/MEM模塊的輸出與訪存階段MEM模塊的輸入變量
wire mem_wreg_i;
wire [`RegAddrBus] mem_wd_i;
wire [`RegBus] mem_wdata_i;

//連接MEM模塊的輸出與訪存階段MEM/WB模塊的輸入變量
wire mem_wreg_o;
wire [`RegAddrBus] mem_wd_o;
wire [`RegBus] mem_wdata_o;

//連接MEM/WB模塊的輸出與訪存階段WB階段的輸入變量
wire wb_wreg_i;
wire [`RegAddrBus] wb_wd_i;
wire [`RegBus] wb_wdata_i;

//連接ID階段ID模塊語通用暫存器Regfile模塊的變量
wire reg1_read;
wire reg2_read;
wire [`RegBus] reg1_data;
wire [`RegBus] reg2_data;
wire [`RegAddrBus] reg1_addr;
wire [`RegAddrBus] reg2_addr;

//pc_reg例化
pc_reg pc_reg0(
    .clk(clk), .rst(rst), .pc(pc), .ce(rom_ce_o)
);

assign rom_addr_o = pc; //指令存儲器的輸入地址就是PC的值

//IF/ID模塊例化
if_id if_id0 (
    .clk(clk),                  .rst(rst),       
    .if_pc(pc),                 .if_inst(rom_data_i),       
    .id_pc(id_pc_i),            .id_inst(id_inst_i)    
);

//ID stage ID模塊例化
id id0(
    .rst(rst),                  .pc_i(id_pc_i),  
    .inst_i(id_inst_i),
    
    //來自Regfile模塊的輸入
    .reg1_data_i(reg1_data),    .reg2_data_i(reg2_data),
    
    //EX stage 的data forwarding接口
    .ex_wreg_i(ex_wreg_o),      .ex_wdata_i(ex_wdata_o),
    .ex_wd_i(ex_wd_o),
    
    //訪存(MEM& MEM/WB) stage的data forwarding接口
    .mem_wreg_i(mem_wreg_o),    .mem_wdata_i(mem_wdata_o),
    .mem_wd_i(mem_wd_o),
    
    //送到Regfile模塊的信息
    .reg1_read_o(reg1_read),    .reg2_read_o(reg2_read),
    .reg1_addr_o(reg1_addr),    .reg2_addr_o(reg2_addr), 
    
    //送到ID/EX模塊的信息
    .aluop_o(id_aluop_o),       .alusel_o(id_alusel_o),
    .reg1_o(id_reg1_o),         .reg2_o(id_reg2_o),
    .wd_o(id_wd_o),             .wreg_o(id_wreg_o)
);

//通用暫存器Regfile模塊例化
regfile regfile1(
    .clk(clk),                  .rst(rst),
    .we(wb_wreg_i),             .waddr(wb_wd_i),
    .wdata(wb_wdata_i),         .re1(reg1_read),
    .raddr1(reg1_addr),         .rdata1(reg1_data),
    .re2(reg2_read),            .raddr2(reg2_addr),
    .rdata2(reg2_data)
);

//ID/EX模塊例化
id_ex id_ex0(
    .clk(clk),                  .rst(rst),
    
    //從譯碼階段ID模塊傳遞過來的信息
    .id_aluop(id_aluop_o),      .id_alusel(id_alusel_o),
    .id_reg1(id_reg1_o),        .id_reg2(id_reg2_o),
    .id_wd(id_wd_o),            .id_wreg(id_wreg_o),
    
    //傳遞到執行階段EX模塊的信息
    .ex_aluop(ex_aluop_i),      .ex_alusel(ex_alusel_i),
    .ex_reg1(ex_reg1_i),        .ex_reg2(ex_reg2_i),
    .ex_wd(ex_wd_i),            .ex_wreg(ex_wreg_i)
);

//EX模塊例化
ex ex0(
    .rst(rst),
    
    //從ID/EX模塊傳遞過來的信息
    .aluop_i(ex_aluop_i),       .alusel_i(ex_alusel_i),
    .reg1_i(ex_reg1_i),         .reg2_i(ex_reg2_i),
    .wd_i(ex_wd_i),             .wreg_i(ex_wreg_i),
    
    //輸出到EX/MEM模塊的信息
    .wd_o(ex_wd_o),             .wreg_o(ex_wreg_o),
    .wdata_o(ex_wdata_o)
);

//EX/MEM模塊例化
ex_mem ex_mem0(
    .clk(clk),                  .rst(rst),
    
    //來自執行階段EX模塊的信息
    .ex_wd(ex_wd_o),            .ex_wreg(ex_wreg_o),
    .ex_wdata(ex_wdata_o),
    
    //送到訪存階段MEM模塊的信息
    .mem_wd(mem_wd_i),          .mem_wreg(mem_wreg_i),
    .mem_wdata(mem_wdata_i)
);

//MEM模塊例化
mem mem0(
    .rst(rst),
    
    //來自EX/MEM模塊的信息
    .wd_i(mem_wd_i),            .wreg_i(mem_wreg_i),
    .wdata_i(mem_wdata_i),
    
    //送到MEM/WB模塊的信息
    .wd_o(mem_wd_o),            .wreg_o(mem_wreg_o),
    .wdata_o(mem_wdata_o)
);

//MEM/WB模塊例化
mem_wb mem_wb0(
    .clk(clk),                  .rst(rst),
    
    //來自訪存階段MEM模塊的信息
    .mem_wd(mem_wd_o),          .mem_wreg(mem_wreg_o),
    .mem_wdata(mem_wdata_o),
    
    //送到WB階段的信息
    .wb_wd(wb_wd_i),            .wb_wreg(wb_wreg_i),
    .wb_wdata(wb_wdata_i)
);

endmodule
