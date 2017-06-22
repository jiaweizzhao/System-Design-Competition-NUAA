module ForwardingUint( //包括转发以及数据相关无法转发时的阻塞判断
	input 	   IDwait,   //若IDwait为1 则ID段阻塞一周期
	input      [172:0] IF_ID_bus_r, //两者是相同的
	input      [172:0] ID_EXE_bus_r,
	input      [156:0] EXE_MEM_bus_r,
	input      [118:0] MEM_WB_bus_r,
	output      [ 63:0] IF_ID_bus_out,
	output      [172:0] ID_EXE_bus_out,
	output      [156:0] EXE_MEM_bus_out,
	output      [118:0] MEM_WB_bus_out
	);