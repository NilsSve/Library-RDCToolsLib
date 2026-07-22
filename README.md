# RDCToolsLib
RDC Tools Base Library

This common library is utilized by other RDC Tools projects and consists of a series of DataFlex standard classes that have been subclassed.

It is important to note that this library is used exclusively by projects on this site, not by other libraries. It is automatically installed when you choose to clone one of the main projects or repositories.

The library provides a unified interface for all applications within the NilsSve repository.

## Dependencies

RDCToolsLib requires **vwin32fh**. Ten packages `Use vWin32fh.pkg` directly, among them
`cRDCCJGrid.pkg`, `cRDCLogFile.pkg`, `cRDCCheckBoxGrid.pkg`, `cRDCProjectIniFile.pkg` and
`CaptureWindow.pkg`.

`RDCToolsLib25.0.sws` and `RDCToolsLib26.0.sws` declare it as `..\vwin32fh\...`, a **sibling**
path. That serves the compile canary below, and it is deliberately sibling-relative rather than
nested: in the expected layout — every library checked out side by side under the application's
`Libraries\` — it resolves to the very same vwin32fh folder the application declares. Same
checkout, reached two ways, so nothing is duplicated.

Consumers must still declare **both** `RDCToolsLib` and `vwin32fh` in their own workspace's
`[Libraries]`, and should not lean on the sibling path above to supply it. The reason is that
DataFlex resolves the compiler search path first-match-wins, with no version arbitration: a
library that arrives twice from two *different* checkouts is resolved silently, and wrongly, by
list order alone. Declaring the full flat set in the application is what makes that impossible.

Declaring only RDCToolsLib fails with error 4313 on `vWin32fh.pkg`, raised from a grid class,
for no obvious reason.

## Compiling it on its own

`AppSrc\Dummy.src` is a compile canary. It `Use`s every publishable package in the library and
does nothing else; if it compiles, the library stands on its own feet - no missing dependency,
no broken `Use` chain, no duplicate class. Compiling it needs vwin32fh on the library list,
exactly as above.

Six packages are excluded from it, each with the reason written in place. Four of those are
duplicate class declarations that had gone unnoticed precisely because nothing here was ever
compiled in isolation.
