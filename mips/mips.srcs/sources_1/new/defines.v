//全局的宏定義
`define RstEnable           1'b1         //復位信號有效
`define RstDisable          1'b0         //復位信號無效
`define ZeroWord            32'h00000000 //32bit的數值0
`define WriteEnable         1'b1         //使能寫
`define WriteDisable        1'b0         //禁止寫
`define ReadEnable          1'b1         //使能讀
`define ReadDisable         1'b0         //禁止讀
`define AluOpBus            7:0          //ID stage的輸出 aluop_o的寬度
`define AluSelBus           2:0          //ID stage的輸出 alusel_o的寬度
`define InstValid           1'b0         //指令有效
`define InstInvalid         1'b1         //指令無效
`define True_v              1'b1         //邏輯"真"
`define False_v             1'b0         //邏輯"假"
`define ChipEnable          1'b1         //晶片使能
`define ChipDisable         1'b0         //晶片禁止

//與具體指令有關的宏定義
`define EXE_AND             6'b100100 //and指令的6bit指令碼
`define EXE_OR              6'b100101 //or指令的6bit指令碼
`define EXE_XOR             6'b100110 //xor指令的6bit指令碼
`define EXE_NOR             6'b100111 //nor指令的6bit指令碼
`define EXE_ANDI            6'b001100 //andi指令的6bit指令碼
`define EXE_ORI             6'b001101 //ori指令的6bit指令碼
`define EXE_XORI            6'b001110 //xori指令的6bit指令碼
`define EXE_LUI             6'b001111 //lui指令的6bit指令碼

`define EXE_SLL             6'b000000 //sll指令的6bit指令碼
`define EXE_SLLV            6'b000100 //sllv指令的6bit指令碼
`define EXE_SRL             6'b000010 //srl指令的6bit指令碼
`define EXE_SRLV            6'b000110 //srlv指令的6bit指令碼
`define EXE_SRA             6'b000011 //sra指令的6bit指令碼
`define EXE_SRAV            6'b000111 //srav指令的6bit指令碼
`define EXE_SYNC            6'b001111 //sync指令的6bit指令碼
`define EXE_PREF            6'b110011 //pref指令的6bit指令碼

`define EXE_NOP             6'b000000 //nop指令的6bit指令碼
`define SSNOP              32'b00000000000000000000000001000000

`define EXE_SPECIAL_INST    6'b000000 //special指令的6bit指令碼
`define EXE_REGIMM_INST     6'b000001
`define EXE_SPECIAL2_INST   6'b011100

//AluOp
`define EXE_AND_OP          8'b00100100
`define EXE_OR_OP           8'b00100101
`define EXE_XOR_OP          8'b00100110
`define EXE_NOR_OP          8'b00100111
`define EXE_ANDI_OP         8'b01011001
`define EXE_ORI_OP          8'b01011010
`define EXE_XORI_OP         8'b01011011
`define EXE_LUI_OP          8'b01011100

`define EXE_SLL_OP          8'b01111100 
`define EXE_SLLV_OP         8'b00000100
`define EXE_SRL_OP          8'b00000010
`define EXE_SRLV_OP         8'b00000110
`define EXE_SRA_OP          8'b00000011
`define EXE_SRAV_OP         8'b00000111

`define EXE_NOP_OP          8'b00000000

//AluSel
`define EXE_RES_LOGIC       3'b001
`define EXE_RES_SHIFT       3'b010

`define EXE_RES_NOP         3'b000


//與指令存儲器ROM有關的宏定義
`define InstAddrBus         31:0    //ROM的地址總線寬度
`define InstBus             31:0    //ROM的數據總線寬度
`define InstMemNum          131071  //ROM的實際大小為128KB
`define InstMemNumLog2      17      //ROM實際使用的地址線寬度

//與通用寄存器Regfile有關的宏定義
`define RegAddrBus          4:0     //Regfile模塊的地址線寬度
`define RegBus              31:0    //Regfile模塊的數據線寬度
`define RegWidth            32      //通用寄存器的寬度
`define DoubleRegWidth      64      //兩倍的通用寄存器的寬度
`define DoubleRegBus        63:0    //兩倍的通用寄存器的數據線寬度
`define RegNum              32      //通用寄存器的數量
`define RegNumLog2          5       //尋址通用寄存器使用的地址位數
`define NOPRegAddr          5'b00000

