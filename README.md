# RDCToolsLib

A base class library for DataFlex Windows desktop applications: around 85 packages of subclassed
standard and CodeJock classes, so an application starts from controls that already behave
consistently instead of configuring each one by hand.

## What it gives you

**Data-aware and plain controls** — form, combo form, checkbox, radio, spin form, read-only form,
text box, rich edit and suggestion forms, each in a `cRDC…` and a `cRDCDb…` variant, plus views,
groups, header groups, modal panels and icon views.

**CodeJock grids** — `cRDCCJGrid` and `cRDCDbCJGrid` with column types for buttons, hyperlinks,
prompt lists and suggestions, a check-box grid, a selection grid, and `cRDCGridClipboard` for a grid's
selected rows on the clipboard.

**Settings that persist themselves** — `cRDCIniFileForm`, `cRDCIniFileCheckbox`,
`cRDCSuggestionIniForm` and `cRDCRegKeyForm` read and write their own value to an INI file or the
registry, so a settings dialog needs no load-and-save code.

**Application plumbing** — `cRDCApplication`, `cRDCLogFile`, `cRDCProjectIniFile`,
`cRDCAutoCreateNewID` for allocating record IDs, `cDataBaseFunctions` for database utilities, and
`RDCTimeSpan` for an elapsed time as text.

**Windows and shell helpers** — `ShellExecute`, `StartProg` and `cRDCExternalProgramResult` for
launching programs and reading back their output, `RDCRunProgram` for a program run and waited for
without a console flash, a file revealed in Explorer, a help page or a web address opened in the
browser, `cRDCAsyncProcess` for a process started and polled from a timer - with
`RDCRunProgramBounded` for a tool that must never hang the program - `CaptureWindow` for screenshots,
`cSelectFolderDialog` and `CJBrowseForFolder` for folder pickers, `Base64Functions`, and a status
panel and *Working…* indicator for long operations.

**Interface touches** — a tooltip controller, a font dialog, slide on/off switches, command-link
buttons, splitter support, a tool panel docked as a CodeJock dialog bar that remembers its dragged
height (`cRDCCJToolPanel`) with the grid that shares its context menu (`cRDCCJToolPanelGrid`), and
CodeJock menu items for changing colours, skins and text-edit options.

## What is new in 1.0.19

- `cRDCFontDialog` opens in a 64-bit program: its CHOOSEFONT has the gaps Windows has there (104 bytes; it was 88,
  and `ChooseFont` refused it). From DataFlex 20 it calls `ChooseFontW`, so a face name in any script goes in and
  comes back as it is. `psFaceName` after the dialog is the name the user chose - it was the address of the name.
- `cRDCExternalProgramResult` decodes each line of a program's output on its own from DataFlex 20: as it is when it
  is UTF-8, else from the machine's ANSI code page. `AnsiToOem` turned every national letter into another one there.
- `CJBrowseForFolder` hands the folder and the title to the dialog as they are from DataFlex 20; `ToANSI` garbled a
  national letter.

## What is new in 1.0.18

- From DataFlex 20 more of the library hands Windows wide text, so a path or a link with a national letter in it is
  found: the snapshot file of `CaptureWindow` (`CreateFileW`), the taskbar icons of `cRDCIconPanel`
  (`ImageList_LoadImageW` - the path went through `OemToAnsi` before), a link clicked in `cRDCRichEditor`
  (`ShellExecuteW`), and the file `cRDCFileFunctions` opens to read or set its times (`CreateFileW` - before,
  `Utf8ToAnsi` turned a letter outside the machine's ANSI code page into `?`). `WinAPIFileTimeToDateTime` formats
  with `GetDateFormatW` and `GetTimeFormatW`.
- `ApplicationPath` (`cRDCFileFunctions`) reads the program's folder with `GetModuleFileNameW` and
  `PathRemoveFileSpecW`, the same whichever declaration of `GetModuleFileName` a program has: DataFlex's own
  converting wrapper, or the ANSI one in `cRDCFileFunctions.h.pkg`.
- The ANSI declarations keep their names (`fCreatefile`, `GetModuleFileName`, `ShellExecute`, ...) for programs that
  call them; the wide ones have names of their own (`RDCCreateFileW`, `RDCShellExecuteW`, ...). DataFlex 19.1 keeps
  the ANSI calls.

## What is new in 1.0.17

- `RDCRunProgramWait`, `RDCRevealInExplorer`, `RDCOpenHelpPage` and `RDCOpenUrl` (`RDCRunProgram.pkg`) hand the
  Windows shell every character of a path or a parameter. From DataFlex 20 they go through the new global
  function `RDCShellExecuteEx`, which calls `ShellExecuteExW`, the Unicode function of Windows. Until now they
  called `ShellExecuteEx`, which is the ANSI `ShellExecuteExA`: a Polish, Greek or Chinese letter on a Western
  European Windows reached the shell as `?` or as a look-alike letter, the shell found no such file, and
  `RDCRunProgramWait` returned at once without the program having run. DataFlex 19.1 keeps the ANSI call, since a
  string there is OEM text.
- `RDCShellExecuteEx` can also be called on its own, for a launch of another kind - a window that shows, say,
  waited on in a loop of its own. It returns whether the shell started the file, and the process handle when
  `RDC_SEE_MASK_NOCLOSEPROCESS` asks for it. `ShellExecuteExEf` stays declared, for a program that calls it
  itself with ANSI text.

## What is new in 1.0.16

- `cRDCCheckBox` follows its anchors. Its container is DataFlex's non-visual `Container` class, which has no
  window of its own, so the runtime anchored nothing for it: the check box and the info icon are windows of the
  panel itself. With `Set peAnchors to anBottomLeft` the check box stayed where it was when the panel grew, and a
  grid anchored to all sides drew over it. The container now gives both its anchors - only the side they move
  with, as both are sized to their text and icon: left and right keep them on the left, top and bottom at the top.
- `cRDCAsyncProcess.pkg` compiles in a program without `cProgressBar.pkg` or `DFAllEnt.pkg`, as its own comment
  says. `RDCRunProgramBounded` sends `piMaximum` and `piPosition` to the progress bar and `Check_StatusPanel` to
  the panel; these messages are now registered above it, so the compiler no longer stops with error 4306.

## What is new in 1.0.15

- A program started by `gStartProgram` (`StartProg.pkg`), `cRDCAsyncProcess` or `cRDCExternalProgramResult`
  gets every character of its command line and its working folder. From DataFlex 20 the three start it through
  `CreateProcessW`, the Unicode function of Windows, by way of the new `RDCCreateProcess.pkg`. Until now they used
  `CreateProcessA`, which takes only the characters of the machine's ANSI code page: a Polish, Greek or Chinese
  letter on a Western European Windows reached the program as `?` or as a look-alike letter, and on DataFlex 20
  and later `gStartProgram` and `cRDCExternalProgramResult` garbled even the Swedish and German letters. DataFlex
  19.1 keeps `CreateProcessA`, since a string there is OEM text.
- `cRDCExternalProgramResult` works in 64-bit programs; until now it answered -1 in every one of them. DataFlex
  packs a struct with no gaps, and the security attributes it handed `CreatePipe` were 13 bytes where Windows
  wants 24 (error 998). `tWinSecurityAttributes`, `tStartInfo` and their `tEPR_` twins now have the layout
  Windows has, in 32- and 64-bit programs, and `bInherit` is an `Integer` - four bytes, like a Windows BOOL.
- In a 64-bit program, `gStartProgram` and `cRDCAsyncProcess.StartProcess` now hand Windows the show-window
  setting where Windows reads it, so the program's window shows or hides as the call asks.
- `CreateProcessEf` is declared in `RDCCreateProcess.pkg`, and `StartProg.pkg` and `cRDCExternalProgramResult.pkg`
  bring it in from there. `OpenProcessEf` returns a `Handle`. Every `External_Function` in these packages takes
  one parameter per line.

## What is new in 1.0.14

- The package asks for vWin32fh by version range, `^1.0.0`, instead of one commit. vWin32fh 1.0.0 fixes the
  Windows folder dialog (`vSHBrowseForFolder`) in 64-bit programs: its declaration kept only 32 of the 64 bits of
  the address Windows returns. RDCToolsLib uses that dialog in `cDataBaseFunctions` (choosing a backup folder) and
  in `cRDCIniFileForm` (a form that asks for a folder).
- A workspace that also asks for vWin32fh itself must ask for `1.0.0` or a range such as `^1.0.0`. A commit pin of
  vWin32fh next to this release is reported as incompatible by df-cli.
- DataFlex 19.1 to 25 use vWin32fh as a library folder and get the fix from the vWin32fh repository.

## What is new in 1.0.13

- `cRDCSuggestionIniForm` no longer raises error 98 ("Invalid message GET_PUITIMEOUTTICKS") on every key pressed
  in the form on DataFlex 23 and up. The class set up DataFlex's suggestion code with a copy of the DataFlex 20.1
  set-up, whose timer property is named `piTimeOutTicks`; from 23.0 that code asks for `puiTimeOutTicks`. The
  class now uses DataFlex's own set-up, so the name always matches the version. Its saved list of earlier values,
  in the workspace's .ws file or in the ini file named in `psIniFileName`, works as before.

## What is new in 1.0.12

- `cRDCModalPanel` and `cRDCDbModalPanel` keep the `piMinSize` a dialog sets for itself, so a resizable dialog
  can be dragged smaller than it opens. Until now the class set the minimum to the dialog's design size after the
  dialog had set its own, and such a dialog could only grow. A dialog that sets no minimum still gets its design
  size as the minimum. The status bar the class adds is counted on top of either, as it is on top of the size.

## What is new in 1.0.11

- `cRDCSuggestionIniForm`: `psIniFileName` now decides where the form keeps its list of earlier values. Empty,
  the default, is the workspace's `.ws` file as before. A file name is that ini file in the `Programs` folder,
  and a full path is that file. A list still found in the `.ws` file is moved over the first time it is read.
  So a program no longer has to write into `Config.ws`, a file that is under version control.
- `Dummy.src` has no connection object any more. It was the only thing here that needed a
  `LoginEncryptionKey.inc`, so the library workspace now compiles without one.

## What is new in 1.0.10

- The library compiles on DataFlex 19.1 again, and has its workspace files for it
  (`RDCToolsLibLibrary19.1.sws`, `RDCToolsLibDev19.1.sws`). What DataFlex 20 added stands behind a version
  gate: wide strings and the wide Windows functions, `Utf8ToAnsi`, `C_NewLine`, and the application object's
  `ReadInteger` and `WriteInteger`, for which the new `RDCAppInteger.pkg` has `RDCReadAppInteger` and
  `RDCWriteAppInteger`.
- No source file starts with a UTF-8 mark any more: DataFlex 19.1 stops at one. The national texts in
  `cDataBaseFunctions.h.pkg` are OEM text (code page 850) again; DataFlex 20 and later convert them when
  they compile.
- `TypeFaceWinTextMetric` of the suggestion classes, on DataFlex 20 and later: it measured a default font
  instead of the one asked for, and let Windows write past the end of its structure. Both are fixed.
- Unit tests on DFUnit: `AppSrc\UnitTests.src` with 16 first tests. See "Unit tests" below.

## What is new in 1.0.9

- The library compiles on DataFlex 20.1, 23 and 24 again, beside 25 and 26, and each of them has its
  workspace files (`RDCToolsLibLibrary20.1.sws` and so on). Block comments became line comments, and what
  DataFlex 23 named or added stands behind a version gate: the error handler package in
  `cDataBaseFunctions`, the grid theme in `cRDCDbCJGrid`, and the CodeJock grid's "Grid" names, which the
  new `RDCCJGridNames.pkg` gives the older versions.
- `CaptureWindow`: asks `vFolderExists` whether its folder is there; `IsDirectory` is known from DataFlex 25
  only.

## What is new in 1.0.8

- `RDCTimeSpan.pkg`: a TimeSpan as text. `RDCTimeSpanToClock` gives `HH:MM:SS`, the days in front as `D:`
  when there are any - the clock a person watches while something runs; `RDCTimeSpanToString` adds the
  milliseconds, `.mmm` - the summary of a run. DFRefactor's engine and status panel each carried the
  function.

## What is new in 1.0.7

- `cRDCDbCJGrid` and `cRDCCJSelectionGrid`: the space bar toggles the row's selection only while no cell is
  being edited; in an editable cell it is a character again. The key binding fired in edit mode too, ended
  the edit and flipped the row's tick, so no space could be typed into a cell.

## What is new in 1.0.6

- `RDCRunProgram.pkg`: `RDCRunProgramWait` runs a program and waits for it, with no console window
  flashing for a console-subsystem child such as the DataFlex compiler; `RDCRevealInExplorer` opens
  Explorer with a file selected in its folder, or a folder opened; `RDCOpenHelpPage` opens a local
  .htm/.html page in the user's browser; `RDCOpenUrl` hands an http or https address to it. The three
  openers take the string only where it names something real - a path on disk, a page, a web address -
  and say nothing on refusal. The strings reach Windows in the ANSI code page, so a path with a national
  character in it arrives intact.
- `cRDCAsyncProcess.pkg`: `cRDCAsyncProcess` starts a process with no console and lets a timer poll it
  (`StartProcess`, `IsProcessRunning`, `ProcessExitCode`, `KillProcess` - the whole process tree -
  and `CleanUp`), and `RDCRunProgramBounded` runs a tool, waits for it and never hangs on it: a deadline
  ends a child that stalls, and the answer is the exit code, `CI_RDCRunToolFailedToStart` or
  `CI_RDCRunToolTimedOut`. While it waits it keeps a status panel alive, when the program shows one. A
  tool that might ask a question must run through a wrapper that redirects its output; the deadline
  alone only bounds the wait. Both are DFRefactor's, built there in 2026.

## What is new in 1.0.5

- `cRDCCJToolPanelGrid.pkg`: a grid inside a `cRDCCJToolPanel` - a `cRDCToolTipGrid` that claims the panel's
  context menu for itself when it takes the focus and again on a right-click, then pops it; a right-click on
  the grid beside the one that held the focus would otherwise act on the sibling. Just before the menu pops,
  `OnToolPanelMenuPopup` hands the grid the menu, to grey an item that does not apply to it or to its current
  row. The grid-side half of the panel's contract, as DFRefactor's dock grids carried it.

## What is new in 1.0.4

- `cRDCCJToolPanel.pkg`: a tool panel docked at the main window's edge as a CodeJock dialog bar - a
  `Container3d` the user drags taller or shorter, hides with its x and a program shows again with `Activate`;
  a compiler's output, a log, a list of results. `psLabel`, `peBarPosition`, `piMinSize`; `OnUpdate` on every
  show, after the bar is realized; `ToolPanelContextMenuClass` for the command-bar system that builds its
  context menu. With `psSizeSettingKey` it remembers the dragged height across runs, in the registry under
  `psSizeSettingSection` through the application object, and a watchdog keeps a floor under a drag at
  `piMinSize` - once the mouse button is up, so nothing flickers. The Hammer's `cCJToolPanel`, courtesy of
  Wil van Antwerpen, as DFRefactor carried and taught it.

## What is new in 1.0.3

- `cRDCGridClipboard.pkg`: `RDCCopyGridRows` puts a grid's selected rows - the current row when none is
  selected - on the clipboard, one line each, the values of the columns asked for joined by a tab, and
  answers how many; `RDCGridRowsText` is that text, `RDCGridSelectedRows` the rows. Global functions that
  take the grid, so every grid class has them - `cRDCCJGrid`, `cRDCDbCJGrid`, `cRDCToolTipGrid`, a plain
  `cCJGrid` - from a `Copy` of the grid's own, which Ctrl+C or a context menu sends.

## What is new in 1.0.2

- `cRDCGridToolTip.pkg`: `RDCApplyGridToolTipStyle` sets a grid's tooltip style and maximum width from the
  program's tooltip controller, at construction - the one place the width takes; `cRDCToolTipGrid` is a plain
  `cCJGrid` with it, and `cRDCToolTipColumn` a column whose cell tooltip wraps at `CI_RDCTipWrapChars`
  characters (`RDCWrapToolTipText`). `cRDCCJGrid` and `cRDCDbCJGrid` use it themselves.
- `cRDCDbCJGrid`: the row is saved the moment its tick changes, and a value-edit in `phoSaveOnChangeColumn`
  the moment it changes; `IsSelectableItem` lets a grid keep rows out of Select All; a no-clear save reaches
  the grid only when it is realized.
- `cRDCCJGrid`, `cRDCDbCJGrid`: the colours (and the theme) are set in `SetGridLook`, for a subclass to
  replace or leave to the CodeJock theme.

## Installing

**DataFlex 26 and later** — add it as a package, with the version after a `#`:

```
https://github.com/NilsSve/Library-RDCToolsLib.git/RDC-Windows-Sub-Classes-Library.sws#1.0.19
```

Each release has a version tag (`1.0.1`, `1.0.2`, ...), listed under Tags on GitHub. Pin a tag, not a
commit: DUF and RDCFlexTron ask for RDCToolsLib by version range (`^1.0.1`), and a range cannot accept a
commit, so df-cli would report "Incompatible ref". Without the `#` part the workspace gets a commit. If
your workspace also uses DUF or RDCFlexTron, list RDCToolsLib before them. A library of your own that
uses RDCToolsLib asks for a range the same way, `"version": "^1.0.1"`.

From 1.0.1 on, the package file has no DataFlex version in its name. Release 1.0.0 still has the old
name, `RDC-Windows-Sub-Classes-Library-26.0.sws`.

**DataFlex 19.1, 20.1, 23, 24 and 25** — add the `RDCToolsLibLibrary` file of your version (`RDCToolsLibLibrary19.1.sws`,
`20.1`, `23.0`, `24.0` or `25.0`) as a library in your workspace.

## Requirements

DataFlex 19.1 to 26, Windows desktop. The grid and CodeJock classes need the CodeJock controls that
ship with DataFlex.

RDCToolsLib uses [vwin32fh](https://github.com/NilsSve/Library-vwin32fh) for Windows file handling.

**On DataFlex 26 you do not need to do anything about it** — it is declared as a dependency of this
package, so installing RDCToolsLib brings vwin32fh in with it.

**On DataFlex 19.1, 20.1, 23, 24 and 25** there is no package manager, so add both to your workspace yourself, as
siblings - the 25.0 files here; the 19.1, 20.1, 23.0 and 24.0 files are named the same way:

```
Lib1=Libraries\RDCToolsLib\RDCToolsLibLibrary25.0.sws
Lib2=Libraries\vwin32fh\StudioLibrary\vWin32fh-Library-DF25.0.sws
```

If vwin32fh is missing, the compile fails with error 4313 on `vWin32fh.pkg`, reported from a grid
class — which does not obviously point at the real cause.

## Unit tests

`AppSrc\UnitTests.src` is the unit-test program of the workspace, built on
[DFUnit](https://github.com/NilsSve/Library-DFUnit). The tests are in `AppSrc\o<Subject>-Tests.pkg`, one file
per subject, and `AppSrc\oUnit_Tests.pkg` lists them. The first files cover the code that differs between
DataFlex versions: the whole-number registry helpers, `Utf8ToAnsi`, the tooltip wrap, the CodeJock "Grid"
names, the Windows user name, the Pictures folder and the font metrics. `oRDCCreateProcess-Tests.pkg` covers
the program launchers: a folder named with Polish and Chinese letters that each of them starts a program in,
and the sizes of the structs they hand Windows.

The `RDCToolsLibDev<version>.sws` files take DFUnit from the sibling folder `..\DFUnit`, which `setup.bat`
clones.

Compile `UnitTests` and run it: the test-runner window opens. `UnitTests64.exe -c` runs the tests without a
window and ends with exit code 0 when all passed; `-o result.xml` adds a JUnit file. On DataFlex 19.1 the
program is `UnitTests.exe`.

`AppSrc\UnitTestHeaps.pkg` is for the test of a function that hands a buffer or a structure to Windows:
`UnitTestDamagedHeaps()` asks Windows whether every heap of the process is still sound. A function that lets
Windows write past the end of what it handed over shows up there at once, and not as a crash somewhere else
later.

## Licence

MIT — see [LICENSE](LICENSE).
