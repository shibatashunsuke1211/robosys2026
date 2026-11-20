#!/bin/bash
# SPDX-FileCopyrightText: 2026 Shunsuke Shibata <s23C1068BM@chibatech.ac.jp>
# SPDX-License-Identifier: BSD-3-Clause

ng () {                               # 関数ngの定義（P18と同じ）
        echo ${1}行目のテスト失敗
        res=1                          # 失敗したことを記録
}

res=0                                  # 0: 失敗なし（ngが呼ばれると1になる）

### NORMAL INPUT ###
out=$(seq 5 | ./plus_stdin)
[ "$?" = 0 ]      || ng "$LINENO"
[ "${out}" = 15 ] || ng "$LINENO"

### STRANGE INPUT ###
out=$(echo あ | ./plus_stdin)           #計算できない値を入力してみる
[ "$?" = 1 ]      || ng "$LINENO" #終了ステータスが1なのを確認
[ "${out}" = "" ] || ng "$LINENO" #上の行と入れ替えるとダメ（なぜ？）

out=$(echo | ./plus_stdin)              #なにも入力しない
[ "$?" = 1 ]      || ng "$LINENO" #これも異常終了する
[ "${out}" = "" ] || ng "$LINENO"

### 順運動学の正常な入力 ###

# 関節角度が90度の場合
out=$(echo 100 100 100 50 0 90 0 | ./kinematics)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "100.00 150.00 100.00 90.00" ] || ng "$LINENO"

# 関節角度がすべて0度の場合
out=$(echo 100 100 100 50 0 0 0 | ./kinematics)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "250.00 0.00 100.00 0.00" ] || ng "$LINENO"

# 負の関節角度の場合
out=$(echo 100 100 100 50 0 -90 0 | ./kinematics)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "100.00 -150.00 100.00 -90.00" ] || ng "$LINENO"

# 複数行を入力した場合
out=$(printf "100 100 100 50 0 0 0\n100 100 100 50 0 90 0\n" | ./kinematics)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "$(printf '250.00 0.00 100.00 0.00\n100.00 150.00 100.00 90.00')" ] || ng "$LINENO"

### 順運動学の異常な入力 ###

# 入力する数値が足りない場合
out=$(echo 100 100 | ./kinematics)
[ "$?" = 1 ] || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

# 文字を入力した場合
out=$(echo abc | ./kinematics)
[ "$?" = 1 ] || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

# 空行を入力した場合
out=$(echo | ./kinematics)
[ "$?" = 1 ] || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

[ "${res}" = 0 ] && echo OK
exit $res
