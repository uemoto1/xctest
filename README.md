# 現在のXC呼び出しルーチン

## ファイル構成

- `salmon_xc.f90`
  - 外部から`use`するモジュール

- `builtin_pz.f90`
  - SALMON(旧ARTED)のLDA用関数(`calc_xc`サブルーチンから呼び出される)

- `builtin_pzm.f90`
  - SALMON(旧ARTED)のLDA用関数(`calc_xc`サブルーチンから呼び出される)

- `builtin_pbe.f90`
  - SALMON(旧ARTED)のGGA用関数(`calc_xc`サブルーチンから呼び出される)

- `builtin_tbmbj.f90`
  - SALMON(旧ARTED)のMetaGGA用関数(`calc_xc`サブルーチンから呼び出される)
  
### 未実装
- `builtin_tpss.f90`
- `builtin_vp98.f90`

## プログラム内からの呼び出し方法

```
use salmon_xc

type(xc_functional) :: xc

! 初期化（プログラムの初期化時に一度だけ）
call init_xc(xc, 1, 1d0, xcname='pz')

! 汎関数の計算
! rho, exc, vxcがそれぞれ、(NX, NY, NZ)の三次元配列の場合
call calc_xc(xc, rho=rho, exc=exc, vxc=vxc)

! 汎関数の破棄（プログラム終了前に一度だけ）
call finalize_xc(xc)
```

## サブルーチン概要

### `init_xc(xc, ispin, cval, xcname, xname, cname)`

#### 引数
| 型        |   名前         |  説明 |
| ------------- |---------------| ----- |
| xc_functional | xc | 格納変数 |
| integer | ispin      | 磁性(1=nonmag, 2=spin?, 4=spinor?) |
| real(8) | cval  | (MetaGGAなどの)パラメータ |
| character(32) | xcname      |  optional 交換相関ポテンシャル名称（一括していする場合） |
| character(32) | xname      |  optional 交換ポテンシャル名称（単体指定する場合） |
| character(32) | cname      |  optional 相関ポテンシャル名称（単体指定する場合） |

- Example:
```
call init_xc(xc, 1, 1d0, xcname=xc, xname=xname, cname=name)
```

### `calc_xc(xc, ...)`

#### 引数

| 型        |   名前         |  説明 |
| ------------- |---------------| ----- |
| xc_functional  | xc | 格納変数 |
| real(8) | rho(:, :, :)  | 電子密度(ispin=1の場合読み込む) |
| real(8) | rho_s(:, :, :, :)  | スピン密度(ispin=2の場合読み込む予定) |
| real(8) | exc(:, :, :)  | 交換相関エネルギー(いわゆる epsilon_xc) |
| real(8) | eexc(:, :, :)  | 交換相関エネルギー(E_xcの被積分関数: n(r) * epsilon_xc) |
| real(8) | vxc(:, :, :)  | 交換相関ポテンシャル(ispin=1の場合書き込み) |
| real(8) | vxc_s(:, :, :, :)  | 交換相関ポテンシャル(ispin=2の場合書き込み) |
| real(8) | grho(:, :, :, :  | 勾配(ispin=1) |
| real(8) | grho_s(:, :, :, :, :)   | 勾配(ispin=2) |
| real(8) | rlrho(:, :, :  | ラプラシアン(ispin=1) |
| real(8) | rlrho_s(:, :, :, :)  | ラプラシアン(ispin=2) |
| real(8) | rj(:, :, :, :  | カレント(ispin=1) |
| real(8) | rj_s(:, :, :, :)  | スピンカレント(ispin=2) |
| real(8) | tau(:, :, :  | 運動エネルギー(ispin=1) |
| real(8) | tau_s(:, :, :, :)  | 運動エネルギー(ispin=2) |
| real(8) | rho_nlcc(:, :, :) | NLCC補正項(要議論) | 
| integer | nd | 有限差分法パラメータ（要議論） |
| integer | ifdx(:, :)  |有限差分法パラメータ|
| integer | ifdy(:, :) |有限差分法パラメータ|
| integer | ifdz(:, :) |有限差分法パラメータ|
| real(8) | nabx(:) |有限差分法パラメータ|
| real(8) | naby(:) |有限差分法パラメータ|
| real(8) | nabz(:) |有限差分法パラメータ|


- `nd`, `ifd(x|y|z)`, `nab(x|y|z)` は`builtin-PBE`のみ使用
- (`Hxyz`, `aLxyz`を廃止,TBmBJは`rho`, `grho`, `rlrho`, `rj`, `tau`のみで計算可)


### `finalize_xc(xc)`
- メモリを開放
