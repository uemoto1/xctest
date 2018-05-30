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

tyoe(xc_functional) :: xc

! 初期化（プログラムの初期化時に一度だけ）
call init_xc("libxc_pzm", 1, 0d0, xc)

! 汎関数の計算
! rho, exc, vxcがそれぞれ、(NX, NY, NZ)の三次元配列の場合
call calc_xc(xc, rho=rho, exc=exc, vxc=vxc)

! 汎関数の破棄（プログラム終了前に一度だけ）
call finalize_xc(xc)
```

## サブルーチン概要

### `init_ac(xcname, ispin, cval, xc)`

#### 引数
| 型        |   名前         |  説明 |
| ------------- |---------------| ----- |
| character(16) | xcname      | 交換相関ポテンシャル名称 |
| integer | ispin      | 磁性(1=nonmag, 2=spin?, 4=spinor?) |
| real(8) | cval  | (MetaGGAなどの)パラメータ |
| xc_functional | xc | 格納変数 |

### `calc_ac(xc, ...)`

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
| real(8) | Hxyz | １グリッドの体積 |
| real(8) | aLxyz | 計算領域全体の体積 |

- `nd`, `ifd(x|y|z)`, `nab(x|y|z)` は`builtin-PBE`のみ使用
- `Hxyz`, `aLxyz, は`TBmBJ/BJ_PW`のみ使用


### `finalize_ac(xc)`
- メモリを開放
