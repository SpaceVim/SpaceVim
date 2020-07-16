---
title: SpaceVim release v0.7.0
categories: [changelog, blog]
description: "Highlight symbol mode and iedit mode come out with v0.7.0"
type: article
image: https://user-images.githubusercontent.com/13142418/80610138-90946700-8a6b-11ea-8565-04f041e56da5.png
commentsID: "SpaceVim release v0.7.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v0.7.0


![welcome-page](https://user-images.githubusercontent.com/13142418/80610138-90946700-8a6b-11ea-8565-04f041e56da5.png)

The last release is 3 mouths ago, so we want to bring you up-to-date in the SpaceVim world.



## Breaking changes

- Add clever f [#1460](https://github.com/SpaceVim/SpaceVim/pull/1460)
Disable `[Unite]` and `[Denite]` custom leader, use clever-f instead.
- Disable all language layers by default, reduced the number of plugins, by default it is 51 only.
  - Improve fzf layer [#1504](https://github.com/SpaceVim/SpaceVim/pull/1504)
  - Improve ctrlp layer [#1503](https://github.com/SpaceVim/SpaceVim/pull/1503)
  - Improve leaderf layer [#1498](https://github.com/SpaceVim/SpaceVim/pull/1498), [#1476](https://github.com/SpaceVim/SpaceVim/pull/1476)
  - Improve denite layer [#1491](https://github.com/SpaceVim/SpaceVim/pull/1491)
  - Improve unite layer [#1487](https://github.com/SpaceVim/SpaceVim/pull/1487)
- Disable `git`, `VersionControl` and all fuzzy finder layers by default.
- Remove most key bindings begin with `<Leader>`, the `<Leader>` should be customized by users themselves.
- Improve tools layer [#1507](https://github.com/SpaceVim/SpaceVim/pull/1507). And disable it by default.

## New features

- Highlight symbol mode [#1394](https://github.com/SpaceVim/SpaceVim/pull/1394)

SpaceVim supports highlighting of the current symbol on demand and adds
a transient state to easily navigate and rename this symbol.

![highlight cursor symbol](https://user-images.githubusercontent.com/13142418/36210381-e6dffde6-1163-11e8-9b35-0bf262e6f22b.gif)

- Iedit mode [#1258](https://github.com/SpaceVim/SpaceVim/pull/1258)

SpaceVim uses powerful iedit mode to quick edit multiple occurrences of a symbol or selection.

**Two new modes:** `iedit-Normal`/`iedit-Insert`

The default color for iedit is `red`/`green` which is based on the current colorscheme.

![iedit mode](https://user-images.githubusercontent.com/13142418/37598530-752bf6e4-2b50-11e8-9b91-4a18cd87afa0.gif)

- Add project rooter [#1245](https://github.com/SpaceVim/SpaceVim/pull/1245)
- Add package.json as project rooter in javascript layer [#1437](https://github.com/SpaceVim/SpaceVim/pull/1437)
- Add windows key bindings guide [#1214](https://github.com/SpaceVim/SpaceVim/pull/1214)
- Add tetach script [#1358](https://github.com/SpaceVim/SpaceVim/pull/1358)

## New layers

- Add tools#dash layer [#1366](https://github.com/SpaceVim/SpaceVim/pull/1366), [#1365](https://github.com/SpaceVim/SpaceVim/pull/1365)
- Add lang#csharp layer. [#1433](https://github.com/SpaceVim/SpaceVim/pull/1433)
- Add cscope layer [#1220](https://github.com/SpaceVim/SpaceVim/pull/1220)
- Add dart layer [#1207](https://github.com/SpaceVim/SpaceVim/pull/1207)
- Rewrite plugin manager [#1446](https://github.com/SpaceVim/SpaceVim/pull/1446)
- Improve Version Control layer [#1470](https://github.com/SpaceVim/SpaceVim/pull/1470)

## Enhancements

- Add icon to welcome page(startify) [#1389](https://github.com/SpaceVim/SpaceVim/pull/1389)
- Add help description for windows key bindings. [#1244](https://github.com/SpaceVim/SpaceVim/pull/1244)
- Add help description for unite key bindings [#1248](https://github.com/SpaceVim/SpaceVim/pull/1248)
- Add help description for other key bindings [#1241](https://github.com/SpaceVim/SpaceVim/pull/1241)
- Add prompt for quit buffer. [#1359](https://github.com/SpaceVim/SpaceVim/pull/1359)
- Add visual selection support [#1291](https://github.com/SpaceVim/SpaceVim/pull/1291)
- Add lsp support for dart [#1222](https://github.com/SpaceVim/SpaceVim/pull/1222)
- Add a new plugin into javascript layer [#1270](https://github.com/SpaceVim/SpaceVim/pull/1270)
- Add preview func [#1425](https://github.com/SpaceVim/SpaceVim/pull/1425)
- Add vim-pydocstring [#1299](https://github.com/SpaceVim/SpaceVim/pull/1299)
- Add option for config filetype icon [#1289](https://github.com/SpaceVim/SpaceVim/pull/1289)
- Add SpaceVim theme [#1255](https://github.com/SpaceVim/SpaceVim/pull/1255)
- Add version api [#1215](https://github.com/SpaceVim/SpaceVim/pull/1215)
- Add new interesting banners [#1208](https://github.com/SpaceVim/SpaceVim/pull/1208)
- Change into more frequented used shortcuts [#1230](https://github.com/SpaceVim/SpaceVim/pull/1230)
- Update icons [#1240](https://github.com/SpaceVim/SpaceVim/pull/1240)
- Improve if_python check in SpaceVim [#1236](https://github.com/SpaceVim/SpaceVim/pull/1236)
- HOTFIX: Fix ambiguous description in killing buffer [#1226](https://github.com/SpaceVim/SpaceVim/pull/1226)
- Improve checker layer [#1223](https://github.com/SpaceVim/SpaceVim/pull/1223)
- Update version api [#1219](https://github.com/SpaceVim/SpaceVim/pull/1219)
- Improve flygrep [#1426](https://github.com/SpaceVim/SpaceVim/pull/1426)
- Disable cursor error info [#1424](https://github.com/SpaceVim/SpaceVim/pull/1424)
- Improve Ocaml layer [#1387](https://github.com/SpaceVim/SpaceVim/pull/1387)
- Improve github layer [#1377](https://github.com/SpaceVim/SpaceVim/pull/1377)
- Improve ocmal/c/unite/denite/ctrlp layer [#1369](https://github.com/SpaceVim/SpaceVim/pull/1369)
- Revert "Fix language client config" [#1282](https://github.com/SpaceVim/SpaceVim/pull/1282)
- Option to use local eslint  [#1257](https://github.com/SpaceVim/SpaceVim/pull/1257)
- Use compatible api for execute() [#1353](https://github.com/SpaceVim/SpaceVim/pull/1353)
- Update Core [#1457](https://github.com/SpaceVim/SpaceVim/pull/1457)
- Improve core config [#1455](https://github.com/SpaceVim/SpaceVim/pull/1455)
- Remove default layer [#1454](https://github.com/SpaceVim/SpaceVim/pull/1454)
- Default layers [#1452](https://github.com/SpaceVim/SpaceVim/pull/1452)
- Better default [#1438](https://github.com/SpaceVim/SpaceVim/pull/1438)
- Improve lint status in statusline [#1416](https://github.com/SpaceVim/SpaceVim/pull/1416)
- Improve javascript layer [#1415](https://github.com/SpaceVim/SpaceVim/pull/1415)
- update file head [#1407](https://github.com/SpaceVim/SpaceVim/pull/1407)
- Supporting eex in the elixir layer [#1404](https://github.com/SpaceVim/SpaceVim/pull/1404)
- Map [SPC]is to Unite ultisnips while using Ultisnips engine [#1399](https://github.com/SpaceVim/SpaceVim/pull/1399)
- doc fix [#1356](https://github.com/SpaceVim/SpaceVim/pull/1356)
- Use nested autocmd for quite vimfiler [#1342](https://github.com/SpaceVim/SpaceVim/pull/1342)
- Replace mode for flygrep [#1340](https://github.com/SpaceVim/SpaceVim/pull/1340)
- Improve cmd [#1339](https://github.com/SpaceVim/SpaceVim/pull/1339)
- Update install script for chinese users [#1338](https://github.com/SpaceVim/SpaceVim/pull/1338)
- wget isn't installed on all systems by default (like mine). Use curl … [#1335](https://github.com/SpaceVim/SpaceVim/pull/1335)
- Filter [#1325](https://github.com/SpaceVim/SpaceVim/pull/1325)
- tools:add VimCalc plugin [#1316](https://github.com/SpaceVim/SpaceVim/pull/1316)
- Hotfix in windows 7 [#1315](https://github.com/SpaceVim/SpaceVim/pull/1315)
- Improve searching tools [#1314](https://github.com/SpaceVim/SpaceVim/pull/1314)
- Reformart as <Space> in install.cmd [#1310](https://github.com/SpaceVim/SpaceVim/pull/1310)
- Colors [#1308](https://github.com/SpaceVim/SpaceVim/pull/1308)
- Plugin manager [#1307](https://github.com/SpaceVim/SpaceVim/pull/1307)
- Improve install.cmd [#1297](https://github.com/SpaceVim/SpaceVim/pull/1297)
- New Plugin UI [#1294](https://github.com/SpaceVim/SpaceVim/pull/1294)
- close terminal buffer just like a regular buffer [#1429](https://github.com/SpaceVim/SpaceVim/pull/1429)

## Bug fixs

- Fix #1505 [#1509](https://github.com/SpaceVim/SpaceVim/pull/1509)
- Fix 1485 [#1508](https://github.com/SpaceVim/SpaceVim/pull/1508)
- Fix #1489 [#1506](https://github.com/SpaceVim/SpaceVim/pull/1506)
- Fix typo in install script [#1497](https://github.com/SpaceVim/SpaceVim/pull/1497)
- Fix Gabirel/Hack-SpaceVim#36 [#1485](https://github.com/SpaceVim/SpaceVim/pull/1485)
- Fix statusline issue [#1466](https://github.com/SpaceVim/SpaceVim/pull/1466)
- Fix buffer API [#1451](https://github.com/SpaceVim/SpaceVim/pull/1451)
- Fix indentline [#1447](https://github.com/SpaceVim/SpaceVim/pull/1447)
- fix layers html table [#1443](https://github.com/SpaceVim/SpaceVim/pull/1443)
- fix several spelling errors [#1442](https://github.com/SpaceVim/SpaceVim/pull/1442)
- Fix github layer [#1420](https://github.com/SpaceVim/SpaceVim/pull/1420)
- Fix c layer [#1413](https://github.com/SpaceVim/SpaceVim/pull/1413)
- fix close current buffer prompt [#1401](https://github.com/SpaceVim/SpaceVim/pull/1401)
- Fix runner for python [#1396](https://github.com/SpaceVim/SpaceVim/pull/1396)
- fix zz mapping does not respect scrolloff value. [#1391](https://github.com/SpaceVim/SpaceVim/pull/1391)
- fix deoplete python complete [#1388](https://github.com/SpaceVim/SpaceVim/pull/1388)
- Fix typos in lang#c layer [#1375](https://github.com/SpaceVim/SpaceVim/pull/1375)
- Fix fly grep [#1373](https://github.com/SpaceVim/SpaceVim/pull/1373)
- Fix deoplete support [#1371](https://github.com/SpaceVim/SpaceVim/pull/1371)
- Fix ruby format [#1368](https://github.com/SpaceVim/SpaceVim/pull/1368)
- Fix checkers layer [#1364](https://github.com/SpaceVim/SpaceVim/pull/1364)
- Fix a Neomake issue [#1352](https://github.com/SpaceVim/SpaceVim/pull/1352)
- Fix windows id [#1347](https://github.com/SpaceVim/SpaceVim/pull/1347)
- Fix statusline for vimcalc [#1324](https://github.com/SpaceVim/SpaceVim/pull/1324)
- Fix warning message [#1321](https://github.com/SpaceVim/SpaceVim/pull/1321)
- Fix a typo [#1318](https://github.com/SpaceVim/SpaceVim/pull/1318)
- Fix main.css [#1313](https://github.com/SpaceVim/SpaceVim/pull/1313)
- Fix an issue of Vimfiler [#1303](https://github.com/SpaceVim/SpaceVim/pull/1303)
- Fix edit url in website [#1300](https://github.com/SpaceVim/SpaceVim/pull/1300)
- Fix website 404 [#1293](https://github.com/SpaceVim/SpaceVim/pull/1293)
- Fix #1266 [#1292](https://github.com/SpaceVim/SpaceVim/pull/1292)
- Fix project manager [#1288](https://github.com/SpaceVim/SpaceVim/pull/1288)
- Fix Iedit mode cursor [#1284](https://github.com/SpaceVim/SpaceVim/pull/1284)
- Fix #1277 [#1279](https://github.com/SpaceVim/SpaceVim/pull/1279)
- Fix language client config [#1265](https://github.com/SpaceVim/SpaceVim/pull/1265)
- Fix neovim crashs [#1264](https://github.com/SpaceVim/SpaceVim/pull/1264)
- Fix info icon [#1253](https://github.com/SpaceVim/SpaceVim/pull/1253)
- Fix libclang path [#1246](https://github.com/SpaceVim/SpaceVim/pull/1246)
- Fix markdown layer [#1235](https://github.com/SpaceVim/SpaceVim/pull/1235)
- Fix #1143 [#1224](https://github.com/SpaceVim/SpaceVim/pull/1224)
- Fix 'defined' typos in plugin help [#1217](https://github.com/SpaceVim/SpaceVim/pull/1217)

## Doc && Wiki

- Relicense [#1406](https://github.com/SpaceVim/SpaceVim/pull/1406)
- Add cn wiki for gitee [#1343](https://github.com/SpaceVim/SpaceVim/pull/1343)
- Update chinese quick guide [#1337](https://github.com/SpaceVim/SpaceVim/pull/1337)
- Add key bindings development doc [#1221](https://github.com/SpaceVim/SpaceVim/pull/1221)
- Add CODEOWNERS [#1302](https://github.com/SpaceVim/SpaceVim/pull/1302)
- Add html layer doc [#1295](https://github.com/SpaceVim/SpaceVim/pull/1295)
- Add faq for update plugins [#1428](https://github.com/SpaceVim/SpaceVim/pull/1428)
- Add OCaml layer documentation [#1386](https://github.com/SpaceVim/SpaceVim/pull/1386)
- Add job api document [#1344](https://github.com/SpaceVim/SpaceVim/pull/1344)
- Add disqus [#1329](https://github.com/SpaceVim/SpaceVim/pull/1329)
- Add github/page check [#1304](https://github.com/SpaceVim/SpaceVim/pull/1304)
- Add reddit Sidebar [#1273](https://github.com/SpaceVim/SpaceVim/pull/1273)
- Edit because jshell was introduced with java9. [#1481](https://github.com/SpaceVim/SpaceVim/pull/1481)
- Website improvement [#1312](https://github.com/SpaceVim/SpaceVim/pull/1312)
- Update development workflow [#1311](https://github.com/SpaceVim/SpaceVim/pull/1311)
- Update translator [#1351](https://github.com/SpaceVim/SpaceVim/pull/1351)
- Update readme [#1350](https://github.com/SpaceVim/SpaceVim/pull/1350)
- Update cn/development.md [#1349](https://github.com/SpaceVim/SpaceVim/pull/1349)
- Update Chinese doc [#1348](https://github.com/SpaceVim/SpaceVim/pull/1348)
- Update README_zh_cn.md [#1262](https://github.com/SpaceVim/SpaceVim/pull/1262)
- Update doc [#1256](https://github.com/SpaceVim/SpaceVim/pull/1256)
- Update doc for vim-diff [#1254](https://github.com/SpaceVim/SpaceVim/pull/1254)
- Update doc for vim_diff [#1274](https://github.com/SpaceVim/SpaceVim/pull/1274)
- Update website (2) [#1272](https://github.com/SpaceVim/SpaceVim/pull/1272)
- Update website [#1271](https://github.com/SpaceVim/SpaceVim/pull/1271)
- Update website [#1305](https://github.com/SpaceVim/SpaceVim/pull/1305)
- Update chinese document [#1331](https://github.com/SpaceVim/SpaceVim/pull/1331)
- Improve javascript [#1421](https://github.com/SpaceVim/SpaceVim/pull/1421)
- Improve json layer [#1419](https://github.com/SpaceVim/SpaceVim/pull/1419)
- Update achievements [#1323](https://github.com/SpaceVim/SpaceVim/pull/1323)
- Update development rules [#1298](https://github.com/SpaceVim/SpaceVim/pull/1298)
- Update features [#1363](https://github.com/SpaceVim/SpaceVim/pull/1363)
- translate documentation.md [#1361](https://github.com/SpaceVim/SpaceVim/pull/1361)
- Update quick start guide [#1417](https://github.com/SpaceVim/SpaceVim/pull/1417)
- Activating Open Collective [#1474](https://github.com/SpaceVim/SpaceVim/pull/1474)
- Banner [#1440](https://github.com/SpaceVim/SpaceVim/pull/1440)
- Update sponsors [#1432](https://github.com/SpaceVim/SpaceVim/pull/1432)
- Use Multiple issue and pull request templates [#1431](https://github.com/SpaceVim/SpaceVim/pull/1431)
- Update readme [#1423](https://github.com/SpaceVim/SpaceVim/pull/1423)
- Automatically generate Wiki from ci [#1309](https://github.com/SpaceVim/SpaceVim/pull/1309)
- Improve readme [#1463](https://github.com/SpaceVim/SpaceVim/pull/1463)
- Update Readme [#1459](https://github.com/SpaceVim/SpaceVim/pull/1459)

## Blog

- Add cn blog: grep on the fly [#1355](https://github.com/SpaceVim/SpaceVim/pull/1355)
- Add newsletter [#1228](https://github.com/SpaceVim/SpaceVim/pull/1228)
- Add newsletter #2 [#1216](https://github.com/SpaceVim/SpaceVim/pull/1216)

