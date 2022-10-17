# MIPS精簡指令集架構電腦的設計與研究

## 1 介紹
##### 此專案為運用VERILOG HDL在VIVADO開發環境中實現Computer Organization and Design中的5-stage pipeline MIPS處理機，驗證MIPS處理機各指令的功能與定址法，並運用暫停和前饋方式解決多指令運行中資料相依和分支預測造成的危障問題。
##### 以下介紹MIPS處理機的功能，設計時運用到的各指令格式與控制信號，以及此精簡指令及架構處理機使用到的硬體結構和關於MIPS編譯環境的建立。

## 2 設計

### 2.1 功能

| 功能 |         MIPS CPU      | 
|-------|:--------------------|
| ISA                            | MIPS32 |   
| Pipelining                     | 5-stage (IF-ID-EXE-MEM-WB) | 
| Instruction Implemented Type   | Arithmetic, Data transfer, Logic, Conditional branch, Unconditional branch | 
| Data forwarding                | Forwarding / Stall+forwarding |  

### 2.2 MIPS指令格式與類別
#####                                              
                                                    表1 MIPS指令格式
![MIPS指令格式](https://user-images.githubusercontent.com/66453841/196083067-147c56e3-6bf8-4ea4-9ddc-be272cb9191e.jpg)
#####                                              
                                                   表2 常見的MIPS指令
![常見的mips指令](https://user-images.githubusercontent.com/66453841/196115502-82770165-31d3-4e8a-8bac-c77b52770951.jpg)

### 2.3 MIPS五種定址法
#### 2.3.1 暫存器定址法
##### 暫存器定址法:運算源均是暫存器。
|  Op  |  rs  |  rt  |  rd  | shamt | funct |
|:----:|:----:|:----:|:----:|:-----:|:-----:|
| 6bit | 5bit | 5bit | 5bit | 5bit  | 6bit  |

Ex:
##### A. add $s1, $s2, $s3
|  Op  |  rs  |  rt  |  rd  | shamt | funct |
|:----:|:----:|:----:|:----:|:-----:|:-----:|
|   0  |  18  |  19  |  17  |   0   |   32  |

##### B. sub $s1, $s2, $s3
|  Op  |  rs  |  rt  |  rd  | shamt | funct |
|:----:|:----:|:----:|:----:|:-----:|:-----:|
|   0  |  18  |  19  |  17  |   0   |   34  |

##### C. sll $t2, $s0, $8
|  Op  |  rs  |  rt  |  rd  | shamt | funct |
|:----:|:----:|:----:|:----:|:-----:|:-----:|
|  0   |   0  |  16  |  10  |   8   |   0   |
 
#### 2.3.2 基底或位移定址法
##### 基底或位移定址法:運算源存放在記憶體中，其位址為暫存器與指令中常數的和。

|  Op  |  rs  |  rt  |  address  |
|:----:|:----:|:----:|:---------:|
| 6bit | 5bit | 5bit |   16bit   |

![基底或位移定址法](https://user-images.githubusercontent.com/66453841/196184146-643e621c-dcbc-4213-8bdb-2c4e90777264.jpg)


Ex:
##### A.lw $s1, 100($s2)
|  Op  |  rs  |  rt  |  address  |
|:----:|:----:|:----:|:---------:|
|  35  |  18  |  17  |    100    |

##### B. sw $s1, 100($s2)
|  Op  |  rs  |  rt  |  address  |
|:----:|:----:|:----:|:---------:|
|  43  |  18  |  17  |    100    |

#### 2.3.3 立即定址法
##### 立即定址法:運算源為常數，存在指令的內部。

|  Op  |  rs  |  rt  |  immediate  | 
|:----:|:----:|:----:|:-----------:|
| 6bit | 5bit | 5bit |    16bit    |

Ex:
##### addi $sp, $sp, 4
|  Op  |  rs  |  rt  | immediate |
|:----:|:----:|:----:|:---------:|
|  8   |  29  |  29  |     4     |

#### 2.3.4 PC相對定址法
##### PC相對定址法:位址是PC與指令中常數的和。

|  Op  |  rs  |  rt  |  address  |
|:----:|:----:|:----:|:---------:|
| 6bit | 5bit | 5bit |   16bit   |

![PC相對定址法](https://user-images.githubusercontent.com/66453841/196185111-d8683af9-767b-485c-b3db-c408565b1bb5.jpg)

Ex:
##### beq $s1, $s2, 25 #if($s1 == $s2) go to PC+4+100
|  Op  |  rs  |  rt  |  address  |
|:----:|:----:|:----:|:---------:|
|  4   |  17  |  18  |     25    |

#### 2.3.5 虛擬直接定址法
##### 虛擬直接定址法:跳躍位址是指令的較低26位源與PC較高位元合併。

|  Op  |    address  |
|:----:|:-----------:|
| 6bit |    26bit    |

![虛擬直接定址法](https://user-images.githubusercontent.com/66453841/196186649-f003d96a-b18b-4771-9cd6-8443a10d27e3.jpg)

Ex:
##### j 2500 #go to location 10000
|  Op  |    address  |
|:----:|:-----------:|
|  4   |     2500    |

### 2.4 MIPS指令Control Signal
#####
                                                  表3 常見指令的控制信號
| Instruction | RegDst | ALUSrc | MemtoReg | RegWrite | MemRead | MemWrite | Branch | ALUOp1 | ALUOp0 | 
|:-----------:|:-------|:-------|:---------|:---------|:--------|:---------|:-------|:-------|:-------|
|   R-Type    |    1   |   0    |     0    |     1    |    0    |     0    |    0   |   1    |    0   | 
|     lw      |    0   |   1    |     1    |     1    |    1    |     0    |    0   |   0    |    0   | 
|     sw      |    X   |   1    |     X    |     0    |    0    |     1    |    0   |   0    |    0   | 
|     beq     |    X   |   0    |     X    |     0    |    0    |     0    |    1   |   0    |    1   | 

### 2.5 MIPS資料路徑與管線化
##### 此CPU擁有標準的五級管線，其運行的Datapath and Control如圖1所示，但在多指令運行時，因無管線化緣故，使在多指令運行時效率不佳，故須修改電路使其達到管線化，各Stage間新增Pipeline ，在理想運行狀態時，可同時重疊執行五個指令，使CPU在多個指令運行時效率可以提升，並運用Hazard Detection Unit抓取指令類別與其使用的暫存器類型來偵測危障類型來對症下藥，更有效的解決管線中的資料(load-use data hazard)、控制危障問題，具有危障偵測單元與前饋單元的管線路徑圖如圖2所示。
##### -

![MIPS單週期](https://user-images.githubusercontent.com/66453841/196047606-966c2cf3-fd28-40ad-bea7-c66723249e25.jpg)

                                             圖1 Single Cyle MIPS CPU Datapath and Control     


![MIPS多週期](https://user-images.githubusercontent.com/66453841/196046653-52257199-35a8-434a-98be-354b8b94e279.jpg)

                                                        圖2 Overview of CPU Design

## 3 MIPS編譯環境的建立
### 3.1 MIPS GNU Toolchain
##### 為了使MIPS處理機與MIPS32指令級架構兼容，故須在Ubuntu GNU/LINUX作業系統的環境下安裝使用GNU開發工具鏈(圖3)，使MIPS能實現從高階語言透過compiler、assembler、linker來得到binary文件也就是指令對應的二進制32bit指令格式，最後進行格式轉換，得到inst_rom.data文件格式，來提供給MIPS的inst_rom，進而讓處理機進行指令提取、解碼等後續階段運算與儲存。

### 3.2 Makefile建立
##### 為使MIPS在實現高階語言編譯、組譯、鏈接到binary乃至到轉換為data文件格式的過程中能更方便快速，讓使用者只需輸入一條指令即可完成上述步驟，這需要使用Makefile來進行所有過程的自動化。
                                           圖3 於Ubuntu GNU/LINUX作業系統環境架設GNU自動化工具鏈
![GNU](https://user-images.githubusercontent.com/66453841/196103223-2a5acf47-4b57-4f88-9c16-afe0132703ae.jpg)

## 4 MIPS於Xilinx VIVADO原生模擬系統
### 4.1 運用Xilinx VIVADO進行多指令運算，透過圖4所示的WAVEFORM，觀察與驗證指令運行結果是否符合預期，驗證RTL Code在設計的過程是否正確。
#####
                                           圖4 運用Xilinx VIVADO原生模擬系統進行指令於管線運行的觀察與驗證
![Waveform simulation](https://user-images.githubusercontent.com/66453841/196104979-fd1fa839-80ad-44ea-95ec-d6f7cc2d8628.png)

## 5 Reference
### [1] DAVID A. PATTERSON, JOHN L. HENNESSY, et al. COMPUTER ORGANIZATION AND DESIGN, FIFTH EDITION
### [2] 雷思磊 自己動手寫CPU, 电子工业出版社
### [3] 夏宇聞 VERILOG数字系统设计教程, 北京航空航天大學出版社 
