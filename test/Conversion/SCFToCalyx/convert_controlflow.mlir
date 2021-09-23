// RUN: circt-opt %s --lower-scf-to-calyx -split-input-file | FileCheck %s

// CHECK:      module  {
// CHECK-NEXT:   calyx.program "main"  {
// CHECK-NEXT:     calyx.component @main(%in0: i32, %in1: i32, %clk: i1 {clk}, %reset: i1 {reset}, %go: i1 {go}) -> (%out0: i32, %done: i1 {done}) {
// CHECK-NEXT:       %true = hw.constant true
// CHECK-NEXT:       %std_slt_0.left, %std_slt_0.right, %std_slt_0.out = calyx.std_slt "std_slt_0" : i32, i32, i1
// CHECK-NEXT:       %ret_arg0_reg.in, %ret_arg0_reg.write_en, %ret_arg0_reg.clk, %ret_arg0_reg.reset, %ret_arg0_reg.out, %ret_arg0_reg.done = calyx.register "ret_arg0_reg" : i32, i1, i1, i1, i32, i1
// CHECK-NEXT:       %bb3_arg0_reg.in, %bb3_arg0_reg.write_en, %bb3_arg0_reg.clk, %bb3_arg0_reg.reset, %bb3_arg0_reg.out, %bb3_arg0_reg.done = calyx.register "bb3_arg0_reg" : i32, i1, i1, i1, i32, i1
// CHECK-NEXT:       calyx.wires  {
// CHECK-NEXT:         calyx.assign %out0 = %ret_arg0_reg.out : i32
// CHECK-NEXT:         calyx.comb_group @bb0_0  {
// CHECK-NEXT:           calyx.assign %std_slt_0.left = %in0 : i32
// CHECK-NEXT:           calyx.assign %std_slt_0.right = %in1 : i32
// CHECK-NEXT:         }
// CHECK-NEXT:         calyx.group @bb1_to_bb3  {
// CHECK-NEXT:           calyx.assign %bb3_arg0_reg.in = %in0 : i32
// CHECK-NEXT:           calyx.assign %bb3_arg0_reg.write_en = %true : i1
// CHECK-NEXT:           calyx.group_done %bb3_arg0_reg.done : i1
// CHECK-NEXT:         }
// CHECK-NEXT:         calyx.group @bb2_to_bb3  {
// CHECK-NEXT:           calyx.assign %bb3_arg0_reg.in = %in1 : i32
// CHECK-NEXT:           calyx.assign %bb3_arg0_reg.write_en = %true : i1
// CHECK-NEXT:           calyx.group_done %bb3_arg0_reg.done : i1
// CHECK-NEXT:         }
// CHECK-NEXT:         calyx.group @ret_assign_0  {
// CHECK-NEXT:           calyx.assign %ret_arg0_reg.in = %bb3_arg0_reg.out : i32
// CHECK-NEXT:           calyx.assign %ret_arg0_reg.write_en = %true : i1
// CHECK-NEXT:           calyx.group_done %ret_arg0_reg.done : i1
// CHECK-NEXT:         }
// CHECK-NEXT:       }
// CHECK-NEXT:       calyx.control  {
// CHECK-NEXT:         calyx.seq  {
// CHECK-NEXT:           calyx.if %std_slt_0.out with @bb0_0  {
// CHECK-NEXT:             calyx.seq  {
// CHECK-NEXT:               calyx.seq  {
// CHECK-NEXT:               }
// CHECK-NEXT:               calyx.seq  {
// CHECK-NEXT:                 calyx.enable @bb1_to_bb3
// CHECK-NEXT:               }
// CHECK-NEXT:               calyx.enable @ret_assign_0
// CHECK-NEXT:             }
// CHECK-NEXT:           } else  {
// CHECK-NEXT:             calyx.seq  {
// CHECK-NEXT:               calyx.seq  {
// CHECK-NEXT:               }
// CHECK-NEXT:               calyx.seq  {
// CHECK-NEXT:                 calyx.enable @bb2_to_bb3
// CHECK-NEXT:               }
// CHECK-NEXT:               calyx.enable @ret_assign_0
// CHECK-NEXT:             }
// CHECK-NEXT:           }
// CHECK-NEXT:         }
// CHECK-NEXT:       }
// CHECK-NEXT:     }
// CHECK-NEXT:   }
// CHECK-NEXT: }
module {
  func @main(%arg0 : i32, %arg1 : i32) -> i32 {
    %0 = cmpi slt, %arg0, %arg1 : i32
    cond_br %0, ^bb1, ^bb2
  ^bb1:
    br ^bb3(%arg0 : i32)
  ^bb2:
    br ^bb3(%arg1 : i32)
  ^bb3(%1 : i32):
    return %1 : i32
  }
}

// -----

