//���������w�q
`define RstEnable           1'b1         //�_��H������
`define RstDisable          1'b0         //�_��H���L��
`define ZeroWord            32'h00000000 //32bit���ƭ�0
`define WriteEnable         1'b1         //�ϯ�g
`define WriteDisable        1'b0         //�T��g
`define ReadEnable          1'b1         //�ϯ�Ū
`define ReadDisable         1'b0         //�T��Ū
`define AluOpBus            7:0          //ID stage����X aluop_o���e��
`define AluSelBus           2:0          //ID stage����X alusel_o���e��
`define InstValid           1'b0         //���O����
`define InstInvalid         1'b1         //���O�L��
`define True_v              1'b1         //�޿�"�u"
`define False_v             1'b0         //�޿�"��"
`define ChipEnable          1'b1         //�����ϯ�
`define ChipDisable         1'b0         //�����T��

//�P������O���������w�q
`define EXE_AND             6'b100100 //and���O��6bit���O�X
`define EXE_OR              6'b100101 //or���O��6bit���O�X
`define EXE_XOR             6'b100110 //xor���O��6bit���O�X
`define EXE_NOR             6'b100111 //nor���O��6bit���O�X
`define EXE_ANDI            6'b001100 //andi���O��6bit���O�X
`define EXE_ORI             6'b001101 //ori���O��6bit���O�X
`define EXE_XORI            6'b001110 //xori���O��6bit���O�X
`define EXE_LUI             6'b001111 //lui���O��6bit���O�X

`define EXE_SLL             6'b000000 //sll���O��6bit���O�X
`define EXE_SLLV            6'b000100 //sllv���O��6bit���O�X
`define EXE_SRL             6'b000010 //srl���O��6bit���O�X
`define EXE_SRLV            6'b000110 //srlv���O��6bit���O�X
`define EXE_SRA             6'b000011 //sra���O��6bit���O�X
`define EXE_SRAV            6'b000111 //srav���O��6bit���O�X
`define EXE_SYNC            6'b001111 //sync���O��6bit���O�X
`define EXE_PREF            6'b110011 //pref���O��6bit���O�X

`define EXE_NOP             6'b000000 //nop���O��6bit���O�X
`define SSNOP              32'b00000000000000000000000001000000

`define EXE_SPECIAL_INST    6'b000000 //special���O��6bit���O�X
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


//�P���O�s�x��ROM���������w�q
`define InstAddrBus         31:0    //ROM���a�}�`�u�e��
`define InstBus             31:0    //ROM���ƾ��`�u�e��
`define InstMemNum          131071  //ROM����ڤj�p��128KB
`define InstMemNumLog2      17      //ROM��ڨϥΪ��a�}�u�e��

//�P�q�αH�s��Regfile���������w�q
`define RegAddrBus          4:0     //Regfile�Ҷ����a�}�u�e��
`define RegBus              31:0    //Regfile�Ҷ����ƾڽu�e��
`define RegWidth            32      //�q�αH�s�����e��
`define DoubleRegWidth      64      //�⭿���q�αH�s�����e��
`define DoubleRegBus        63:0    //�⭿���q�αH�s�����ƾڽu�e��
`define RegNum              32      //�q�αH�s�����ƶq
`define RegNumLog2          5       //�M�}�q�αH�s���ϥΪ��a�}���
`define NOPRegAddr          5'b00000

