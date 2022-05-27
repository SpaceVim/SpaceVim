typedef class a;

// Code based on: https://github.com/vhda/verilog_systemverilog.vim/issues/2
class z;          

    // this is a comment
    // -----------------
    typedef struct {
        real a;
        int b;
        int c;
        real d; } ts;

    ts s[];

    // if there are
    // more comments
    typedef struct {
        real a;
        int b;
        int c;
        real d;
    } ts2;

    ts2 t[];

    int unsigned cnt=0;

    function new();
        super.new();
    endfunction;

    virtual interface my_itf itf;

    // Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/4
    task run_phase(uvm_phase phase);

        assert(my_seq.randomize());
        my_seq.start(low_sequencer_h);

        assert(my_seq.randomize() with {Nr==6;});
        my_seq.start(low_sequencer_h);

        assert(my_seq.randomize() with
            {Nr==6; Time==8;});
        my_seq.start(low_sequencer_h);

        assert(
            my_seq.randomize() with
            {Nr==6; Time==8;}
        );
        my_seq.start(low_sequencer_h);

        // Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/5
        fork
            begin : isolating_thread
                do_something();
            end : isolating_thread
        join
        // End of copied code

        // Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/15
        assert(out>0) else $warning("xxx");
        $display("Hi");

        assert(out>0)
        else $warning("xxx");
        $display("Hi");

        assert(out>0) else $warning("xxx");
        $display("Hi");
        $display("Hi");
        // End of copied code

        assert(out>0)
        else
            $warning("xxx");
        $display("Hi");

        if (1 > 0) $display("1 > 0");
        else $display("1 < 0");
        $display();

    endtask
    // End of copied code

    // Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/7
    task run_phase2(uvm_phase phase);
        assert(out>0) else $warning("xxx");
        assert(out>0) else $warning("xxx");
        foreach(out[i]) begin
            out[i]=new;
        end
    endtask
    // End of copied code

    /*
    *
    *
    *
    */

    // Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/12
    task my_seq::body();
        `uvm_info({get_type_name(),"::body"}, "something" ,UVM_HIGH)
        req = my_seq_item_REQ::type_id::create("req");
    endtask
    // End of copied code

    // Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/14
    pure virtual function void a(input int unsigned N, ref t Data);
    pure virtual function void b(input int unsigned N, ref t Data);
    pure virtual function void c(input int unsigned N, ref t Data);
    // End of copied code

    // Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/17
    function void sink_driver::build_phase(uvm_phase phase);
        if (!uvm_config_db #(sink_agent_config)::get(this, "", "sink_agent_config", m_cfg) )
            `uvm_fatal("CONFIG_LOAD", "Cannot get() configuration sink_agent_config from uvm_config_db. Have you set() it?")
        // OK to do this herE>
        foreach(rand_bool_gen[ch]) begin
            rand_bool_gen[ch]=new();
        end
    endfunction
    // End of copied code

    // Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/41
    `uvm_info("TAG", "message", UVM_MEDIUM)

    if (condition)
        `uvm_info("TAG", "message1", UVM_MEDIUM)
    else
        `uvm_info("TAG", "message2", UVM_NONE)
    // End of copied code

    // Other tests
    task fork_test;
        fork
            do_something1();
            do_something2();
        join_none // {}
        do_something3();
    endtask

    task while_one_line;
        while (1)
            do_something();

        (* full_case=1 *)
        (* parallel_case=1 *)
        case (a)
        endcase

        (* full_case,
            parallel_case=1 *)
        case (a)
        endcase

    endtask

    function less_or_equal;
        if (a <= b)
            less_or_equal = a;
    endfunction

    task while_block;
        while (1)
        begin
            do_something();
        end
    endtask

    task while_block2;
        while (1) begin
            do_something();
        end
    endtask

    virtual task virtual_task;
        while (1) begin
            do_something();
        end
    endtask

    virtual function virtual_function;
        while (1) begin
            do_something();
        end

        do
            do_something();
        while (1);

        do begin
            do_something();
        end while (1);

    endfunction

    //function old_style_function_with_var(
    //    input a
    //);
    //reg test;    
    //begin
    //    do_something1();
    //    do_something2();
    //    begin
    //        do_something3();
    //    end
    //end
    //endfunction

    //function old_style_function_without_var(
    //    input a
    //);
    //begin
    //    do_something1();
    //    do_something2();
    //    begin
    //        do_something3();
    //    end
    //end
    //endfunction

    //function old_style_function_one_line_with_var(input a);
    //    reg x;
    //begin
    //    do_something1();
    //    do_something2();
    //    begin
    //        do_something3();
    //    end
    //end
    //endfunction

    //function old_style_function_one_line_without_var(input a);
    //begin
    //    do_something1();
    //    do_something2();
    //    begin
    //        do_something3();
    //    end
    //end
    //endfunction

    function void hello();
        foreach (element[i])    
            if (hi)
                if (hi) /* comment */ begin /* comment */
                    if (hi) begin     
                        foreach (element[i])
                            if (condition0)
                                if (condition1) begin
                                    var0 <= 0;
                                end
                                else begin
                                    if (1) begin
                                        var1 <= 1;
                                        something();
                                        if (1)
                                            if (1) begin
                                                something();
                                            end
                                            else
                                                if (1)
                                                    if (1) begin
                                                        if (1)
                                                            something();
                                                        else begin
                                                            something();
                                                        end
                                                    end
                                                    else if (1)
                                                        something();
                                                    else
                                                        something();

                                        if (1)
                                            something();

                                        if (1) begin
                                            something();
                                        end else
                                            something();

                                        if (1) begin
                                            something();
                                        end else
                                            something();

                                        if (1)
                                            // Nested case
                                            case(value)
                                                0,
                                                1:
                                                    case(value) inside
                                                        [0:20]:;
                                                        21: something();
                                                        22:;
                                                        default: something();
                                                    endcase
                                                2:;
                                                3:;
                                            endcase

                                        if (1)
                                            something();

                                        /* end */

                                        something();
                                        /* end */
                                        something();
                                    end
                                end
                        deindent_x2_please();
                        /* end */
                        dont_deindent_please();
                    end
                    deindent_please();
                end
        deindent_please();
        dont_deindent_please();
    endfunction : hello

    function void hello();
        if (1)
            fork
                something();
                something();
                begin
                    something();
                end
                begin
                    fork
                        if (1) // begin
                            if (1)
                                if (1) begin // comment
                                    something();
                                    if (1) begin
                                    end
                                    something();
                                end
                        something();
                    join
                    if (1)
                        do
                            something();
                        while(1);
                    else
                        do
                            something();
                        while (1) ;
                    something();
                end
                if (1)
                    foreach (objects[i])
                        if (1)
                            if (1) begin
                                something();
                                fork begin
                                    something();
                                end join
                            end
                something();
            join_none

        // Code from: // https://github.com/vhda/verilog_systemverilog.vim/issues/158
        fork
            p1: begin
                myvar=1'b1;
                `info("some message with the word join");
            end
            p2: begin
                myvar2=1'b1;
            end
        join
        // End of copied code
    endfunction : hello

    local static function void hello();
        const bit variable1 =
            func_call(object_t) && structue_t.field_t.source != ENUM_VALUE &&
            object_t.field_t && variable0;

        const bit variable1 =
            func_call(object_t) && structue_t.field_t.source != ENUM_VALUE
            && object_t.field_t && variable0;

        const bit variable2 =
            object_t.field_t && object_t.field_t.source == ENUM_VALUE;

        bit variable3;

        // Multi-line if with no begin
        if (variable && variable && variable &&
            variable)
            indent();

        de_indent();

        // Multi-line if with begin with a line starting with &&
        if (variable && variable && variable
            && variable
            && variable) begin
                indent();
                stay();
            end

        de_indent();

        variable = variable
                   || variable || variable;

        variable = variable ||
                   variable || variable;

        variable = (variable == CONSTANT) &
                   variable &
                   variable;

        wire var0 = a &
                    b;

        wire [1:0] var1 = a &
                          b;

        var2[0] = a &
                  b;

        {var0, var1} = a &
                       b;

        some_struct.field1 = a &
                             b;

        some_type #(params) some_object = cond0 ? a :
                                          cond1 ? b : c;

        if (1) begin
            if (1
                && 1)
                something();
        end

    endfunction

