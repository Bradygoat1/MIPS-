# MIPS精簡指令集架構電腦的設計與研究

## 1 Introduction
##### 此專案為運用VERILOG HDL在VIVADO開發環境中實現Computer Organization and Design中的5-stage pipeline MIPS處理機，驗證MIPS處理機各指令的功能與定址法，並運用暫停和前饋方式解決多指令運行中資料相依和分支預測造成的危障問題。

## 2 設計

### 2.1 功能

| 功能 |         MIPS CPU      | 
|-------|:--------------------|
| ISA                            | MIPS32 |   
| Pipelining                     | 5-stage (IF-ID-EXE-MEM-WB) | 
| Instruction Implemented Type   | Arithmetic, Data transfer, Logic, Conditional branch, Unconditional branch | 
| Data forwarding                | Forwarding / Stall+forwarding |  

### 2.2 MIPS指令格式

![MIPS指令格式](https://user-images.githubusercontent.com/66453841/196083067-147c56e3-6bf8-4ea4-9ddc-be272cb9191e.jpg)

### 2.3 各指令opcode

| Instruction | RegDst | ALUSrc | MemtoReg | RegWrite | MemRead | MemWrite | Branch | ALUOp1 | ALUOp0 | 
|:-----------:|:-------|:-------|:---------|:---------|:--------|:---------|:-------|:-------|:-------|
|   R-Type    |    1   |   0    |     0    |     1    |    0    |     0    |    0   |   1    |    0   | 
|     lw      |    0   |   1    |     1    |     1    |    1    |     0    |    0   |   0    |    0   | 
|     sw      |    X   |   1    |     X    |     0    |    0    |     1    |    0   |   0    |    0   | 
|     beq     |    X   |   0    |     X    |     0    |    0    |     0    |    1   |   0    |    1   | 

### 2.4 MIPS資料路徑與管線化
##### 此CPU擁有標準的五級管線，其運行的Datapath and Control如圖1所示，但在多指令運行時，因無管線化緣故，使在多指令運行時效率不佳，故須修改電路使其達到管線化，各Stage間新增Pipeline ，在理想運行狀態時，可同時重疊執行五個指令，使CPU在多個指令運行時效率可以提升，並運用Hazard Detection Unit抓取指令類別與其使用的暫存器類型來偵測危障類型來對症下藥，更有效的解決管線中的資料(load-use data hazard)、控制危障問題，具有危障偵測單元與前饋單元的管線路徑圖如圖2所示。
##### -

![MIPS單週期](https://user-images.githubusercontent.com/66453841/196047606-966c2cf3-fd28-40ad-bea7-c66723249e25.jpg)

                                             圖1 Single Cyle MIPS CPU Datapath and Control     


![MIPS多週期](https://user-images.githubusercontent.com/66453841/196046653-52257199-35a8-434a-98be-354b8b94e279.jpg)

                                                        圖2 Overview of CPU Design

## 3 MIPS編譯環境的建立
### 3.1 MIPS GNU Toolchain
##### 為了使MIPS處理機與MIPS32指令級架構兼容，故須在Ubuntu GNU/LINUX作業系統的環境下安裝使用GNU開發工具鏈，使MIPS能實現從高階語言透過compiler、assembler、linker來得到binary文件也就是指令對應的二進制32bit指令格式，最後進行格式轉換，得到inst_rom.data文件格式，來提供給MIPS的inst_rom，進而讓處理機進行指令提取、解碼等後續階段運算與儲存。

### 3.2 Makefile建立
##### 為使MIPS在實現高階語言編譯、組譯、鏈接到binary乃至到轉換為data文件格式的過程中能更方便快速，讓使用者只需輸入一條指令即可完成上述步驟，這需要使用Makefile來進行所有過程的自動化。

![GNU](https://user-images.githubusercontent.com/66453841/196103223-2a5acf47-4b57-4f88-9c16-afe0132703ae.jpg)

## 4 MIPS於Xilinx VIVADO原生模擬系統
### 4.1 運用Xilinx VIVADO進行多指令時，指令運行結果的觀察與驗證，驗證RTL Code在設計的過程是否正確。
![Waveform simulation](https://user-images.githubusercontent.com/66453841/196104979-fd1fa839-80ad-44ea-95ec-d6f7cc2d8628.png)

## 5 Reference
### [1] DAVID A. PATTERSON, JOHN L. HENNESSY, et al. COMPUTER ORGANIZATION AND DESIGN, FIFTH EDITION
### [2] 雷思磊 自己動手寫CPU, 电子工业出版社
### [3] 夏宇聞 VERILOG数字系统设计教程, 北京航空航天大學出版社 
