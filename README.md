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
`cRDCAutoCreateNewID` for allocating record IDs, and `cDataBaseFunctions` for database utilities.

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
https://github.com/NilsSve/Library-RDCToolsLib.git/RDC-Windows-Sub-Classes-Library.sws#1.0.7
```

Each release has a version tag (`1.0.1`, `1.0.2`, ...), listed under Tags on GitHub. Pin a tag, not a
commit: DUF and RDCFlexTron ask for RDCToolsLib by version range (`^1.0.1`), and a range cannot accept a
commit, so df-cli would report "Incompatible ref". Without the `#` part the workspace gets a commit. If
your workspace also uses DUF or RDCFlexTron, list RDCToolsLib before them. A library of your own that
uses RDCToolsLib asks for a range the same way, `"version": "^1.0.1"`.

From 1.0.1 on, the package file has no DataFlex version in its name. Release 1.0.0 still has the old
name, `RDC-Windows-Sub-Classes-Library-26.0.sws`.

**DataFlex 25** — add `RDCToolsLibLibrary25.0.sws` as a library in your workspace.

## Requirements

DataFlex 25 or 26, Windows desktop. The grid and CodeJock classes need the CodeJock controls that
ship with DataFlex.

RDCToolsLib uses [vwin32fh](https://github.com/NilsSve/Library-vwin32fh) for Windows file handling.

**On DataFlex 26 you do not need to do anything about it** — it is declared as a dependency of this
package, so installing RDCToolsLib brings vwin32fh in with it.

**On DataFlex 25** there is no package manager, so add both to your workspace yourself, as siblings:

```
Lib1=Libraries\RDCToolsLib\RDCToolsLibLibrary25.0.sws
Lib2=Libraries\vwin32fh\StudioLibrary\vWin32fh-Library-DF25.0.sws
```

If vwin32fh is missing, the compile fails with error 4313 on `vWin32fh.pkg`, reported from a grid
class — which does not obviously point at the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