endclass

class a;
    class nested;
        import "DPI-C" function void c_print();
        int b;
    endclass
endclass

clocking ck1 @(posedge clk);
    default input #1step output negedge;
    input a;
    output y;
endclocking

// TODO: Unsupported
// class a;
//     typedef class a;
// endclass

// Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/14
virtual class base;

    extern function void x(input int unsigned N, ref t Data);
    extern function void y(input int unsigned N, ref t Data);

    pure virtual function void a(input int unsigned N, ref t Data);
    pure virtual function void b(input int unsigned N, ref t Data);
    pure virtual function void c(input int unsigned N, ref t Data);

endclass;
// End of copied code

// Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/49
module MyModule #(
    parameter A = 1,
    parameter B = 2
)(
    input I,
    output O
);


wire Val_IP  = !In_Pkt_S_Bus_enf ||
               ((Pls_Don || ResVal) && (Pls_Res || ResFnd));

wire Val_IP  =
    !In_Pkt_S_Bus_enf || // A, B, C
    ((Pls_Don || ResVal) && (Pls_Res || ResFnd));

wire Val_IP  = !In_Pkt_S_Bus_enf ?
               ((Pls_Don || ResVal) && (Pls_Res == ResFnd)) :
               ((Pls_Don || ResVal) && (Pls_Res || ResFnd));

MyModule #(
    .A (1),
    .B (2)
) Module_1 (
    .I (wire1),
    .O (wire2)
);

or or_0();

endmodule
// End of copied code

// Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/51
case (Signal)
    2'd0: begin Result <= 0; end
    2'd1: begin Result <= 1; end
    2'd2: begin Result <= 2; end
    default: begin Result <= 0; end
endcase
// End of copied code

interface class base;

    pure virtual function void a(input int unsigned N, ref t Data);
    pure virtual function void b(input int unsigned N, ref t Data);
    pure virtual function void c(input int unsigned N, ref t Data);

endclass;

module m #(1)
(
    portA,
    portB
);

// Nested modules (IEEE - 1800-2012, section 23.4)
module a;
endmodule

endmodule

module m (
    portA,
    portB
);

device d0 (
    .port (port[1]),
    .port2(), // comment
    .portA(port[2])
);

// Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/6
device d1 (
    .port (port[1]),
    // .port2(), // comment
    .*
);

`ifdef DO_THIS
    device d1 (
        .port (port[1]),
        /* comment line 1
        * comment line2 */
        .port2(),
        .*
    );
`endif

`ifdef DO_THIS
    device2 d2 (
        .out,
        .a,
        .b(B)/*,
        TODO  .c(C) port not implemented yet */
    );
`endif
// End of copied code

device d1 (
    .port (port[1]),
    // .port1(), comment
    /**/.port2(), // comment
    /*.port3(), */     
    // .port4(), comment
    .portA(port[2])
);

`define VALUE 3

`define VALUE_MULTI_LINE \
    16'hFF

`ifdef V95     
    device d2 ( out, portA, portB );
    device d2 ( out, portA, portB );
    `ifdef V95
        device d2 ( out, portA, portB );
        device d2 ( out, portA, portB );
    `endif    
`elsif V2K
    device d2 ( .out(out), .* );
    device d2 ( out, portA, portB );
    `ifndef SWAP
        device d3 ( .out(out), .* );
        device d2 ( .out(out), .* );
    `else
        device d3 ( .out(out), .portA(portB), .portB(portA) );
        device d2 ( .out(out), .* );
    `endif
`endif
`ifndef SWAP
    device d3 ( .out(out), .* );
    device d2 ( .out(out), .* );
`else
    device d3 ( .out(out), .portA(portB), .portB(portA) );
    device d2 ( .out(out), .* );
`endif

endmodule

class a;
endclass : a

module a import some_pkg::*;
(
    input clk,
    output x
);

always @ (posedge clk)
begin
end

always
    x <= 1;

always
begin
    x <= 1;
    statement();
end

always //
begin
    x <= 1;
    statement();
end

label : always //
    x <= 1;

always @ (posedge clk) //
    x <= 1;

always @ (posedge clk)
    x <= 1;

always_ff // begin
    x <= 1;

always_comb
    x <= 1;

label : always_ff begin
    begin
        x <= 1;
        statement();
    end
end

always_ff @ (posedge clk)
begin
    x <= 1;
    statement();
    foreach (object[i])
        statement();
end

always_ff @ (posedge clk)
begin
    x <= 1;
    statement();
    foreach (object[i])
        statement();
end

always_ff @ (posedge clk)
begin
    x <= 1;
    statement();
    foreach (object[i])
        statement();
end

always_ff @ (posedge clk)
begin
    x <= 1;
    statement();
    foreach (object[i])
        statement();
end

always_ff @ (posedge clk)
begin
    x <= 1;
    statement();
    foreach (object[i])
        statement();
end

always_ff @ (posedge clk)
begin
    x <= 1;
    statement();
    foreach (object[i])
        statement();
end

always_ff @ (posedge clk)
begin
    x <= 1;
    statement();
    foreach (object[i])
        statement();
end

always_ff @ (posedge clk)
begin
    x <= 1;
    statement();
    foreach (object[i])
        statement();
end

// always_ff
// begin
//     x <= 1;
// end

endmodule

if (condition) begin
    something();
end
else
    `macro_call()

always : label
    `macro_call()

begin
    begin
    end // always
    `dont_indent()
    dont_deindent();

    begin
    end // foreach()
    dont_indent();
    dont_deindent();

    begin
    end /* while() */
    dont_indent();
    dont_deindent();
end

class a extends b;

    local static function void hello();

        something();
    endfunction

    constraint l1 {
        y == 1;
    }

    constraint l1
    {
        y == 1;
    }

endclass : a

extern module counter (input clk,enable,reset,
    output logic [3:0] data);

extern module counter2;

class a implements
    b,
    c,
    d;

    function void function_with_multiline_proto(
        object_type object);
        indent();
    endfunction

    function void function_with_multiline_proto(
        object_type object0,
        object_type object1,
        object_type object2,
        object_type object3
    );
        indent();
    endfunction

endclass

