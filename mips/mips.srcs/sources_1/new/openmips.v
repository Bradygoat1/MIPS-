`timescale 1ns / 1ps

module openmips(
    input wire clk,
    input wire rst,
    input wire [`RegBus] rom_data_i,    //�q���O�s�x�����o�����O
    output wire [`RegBus] rom_addr_o,   //��X����O�s�x�����a�}
    output wire rom_ce_o                //�s�x���ϯ�H��
    );
    
//�s��IF/ID�Ҷ��PĶ�X���qID�Ҷ����ܶq
wire[`InstAddrBus] pc;
wire[`InstAddrBus] id_pc_i;
wire[`InstBus] id_inst_i;

//�s��Ķ�X���qID�Ҷ���X�PID/EX�Ҷ�����J�ܶq
wire [`AluOpBus] id_aluop_o;
wire [`AluSelBus] id_alusel_o;
wire [`RegBus] id_reg1_o;
wire [`RegBus] id_reg2_o;
wire id_wreg_o;
wire [`RegAddrBus] id_wd_o;

//�s��ID/EX�Ҷ���X�P���涥�qEX�Ҷ�����J�ܶq
wire [`AluOpBus] ex_aluop_i;
wire [`AluSelBus] ex_alusel_i;
wire [`RegBus] ex_reg1_i;
wire [`RegBus] ex_reg2_i;
wire ex_wreg_i;
wire [`RegAddrBus] ex_wd_i;

//�s�����涥�qEX�Ҷ�����X�PEX/MEM�Ҷ�����J�ܶq
wire ex_wreg_o;
wire [`RegAddrBus] ex_wd_o;
wire [`RegBus] ex_wdata_o;

//�s��EX/MEM�Ҷ�����X�P�X�s���qMEM�Ҷ�����J�ܶq
wire mem_wreg_i;
wire [`RegAddrBus] mem_wd_i;
wire [`RegBus] mem_wdata_i;

//�s��MEM�Ҷ�����X�P�X�s���qMEM/WB�Ҷ�����J�ܶq
wire mem_wreg_o;
wire [`RegAddrBus] mem_wd_o;
wire [`RegBus] mem_wdata_o;

//�s��MEM/WB�Ҷ�����X�P�X�s���qWB���q����J�ܶq
wire wb_wreg_i;
wire [`RegAddrBus] wb_wd_i;
wire [`RegBus] wb_wdata_i;

//�s��ID���qID�Ҷ��y�q�μȦs��Regfile�Ҷ����ܶq
wire reg1_read;
wire reg2_read;
wire [`RegBus] reg1_data;
wire [`RegBus] reg2_data;
wire [`RegAddrBus] reg1_addr;
wire [`RegAddrBus] reg2_addr;

//pc_reg�Ҥ�
pc_reg pc_reg0(
    .clk(clk), .rst(rst), .pc(pc), .ce(rom_ce_o)
);

assign rom_addr_o = pc; //���O�s�x������J�a�}�N�OPC����

//IF/ID�Ҷ��Ҥ�
if_id if_id0 (
    .clk(clk),                  .rst(rst),       
    .if_pc(pc),                 .if_inst(rom_data_i),       
    .id_pc(id_pc_i),            .id_inst(id_inst_i)    
);

//ID stage ID�Ҷ��Ҥ�
id id0(
    .rst(rst),                  .pc_i(id_pc_i),  
    .inst_i(id_inst_i),
    
    //�Ӧ�Regfile�Ҷ�����J
    .reg1_data_i(reg1_data),    .reg2_data_i(reg2_data),
    
    //EX stage ��data forwarding���f
    .ex_wreg_i(ex_wreg_o),      .ex_wdata_i(ex_wdata_o),
    .ex_wd_i(ex_wd_o),
    
    //�X�s(MEM& MEM/WB) stage��data forwarding���f
    .mem_wreg_i(mem_wreg_o),    .mem_wdata_i(mem_wdata_o),
    .mem_wd_i(mem_wd_o),
    
    //�e��Regfile�Ҷ����H��
    .reg1_read_o(reg1_read),    .reg2_read_o(reg2_read),
    .reg1_addr_o(reg1_addr),    .reg2_addr_o(reg2_addr), 
    
    //�e��ID/EX�Ҷ����H��
    .aluop_o(id_aluop_o),       .alusel_o(id_alusel_o),
    .reg1_o(id_reg1_o),         .reg2_o(id_reg2_o),
    .wd_o(id_wd_o),             .wreg_o(id_wreg_o)
);