// CHECK:      module  {
// CHECK-NEXT:   calyx.program "main"  {
// CHECK-NEXT:     calyx.component @main(%in0: i32, %in1: i32, %in2: i32, %clk: i1 {clk}, %reset: i1 {reset}, %go: i1 {go}) -> (%out0: i32, %done: i1 {done}) {
// CHECK-NEXT:       %true = hw.constant true
// CHECK-NEXT:       %std_slt_0.left, %std_slt_0.right, %std_slt_0.out = calyx.std_slt "std_slt_0" : i32, i32, i1
// CHECK-NEXT:       %while_0_arg0_reg.in, %while_0_arg0_reg.write_en, %while_0_arg0_reg.clk, %while_0_arg0_reg.reset, %while_0_arg0_reg.out, %while_0_arg0_reg.done = calyx.register "while_0_arg0_reg" : i32, i1, i1, i1, i32, i1
// CHECK-NEXT:       %ret_arg0_reg.in, %ret_arg0_reg.write_en, %ret_arg0_reg.clk, %ret_arg0_reg.reset, %ret_arg0_reg.out, %ret_arg0_reg.done = calyx.register "ret_arg0_reg" : i32, i1, i1, i1, i32, i1
// CHECK-NEXT:       calyx.wires  {
// CHECK-NEXT:         calyx.assign %out0 = %ret_arg0_reg.out : i32
// CHECK-NEXT:         calyx.group @assign_while_0_init  {
// CHECK-NEXT:           calyx.assign %while_0_arg0_reg.in = %in0 : i32
// CHECK-NEXT:           calyx.assign %while_0_arg0_reg.write_en = %true : i1
// CHECK-NEXT:           calyx.group_done %while_0_arg0_reg.done : i1
// CHECK-NEXT:         }
// CHECK-NEXT:         calyx.comb_group @bb0_0  {
// CHECK-NEXT:           calyx.assign %std_slt_0.left = %while_0_arg0_reg.out : i32
// CHECK-NEXT:           calyx.assign %std_slt_0.right = %in1 : i32
// CHECK-NEXT:         }
// CHECK-NEXT:         calyx.group @assign_while_0_latch  {
// CHECK-NEXT:           calyx.assign %while_0_arg0_reg.in = %while_0_arg0_reg.out : i32
// CHECK-NEXT:           calyx.assign %while_0_arg0_reg.write_en = %true : i1
// CHECK-NEXT:           calyx.group_done %while_0_arg0_reg.done : i1
// CHECK-NEXT:         }
// CHECK-NEXT:         calyx.group @ret_assign_0  {
// CHECK-NEXT:           calyx.assign %ret_arg0_reg.in = %while_0_arg0_reg.out : i32
// CHECK-NEXT:           calyx.assign %ret_arg0_reg.write_en = %true : i1
// CHECK-NEXT:           calyx.group_done %ret_arg0_reg.done : i1
// CHECK-NEXT:         }
// CHECK-NEXT:       }
// CHECK-NEXT:       calyx.control  {
// CHECK-NEXT:         calyx.seq  {
// CHECK-NEXT:           calyx.seq  {
// CHECK-NEXT:             calyx.enable @assign_while_0_init
// CHECK-NEXT:             calyx.while %std_slt_0.out with @bb0_0  {
// CHECK-NEXT:               calyx.seq  {
// CHECK-NEXT:                 calyx.enable @assign_while_0_latch
// CHECK-NEXT:               }
// CHECK-NEXT:             }
// CHECK-NEXT:             calyx.enable @ret_assign_0
// CHECK-NEXT:           }
// CHECK-NEXT:         }
// CHECK-NEXT:       }
// CHECK-NEXT:     }
// CHECK-NEXT:   }
// CHECK-NEXT: }
module {
  func @main(%arg0: i32, %arg1: i32, %arg2: i32) -> i32 {
    %cst = constant 0 : i32
    %0 = scf.while (%arg3 = %arg0) : (i32) -> (i32) {
      %1 = cmpi slt, %arg3, %arg1 : i32
      scf.condition(%1) %arg3 : i32
    } do {
    ^bb0(%arg3: i32):  // no predecessors
      scf.yield %arg3 : i32
    }
    return %0 : i32
  }
}

// -----

// module  {
//   calyx.program "main"  {
//     calyx.component @main(%in0: i32, %in1: i32, %in2: i32, %clk: i1 {clk}, %reset: i1 {reset}, %go: i1 {go}) -> (%out0: i32, %done: i1 {done}) {
//       %true = hw.constant true
//       %std_slt_1.left, %std_slt_1.right, %std_slt_1.out = calyx.std_slt "std_slt_1" : i32, i32, i1
//       %std_slt_0.left, %std_slt_0.right, %std_slt_0.out = calyx.std_slt "std_slt_0" : i32, i32, i1
//       %while_0_arg0_reg.in, %while_0_arg0_reg.write_en, %while_0_arg0_reg.clk, %while_0_arg0_reg.reset, %while_0_arg0_reg.out, %while_0_arg0_reg.done = calyx.register "while_0_arg0_reg" : i32, i1, i1, i1, i32, i1
//       %ret_arg0_reg.in, %ret_arg0_reg.write_en, %ret_arg0_reg.clk, %ret_arg0_reg.reset, %ret_arg0_reg.out, %ret_arg0_reg.done = calyx.register "ret_arg0_reg" : i32, i1, i1, i1, i32, i1
//       %bb4_arg0_reg.in, %bb4_arg0_reg.write_en, %bb4_arg0_reg.clk, %bb4_arg0_reg.reset, %bb4_arg0_reg.out, %bb4_arg0_reg.done = calyx.register "bb4_arg0_reg" : i32, i1, i1, i1, i32, i1
//       %bb3_arg0_reg.in, %bb3_arg0_reg.write_en, %bb3_arg0_reg.clk, %bb3_arg0_reg.reset, %bb3_arg0_reg.out, %bb3_arg0_reg.done = calyx.register "bb3_arg0_reg" : i32, i1, i1, i1, i32, i1
//       calyx.wires  {
//         calyx.assign %out0 = %ret_arg0_reg.out : i32
//         calyx.group @assign_while_0_init  {
//           calyx.assign %while_0_arg0_reg.in = %in0 : i32
//           calyx.assign %while_0_arg0_reg.write_en = %true : i1
//           calyx.group_done %while_0_arg0_reg.done : i1
//         }
//         calyx.comb_group @bb0_0  {
//           calyx.assign %std_slt_0.left = %while_0_arg0_reg.out : i32
//           calyx.assign %std_slt_0.right = %in1 : i32
//         }
//         calyx.comb_group @bb0_1  {
//           calyx.assign %std_slt_1.left = %while_0_arg0_reg.out : i32
//           calyx.assign %std_slt_1.right = %in0 : i32
//         }
//         calyx.group @bb1_to_bb3  {
//           calyx.assign %bb3_arg0_reg.in = %in0 : i32
//           calyx.assign %bb3_arg0_reg.write_en = %true : i1
//           calyx.group_done %bb3_arg0_reg.done : i1
//         }
//         calyx.group @bb2_to_bb3  {
//           calyx.assign %bb3_arg0_reg.in = %in1 : i32
//           calyx.assign %bb3_arg0_reg.write_en = %true : i1
//           calyx.group_done %bb3_arg0_reg.done : i1
//         }
//         calyx.group @bb3_to_bb4  {
//           calyx.assign %bb4_arg0_reg.in = %bb3_arg0_reg.out : i32
//           calyx.assign %bb4_arg0_reg.write_en = %true : i1
//           calyx.group_done %bb4_arg0_reg.done : i1
//         }
//         calyx.group @assign_while_0_latch  {
//           calyx.assign %while_0_arg0_reg.in = %bb4_arg0_reg.out : i32
//           calyx.assign %while_0_arg0_reg.write_en = %true : i1
//           calyx.group_done %while_0_arg0_reg.done : i1
//         }
//         calyx.group @ret_assign_0  {
//           calyx.assign %ret_arg0_reg.in = %while_0_arg0_reg.out : i32
//           calyx.assign %ret_arg0_reg.write_en = %true : i1
//           calyx.group_done %ret_arg0_reg.done : i1
//         }
//       }
//       calyx.control  {
//         calyx.seq  {
//           calyx.seq  {
//             calyx.enable @assign_while_0_init
//             calyx.while %std_slt_0.out with @bb0_0  {
//               calyx.seq  {
//                 calyx.if %std_slt_1.out with @bb0_1  {
//                   calyx.seq  {
//                     calyx.seq  {
//                     }
//                     calyx.seq  {
//                       calyx.enable @bb1_to_bb3
//                     }
//                     calyx.seq  {
//                       calyx.enable @bb3_to_bb4
//                     }
//                   }
//                 } else  {
//                   calyx.seq  {
//                     calyx.seq  {
//                     }
//                     calyx.seq  {
//                       calyx.enable @bb2_to_bb3
//                     }
//                     calyx.seq  {
//                       calyx.enable @bb3_to_bb4
//                     }
//                   }
//                 }
//                 calyx.enable @assign_while_0_latch
//               }
//             }
//             calyx.enable @ret_assign_0
//           }
//         }
//       }
//     }
//   }
// }
module {
  func @main(%arg0: i32, %arg1: i32, %arg2: i32) -> i32 {
    %cst = constant 0 : i32
    %0 = scf.while (%arg3 = %arg0) : (i32) -> (i32) {
      %1 = cmpi slt, %arg3, %arg1 : i32
      scf.condition(%1) %arg3 : i32
    } do {
    ^bb0(%arg3: i32):  // no predecessors
      %2 = scf.execute_region -> i32 {
        %3 = cmpi slt, %arg3, %arg0 : i32
        cond_br %3, ^bb1, ^bb2
      ^bb1:
        br ^bb3(%arg0 : i32)
      ^bb2:
        br ^bb3(%arg1 : i32)
      ^bb3(%4 : i32):
        scf.yield %4 : i32
      }
      scf.yield %2 : i32
    }
    return %0 : i32
  }
}