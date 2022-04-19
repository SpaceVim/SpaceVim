//                                                               all
//                                                               |  all,block_nested
//                                                               |  |  all,block_named

function f;                                                   //<1><1><1>
begin                                                         //<2><2><1>
                                                              //<2><2><1>
end                                                           //<2><2><1>
endfunction : f                                               //<1><1><1>

task t;                                                       //<1><1><1>
                                                              //<1><1><1>
begin                                                         //<2><2><1>
    state = something();                                      //<2><2><1>
    begin : block1                                            //<3><3><2>
        state = 2'b00;                                        //<3><3><2>
        if (a <= b) begin                                     //<4><4><2>
            begin : block2                                    //<5><5><3>
            end // block2                                     //<5><5><3>
            state = 2'b11;                                    //<4><4><2>
            begin                                             //<5><5><2>
            end                                               //<5><5><2>
        end                                                   //<4><4><2>
        begin : block3                                        //<4><4><3>
        end // block3                                         //<4><4><3>
        begin                                                 //<4><4><2>
        end                                                   //<4><4><2>
    end // block1                                             //<3><3><2>
end                                                           //<2><2><1>
                                                              //<1><1><1>
endtask : t                                                   //<1><1><1>

/*                                                            //<1><1><1>
*                                                             //<1><1><1>
* function in_comment;                                        //<1><1><1>
*                                                             //<1><1><1>
* endfunction                                                 //<1><1><1>
*                                                             //<1><1><1>
*/                                                            //<1><1><1>

extern                        function    e_func (x, y);      //<0><0><0>
extern              static    function   es_func (x, y);      //<0><0><0>
extern              protected function   ep_func (x, y);      //<0><0><0>
extern              local     function   el_func (x, y);      //<0><0><0>

       pure virtual           function   pv_func (x);         //<0><0><0>
       pure virtual static    function  pvs_func (x);         //<0><0><0>
       pure virtual protected function  pvp_func (x);         //<0><0><0>
       pure virtual local     function  pvl_func (x);         //<0><0><0>

extern      virtual           function   ev_func (x);         //<0><0><0>
extern      virtual static    function  evs_func (x);         //<0><0><0>
extern      virtual protected function  evp_func (x);         //<0><0><0>
extern      virtual local     function  evl_func (x);         //<0><0><0>

extern pure virtual           function  epv_func (x);         //<0><0><0>
extern pure virtual static    function epvs_func (x);         //<0><0><0>
extern pure virtual protected function epvp_func (x);         //<0><0><0>
extern pure virtual local     function epvl_func (x);         //<0><0><0>

extern                        task        e_task (x, y);      //<0><0><0>
extern              static    task       es_task (x, y);      //<0><0><0>
extern              protected task       ep_task (x, y);      //<0><0><0>
extern              local     task       el_task (x, y);      //<0><0><0>

       pure virtual           task       pv_task (x);         //<0><0><0>
       pure virtual static    task      pvs_task (x);         //<0><0><0>
       pure virtual protected task      pvp_task (x);         //<0><0><0>
       pure virtual local     task      pvl_task (x);         //<0><0><0>

extern      virtual           task       ev_task (x, y);      //<0><0><0>
extern      virtual static    task      evs_task (x, y);      //<0><0><0>
extern      virtual protected task      evp_task (x, y);      //<0><0><0>
extern      virtual local     task      evl_task (x, y);      //<0><0><0>

extern pure virtual           task      epv_task (x, y);      //<0><0><0>
extern pure virtual static    task     epvs_task (x, y);      //<0><0><0>
extern pure virtual protected task     epvp_task (x, y);      //<0><0><0>
extern pure virtual local     task     epvl_task (x, y);      //<0><0><0>


/**                                                           //<1><1><1>
* Static function                                             //<1><1><1>
*/                                                            //<1><1><1>
static function f1;                                           //<1><1><1>
endfunction                                                   //<1><1><1>

specify                                                       //<1><1><1>
                                                              //<1><1><1>
endspecify                                                    //<1><1><1>

covergroup cov;                                               //<1><1><1>
                                                              //<1><1><1>
endgroup                                                      //<1><1><1>

property prop;                                                //<1><1><1>
endproperty                                                   //<1><1><1>

sequence                                                      //<1><1><1>
endsequence                                                   //<1><1><1>

// Classes                                                    //<0><0><0>
class class_a;                                                //<1><1><1>
                                                              //<1><1><1>
endclass : class_a                                            //<1><1><1>

class class_b;                                                //<1><1><1>
  class class_b1;                                             //<2><2><2>
                                                              //<2><2><2>
  endclass : class_b1                                         //<2><2><2>
                                                              //<1><1><1>
  class class_b2;                                             //<2><2><2>
                                                              //<2><2><2>
  endclass : class_b2                                         //<2><2><2>
endclass : class_b                                            //<1><1><1>

interface a;                                                  //<1><1><1>
                                                              //<1><1><1>
  interface class b;                                          //<2><2><2>
  endclass : b                                                //<2><2><2>
                                                              //<1><1><1>
  clocking cb @ (posedge Clk);                                //<2><2><2>
  endclocking : cb                                            //<2><2><2>
                                                              //<1><1><1>
endinterface : a                                              //<1><1><1>

typedef interface class my_itf_class;                         //<0><0><0>

`ifdef A                                                      //<1><1><1>
reg test;                                                     //<1><1><1>
                                                              //<1><1><1>
//  `ifdef A_1                                                //<1><1><1>
//                                                            //<1><1><1>
//  `else                                                     //<1><1><1>
//                                                            //<1><1><1>
//  `endif                                                    //<1><1><1>
                                                              //<1><1><1>
`else                                                         //<1><1><1>
                                                              //<1><1><1>
`endif                                                        //<1><1><1>

`ifndef B                                                     //<1><1><1>
                                                              //<1><1><1>
`elsif C                                                      //<1><1><1>
                                                              //<1><1><1>
`elsif D                                                      //<1><1><1>
                                                              //<1><1><1>
`else                                                         //<1><1><1>
                                                              //<1><1><1>
`endif                                                        //<1><1><1>

`ifdef E                                                      //<1><1><1>
                                                              //<1><1><1>
  `ifndef E_1                                                 //<2><2><2>
                                                              //<2><2><2>
  `else                                                       //<2><2><2>
                                                              //<2><2><2>
  `endif                                                      //<2><2><2>
                                                              //<1><1><1>
  `ifndef E_2                                                 //<2><2><2>
                                                              //<2><2><2>
  `elsif E_3                                                  //<2><2><2>
                                                              //<2><2><2>
  `endif                                                      //<2><2><2>
                                                              //<1><1><1>
`endif                                                        //<1><1><1>

`ifdef A                                                      //<1><1><1>
                                                              //<1><1><1>
  `ifdef B                                                    //<2><2><2>
                                                              //<2><2><2>
  `else                                                       //<2><2><2>
                                                              //<2><2><2>
  `endif                                                      //<2><2><2>
                                                              //<1><1><1>
`elsif C                                                      //<1><1><1>
                                                              //<1><1><1>
`else                                                         //<1><1><1>
                                                              //<1><1><1>
`endif                                                        //<1><1><1>


/*                                                            //<1><1><1>
  `ifdef X                                                    //<1><1><1>
                                                              //<1><1><1>
  `else                                                       //<1><1><1>
                                                              //<1><1><1>
  `endif                                                      //<1><1><1>
*/                                                            //<1><1><1>

   module_name #(                                             //<1><1><1>
       .PARAM1 (VALUE1)                                       //<1><1><1>
   )                                                          //<1><1><1>
   instance_name(                                             //<1><1><1>
       .port1 (net1),                                         //<1><1><1>
       .port2 (net2)                                          //<1><1><1>
   );                                                         //<1><1><1>

module_name instance_name(                                    //<1><1><1>
    .port1 (net1),                                            //<1><1><1>
    .port2 (net2)                                             //<1><1><1>
);                                                            //<1><1><1>

module_name #(VALUE1) instance_name (                         //<1><1><1>
    .port1 (net1),                                            //<1><1><1>
    .port2 (net2)                                             //<1><1><1>
);                                                            //<1><1><1>

module_name #(VALUE1) instance_name                           //<1><1><1>
(                                                             //<1><1><1>
    .port1 (net1),                                            //<1><1><1>
    .port2 (net2)                                             //<1><1><1>
);                                                            //<1><1><1>

uvm_blocking_put_port #(trans) out;                           //<0><0><0>

task t_multi_line(                                            //<1><1><1>
  input an_input                                              //<1><1><1>
);                                                            //<1><1><1>
                                                              //<1><1><1>
endtask : t_multi_line                                        //<1><1><1>

  task t_multi_line_indented(                                 //<1><1><1>
    input an_input                                            //<1><1><1>
  );                                                          //<1><1><1>
                                                              //<1><1><1>
  endtask : t_multi_line                                      //<1><1><1>

if (cond1) begin                                              //<1><1><0>
    do1();                                                    //<1><1><0>
end else if (cond2) begin                                     //<1><1><0>
    do2();                                                    //<1><1><0>
    do3();                                                    //<1><1><0>
    do4();                                                    //<1><1><0>
end else begin                                                //<1><1><0>
    do5();                                                    //<1><1><0>
end                                                           //<1><1><0>

if (cond1)                                                    //<0><0><0>
    do1();                                                    //<0><0><0>
else if (cond2) begin                                         //<1><1><0>
    do2();                                                    //<1><1><0>
    begin                                                     //<2><2><0>
    do2_1();                                                  //<2><2><0>
    end                                                       //<2><2><0>
    do3();                                                    //<1><1><0>
    do4();                                                    //<1><1><0>
end else begin                                                //<1><1><0>
    do5();                                                    //<1><1><0>
end                                                           //<1><1><0>

if (cond1) begin : b1                                         //<1><1><1>
    do1();                                                    //<1><1><1>
end else if (cond2) begin : b2                                //<1><1><1>
    do2();                                                    //<1><1><1>
    do3();                                                    //<1><1><1>
    do4();                                                    //<1><1><1>
end else begin : b3                                           //<1><1><1>
    do5();                                                    //<1><1><1>
end                                                           //<1><1><1>

if (cond1)                                                    //<0><0><0>
    do1();                                                    //<0><0><0>
else if (cond2) begin : b1                                    //<1><1><1>
    do2();                                                    //<1><1><1>
    begin:b2                                                  //<2><2><2>
    do2_1();                                                  //<2><2><2>
    end                                                       //<2><2><2>
    do3();                                                    //<1><1><1>
    do4();                                                    //<1><1><1>
end else begin                                                //<1><1><1>
    do5();                                                    //<1><1><0>
end else begin:b3                                             //<1><1><1>
    do5();                                                    //<1><1><1>
end                                                           //<1><1><1>

task something;                                               //<1><1><1>
fork                                                          //<1><1><1>
    begin                                                     //<2><2><1>
        begin                                                 //<3><3><1>
        end                                                   //<3><3><1>
        /*                                                    //<3><3><2>
        begin                                                 //<3><3><2>
        end                                                   //<3><3><2>
        */                                                    //<3><3><2>
    end                                                       //<2><2><1>
join                                                          //<1><1><1>
endtask                                                       //<1><1><1>

// spyglass disable_block SOMETHING                           //<1><1><1>
assign a = b & c;                                             //<1><1><1>
// spyglass enable_block SOMETHING                            //<1><1><1>

// vi: set expandtab softtabstop=4 shiftwidth=4:
