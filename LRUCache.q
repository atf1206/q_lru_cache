

.lrucache.cache:(`u#enlist "")!(enlist "");

.lrucache.maxsize:1e9;
.lrucache.keycount:1;

.lrucache.get:`.lrucache.cache@;

.lrucache.set:{[k;v]
    if[(not k~"") and 10h = type k;
        $[c:not k in key .lrucache.cache;
            .lrucache.insertafter[k;""];
            .lrucache.movetofront[k]
        ];
        if[c and .lrucache.maxsize <= .lrucache.keycount;
            .lrucache.delete[.lrucache.dll["";`prev]]
        ];
        .lrucache.keycount+:c;
        `.lrucache.cache upsert (enlist k)!enlist v;
    ]
 };

.lrucache.delete:{[k]
    if[k~"";:()];
    if[k in key .lrucache.cache;
        .lrucache.cache:(enlist k) _ .lrucache.cache;
        .lrucache.deletenode[k];
        .lrucache.keycount-:1
    ]
 };

.lrucache.dll:update `u#node from (enlist (enlist `node)!enlist "")!enlist (`next`prev)!2#enlist "";

.lrucache.insertafter:{[newnode;prevnode]
    nextnode:.lrucache.dll[prevnode;`next];
    `.lrucache.dll insert (enlist (enlist `node)!enlist newnode)!enlist (`next`prev)!(nextnode;prevnode);
    .lrucache.dll[prevnode;`next]:newnode;
    .lrucache.dll[nextnode;`prev]:newnode;
 };

.lrucache.deletenode:{[node]
    prevnode:.lrucache.dll[node;`prev];
    nextnode:.lrucache.dll[node;`next];
    .lrucache.dll[prevnode;`next]:nextnode;
    .lrucache.dll[nextnode;`prev]:prevnode;
    .lrucache.dll:(enlist (enlist `node)!enlist node) _ .lrucache.dll
 };

.lrucache.movetofront:{[node]
    .lrucache.deletenode[node];
    .lrucache.insertafter[node;""]
 };

// test dll
.lrucache.dll
.lrucache.insertafter["new1";""]
.lrucache.insertafter["new2";"new1"]
.lrucache.insertafter["new2b";"new1"]
.lrucache.deletenode["new2b"]
.lrucache.deletenode["new2"]
/ delete node, prevnode, nextnode, k from `.


// Test cache
.lrucache.cache
.lrucache.set["test";`result]
.lrucache.set["test1";`result1]
.lrucache.get["test"]
.lrucache.delete["test"]

.lrucache.maxsize:3;

.lrucache.set["test2";`result2]
.lrucache.set["test3";`result3]
.lrucache.set["test4";`result4]
.lrucache.set["test5";`result5]
