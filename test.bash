#!/bin/bash
# SPDX-FileCopyrightText: 2026 Shunsuke Shibata <s23C1068BM@chibatech.ac.jp>
# SPDX-License-Identifier: BSD-3-Clause

ng () {
        echo ${1}行目のテスト失敗
        res=1
}

res=0

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

# θ1を90度回転させた場合
out=$(echo 100 100 100 50 90 0 0 0 | ./kinematics)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "0.00 250.00 100.00 90.00" ] || ng "$LINENO"

# θ1からθ4までの関節角度がすべて90度の場合
out=$(echo 100 100 100 50 90 90 90 90 | ./kinematics)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "-50.00 -100.00 100.00 360.00" ] || ng "$LINENO"

# θ1を-90度回転させた場合
out=$(echo 100 100 100 50 -90 0 0 0 | ./kinematics)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "0.00 -250.00 100.00 -90.00" ] || ng "$LINENO"

# θ1を45度回転させた場合
out=$(echo 100 100 100 50 45 0 0 0 | ./kinematics)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "176.78 176.78 100.00 45.00" ] || ng "$LINENO"

# 小数の関節角度を入力した場合
out=$(echo 100 100 100 50 22.5 0 0 0 | ./kinematics)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "230.97 95.67 100.00 22.50" ] || ng "$LINENO"

# 小数のリンク長を入力した場合
out=$(echo 80.5 100.25 60.5 30 0 0 0 | ./kinematics)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "190.75 0.00 80.50 0.00" ] || ng "$LINENO"

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

# 入力する数値が多すぎる場合
out=$(echo 100 100 100 50 0 0 0 0 0 | ./kinematics)
[ "$?" = 1 ] || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

[ "${res}" = 0 ] && echo OK
exit $res
