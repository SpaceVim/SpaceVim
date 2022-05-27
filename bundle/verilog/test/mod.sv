module mod(
    input  wire     [7:0] in1,
    input  wire           in2,
    output reg            out
);
parameter PARAM1 = 1;
parameter PARAM2 = 2;

function test(
    input a,
    input b,
    output z
);
endfunction

endmodule

class myclass #(
  type BASE = extended_base   ,
  int size = 1
) extends BASE;
    logic value_myclass;
    real rl_variable = 1.0;

    function method(input a, input b);
    endfunction : method

    task atask(input a, output x);
    endtask : atask

endclass : myclass

class extended_base extends base;
    logic value_extended_base;

    function method(input a, input b);
    endfunction : method

    task btask(input a, output x);
    endtask : atask

endclass : extended_base

class base;
    logic value_base;

    task ctask(input x, output z);
    endtask : ctask

endclass : base

// vi: set expandtab softtabstop=4 shiftwidth=4:
