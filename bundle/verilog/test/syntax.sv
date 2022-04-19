module #(
    parameter TEST1 = $clog(0),
    parameter TEST2 = $clog(1),
    parameter TEST3 = $clog(2)
) mymodule(
    input  wire a,
    input  wire b,
    `ifdef MACRO
    input  wire c,
    `endif
    output wire y
);

    othermodule #(.something (a),
      .somethingelse(b)
    ) inst(.p1(), .p2(), .p3 (),
        .p4(),
        .p5(), .p6(), .p7(),
        .p8 ()
        .p9 (a)
    );

    mymod MOD(.IN1(), .IN2(), .OP(),
    .OUT());

endmodule

`define DEF_WITH_EQ = 1'b0
`define DEF_MULTI_LINE cond(a,b,c) \
    a ? b : c

`ifdef SYSTEM_VERILOG_KEYWORDS
accept_on
alias
always
always_comb
always_ff
always_latch
and
assert
assign
assume
automatic
before
begin
end
bind
bins
binsof
bit
break
buf
bufif0
bufif1
byte
case
casex
casez
cell
chandle
checker
cmos
config
const
constraint
context
continue
cover
coverpoint
cross
deassign
default
defparam
design
disable
dist
do
edge
else
endcase
endchecker
endconfig
endgenerate
endpackage
endprimitive
endprogram
endtable
enum
event
eventually
expect
export "DPI-SC" task exported_task;
extends
extern
final
first_match
for
force
foreach
forever
fork
forkjoin
generate
genvar
global
highz0
highz1
if
iff
ifnone
ignore_bins
illegal_bins
implements
implies
import
incdir
include
initial
inout
input
inside
instance
int
integer
interconnect
intersect
join
join_any
join_none
large
let
liblist
library
local
localparam
logic
longint
macromodule
mailbox
matches
medium
modport
nand
negedge
nettype
new
nexttime
nmos
nor
noshowcancelled
not
notif0
notif1
null
or
output
package
packed
parameter
pmos
posedge
primitive
priority
program
protected
pull0
pull1
pulldown
pullup
pulsestyle_ondetect
pulsestyle_onevent
pure
rand
randc
randcase
randsequence
rcmos
real
realtime
ref
reg
reject_on
release
repeat
restrict
return
rnmos
rpmos
rtran
rtranif0
rtranif1
s_always
s_eventually
s_nexttime
s_until
s_until_with
scalared
semaphore
shortint
shortreal
showcancelled
signed
small
soft
solve
specparam
static
string
strong
strong0
strong1
struct
super
supply0
supply1
sync_accept_on
sync_reject_on
table
tagged
this
throughout
time
timeprecision
timeunit
tran
tranif0
tranif1
tri
tri0
tri1
triand
trior
trireg
type
union
unique
unique0
unsigned
until
until_with
untyped
use
uwire
var
vectored
virtual
void
wait
wait_order
wand
weak
weak0
weak1
while
wildcard
wire
with
within
wor
xnor
xor
// Syntax regions
typedef;
class
endclass
clocking
endclocking
covergroup
endgroup
function
endfunction
interface
endinterface
module
endmodule
property
endproperty
sequence
endsequence
specify
endspecify
task
endtask
`endif
`ifdef COMPLEX_STATEMENTS
typedef class c;
`endif
`ifdef TIME
10ns
100ns
1ps
2_0ps
3_000_000s
1.23ns
1_000.123ns
10_000.123ns
100_000.123ns
1_000_000.123ns
1.2.3ns  // Second to should not be part of number syntax
1step
`endif
`ifdef NUMBERS
4'h0
4'h1
4'h2
4'h3
4'h4
4'h5
4'h6
4'h7
4'h8
4'h9
4'ha
4'hb
4'hc
4'hd
4'he
4'hf
4'hA
4'hB
4'hC
4'hD
4'hE
4'hF
4'hg // Invalid value for hexadecimal number
4'hG // Invalid value for hexadecimal number
3'o0
3'o1
3'o2
3'o3
3'o4
3'o5
3'o6
3'o7
3'o8 // Invalid value for octal number
3'b0_01
3'b001
3'b_01
3'b120 // Invalid value for binary number
'd10000
'd_000_000
'd_x00_000
4'b0?x0
4'b010?
4'b010? ? 4'b????; // Conditional '?' and ';' should not be part of number syntax
`endif
// synopsys

/* synopsys dc_script_begin
*  set_size_only {U1}
*  synopsys dc_script_end
*/

// synopsys dc_script_begin
// set_size_only {U1}
// synopsys dc_script_end

// TODO todo check

/*
* TODO todo check
*/

/*//my comment */

//my /*comment*/

// Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/186
string foo = "bar, baz";
int foo2 = 0;
// End of copied code

// Comment with DEFINE-ML

always@(posedge clk or posedge rst)
begin
  priority if (rst)
    state <= IDLE;
  else
    state <= NS;
end

always @(*) begin : label
  if (a) begin
    y = c, z = a;
  end else begin
    y = d, z = b;
  end
end

assign a = myfunc(this);

// vi: set expandtab softtabstop=4 shiftwidth=4:
