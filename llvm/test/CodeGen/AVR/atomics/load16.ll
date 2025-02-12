; RUN: llc -mattr=avr6 < %s -mtriple=avr | FileCheck %s

; CHECK-LABEL: atomic_load16
; CHECK:      in r0, 63
; CHECK-NEXT: cli
; CHECK-NEXT: ld  [[RR:r[0-9]+]], [[RD:(X|Y|Z)]]
; CHECK-NEXT: ldd [[RR:r[0-9]+]], [[RD]]+1
; CHECK-NEXT: out 63, r0
define i16 @atomic_load16(ptr %foo) {
  %val = load atomic i16, ptr %foo unordered, align 2
  ret i16 %val
}

; CHECK-LABEL: atomic_load_swap16
; CHECK: call __sync_lock_test_and_set_2
define i16 @atomic_load_swap16(ptr %foo) {
  %val = atomicrmw xchg ptr %foo, i16 13 seq_cst
  ret i16 %val
}

; CHECK-LABEL: atomic_load_cmp_swap16
; CHECK: call __sync_val_compare_and_swap_2
define i16 @atomic_load_cmp_swap16(ptr %foo) {
  %val = cmpxchg ptr %foo, i16 5, i16 10 acq_rel monotonic
  %value_loaded = extractvalue { i16, i1 } %val, 0
  ret i16 %value_loaded
}

; CHECK-LABEL: atomic_load_add16
; CHECK:      in r0, 63
; CHECK-NEXT: cli
; CHECK-NEXT: ld [[RDL:r[0-9]+]], [[RR:(X|Y|Z)]]
; CHECK-NEXT: ldd [[RDH:r[0-9]+]], [[RR]]+1
; CHECK-NEXT: add [[RR1L:r[0-9]+]], [[RDL]]
; CHECK-NEXT: adc [[RR1H:r[0-9]+]], [[RDH]]
; CHECK-NEXT: std [[RR]]+1, [[RR1H]]
; CHECK-NEXT: st [[RR]], [[RR1L]]
; CHECK-NEXT: out 63, r0
define i16 @atomic_load_add16(ptr %foo) {
  %val = atomicrmw add ptr %foo, i16 13 seq_cst
  ret i16 %val
}

; CHECK-LABEL: atomic_load_sub16
; CHECK:      in r0, 63
; CHECK-NEXT: cli
; CHECK-NEXT: ld [[RDL:r[0-9]+]], [[RR:(X|Y|Z)]]
; CHECK-NEXT: ldd [[RDH:r[0-9]+]], [[RR]]+1
; CHECK-NEXT: movw [[TMPL:r[0-9]+]], [[RDL]]
; CHECK-NEXT: sub [[TMPL]],         [[RR1L:r[0-9]+]]
; CHECK-NEXT: sbc [[TMPH:r[0-9]+]], [[RR1H:r[0-9]+]]
; CHECK-NEXT: std [[RR]]+1, [[TMPH]]
; CHECK-NEXT: st [[RR]], [[TMPL]]
; CHECK-NEXT: out 63, r0
define i16 @atomic_load_sub16(ptr %foo) {
  %val = atomicrmw sub ptr %foo, i16 13 seq_cst
  ret i16 %val
}

; CHECK-LABEL: atomic_load_and16
; CHECK:      in r0, 63
; CHECK-NEXT: cli
; CHECK-NEXT: ld [[RDL:r[0-9]+]], [[RR:(X|Y|Z)]]
; CHECK-NEXT: ldd [[RDH:r[0-9]+]], [[RR]]+1
; CHECK-NEXT: and [[RD1L:r[0-9]+]], [[RDL]]
; CHECK-NEXT: and [[RD1H:r[0-9]+]], [[RDH]]
; CHECK-NEXT: std [[RR]]+1, [[RD1H]]
; CHECK-NEXT: st [[RR]], [[RD1L]]
; CHECK-NEXT: out 63, r0
define i16 @atomic_load_and16(ptr %foo) {
  %val = atomicrmw and ptr %foo, i16 13 seq_cst
  ret i16 %val
}

; CHECK-LABEL: atomic_load_or16
; CHECK:      in r0, 63
; CHECK-NEXT: cli
; CHECK-NEXT: ld [[RDL:r[0-9]+]], [[RR:(X|Y|Z)]]
; CHECK-NEXT: ldd [[RDH:r[0-9]+]], [[RR]]+1
; CHECK-NEXT: or [[RD1L:r[0-9]+]], [[RDL]]
; CHECK-NEXT: or [[RD1H:r[0-9]+]], [[RDH]]
; CHECK-NEXT: std [[RR]]+1, [[RD1H]]
; CHECK-NEXT: st [[RR]], [[RD1L]]
; CHECK-NEXT: out 63, r0
define i16 @atomic_load_or16(ptr %foo) {
  %val = atomicrmw or ptr %foo, i16 13 seq_cst
  ret i16 %val
}

; CHECK-LABEL: atomic_load_xor16
; CHECK:      in r0, 63
; CHECK-NEXT: cli
; CHECK-NEXT: ld [[RDL:r[0-9]+]], [[RR:(X|Y|Z)]]
; CHECK-NEXT: ldd [[RDH:r[0-9]+]], [[RR]]+1
; CHECK-NEXT: eor [[RD1L:r[0-9]+]], [[RDL]]
; CHECK-NEXT: eor [[RD1H:r[0-9]+]], [[RDH]]
; CHECK-NEXT: std [[RR]]+1, [[RD1H]]
; CHECK-NEXT: st [[RR]], [[RD1L]]
; CHECK-NEXT: out 63, r0
define i16 @atomic_load_xor16(ptr %foo) {
  %val = atomicrmw xor ptr %foo, i16 13 seq_cst
  ret i16 %val
}

; CHECK-LABEL: atomic_load_nand16
; CHECK: call __sync_fetch_and_nand_2
define i16 @atomic_load_nand16(ptr %foo) {
  %val = atomicrmw nand ptr %foo, i16 13 seq_cst
  ret i16 %val
}

; CHECK-LABEL: atomic_load_max16
; CHECK: call __sync_fetch_and_max_2
define i16 @atomic_load_max16(ptr %foo) {
  %val = atomicrmw max ptr %foo, i16 13 seq_cst
  ret i16 %val
}

; CHECK-LABEL: atomic_load_min16
; CHECK: call __sync_fetch_and_min_2
define i16 @atomic_load_min16(ptr %foo) {
  %val = atomicrmw min ptr %foo, i16 13 seq_cst
  ret i16 %val
}

; CHECK-LABEL: atomic_load_umax16
; CHECK: call __sync_fetch_and_umax_2
define i16 @atomic_load_umax16(ptr %foo) {
  %val = atomicrmw umax ptr %foo, i16 13 seq_cst
  ret i16 %val
}

; CHECK-LABEL: atomic_load_umin16
; CHECK: call __sync_fetch_and_umin_2
define i16 @atomic_load_umin16(ptr %foo) {
  %val = atomicrmw umin ptr %foo, i16 13 seq_cst
  ret i16 %val
}