covergroup c1_cg (ref bit x);
    option.per_instance = 1;
    type_option.merge_instances = 1;

    x : coverpoint x {
        bins _0 = {1'h0};
        bins _1 = {1'h1};
    }

endgroup

package a;

    class b;
    endclass

    class c;
    endclass

    class d;
    endclass

endpackage

sequence acknowledge
    ##[1:2] Ack;
endsequence

property handshake;
    @(posedge Clock)
    request |-> acknowledge;
endproperty

always
    if(1) begin
    end
    // comment
    else
        {var0, var1} <= 2'b00;

always
    if (0) begin
        var0 <= 1'b0;
    end else if(0) begin
        var0 <= 1'b1;
    end

// comment

virtual class DataTypes_packer#(type T, int L, int W, int I);

    extern static function void unpack(const ref bit [L-1:0] in, ref T out[]);
    extern static function void unpack5(const ref bit [L-1:0] in, ref t5#(W,I) out[], input int n_MSB2ignore=0);

    /*
    // packing functions
    extern static function void pack(const ref T in[], ref bit [L-1:0] out);
    extern static function void pack2(const ref t2#(W,I) in[], ref bit [L-1:0] out);
    */

    // unpack functions:
    extern static function void unpack(const ref bit [L-1:0] in, ref T out[]);
    extern static function void unpack5(const ref bit [L-1:0] in, ref t5#(W,I) out[], input int n_MSB2ignore=0);

endclass

fork
    begin

        for(int i=0;i<5;i++) begin
            automatic int idx=i;
            fork
                begin
                    $display("%fns: %0d start",$realtime/1ns,idx);
                    my_seq[idx].go();
                end
            join_none
        end

        // wait for all forks to end
        wait fork;
        $display("%fns: all done",$realtime/1ns);
    end
join

$display("hi");

assert_value: assert property (@(posedge clk) disable iff (~reset_n)
    var0 |-> var1 == var2
);

`ifdef NOTHING
`endif

wire signal =    
    !var0 && (
        var2
    );

task run_phase(uvm_phase phase);
    int var0 = var1 +
               var2 *
               var3;

    int var0 =   
        var1;

    if (map.first(s))
        do
            $display("%s : %d\n", s, map[s]);
        while (map.next(s));

    label : assert(my_seq.randomize());
    my_seq.start(low_sequencer_h);

    assert(my_seq.randomize() with {Nr==6;});
    my_seq.start(low_sequencer_h);

    label : assert(my_seq.randomize() with
        {Nr==6; Time==8;});
    my_seq.start(low_sequencer_h);

    assert(
        my_seq.randomize() with
    );

    //task
endtask

function void sink_driver::build_phase(uvm_phase phase);

    assert property (prop1)
    else `uvm_fatal("TAG", "Assertion failed.")

    do_something();

    assert property (prop1)
    else
        `uvm_fatal("TAG", "Assertion failed.")

    do_something();

    if (condition)
        something();
    else `uvm_fatal("TAG", "This is invalid.")

    do_something();

    if (condition)
        something();
    else
        `uvm_fatal("TAG", "This is invalid.")

    do_something();
endfunction

// Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/51
case (XfrState)
    One_XFR : XfrState_str = "One";
    Two_XFR : XfrState_str = "Two";
    End_XFR : XfrState_str = "End";
    default : XfrState_str = "N/A";
endcase
// End of copied code

interface rx_if;
    logic        trans;
    logic [31:0] data ;
    logic [31:0] addr ;
endinterface

generate
    for (int i = 0; i < 9; ++i) begin : gen_loop
        dut u_dut(.in(i));
    end
endgenerate

program u_prg;
    logic clk;
endprogram

// Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/71
wire a = c <= d &
         e = f;
// End of copied code

// Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/72
function bit return_something();
    return a &     
           b |
           c;
endfunction
// End of copied code

// Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/80
/*
* function text
* text
*/

// Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/51
module dut_wrapper (
    interface source_IF,
    interface sink_IF,
    interface ctrl_IF
);

endmodule
// End of copied code

// Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/81
cover property (
    a &&
    b &&
    c
);
// End of copied code

// Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/167
co__ack_and_req : cover sequence (
    req && ack
);
// End of copied code

// Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/84
assign out = cond0 ? a :
             cond1 ? b :
                     c ;
// End of copied code

// Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/85
assert_label: assert property (
    precondition |-> a &&
                     b &&
                     c
);
assert_label: assert property (
    precondition |=> a &&
                     b &&
                     c
);
// End of copied code

// Code from: // https://github.com/vhda/verilog_systemverilog.vim/issues/113
assign a = b <= c &&
           d <= e &&
           f <= g &&
           h <= i;
// End of copied code

// Code from: // https://github.com/vhda/verilog_systemverilog.vim/issues/129
if (cond) begin do_something; end
do_something_else;

// Code from: // https://github.com/vhda/verilog_systemverilog.vim/issues/120
package automatic regmodel_dpi_pkg;
    export "DPI-SC" task check_reg;
    task check_reg(string mystring, output bit [63:0] o1);
    endtask
endpackage
// End of copied code

// vi: set expandtab softtabstop=4 shiftwidth=4:
