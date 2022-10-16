# MIPS精簡指令集架構電腦的設計與研究

## 1 Introduction
##### 此專案為運用VERILOG HDL在VIVADO開發環境中實現Computer Organization and Design中的5-stage pipeline MIPS處理機，驗證MIPS處理機各指令的功能與定址法，並運用暫停和前饋方式解決多指令運行中造成的危障問題。

## 2 Design

### 2.1 Features

| 功能 |         MIPS CPU      | 
|-------|:--------------------|
| ISA                            | MIPS32 |   
| Pipelining                     | 5-stage (IF-ID-EXE-MEM-WB) | 
| Instruction Implemented Type   | Arithmetic, Data transfer, Logic, Conditional branch, Unconditional branch | 
| Data forwarding                | Forwarding / Stall+forwarding |  

### 2.2 Specification
##### 此CPU擁有標準的五級管線，其運行的Datapath and Control如圖1所示，但在多指令運行時，因無管線化緣故，其在多指令時，並可針對RAW此種資料危障進行前一指令運算結果前饋給欲取用此運算結果的指令，本專案使用EXE-ID與MEM-ID的前饋方法，詳細管線前饋路徑圖如圖2所示

![MIPS單週期](https://user-images.githubusercontent.com/66453841/196047606-966c2cf3-fd28-40ad-bea7-c66723249e25.jpg)

|:-----:|
| 圖1 Single Cyle MIPS CPU Datapath and Control |

![MIPS多週期](https://user-images.githubusercontent.com/66453841/196046653-52257199-35a8-434a-98be-354b8b94e279.jpg)

|:-----:|
| 圖2 Overview of CPU Design |

### 2.3 Comparison to the single cycle MIPS CPU