//�q�μȦs��Regfile�Ҷ��Ҥ�
regfile regfile1(
    .clk(clk),                  .rst(rst),
    .we(wb_wreg_i),             .waddr(wb_wd_i),
    .wdata(wb_wdata_i),         .re1(reg1_read),
    .raddr1(reg1_addr),         .rdata1(reg1_data),
    .re2(reg2_read),            .raddr2(reg2_addr),
    .rdata2(reg2_data)
);

//ID/EX�Ҷ��Ҥ�
id_ex id_ex0(
    .clk(clk),                  .rst(rst),
    
    //�qĶ�X���qID�Ҷ��ǻ��L�Ӫ��H��
    .id_aluop(id_aluop_o),      .id_alusel(id_alusel_o),
    .id_reg1(id_reg1_o),        .id_reg2(id_reg2_o),
    .id_wd(id_wd_o),            .id_wreg(id_wreg_o),
    
    //�ǻ�����涥�qEX�Ҷ����H��
    .ex_aluop(ex_aluop_i),      .ex_alusel(ex_alusel_i),
    .ex_reg1(ex_reg1_i),        .ex_reg2(ex_reg2_i),
    .ex_wd(ex_wd_i),            .ex_wreg(ex_wreg_i)
);

//EX�Ҷ��Ҥ�
ex ex0(
    .rst(rst),
    
    //�qID/EX�Ҷ��ǻ��L�Ӫ��H��
    .aluop_i(ex_aluop_i),       .alusel_i(ex_alusel_i),
    .reg1_i(ex_reg1_i),         .reg2_i(ex_reg2_i),
    .wd_i(ex_wd_i),             .wreg_i(ex_wreg_i),
    
    //��X��EX/MEM�Ҷ����H��
    .wd_o(ex_wd_o),             .wreg_o(ex_wreg_o),
    .wdata_o(ex_wdata_o)
);

//EX/MEM�Ҷ��Ҥ�
ex_mem ex_mem0(
    .clk(clk),                  .rst(rst),
    
    //�Ӧ۰��涥�qEX�Ҷ����H��
    .ex_wd(ex_wd_o),            .ex_wreg(ex_wreg_o),
    .ex_wdata(ex_wdata_o),
    
    //�e��X�s���qMEM�Ҷ����H��
    .mem_wd(mem_wd_i),          .mem_wreg(mem_wreg_i),
    .mem_wdata(mem_wdata_i)
);

//MEM�Ҷ��Ҥ�
mem mem0(
    .rst(rst),
    
    //�Ӧ�EX/MEM�Ҷ����H��
    .wd_i(mem_wd_i),            .wreg_i(mem_wreg_i),
    .wdata_i(mem_wdata_i),
    
    //�e��MEM/WB�Ҷ����H��
    .wd_o(mem_wd_o),            .wreg_o(mem_wreg_o),
    .wdata_o(mem_wdata_o)
);

//MEM/WB�Ҷ��Ҥ�
mem_wb mem_wb0(
    .clk(clk),                  .rst(rst),
    
    //�Ӧ۳X�s���qMEM�Ҷ����H��
    .mem_wd(mem_wd_o),          .mem_wreg(mem_wreg_o),
    .mem_wdata(mem_wdata_o),
    
    //�e��WB���q���H��
    .wb_wd(wb_wd_i),            .wb_wreg(wb_wreg_i),
    .wb_wdata(wb_wdata_i)
);

endmodule
