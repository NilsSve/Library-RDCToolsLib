# RDCToolsLib

A base class library for DataFlex Windows desktop applications: around 85 packages of subclassed
standard and CodeJock classes, so an application starts from controls that already behave
consistently instead of configuring each one by hand.

## What it gives you

**Data-aware and plain controls** — form, combo form, checkbox, radio, spin form, read-only form,
text box, rich edit and suggestion forms, each in a `cRDC…` and a `cRDCDb…` variant, plus views,
groups, header groups, modal panels and icon views.

**CodeJock grids** — `cRDCCJGrid` and `cRDCDbCJGrid` with column types for buttons, hyperlinks,
prompt lists and suggestions, a check-box grid, and a selection grid.

**Settings that persist themselves** — `cRDCIniFileForm`, `cRDCIniFileCheckbox`,
`cRDCSuggestionIniForm` and `cRDCRegKeyForm` read and write their own value to an INI file or the
registry, so a settings dialog needs no load-and-save code.

**Application plumbing** — `cRDCApplication`, `cRDCLogFile`, `cRDCProjectIniFile`,
`cRDCAutoCreateNewID` for allocating record IDs, and `cDataBaseFunctions` for database utilities.

**Windows and shell helpers** — `ShellExecute`, `StartProg` and `cRDCExternalProgramResult` for
launching programs and reading back their output, `CaptureWindow` for screenshots,
`cSelectFolderDialog` and `CJBrowseForFolder` for folder pickers, `Base64Functions`, and a status
panel and *Working…* indicator for long operations.

**Interface touches** — a tooltip controller, a font dialog, slide on/off switches, command-link
buttons, splitter support, and CodeJock menu items for changing colours, skins and text-edit
options.

## Installing

**DataFlex 26 and later** — add it as a package, with the version after a `#`:

```
https://github.com/NilsSve/Library-RDCToolsLib.git/RDC-Windows-Sub-Classes-Library.sws#1.0.1
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
