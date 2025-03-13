//go:build ignore

#include "common.h"

char __license[] SEC("license") = "Dual MIT/GPL";

struct {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(key, u32);
    __type(value, u64);
    __uint(max_entries, 1);
} map_men SEC(".maps");

SEC("tracepoint/kmem/mm_page_alloc")
int mm_page_alloc(void *info) {
    return 0;
}
