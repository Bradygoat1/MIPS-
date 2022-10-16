`timescale 1ns / 1ps

module openmips_min_sopc(
    input wire clk,
    input wire rst

    );
    
wire [`InstAddrBus] inst_addr;
wire [`InstBus] inst;
wire rom_ce;

//例化處理器OPENMIPS
openmips openmips0(
    .clk(clk),                  .rst(rst),
    .rom_addr_o(inst_addr),     .rom_data_i(inst),
    .rom_ce_o(rom_ce)
);

//例化指令存儲器ROM
inst_rom inst_rom0(
    .ce(rom_ce),
    .addr(inst_addr),           
    .inst(inst)
);

endmodule
