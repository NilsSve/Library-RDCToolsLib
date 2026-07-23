# RDCToolsLib
RDC Tools Base Library

This common library is utilized by other RDC Tools projects and consists of a series of DataFlex standard classes that have been subclassed.

It is important to note that this library is used exclusively by projects on this site, not by other libraries. It is automatically installed when you choose to clone one of the main projects or repositories.

The library provides a unified interface for all applications within the NilsSve repository.

## Two workspace files, named for their role

| File | Role | `[Libraries]` |
|---|---|---|
| `RDCToolsLibLibrary25.0.sws` / `26.0` | A consumer **references** this | none — deliberately empty |
| `RDCToolsLibDev25.0.sws` / `26.0` | Open this to **test-compile** the library | `..\vwin32fh` |

There is no plain `RDCToolsLib25.0.sws`. The library ships no application of its own, so
`RDCToolsLibLibrary*.sws` is a pure reference entry with no libraries and no projects. The
canary lives in `RDCToolsLibDev*.sws`, which is a maintainer tool, not something a consumer ever
references.

## Dependencies

RDCToolsLib requires **vwin32fh**. Ten packages `Use vWin32fh.pkg` directly, among them
`cRDCCJGrid.pkg`, `cRDCLogFile.pkg`, `cRDCCheckBoxGrid.pkg`, `cRDCProjectIniFile.pkg` and
`CaptureWindow.pkg`.

`RDCToolsLibLibrary*.sws` does **not** declare vwin32fh — the consuming application declares
both RDCToolsLib and vwin32fh as a flat sibling list in its own `[Libraries]`. The reason is
that DataFlex resolves the compiler search path first-match-wins, with no version arbitration: a
library reached from two *different* checkouts is resolved silently, and wrongly, by list order
alone. One flat set, declared by the application, is the only arrangement that cannot drift.

Declaring only RDCToolsLib and forgetting vwin32fh fails with error 4313 on `vWin32fh.pkg`,
raised from a grid class, for no obvious reason.

## Compiling it on its own

Open **`RDCToolsLibDev25.0.sws`** and build `Dummy.src`. That `.sws` is the only place vwin32fh
is wired in (as the sibling `..\vwin32fh`), which resolves to the same vwin32fh the surrounding
application uses — so nothing is duplicated. If you are working on RDCToolsLib standalone, run
`setup.bat` first; it clones vwin32fh as a sibling.

`Dummy.src` is a compile canary: it `Use`s every publishable package in the library and does
nothing else. If it compiles, the library stands on its own feet - no missing dependency, no
broken `Use` chain, no duplicate class.

Nine packages are excluded from it, each with the reason written in place. Most are duplicate
class declarations or references to files that no longer exist - all of which had gone unnoticed
precisely because nothing here was ever compiled in isolation.
