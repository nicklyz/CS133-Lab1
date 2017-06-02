#*******************************************************************************
#Vendor: Xilinx 
#Associated Filename: Makefile
#Purpose: Makefile exmaple for SDAccel Compilation
#
#*******************************************************************************
#Copyright (C) 2015-2016 XILINX, Inc.
#
#This file contains confidential and proprietary information of Xilinx, Inc. and 
#is protected under U.S. and international copyright and other intellectual 
#property laws.
#
#DISCLAIMER
#This disclaimer is not a license and does not grant any rights to the materials 
#distributed herewith. Except as otherwise provided in a valid license issued to 
#you by Xilinx, and to the maximum extent permitted by applicable law: 
#(1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX 
#HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
#INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR 
#FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether 
#in contract or tort, including negligence, or under any other theory of 
#liability) for any loss or damage of any kind or nature related to, arising under 
#or in connection with these materials, including for any direct, or any indirect, 
#special, incidental, or consequential loss or damage (including loss of data, 
#profits, goodwill, or any type of loss or damage suffered as a result of any 
#action brought by a third party) even if such damage or loss was reasonably 
#foreseeable or Xilinx had been advised of the possibility of the same.
#
#CRITICAL APPLICATIONS
#Xilinx products are not designed or intended to be fail-safe, or for use in any 
#application requiring fail-safe performance, such as life-support or safety 
#devices or systems, Class III medical devices, nuclear facilities, applications 
#related to the deployment of airbags, or any other applications that could lead 
#to death, personal injury, or severe property or environmental damage 
#(individually and collectively, "Critical Applications"). Customer assumes the 
#sole risk and liability of any use of Xilinx products in Critical Applications, 
#subject only to applicable laws and regulations governing limitations on product 
#liability. 
#
#THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT 
#ALL TIMES.
#
#******************************************************************************
ifndef XILINX_SDX
$(error Environment variable XILINX_SDX is required and should point to SDAccel install area)
endif

SDA_FLOW = cpu_emu
HOST_SRCS = cnn.cpp
HOST_EXE_DIR=./
HOST_EXE = cs133_lab5
HOST_CFLAGS = -g -Wall -DFPGA_DEVICE 
HOST_LFLAGS = 

KERNEL_SRCS = kernel.cl
KERNEL_NAME = cnn_kernel
KERNEL_DEFS = 
KERNEL_INCS = 

#set target device for XCLBIN
XDEVICE=xilinx:adm-pcie-7v3:1ddr:3.0
XDEVICE_REPO_PATH=
KEEP_TEMP=1
KERNEL_DEBUG=
XCLBIN_NAME=bin_cnn
HOST_CFLAGS+=-DTARGET_DEVICE=\"${XDEVICE}\"

ifeq (${SDA_FLOW},cpu_emu)
    CLCC_OPT += -t sw_emu
    XCLBIN = ${XCLBIN_NAME}_cpu_emu.xclbin
else ifeq (${SDA_FLOW},hw_emu)
    CLCC_OPT += -t hw_emu
    XCLBIN = ${XCLBIN_NAME}_hw_emu.xclbin
else ifeq (${SDA_FLOW},hw)
    XCLBIN = ${XCLBIN_NAME}_hw.xclbin
    CLCC_OPT += -t hw
endif

CLCC=xocc
hls:
	${CLCC} -c -s -t  hw_emu -o kernel_top.xo --xdevice ${XDEVICE} --report estimate --kernel ${KERNEL_NAME} ${KERNEL_SRCS}

HOST_ARGS = ${XCLBIN}

COMMON_DIR = /usr/local/cs133/Xilinx/SDx/2016.4/examples/common
include ${COMMON_DIR}/common.mk