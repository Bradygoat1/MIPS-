# MIPS精簡指令集架構電腦的設計與研究

## 1 Introduction
##### 此專案為運用VERILOG HDL在VIVADO開發環境中實現Computer Organization and Design中的5-stage pipeline MIPS處理機，驗證MIPS處理機各指令的功能與定址法，並運用暫停和前饋方式解決多指令運行中造成的危障問題。

## 2 Design

### 2.1 Features

| 功能 |         MIPS CPU      | 
|-------|:--------------------|
| ISA                            | MIPS32 |   右1 |
| Pipelining                     | 5-stage (IF-ID-EXE-MEM-WB) | 
| Instruction Implemented Type   | Arithmetic, Data transfer, Logic, Conditional branch, Unconditional branch | 
| Data forwarding                | Forwarding(EXE-EXE) / Stall+forwarding(EXE-MEM) |  

### 2.2 Specification
##### 此CPU擁有標準的五級管線，並可針對
